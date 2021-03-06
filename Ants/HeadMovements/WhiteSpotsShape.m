function WhiteSpotsShape

% Pick Starting Spot and threshold
% PickSpotAndThresh

ConsolidateFiles
WhiteSpots
% GetWhiteSpots

% CheckWhiteSpots('V1even_SpotsAnalysis.mat')
% CheckWhiteSpotsHand('V1even_SpotsAnalysis.mat')

function ConsolidateFiles
cd C:\_MyDocuments\WorkPrograms\Bees\bees11\
SpotsDir='SpotsAnalysis/';
s=dir([SpotsDir '*SpotsAnalysis.mat']);
PauseDir='FilesWithIndexesOfPausesAndSaccades/';
ClickDir='ClickedData2011/';
hcd=cd;
fbit='LenaFlights2011';
for i=length(s)

    SpotsFile=s(i).name
    [isf,ImDir]=FolderName(SpotsFile,fbit);
    if(isf)
        [a,namematchlist]=xlsread([SpotsDir 'NameMatching.xlsx']);
        row=strmatch(SpotsFile,namematchlist(:,3));
        if(~isempty(row))
            load([SpotsDir SpotsFile])
            PauseFile=[char((namematchlist(row,2))) '.mat'];
            load([PauseDir PauseFile])
            ClickFile=[char(namematchlist(row,1)) '.mat'];
            load([ClickDir ClickFile])
            FullFile=[SpotsFile(1:end-22) '_SpotsFull.mat']
            save(FullFile)
        else
            keyboard
        end
    else
        keyboard
    end
end


function WhiteSpots
cd C:\_MyDocuments\WorkPrograms\Bees\bees11\SpotsAnalysis
s=dir('../SpotsAnalysis/*SpotsAnalysis.mat');
f2='../FilesWithIndexesOfPausesAndSaccades/';
hcd=cd;
fbit='..\LenaFlights2011';
for i=1:length(s)
    i
        fn1=s(i).name
        fn2=[f2 fn1(1:end-17) 'PauseSacc.mat'];
        isfile(fn2)
        fn3=[fn1(1:end-17) 'SpotsAndy.mat'];
        
        [isf,fdr]=FolderName(fn1,fbit);
        load(fn2)
%     cd(fdr)
    tot(i)=0;
    for j=1:size(inds_sacc,1)
        is=inds_sacc(j,1):inds_sacc(j,2);
        tot(i)=tot(i)+length(is);
%         CheckWhiteSpots(is,fn3,fdr)
    end
 
%     cd(hcd);
%     
end
tot

function PickSpotAndThresh
% cd C:\_MyDocuments\WorkPrograms\Bees\bees11\SpotsAnalysis
s=dir('../SpotsAnalysis/*SpotsAnalysis.mat');
s2=dir('../FilesWithIndexesOfPausesAndSaccades/*.mat');
f2='../FilesWithIndexesOfPausesAndSaccades/';
s(1).isFDr=[];
s2(1).isFDr=[];
% load FileList
hcd=cd;

for i=1:length(s)
    fn1=s(i).name;
    fn2=[f2 fn1(1:end-17) 'PauseSacc.mat'];
    [isf,fdr]=FolderName(fn1,'E:\LenaFlights2011\');
    
    load(fn1)
    load(fn2)
    cd(fdr)
    ms=dir('HM*Hand_3.mat');
    load(ms(1).name);
    for j=1:size(inds_sacc,1)
        if(j==1) 
            startsp(j)=PickSandT(inds_sacc(j,:),AntennaeBase);
        else
            startsp(j)=PickSandT(inds_sacc(j,:),AntennaeBase,startsp(j-1).th);
        end
    end
%     fn3=s2(i).name;
%     load(fn3)
%     if((isempty(s2(i).isFDr))||(s2(i).isFDr==0))
%         s2(i).isFDr=CopyFiles(inds_sacc,fn3);
%     end
%     save FileList.mat s
    cd(hcd);
    save([fn1(1:end-17) 'SpotsAndy.mat']);
end

function[startsp]=PickSandT(isacc,AntennaeBase,th)

if(nargin<3) 
    th=0.5;
    th=150;%0.5;
end

% get spot
np=4;
g=floor((isacc(2)-isacc(1))/np);
is=isacc(1):g:isacc(2);
ind=0;
p=[];
imad=[0.15 0.4];
thadd=2;%0.01;
sfr=[];
bs=[];ph=[];sfh=[];
N=50;
inds=is+ind;
for i=1:np
    ims(i).im=imread(beefn(inds(i)));
end
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));
ab1=AntennaeBase(1:2:end, :);
ab2=AntennaeBase(2:2:end, :);
while 1
    for i=1:np
        h(i)=subplot(2,2,i);
        imagesc(ims(i).im)
        if(~isempty(p))            
            bs=SpotOutline(ims(i).im,x,y,th,imad,N,dangs(i),vab,...
                ab1(inds(i),:),ab2(inds(i),:),sfind,mdi,1);
        else
        end
        title(['frame ' int2str(inds(i)) '; sacc' int2str(isacc) '; th=' num2str(th)])
    end
    hx=xlabel('click spot; return end; n next; x bad; arrows threshold');
%     MoveXYZ(hx,-0.5,0,0)
    if(~isempty(sfh))
        subplot(sfh),
        ylabel(['start frame ' int2str(sfr)])
    end
    [p,q,b]=ginput(1);
    delete(bs);
    if(isempty(p))
        startsp.x=[x,y];
        startsp.f=sfr;
        startsp.th=th;
        break;
    elseif(b==120)    % bad frame
        startsp.x=[-1 -1];
        startsp.f=-1;
        startsp.th=[];
        break;
    elseif(b==110)  % move on a frame
        ind=mod(ind+1,g);
        inds=is+ind;
        for i=1:np
            ims(i).im=imread(beefn(inds(i)));
        end
    elseif(b==30)  % move on a frame
        th=min(th+thadd,255);
%         th=min(th+thadd,1);
    elseif(b==31)  % move on a frame
        th=max(th-thadd,0);
    elseif(b==1)
        x=p;
        y=q;
        sfind=inds(gca==h);
        dangs=AngularDifference(oAnt(sfind),oAnt(inds));
        ds=CartDist([ab1(sfind,:);ab2(sfind,:)],[x y]);
        [m,mdi]=min(ds);
%         sfang=Ant(sfind);
        % vector to each of the antenna bases
        vab=[[x,y]-ab1(sfind,:);[x,y]-ab2(sfind,:)];
        if(mdi==1) 
            dabs=[ab1(sfind,1)-ab1(inds,1) ab1(sfind,2)-ab1(inds,2)];
%             oabs=ab1(inds,:);
        else
            dabs=[ab2(sfind,1)-ab2(inds,1) ab2(sfind,2)-ab2(inds,2)];
        end            
        sfr=inds(gca==h);
        sfh=h(gca==h);
%         delete(ph);
%         hold on
%         ph=plot(p,q,'gx');
%         hold off
%         subplot(sfh),
%         ylabel(['start frame ' int2str(sfr)])
    end
end

function[isFdr,dn]=FolderName(fn,dnbit)
if(nargin<2)
    dnbit='..\LenaFlights2011';
end
n=[strfind(fn,'_') strfind(fn,'.')];
ind=1;
isFdr=0;
while (ind<=min(3,length(n)));
    fdr=fn(1:n(ind)-1)
    dn=([dnbit '\' fdr '\']);
    if(isfile(dn))
        isFdr=1;
        break;
    end
    ind=ind+1;
end
if(~isFdr)
    dn='';
end

function[bs]=SpotOutline(im,x1,y1,th,imad,N,rang,vab,ab1,ab2,sfi,oe,pl)
rc1=round(max(1,[y1-N x1-N]));
rc2=round(min([size(im,1) size(im,2)],[y1+N x1+N]));
im2=im(rc1(1):rc2(1),rc1(2):rc2(2),1);
imad=im2;%imadjust(im2, imad, []);
bw=imad>th;%im2bw(imad, th);
% spots= bwlabeln(bw,4);
[B,L] = bwboundaries(bw);
params=regionprops(L, 'Area', 'Orientation', 'Perimeter', 'Centroid');%, ...
%     'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');
% imagesc(im2),colormap gray
axis([rc1(2) rc2(2) rc1(1) rc2(1)])
bs=[];
R=[cos(rang) -sin(rang);sin(rang) cos(rang)];
rv=(R*vab')'+[ab1;ab2];
x=[ab1;rv(1,:);ab2;rv(2,:)];
predx=x(oe*2,:);

ars=[params.Area];
inds=find(ars>10);
if(~isempty(inds))
    cas=[params(inds).Centroid];
    cs=[cas(1:2:end)'+rc1(2)-1 cas(2:2:end)'+rc1(1)-1]; 
    ds=CartDist(cs,predx);
    [mind,mindi]=min(ds);
    sp=inds(mindi);
end
if(pl)
    hold on
    ph=plot(x1,y1,'gx');  % plot the spot
    plot(x(1:2,1),x(1:2,2),'b- .',x(3:4,1),x(3:4,2),'r- .')
    for k = sp%1:length(B)
        boundary = B{k};
        bs=[bs;plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'r')];%, 'LineWidth', 2)
    end
    hold off
end

function GetSpotData
imad=imadjust(im2, imad, []);
bw=im2bw(imad, th);
spots= bwlabeln(bw,4);
[B,L] = bwboundaries(bw);
spots= bwlabeln(bw,4);
params=regionprops(spots, 'Area', 'Orientation', 'Perimeter', 'Centroid', ...
    'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');

% We are trying to discriminate between the two cases. In one, the
% spots would rotate during saccades/slopy pauses, and it's area,
% length of the axes and centroid won't change. In the other, it will
% morph instead of rotating as a solid body, i.e. the Orientation
% parameter will change unpredictably, as well as the area, axis length
% and centroid params. Orientation may be not a good parameter for
% round spots, i.e. with Centroid close to 0.

%     spots_areas=[params.Area];
% keyboard
%     [min_d, idx]=min(
%     [max_ar,idx]=max(spots_areas);
coords=[params.Centroid];

dist=(size(bw,1)/2-coords(1:2:end)).^2+(size(bw,2)/2-coords(2:2:end)).^2;

ar=[params.Area];

ind_ar=find(ar>10 & ar<200);
dist_c=dist(ind_ar);

if (~isempty(ind_ar) )

    idx=find(dist==min(dist_c),1);

    %         plot(coords(idx*2-1), coords(idx*2), 'or')


    params=params(idx);
    arr=ar(idx);

    area(k)=[params.Area];
    orient(k)=[params.Orientation];
    perim(k)=[params.Perimeter];
    majorax(k)=[params.MajorAxisLength];
    minorax(k)=[params.MinorAxisLength];
    ecc(k)=[params.Eccentricity];
    % OR: some weird thing for centroidL
    cent(k,:)=sqrt(params.Centroid(1)^2+params.Centroid(2)^2);
    centr(k,:)=params.Centroid;
    spot(k).mask=(spots==idx);
    spot(k).im=uint8(spot(k).mask).*im2;
    spot(k).rawim=im2;

    %     oAnt_pr=[oAnt_pr; oAnt(k)];
    %     isClicked_pr=[isClicked_pr; i];
end;



function[sn]=beefn(i)
if(i<10) sn=['0000' int2str(i) '.jpeg'];
elseif(i<100) sn=['000' int2str(i) '.jpeg'];
elseif (i<1000) sn=['00' int2str(i) '.jpeg'];
elseif (i<10000) sn=['0' int2str(i) '.jpeg'];
else sn=[int2str(i) '.jpeg'];
end


function CheckWhiteSpots(is,fnsp,fdr)
% load hm-8-top-080811-HeadPos0000Fr0_738Hand_3.mat
load(fnsp)
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

% load(fn)
yf=[];
ang=oAnt(65);
addbit=1;

s_ind=is(1);
c_im=double(spot(s_ind).im);
c_rawim=double(spot(s_ind).rawim);
rc=regionprops(bwlabeln(c_im>0),'Centroid','ConvexHull','PixelList','BoundingBox');
[h,w]=size(c_rawim);
sp=max(floor(rc.BoundingBox(1:2)-2*addbit),[1 1]);
ep=min(ceil(rc.BoundingBox(1:2)+rc.BoundingBox(3:4)+2*addbit),[h w]);
cb_im=c_rawim(sp(2):ep(2),sp(1):ep(1));

cst=rc.Centroid;
cvh=rc.ConvexHull;
cvh0=[cvh(:,1)-cst(:,1) cvh(:,2)-cst(:,2)];
[m,ep_i]=max(cvh0(:,1));
% angep=cart2pol(cvh0(ep_i,1),cvh0(ep_i,2));
% c_ar=polyarea(cvh(:,1),cvh(:,2));
cpix_x=rc.PixelList(:,1);
cpix_y=rc.PixelList(:,2);
c_in = sum(inpolygon(cpix_x,cpix_y,cvh(:,1),cvh(:,2)));
% c_all=sum(im(:)>0);
adj(1).s_ind=s_ind;
save(fn,'adj','-append')
angs=[-90:1:90];

for i=is
    im=double(spot(i).im);
    rawim=double(spot(i).im);
    rang=AngularDifference(oAnt(i),ang);
    v=im(:);
    [y,x]=hist(v(v>0),8:16:256);
    yf=[yf;y./sum(y)];
    rim=imrotate(im,rang);
    %     rc=regionprops(bwlabeln(rim>0),'Centroid','ConvexHull','PixelList');
    rc=regionprops(bwlabeln(im>0),'Centroid','ConvexHull','PixelList','BoundingBox');
    %     rs=sum(rim>0,1);
    %     r2=rim(:,round(rc.Centroid(1)))>0;
    %     r3=rim(round(rc.Centroid(2)),:)>0;
    %     w(i)=find(rs,1,'last')-find(rs,1)-1;
    %     w2(i)=find(r2,1,'last')-find(r2,1)-1;
    %     w3(i)=find(r3,1,'last')-find(r3,1)-1;
    %     rrc=[cos(rang) -sin(rang);sin(rang) cos(rang)]*centr(i,:)';

    rcc=rc.Centroid;
    pix_x=rc.PixelList(:,1);
    pix_y=rc.PixelList(:,2);
    [h,w]=size(rawim);
    sp=max(floor(rc.BoundingBox(1:2)-addbit),[1 1]);
    ep=min(ceil(rc.BoundingBox(1:2)+rc.BoundingBox(3:4)+addbit),[h w]);
    b_im=rawim(sp(2):ep(2),sp(1):ep(1));
    for j=1:length(angs)
        rang=angs(j)*pi/180;
        % rotate bounding box
        rotm=[cos(rang) -sin(rang);sin(rang) cos(rang)];
        rcvh0=[rotm*cvh0']';
        % put it at centre of new shape
        rcvh=[rcvh0(:,1)+rcc(:,1) rcvh0(:,2)+rcc(:,2)];
%         ep=rcvh(ep_i,:);
        % calc num in convex hull
        in = inpolygon(pix_x,pix_y,rcvh(:,1),rcvh(:,2));
        pcin(j).s=100*sum(in)/length(in);%c_in;
        pcin(j).rcvh=rcvh;
    end
    
    dpc=abs(100-[pcin.s]);    
    [mdpc,ind]=min(dpc);
    [ma,mi]=findextrema_diff(dpc);
    if(~isempty(mi))
        mi=round(mi);
        ind=mi(find(dpc(mi)==mdpc));
        if(isempty(ind))
            [mdpc,ind]=min(dpc);
        end
        if(length(ind)~=1)
            %         keyboard;
            ds=abs(angs(ind)-heading(i-1).a_cvh)
            [mdd,ind2]=min(ds);
            ind=ind(ind2);
        end
    end
%     is=find(dpc==mdpc);
%     ind=round(median(is));
    
    heading(i).a_cvh=angs(ind);
    heading(i).rcvh=pcin(ind).rcvh;
    heading(i).e_cvh=pcin(ind).s;
    
    if 0
        figure(2)
    imagesc(im);    
    hold on;
    plot(pcin(ind).rcvh(:,1),pcin(ind).rcvh(:,2),'w')
    xlabel(['%in=' int2str(pcin(ind).s)])
    hold off
    figure(3),
    plot(angs,dpc,angs,100-[pcin.s],'k:',angs(ind),dpc(ind),'r*')
    end
    %     [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, angle, step,0);
    

% figure(2);
% imagesc(spot(i).rawim);
% colormap gray
% hold on
% plot(rcvh(:,1),rcvh(:,2),'r',rcc(1),rcc(2),'r.',ep(1),ep(2),'g.')
% hold off;
% axis equal
% xlabel(['%in=' int2str(pcin)])% '; %olap=' int2str(pcolap)];
%             [x,y,p]=ginput(1);


        %     rc=rotate(centr(i,:),AngularDifference(oAnt,ang));
end
figure(1)
m=3;n=2;
eval(['arf=area(is);'])%-mode(area(is));
r_or=180/pi*AngularDifference(oAnt(is),o(is)*pi/180);

% figure(1)
% m=5;n=1;
% subplot(m,n,1),plot(is,arf),axis tight
% subplot(m,n,2),plot(is,r_or),axis tight
% subplot(m,n,3),plot(is,dAnt(is)),axis tight
% subplot(m,n,4),plot(is,oAnt(is)),axis tight
% orf=r_or(is)-mode(area(is));
eval(['o=-orient;'])
r_or=180/pi*AngularDifference(oAnt(is),o(is)*pi/180);
e1=(AngularDifference(oAnt(is),[heading(is).a_cvh]*pi/180))*180/pi;
e2=(AngularDifference(o(is)*pi/180,[heading(is).a_cvh]*pi/180))*180/pi;
subplot(m,n,1),plot(is,o(is)),axis tight,title('Major axis')
subplot(m,n,3),plot(is,oAnt(is)*180/pi),axis tight,title('clicked')
subplot(m,n,5),plot(is,[heading(is).a_cvh]),axis tight,title('spot')
subplot(m,n,6),plot(is,[heading(is).e_cvh]),axis tight
subplot(m,n,2),plot(is,r_or-median(r_or))%,is,e1-median(e1),'r:',is,e2-median(e2),'k--'),axis tight
axis tight,ylim([-10 10])
subplot(m,n,4),plot(is,e1-median(e1))%,is,e2-median(e2),'k--'),axis tight
axis tight,ylim([-10 10])
save tempdata
% plot(is,w(is),is,w2(is),'r:',is,w3(is),'k--'),axis tight
Y = pdist(yf, 'euclidean');
figure(2)
imagesc(squareform(Y))

function CheckWhiteSpotsHand(fn)
load hm-8-top-080811-HeadPos0000Fr0_738Hand_3.mat
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

load(fn)
is=101:216;
eval(['arf=area(is);'])%-mode(area(is));
eval(['o=orient;'])
r_or=180/pi*AngularDifference(oAnt(is),o(is)*pi/180);

figure(1)
m=5;n=1;
subplot(m,n,1),plot(is,arf),axis tight
subplot(m,n,2),plot(is,r_or),axis tight
subplot(m,n,3),plot(is,dAnt(is)),axis tight
subplot(m,n,4),plot(is,oAnt(is)),axis tight
% orf=r_or(is)-mode(area(is));
yf=[];
ang=oAnt(65);

s_ind=is(1);
im=double(spot(s_ind).im);
rc=regionprops(bwlabeln(im>0),'Centroid','ConvexHull','PixelList');
cst=rc.Centroid;
cvh=rc.ConvexHull;
cvh0=[cvh(:,1)-cst(:,1) cvh(:,2)-cst(:,2)];
[m,ep_i]=max(cvh0(:,1));
angep=cart2pol(cvh0(ep_i,1),cvh0(ep_i,2));
cim=im;
c_ar=polyarea(cvh(:,1),cvh(:,2));
c_all=sum(im(:)>0);
adj(1).s_ind=s_ind;
save(fn,'adj','-append')

for i=is
    im=double(spot(i).im);
    rang=AngularDifference(oAnt(i),ang);
    v=im(:);
    [y,x]=hist(v(v>0),8:16:256);
    yf=[yf;y./sum(y)];
    rim=imrotate(im,rang);
    %     rc=regionprops(bwlabeln(rim>0),'Centroid','ConvexHull','PixelList');
    rc=regionprops(bwlabeln(im>0),'Centroid','ConvexHull','PixelList');
    %     rs=sum(rim>0,1);
    %     r2=rim(:,round(rc.Centroid(1)))>0;
    %     r3=rim(round(rc.Centroid(2)),:)>0;
    %     w(i)=find(rs,1,'last')-find(rs,1)-1;
    %     w2(i)=find(r2,1,'last')-find(r2,1)-1;
    %     w3(i)=find(r3,1,'last')-find(r3,1)-1;
    %     rrc=[cos(rang) -sin(rang);sin(rang) cos(rang)]*centr(i,:)';

    rang=rand(1)-0.5;
    rcc=rc.Centroid;
    pix_x=rc.PixelList(:,1);
    pix_y=rc.PixelList(:,2);
    tst='move centroid or click near end to rotate';
    while 1
        rotm=[cos(rang) -sin(rang);sin(rang) cos(rang)];
        rcvh0=[rotm*cvh0']';
        rcvh=[rcvh0(:,1)+rcc(:,1) rcvh0(:,2)+rcc(:,2)];
        ep=rcvh(ep_i,:);

        % calc num in convex hull
        in = inpolygon(pix_x,pix_y,rcvh(:,1),rcvh(:,2));
        rim=imrotate(im,180/pi*AngularDifference(angep,rang),'crop');
        dim=double(rim>0)-double(cim>0);
        figure(3);
        subplot(2,1,1),imagesc(rim);
        subplot(2,1,2),imagesc(cim);
        pcin=round(100*sum(in)/c_ar);
        pcolap=round(100*sum(abs(dim(:)))/c_all);

        figure(2);
        imagesc(spot(i).rawim);
        colormap gray
        hold on
        plot(rcvh(:,1),rcvh(:,2),'r',rcc(1),rcc(2),'r.',ep(1),ep(2),'g.')
        hold off;
        axis equal
        xlabel(['%in=' int2str(pcin)])% '; %olap=' int2str(pcolap)];
        %             [x,y,p]=ginput(1);

        if(i==s_ind)
            title('Original file; return to continue')
            ginput(1);
            i_m=0;
        else
            [i_m,b,p,q] = GetNearestClickedPt([rcc;ep],tst);
        end

        if(i_m==0)
            adj(i).rang=rang;
            adj(i).rcc=rcc;
            adj(i).rcvh0=rcvh0;
            adj(i).rcvh=rcvh;
            save(fn,'adj','-append')
            break;
        elseif(i_m==1)
            %         (CartDist([x,y]-rcc)<3)
            rcc=[p,q];
        else
            vs=[ep-rcc;[p,q]-rcc];
            as=cart2pol(vs(:,1),vs(:,2));
            rang=as(2);
        end
    end
    %     rc=rotate(centr(i,:),AngularDifference(oAnt,ang));
end
subplot(m,n,5),
plot(is,w(is),is,w2(is),'r:',is,w3(is),'k--'),axis tight
Y = pdist(yf, 'euclidean');
figure(2)
imagesc(squareform(Y))

function GetWhiteSpots(is,fnsp,fdr)
clear all
% cd ('D:\Experiment\Bee2011\hm-32-top-030811')
% load('D:\Experiment\Bee2011\hm-32-top-030811\hm-32-top-030811-total.mat')

load(fnsp)
% pref='temp';%input('Enter the file name prefix: ','s');
N=24; %half of the side of the square around the clicked points
arr=20;

area_n=[80];
orient=[];
perim=[];
majorax=[];
minorax=[];
ecc=[];
cent=[];
oAnt_pr=[];
isClicked_pr=[];

Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

odde={'V1odd';'V1even'};
for i=1:2
    pref=char(odde(oddev));
    oe=2-oddev;
    for k=is
        i=isClicked(k)

        % OR code: x1=round(AntennaeBase(k*2-1,1));
        % the original just looked at one antenna
        x1=round(AntennaeBase(k*2-oe,1));
        y1=round(AntennaeBase(k*2-oe,2));


        %     x2=AntennaeBase(i*2,1)
        %     y2=AntennaeBase(i*2,2)


        if(i<10) sn=['0000' int2str(i) '.jpeg'];
        elseif(i<100) sn=['000' int2str(i) '.jpeg'];
        elseif (i<1000) sn=['00' int2str(i) '.jpeg'];
        elseif (i<10000) sn=['' int2str(i) '.jpeg'];
        else sn=[int2str(i) '.jpeg'];
        end

        im=imread(sn);
        im2=im(y1-N:y1+N,x1-N:x1+N);
        imad=imadjust(im2, [0.15 0.4], []);
        level =graythresh(imad)
        bw=im2bw(imad, level);
        % bw=im>50;

        %
        %     imshow(bw)


        %     spots= bwconncomp(bw,4);
        spots= bwlabeln(bw,4);
        params=regionprops(spots, 'Area', 'Orientation', 'Perimeter', 'Centroid', ...
            'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');

        % We are trying to discriminate between the two cases. In one, the
        % spots would rotate during saccades/slopy pauses, and it's area,
        % length of the axes and centroid won't change. In the other, it will
        % morph instead of rotating as a solid body, i.e. the Orientation
        % parameter will change unpredictably, as well as the area, axis length
        % and centroid params. Orientation may be not a good parameter for
        % round spots, i.e. with Centroid close to 0.

        %     spots_areas=[params.Area];
        % keyboard
        %     [min_d, idx]=min(
        %     [max_ar,idx]=max(spots_areas);
        coords=[params.Centroid];

        dist=(size(bw,1)/2-coords(1:2:end)).^2+(size(bw,2)/2-coords(2:2:end)).^2;

        ar=[params.Area];

        ind_ar=find(ar>20 & ar<100);
        dist_c=dist(ind_ar);
        %     arr=(area_n-ar).^2;

        %     [v_d,~]=sortrows(dist');
        %     [v_a,~]=sortrows(arr');

        %     rank_d=[]; rank_a=[];
        %
        %     for j=1:length(v_d)
        %         rank_d=[rank_d; min(find(v_d==dist(j)))];
        %         rank_a=[rank_a; min(find(v_a==arr(j)))];
        %     end;



        %     keyboard

        %     idx=find(dist==min(dist_c));

        % if (isempty(ind_ar) )
        %     idx=min(find(dist==min(dist)));
        % else idx=min(find(dist==min(dist_c)));
        % end;

        hold on
        %

        if (~isempty(ind_ar) )

            idx=find(dist==min(dist_c),1);

            %         plot(coords(idx*2-1), coords(idx*2), 'or')


            params=params(idx);
            arr=ar(idx);

            area(k)=[params.Area];
            orient(k)=[params.Orientation];
            perim(k)=[params.Perimeter];
            majorax(k)=[params.MajorAxisLength];
            minorax(k)=[params.MinorAxisLength];
            ecc(k)=[params.Eccentricity];
            % OR: some weird thing for centroidL
            cent(k,:)=sqrt(params.Centroid(1)^2+params.Centroid(2)^2);
            centr(k,:)=params.Centroid;
            spot(k).mask=(spots==idx);
            spot(k).im=uint8(spot(k).mask).*im2;
            spot(k).rawim=im2;

            %     oAnt_pr=[oAnt_pr; oAnt(k)];
            %     isClicked_pr=[isClicked_pr; i];
        end;

        % % %
        %       keyboard
    end;
    area=area';
    % orientation of the line that connects spots
    % Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
    % [oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

    % cd ('D:\Experiment\Bee2011\Clicked\Spots')
    save ([pref '_SpotsAnalysis.mat'], 'oAnt', 'isClicked', 'area', 'orient',...
        'perim', 'majorax', 'minorax', 'ecc', 'cent',...
        'centr','spot','dAnt')

    figure
    plot(oAnt*180/pi, 'r')
    hold on
    plot(orient, 'b')
    plot(ecc, 'g')
    plot(area, 'k')
end

function[isFdr]=CopyFiles(inds_sacc,fn)
% get dir
n=strfind(fn,'_');
ind=1;
isFdr=0;
while (ind<=min(2,length(n)));
    fdr=fn(1:n(ind)-1)
    dn=(['E:\LenaFlights2011\' fdr '\']);
    if(isfile(dn))
        isFdr=1;
        break;
    end
    ind=ind+1;
end
if(isFdr)
    cd ../LenaFlights2011;
    % make new directory
    if(~isfile(fdr))
        mkdir(fdr);
    end
    cd(fdr)

    for j=1:size(inds_sacc,1)
        is=inds_sacc(j,1):inds_sacc(j,2);
        for i=1:length(is)
            bfn=beefn(is(i));
            if 1%(~isfile(bfn))
                cfn=[dn bfn];
                cfn2=[dn bfn(2:end)];
                if(isfile(cfn)) copyfile(cfn,bfn);
                elseif(isfile(cfn2))
                    copyfile(cfn2,bfn);
                else
                    keyboard
                end
            end
        end
        disp([fdr ' ' int2str([j size(inds_sacc,1)])])
    end
    s=dir([dn '*.mat']);
    for j=1:length(s)
        mfn=s(j).name;
        if(~isfile(mfn))
          copyfile([dn mfn],mfn);
        end
    end
end

function GetWhiteSpotsLena
clear all
% cd ('D:\Experiment\Bee2011\hm-32-top-030811')
% load('D:\Experiment\Bee2011\hm-32-top-030811\hm-32-top-030811-total.mat')

load hm-8-top-080811-HeadPos0000Fr0_738Hand_3.mat
% pref='temp';%input('Enter the file name prefix: ','s');
N=17; %half of the side of the square around the clicked points
arr=20;

area_n=[80];
orient=[];
perim=[];
majorax=[];
minorax=[];
ecc=[];
cent=[];
oAnt_pr=[];
isClicked_pr=[];

Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

is=100:215;
odde={'V1odd';'V1even'};
for oddev=1:2
    pref=char(odde(oddev));
    oe=2-oddev;
    for k=is+1%2:length(isClicked)
        i=isClicked(k)

        % OR code: x1=round(AntennaeBase(k*2-1,1));
        % the original just looked at one antenna
        x1=round(AntennaeBase(k*2-oe,1));
        y1=round(AntennaeBase(k*2-oe,2));

        % 25b-080811 - i*2
        % hm29-top-030811 - i*2-1
        %Hm24-080811  - i*2
        % HM19-0808  i*2
        % Hm5-0708_750_1305.mat   k*2-1, level=0.37
        % hm-27-top-030811 seg1 level*1.5, k*2-1
        % HM12-0808, k*2, level aut

        %     x2=AntennaeBase(i*2,1)
        %     y2=AntennaeBase(i*2,2)


        if(i<10) sn=['0000' int2str(i) '.jpeg'];
        elseif(i<100) sn=['000' int2str(i) '.jpeg'];
        elseif (i<1000) sn=['00' int2str(i) '.jpeg'];
        elseif (i<10000) sn=['' int2str(i) '.jpeg'];
        else sn=[int2str(i) '.jpeg'];
        end

        im=imread(sn);
        im2=im(y1-N:y1+N,x1-N:x1+N);
        imad=imadjust(im2, [0.15 0.4], []);
        level =graythresh(imad)
        bw=im2bw(imad, level);
        % bw=im>50;

        %
        %     imshow(bw)


        %     spots= bwconncomp(bw,4);
        spots= bwlabeln(bw,4);
        params=regionprops(spots, 'Area', 'Orientation', 'Perimeter', 'Centroid', ...
            'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');

        % We are trying to discriminate between the two cases. In one, the
        % spots would rotate during saccades/slopy pauses, and it's area,
        % length of the axes and centroid won't change. In the other, it will
        % morph instead of rotating as a solid body, i.e. the Orientation
        % parameter will change unpredictably, as well as the area, axis length
        % and centroid params. Orientation may be not a good parameter for
        % round spots, i.e. with Centroid close to 0.

        %     spots_areas=[params.Area];
        % keyboard
        %     [min_d, idx]=min(
        %     [max_ar,idx]=max(spots_areas);
        coords=[params.Centroid];

        dist=(size(bw,1)/2-coords(1:2:end)).^2+(size(bw,2)/2-coords(2:2:end)).^2;

        ar=[params.Area];

        ind_ar=find(ar>20 & ar<100);
        dist_c=dist(ind_ar);
        %     arr=(area_n-ar).^2;

        %     [v_d,~]=sortrows(dist');
        %     [v_a,~]=sortrows(arr');

        %     rank_d=[]; rank_a=[];
        %
        %     for j=1:length(v_d)
        %         rank_d=[rank_d; min(find(v_d==dist(j)))];
        %         rank_a=[rank_a; min(find(v_a==arr(j)))];
        %     end;



        %     keyboard

        %     idx=find(dist==min(dist_c));

        % if (isempty(ind_ar) )
        %     idx=min(find(dist==min(dist)));
        % else idx=min(find(dist==min(dist_c)));
        % end;

        hold on
        %

        if (~isempty(ind_ar) )

            idx=find(dist==min(dist_c),1);

            %         plot(coords(idx*2-1), coords(idx*2), 'or')


            params=params(idx);
            arr=ar(idx);

            area(k)=[params.Area];
            orient(k)=[params.Orientation];
            perim(k)=[params.Perimeter];
            majorax(k)=[params.MajorAxisLength];
            minorax(k)=[params.MinorAxisLength];
            ecc(k)=[params.Eccentricity];
            % OR: some weird thing for centroidL
            cent(k,:)=sqrt(params.Centroid(1)^2+params.Centroid(2)^2);
            centr(k,:)=params.Centroid;
            spot(k).mask=(spots==idx);
            spot(k).im=uint8(spot(k).mask).*im2;
            spot(k).rawim=im2;

            %     oAnt_pr=[oAnt_pr; oAnt(k)];
            %     isClicked_pr=[isClicked_pr; i];
        end;

        % % %
        %       keyboard
    end;
    area=area';
    % orientation of the line that connects spots
    % Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
    % [oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

    % cd ('D:\Experiment\Bee2011\Clicked\Spots')
    save ([pref '_SpotsAnalysis.mat'], 'oAnt', 'isClicked', 'area', 'orient',...
        'perim', 'majorax', 'minorax', 'ecc', 'cent',...
        'centr','spot','dAnt')

    figure
    plot(oAnt*180/pi, 'r')
    hold on
    plot(orient, 'b')
    plot(ecc, 'g')
    plot(area, 'k')
end

