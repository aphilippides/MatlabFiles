function LocustTrackingHand(fn,vObj)

% CheckhandTracking(fn,vObj)
% return

% prepare the file for reading
if(nargin<2)
    fn='PIC_0947-x2 good e.g. reaching leg.MP4';
    vObj=VideoReader(fn);
end
if 0
    fps=get(vObj,'FrameRate');
ht=get(vObj,'Height');
wid=get(vObj,'Width');
numFr=get(vObj,'NumberOfFrames');
else
    fps=200;
    ht=360;
    wid=640;
    numFr=500;
    vObj=[];
end

% prepare output files
alldat=[fn(1:end-4) 'JointData.mat'];
if(~exist(alldat,'file'));
    TrackedData=[];
else
    load(alldat);
end


inp=[];
while(isempty(inp))
    inp=input('enter start time in secs: ');
end
StartFr=GetStartFrame(round(inp*fps),numFr,vObj);
StartTime=StartFr/fps;
fr_gap=10;
frs=StartFr:fr_gap:numFr;

numTracked=1;%length(TrackedData)+1;numJoint=1;
while 1
    inp=ForceNumericInput('1 to do a new point; 0 to end: ');
    if(isequal(inp,0))
        break;
    elseif(isequal(inp,1))
        TrackJoint(frs,vObj,StartFr,alldat,numTracked);
        numTracked=numTracked+1;
    end
end

function TrackJoint(frs,vObj,StartFr,alldat,numTracked)
% initialise
TrackedData(numTracked).StartFr=StartFr;
TrackedData(numTracked).EndFr=max(frs);
pos=zeros(max(frs),2)*NaN;
fr=zeros(max(frs),1)*NaN;
for i=1:length(frs)
    fr(i)=frs(i);
    if(i==1)
        [pos(fr(i),:),AxTr]=ClickAndAdjustPerson(frs(i),vObj);
%         [pos(i,:),AxTr]=ClickPersonOnce(frs(i),vObj);
%         CheckStartPos;

    else
%         [pos(i,:),AxTr]=ClickAndAdjustPerson(frs(i),vObj,AxTr);      
        [pos(fr(i),:),AxTr]=ClickPersonOnce(frs(i),vObj,AxTr);      
    end
    if(isequal(pos(i,1),-1))
        pos=pos(1:i-1,:);
        fr=fr(1:i-1);
        TrackedData(numTracked).EndFr=fr(i);
        save(alldat,'TrackedData','StartFr','numTracked');
       break;
    else
        save(alldat,'pos','fr','-append');
        TrackedData(numTracked).pos=pos;
        TrackedData(numTracked).fr=fr;
    end
end
save(alldat,'TrackedData','StartFr','numTracked');


function[pos,AxEnd]=ClickPersonOnce(StartFr,vObj,AxTr)

figure(1)
clf
im=MyAviRead([],StartFr,vObj);
imagesc(im);
axis equal;

if(nargin<3)
    axis tight;
else
    axis(AxTr);        
end

subplot(3,1,1)
title(['click joint position in *this* fig; x = stop'])
% this governs the width of the axis
axl=50;
[x,y,b]=ginput(1);
if(isequal(b,120))
    pos=[-1 -1];
    AxEnd=axis;
    return;
else
    AxEnd=[x-axl,x+axl,y-axl,y+axl];
    pos=[x y];
    
    % plot the previous data
    figure(2)
    imagesc(im);
    axis equal;
    hold on
    plot(x,y,'ro','MarkerSize',14);
    axis(AxEnd)
    hold off
    title('Initial image and tracked position')
end

function CheckhandTracking(fn,vObj)
% prepare output files
alldat=[fn(1:end-4) 'AllData.mat'];
load(alldat);
numTracked=length(TrackedData);
im=MyAviRead([],1,vObj);
figure(1)
imagesc(im);
axis equal
hold on
col=['b';'k';'r';'g';'y'];
for i=1:numTracked
    indivout=[fn(1:end-4) 'Indiv' int2str(i) '.mat'];
    load(indivout);
    nsteps=size(pos,1)-1;
%     fr=[0:nsteps]*fr_gap+StartFr;
%     save(indivout,'fr','-append');
        isequal(TrackedData(i).pos,pos)
        isequal(TrackedData(i).fr,fr)
    figure(1)
    plot(pos(:,1),pos(:,2),col(mod(i,5)+1,:))
    figure(2)
    plot(fr,pos(:,1),fr,pos(:,2))
    hold on
    figure(3)
    for j=1:(nsteps+1)
        im=MyAviRead([],fr(j),vObj);
        figure(3)
        imagesc(im);
        axis equal
        hold on
        plot(pos(j,1),pos(j,2),'ro','MarkerSize',14);
        hold off
    end
end
figure(1)
hold off
figure(2)
hold off




function[pos,AxEnd]=ClickAndAdjustPerson(StartFr,vObj,AxTr)
im=MyAviRead([],StartFr,vObj);
imagesc(im);
axis equal;

if(nargin<3)
    axis tight;
else
    axis(AxTr);
end
title(['click person to be tracked and adjust'])
xlabel(['return when done; x to stop tracking'])
hold on

% this governs the width of the axis
axl=150;
h=[];
while 1
    [x,y,b]=ginput(1);
    if(isempty(x))
        if(~isempty(pos))
            delete(h);
            hold off
            AxEnd=axis;
            return;
        end
    elseif(isequal(b,120))
        pos=[-1 -1];
        AxEnd=axis;
        return;
    end
    delete(h);
    h=plot(x,y,'ro','MarkerSize',14);
    axis([x-axl,x+axl,y-axl,y+axl])
    pos=[x y];
end


% function[trac]=TrackPerson(curr_fr,numFr,vObj)
% 
% numadd=25;
% while 1
%     im=MyAviRead([],curr_fr,vObj);
%     imagesc(im);
%     axis equal;
%     axis tight;
%     title(['currently frame ' int2str(curr_fr) '/' int2str(numFr) ...
%         '; s to start tracking'])
%     xlabel(['up/down arrows to -/+ ' int2str(numadd) ' frames; s to stop'])
%     [x,y,b]=ginput(1);
%     if(isequal(b,30))
%         % up arrow
%         curr_fr=max(1,curr_fr-numadd);
%     elseif(isequal(b,31))
%         % down arrow
%         curr_fr=min(numFr,curr_fr+numadd);
%     elseif(isequal(b,115))
%         % s is pressed
%         break;
%     end
% end


function[curr_fr]=GetStartFrame(curr_fr,numFr,vObj)

numadd=5;
while 1
    im=MyAviRead([],curr_fr,vObj);
    imagesc(im);
    axis equal;
    axis tight;
    title(['currently frame ' int2str(curr_fr) '/' int2str(numFr)])
    xlabel(['left/right arrows to -/+ ' int2str(numadd) ' frames; s to start tracking'])
    [x,y,b]=ginput(1);
    if(isequal(b,28))
        % left arrow
        curr_fr=max(1,curr_fr-numadd);
    elseif(isequal(b,29))
        % right arrow
        curr_fr=min(numFr,curr_fr+numadd);
    elseif(isequal(b,115))
        % s is pressed
        break;
    end
end


% function[im]=MyAviRead(ff,i,nf)
%
% function returns frame i from filename ff
% it defaults to using mmread. However, it can be made to use aviread (for
% speed: think aviread is a bit quicker but haven't checked recently if
% nf=1 and if line 9 is changed

function[im]=MyAviRead(ff,i,vObj)
if(nargin==3)
    if(~isempty(vObj))
        im = read(vObj, i);
    else
        if(i<0)%1e3)
            k=aviread(ff,i);
            im=k.cdata;
        else
            fb=ff(1:end-4);
            of=[fb '/' fb 'Fr' int2str(i) '.mat'];
            if(isfile(of))
                load(of)
            else
                k=mmread(ff,i);
                if(isempty(k.frames))
                    im=[];
                else
                    im=k.frames.cdata;
                end
            end
        end
    end
else
    fb=ff(1:end-4);
    of=[fb '/' fb 'Fr' int2str(i) '.mat'];
    if(isfile(of))
        load(of)
    else
        k=mmread(ff,i);
        im=k.frames.cdata;
    end
end