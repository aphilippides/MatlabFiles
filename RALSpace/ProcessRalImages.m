function ProcessRalImages
runall('Straight')
% runall('DogLeg')

% this is just a helper function that compares all routes of eg type
% straight to all the other routes of the same type by looking for the mat
% files which match *str*wdRS.mat  where str is a user specified string.
% Essentially it works with movies generated by the function
% ReSizeRalImages
function runall(str)
fn=dir(['*' str '*wdRS.mat']);
ggap=25;
rgap=5;
for i=1:length(fn)
    fn(i).name
    load(fn(i).name)
    ims1=ims;
    for j=i:length(fn)
        load(fn(j).name)
        ims2=ims;
        outf=[str int2str(i) '_' int2str(j) 'CAs.mat'];
        
        % this gets all the data
        [dat,r_is,goalis]=GetCAData(ims1,ims2,ggap,rgap,[i j]);
%         save(outf,'dat','fn','ggap','rgap','r_is','goalis');
        
        
        % this is some stuff to do plotting of the indices of the goal
        % images and where they are predicted to be (should be a straight
        % line) for each route to route comparison
        load(outf,'dat','ggap','rgap');
        goalis=ggap:ggap:(length(ims1)-ggap);
        r_is=1:rgap:length(ims2);
        save(outf,'r_is','goalis','-append');
        figure(1)
        subplot(2,3,j)
        plot(goalis,[dat.pr_goal],'k.'),axis tight       
        title(fn(j).name)
        
        % this plots the angular 'error' for each route. However, the error
        % is assuming that 0 is the correct heading (which it probably
        % isn't but it won't be more than 15 degrees or so off
        figure(2)
        subplot(2,3,j)
        for k=1:length(goalis)
            ang_err(k)=dat(k).es(dat(k).pr_goal);
        end
        plot(goalis,ang_err,'k.'),axis tight
        title(fn(j).name)
    end
end

% fn='Route1_trav2_Pano.mp4';
% load([fn(1:end-4) 'RS.mat']);
% ims1=ims;
% load(['Route1_trav1_PanoRS.mat']);
% ims2=ims;

% load datr1
% for i=1:length(goalis)
%     ang_err(i)=datr2(i).es(datr2(i).pr_goal);
% end
% p_goal=is([datr2.pr_goal]);



function[dat,r_is,goalis]=GetCAData(ims1,ims2,ggap,rgap,b)
is=1:length(ims1);
goalis=is(ggap:ggap:end-ggap);
r_is=1:rgap:length(ims2);
tic
for i=1:length(goalis)
    goal=ims1(goalis(i)).im;
    dat(i)=imdiffsGoal(ims2,goal,r_is,1);
    disp([b i toc])
end
% ResizeImages(im_size,fn,is)


% this is the main function which does all the work. It calls VisualCompass
% for each of the images specified by is in ims and compares them to the
% goal image goal. set topl= 0 to not plot IDFS and RIDFS as you go along
% set topl=1 to plot them (good for debuggint
function[dat]=imdiffsGoal(ims,goal,is,topl)
d=zeros(length(is),size(goal,2));
for i=1:length(is)
%     i
    [mini(i),rim,imin,mind(i),d(i,:)]=VisualCompass(goal,ims(is(i)).im);%,np)
end
dat.mini=mini;
dat.mind=mind;
dat.d=d;

% this calculates the angular 'error' assuming that the true heading is 
% at an angle of 0, ie it is facing the 360'th pixel
dat.es=mini;
dat.es(mini>180)=mini(mini>180)-360;

[dat.min_goal,dat.pr_goal]=min(mind);

% get actachment areas
rvals=5;
[dat.ca,dat.isca]=GetCA_New(mind,dat.pr_goal,rvals,1);
[dat.rca,dat.isrca]=GetRCA(dat.es,dat.pr_goal,45,rvals);
if(topl)
    ShowCatchmentArea(dat,is)
    drawnow;
end


% this shows the catchment area for a particular goal and data file
function ShowCatchmentArea(dat,is,goal,ims2,opt)
if(nargin<3)
    m=1;
else
    m=2;
end
t=is*0.2;
subplot(2,m,1)
plot(t,dat.mind, t(dat.isca),dat.mind(dat.isca),'r.'...
    ,t(dat.pr_goal),dat.mind(dat.pr_goal),'ks');grid
axis tight
title(['IDF: CA = ' num2str(dat.ca)])
subplot(2,m,m+1)
plot(t,dat.es,t(dat.isrca),dat.es(dat.isrca),'r.' ...
    ,t(dat.pr_goal),dat.es(dat.pr_goal),'ks');grid
axis tight
ang_err=dat.es(dat.pr_goal);
title(['RIDF: Error at goal = ' num2str(ang_err)])
if(m==2)
    subplot(3,2,2)
    imagesc(goal)
    colormap gray;%axis equal;axis tight
    x=[180 180];
    y=[0 90];
    hold on;plot(x,y,'r','Linewidth',2); hold off
    title('goal')
    subplot(3,2,4)
    imagesc(ims2(is(dat.pr_goal)).im)
    colormap gray;%axis equal;axis tight
    hold on;plot(x+ang_err,y,'r','Linewidth',2); hold off
    title(['best match e=' num2str(ang_err)])
    subplot(3,2,6)
    if opt
        imagesc(goal-ims2(is(dat.pr_goal)).im)
    caxis([-100 100])
    else
        imagesc(abs(goal-ims2(is(dat.pr_goal)).im))
    caxis([0 100])
    end
    colormap gray;%axis equal;axis tight
    hold on;plot(x+ang_err,y,'r','Linewidth',2); hold off
    title(['best match e=' num2str(ang_err)])
end

% keyboard
% 

% function gets the catchment area. Includes options to use diff opt=1 or
% gradient opt=0 (default)
%
% it also does some median smoothing (rvals is filter length
% which helps increase CA size. 
% 
% Alternatively I could do something with GetMaxMin and use the size of 
% the maxima/minima to determine CA size. Don't think it really matters
function[ca,isca]=GetCA_New(df2,goal,rvals,opt)

if(nargin<3); rvals=3; end;
if(nargin<4); opt=0; end;

l=length(df2);
vR=medfilt1(df2([1 1:l l]),rvals);
vR=vR(2:end-1);
vR(goal)=0;
if(opt==1)
    dR=diff(vR([goal:l]));
    dL=diff(vR([goal:-1:1]));
else
    n=gradient(vR([goal goal:l l]));
    dR=n(2:end-1);
    n=gradient(vR([goal goal:-1:1 1]));
    dL=n(2:end-1);
end

caR=find(dR<0,1);
caL=find(dL<0,1);
caR=find(dR<0,1);
caL=find(dL<0,1);

if(isempty(caR)) caR=l-goal;
else caR=caR-2;
end

if(isempty(caL)) caL=goal-1;
else caL=caL-2;
end

% get rid of 'spurious' minima ie 11011 counting as 2 (opt=1)
% or use the minimal area within which a gradient applies (opt=2)
% This used to be an option but I have now hardcoded this
optCAmin=2;
if(optCAmin==1)
    if(caL==1) caL=0;end
    if(caR==1) caR=0;end
elseif(optCAmin==2)
    caL=max(caL-1,0);
    caR=max(caR-1,0);    
end

% if necessary (opt =-1) calculates the catchment area not radius 
% This used to be an option but I have now hardcoded this
optWid=-1;
if(optWid==-1) ca=caL+caR; 
else ca=0.5*(caL+caR);  
end
isca=[max(goal-caL,1):min(goal+caR,l)];

% this gets the rotational catchment area
% it's the largest contiguous region with an absolute error less than 45
% degrees
function[rca,isca]=GetRCA(es,goal,th,rvals)
if(nargin<4) rvals=3; end;
l=length(es);
se=medfilt1(abs(es([1 1:l l])),rvals);
se=se(2:end-1);
se(goal)=0;
caR=find(se(goal:end)>th,1);
caL=find(se(goal:-1:1)>th,1);
if(isempty(caR)) caR=l-goal;
else caR=caR-2;
end
if(isempty(caL)) caL=goal-1;
else caL=caL-2;
end

opt=-1;
% if necessary (opt =-1) calculates the catchment area not radius 
if(opt==-1) rca=caL+caR; 
else rca=0.5*(caL+caR);  
end

isca=[max(goal-caL,1):min(goal+caR,l)];


% this is currently not used
function ResizeImages(im_size,fn,is)
% ims(max(is)).im=zeros(im_size);  % this doesn't appear to save any time
for i=is
    i
    im=MyAviRead(fn,i);
    ims(i).im=double(imresize(im(5:484,:),[90,360]));
end
save([fn(1:end-4) 'RS.mat'],'is','im_size','ims');
