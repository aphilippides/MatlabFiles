function WhiteSpotsShapeV2

% Pick Starting Spot and threshold
CheckSpotAndThresh
% PickSpotAndThresh
% ConsolidateFiles

% RotateSpots

% WhiteSpots
% GetWhiteSpots

% CheckWhiteSpots('V1even_SpotsAnalysis.mat')
% CheckWhiteSpotsHand('V1even_SpotsAnalysis.mat')

function RotateSpots
cd C:\_MyDocuments\WorkPrograms\Bees\bees11\FullFiles2011
dlist=dir('*Adj.mat');

fll_dir=cd;

for i=1:length(dlist)
    fn1=dlist(i).name;%['FullFiles2011/' s(i).name];
    load(fn1)
    outf=[dlist(i).name(1:end-8) 'Rot.mat'];
    if 1%(~isfile(outf))
        fdr=['../' ImDir];
        cd(fdr)
        eval(['o=orient;']);
        for j=1:size(inds_sacc,1)
            IndsSaccDat(j).spot_thresh=CheckWhiteSpotsV2(inds_sacc(j,:),IndsSaccDat(j).spot_thresh,...
                AntennaeBase,o);
        end
        cd(fll_dir)
        save(outf);%,'IndsSaccDat','-append')
        clear allstartsp startsp IndsSaccDat
    end
end


function[spot]=CheckWhiteSpotsV2(isacc,spot,AntennaeBase,o_old)
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

st_i=1;

yf=[];
is=isacc(1):isacc(2);

cst=spot(st_i).cent;
cvh=spot(st_i).cvh;
cvh0=[cvh(:,1)-cst(:,1) cvh(:,2)-cst(:,2)];
% [m,ep_i]=max(cvh0(:,1));

angs=-45:0.5:45;
for i=1:length(is)
    im=imread(beefn(is(i)));
    rcc=spot(i).cent;
    d=rcc-spot(i).params.Centroid;
    spot(i).ex_x=d(1);
    spot(i).ex_y=d(2);
    spot(i).area=spot(i).params.Area;
    pix_x=spot(i).params.PixelList(:,1)+spot(i).ex_x;
    pix_y=spot(i).params.PixelList(:,2)+spot(i).ex_y;
    for j=1:length(angs)
        rang=angs(j)*pi/180;
        % rotate convex hull
        rotm=[cos(rang) -sin(rang);sin(rang) cos(rang)];
        rcvh0=(rotm*cvh0')';
        % put it at centre of new shape
        rcvh=[rcvh0(:,1)+rcc(:,1) rcvh0(:,2)+rcc(:,2)];
%         ep=rcvh(ep_i,:);

        % calc num in convex hull
        in = inpolygon(pix_x,pix_y,rcvh(:,1),rcvh(:,2));
        pcin(j).s=100*sum(in)/length(in);%c_in;
        pcin(j).rcvh=rcvh;
    end

    % find the rotatoin that has % closest to 100
    dpc=abs(100-[pcin.s]);
    [mdpc,ind]=min(dpc);
    [ma,mi]=findextrema_diff(dpc);
    if(~isempty(mi))
        mi=round(mi);
        ind=mi(dpc(mi)==mdpc);
    end
    if(isempty(mi)||isempty(ind))
        mdpc=min(dpc);
        ind=find(dpc==mdpc);
    end

    if(length(ind)~=1)
        %         keyboard;
        if(i==1)
            ind=find(angs==0);
        else
            ds=abs(angs(ind)-spot(i-1).a_cvh)
            [mdd,ind2]=min(ds);
            ind=ind(ind2);
        end
    end
%     is=find(dpc==mdpc);
%     ind=round(median(is));
    
    spot(i).a_cvh=angs(ind);
    spot(i).rcvh=pcin(ind).rcvh;
    spot(i).e_cvh=pcin(ind).s;
    
    if 1
        figure(2)
        imagesc(im);
        N=25;
        rc1=round(max(1,[rcc(1)-N rcc(2)-N]));
        rc2=round(min([size(im,1) size(im,2)],[rcc(1)+N rcc(2)+N]));
        axis([rc1(1) rc2(1) rc1(2) rc2(2)])
        hold on;
        plot(pcin(ind).rcvh(:,1),pcin(ind).rcvh(:,2),'r')
        xlabel(['%in=' int2str(pcin(ind).s)])
        hold off
        figure(3),
        plot(angs,dpc,angs,100-[pcin.s],'k:',angs(ind),dpc(ind),'r*')
    end
    %     [h,w]=size(rawim);
    %     sp=max(floor(rc.BoundingBox(1:2)-addbit),[1 1]);
    %     ep=min(ceil(rc.BoundingBox(1:2)+rc.BoundingBox(3:4)+addbit),[h w]);
    %     b_im=rawim(sp(2):ep(2),sp(1):ep(1));
    %     [h,im_matched, theta,I,J]=image_registr_MI(image1, image2, angle, step,0);
end
if 1
    figure(1)
    m=3;n=2;
    arf=[spot.area];
    o_new=[spot.ang];
    r_or=180/pi*AngularDifference(oAnt(is),-o_old(is)*pi/180);
    e1=(AngularDifference(oAnt(is),[spot.a_cvh]*pi/180))*180/pi;
    e2=(AngularDifference(oAnt(is),o_new))*180/pi;
    e3=(AngularDifference(o_old(is)*pi/180,o_new))*180/pi;
    subplot(m,n,1),plot(is,o_old(is)),axis tight,title('Major axis old')
    subplot(m,n,3),plot(is,oAnt(is)*180/pi),axis tight,title('clicked')
    subplot(m,n,5),plot(is,[spot.a_cvh]),axis tight,title('spot')
    subplot(m,n,6),plot(is,AngleWithoutFlip(o_new*180/pi)),axis tight
    subplot(m,n,2),plot(is,r_or-median(r_or),is,e1-median(e1),'r:',is,e2-median(e2),'k--'),axis tight
    axis tight,ylim([-10 10])
    subplot(m,n,4),plot(is,arf)%e1-median(e1))%,is,e2-median(e2),'k--'),axis tight
    axis tight,%ylim([-10 10])
    % plot(is,w(is),is,w2(is),'r:',is,w3(is),'k--'),axis tight
end

function[heading]=CheckWhiteSpots(isacc,spot,AntennaeBase)
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

st_i=1;

yf=[];
is=isacc(1):isacc(2);
s_ind=is(st_i);

ang=oAnt(s_ind);
addbit=1;
% c_im=double(spot(s_ind).im);

% rc1=round(max(1,[y1-N x1-N]));
% rc2=round(min([size(im,1) size(im,2)],[y1+N x1+N]));
% im2=im(rc1(1):rc2(1),rc1(2):rc2(2),1);

c_rawim=double(imread(beefn(s_ind)));

% rc=regionprops(bwlabeln(c_im>0),'Centroid','ConvexHull','PixelList','BoundingBox');
% [h,w]=size(c_rawim);
% sp=max(floor(rc.BoundingBox(1:2)-2*addbit),[1 1]);
% ep=min(ceil(rc.BoundingBox(1:2)+rc.BoundingBox(3:4)+2*addbit),[h w]);
% cb_im=c_rawim(sp(2):ep(2),sp(1):ep(1));

rc=spot(st_i);
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
    
    if 1
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
load(fn)
Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

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

% get the first point
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




function CheckSpotAndThresh
cd C:\_MyDocuments\WorkPrograms\Bees\bees11\FullFiles2011
dlist=dir('*SpotsData.mat');

fll_dir=cd;

for i=1:length(dlist)
    fn1=dlist(i).name;%['FullFiles2011/' s(i).name];
    load(fn1)
    outf=[dlist(i).name(1:end-8) 'Adj.mat'];
    if(~isfile(outf))
        fdr=['../' ImDir];
        cd(fdr)
        for j=1:size(inds_sacc,1)
            %         CheckSandT(inds_sacc(j,:),AntennaeBase,IndsSaccDat(j).spot_thresh)
            %         pause
            IndsSaccDat(j).spot_thresh=AdjustSAndT(inds_sacc(j,:),IndsSaccDat(j).spot_thresh);
        end
        cd(fll_dir)
        save(outf)
        clear allstartsp startsp IndsSaccDat
    end
end

function[startsp]=AdjustSAndT(isacc,startsp)%,AntennaeBase

% get spot
np=2;
inds=isacc(1):isacc(2);
N=25;

% Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
% [oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));
% ab1=AntennaeBase(1:2:end, :);
% ab2=AntennaeBase(2:2:end, :);
thadd=1;
fl=0;
for i=1:length(inds)
    if(np==2)
        h(i)=subplot(1,2,2);
    else
        h(i)=subplot(2,2,i);
    end
    sp=startsp(i);
    oldth=sp.th;
    if(fl==1)
        sp.th=startsp(i-1).th;
    end
    im=imread(beefn(inds(i)));
%     fl=0;
    while 1
        imagesc(im)
        [rcc,rcvh,pix_x,pix_y,rcang,rcline,rc]=SpotOutlineV2(im,sp.x(1),sp.x(2),sp.th,N,2,oldth);
        title(['frame ' int2str(inds(i)) '; sacc' int2str(isacc) '; th=' num2str(sp.th)])
        hx=xlabel('click spot; return next frame; arrows threshold; o old thresh');
        [p,q,b]=ginput(1);
        if(isempty(p))
            startsp(i).x=sp.x;
            startsp(i).th=sp.th;
            startsp(i).cent=rcc;
            startsp(i).ang=rcang;
            startsp(i).line=rcline;
            startsp(i).cvh=rcvh;
            startsp(i).params=rc;
            break;
        elseif(b==30)  
            sp.th=min(sp.th+thadd,255);
            fl=1;
        elseif(b==31)  
            sp.th=max(sp.th-thadd,0);
            fl=1;
        elseif(b==1)
            sp.x=[p q];
        elseif(b==111)
            sp.th=oldth;
            fl=0;
        end
    end
    if(i==1)
        subplot(1,2,1);
        imagesc(im)
        SpotOutlineV2(im,sp.x(1),sp.x(2),sp.th,N,2,sp.th);
    end        
end


function[rcc,rcvh,pix_x,pix_y,rcang,rcline,rc,predx]=SpotOutlineV2(im,x1,y1,th,N,pl,oldth)
rc1=round(max(1,[y1-N x1-N]));
rc2=round(min([size(im,1) size(im,2)],[y1+N x1+N]));
im2=im(rc1(1):rc2(1),rc1(2):rc2(2),1);
bw=im2>th;
[B,L] = bwboundaries(bw);
params=regionprops(L, 'Area', 'Orientation', 'Perimeter', 'Centroid','ConvexHull','PixelList',...
    'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');
axis([rc1(2) rc2(2) rc1(1) rc2(1)])
bs=[];

ars=[params.Area];
inds=find(ars>10);

predx=[x1 y1];
ex_x=rc1(2)-1;
ex_y=rc1(1)-1;
if(~isempty(inds))
    cas=[params(inds).Centroid];
    cs=[cas(1:2:end)'+ex_x cas(2:2:end)'+ex_y]; 
    ds=CartDist(cs,predx);
    [mind,mindi]=min(ds);
    sp=inds(mindi);
    rcc=params(sp).Centroid+[ex_x ex_y];
    pix_x=params(sp).PixelList(:,1)+ex_x;
    pix_y=params(sp).PixelList(:,2)+ex_y;
    rc=params(sp);
    rc.ex_x=ex_x;
    rc.ex_y=ex_y;
    
    rcvh=[rc.ConvexHull(:,1)+ex_x rc.ConvexHull(:,2)+ex_y];
    
    [area_e,axes_e,angs,elips]=ellipse(pix_x,pix_y,[],0.95);
    rcang=angs(1);
    rclen=axes_e(1);
%     rcang=params(sp).Orientation;
%     rclen=params(sp).MajorAxisLength;
%     [lx,ly]=pol2cart(rcang*pi/180,rclen*0.5);
    [lx,ly]=pol2cart(rcang,rclen);
    rcline=[rcc-[lx,ly];rcc+[lx,ly]];
end

if(pl==1)
    hold on
    ph=plot(x1,y1,'gx');  % plot the spot
    plot(x(1:2,1),x(1:2,2),'b- .',x(3:4,1),x(3:4,2),'r- .')
    for k = inds%1:length(B)
        boundary = B{k};
        if(k==sp) 
        bs=[bs;plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'r')];%, 'LineWidth', 2)
        else
            plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'g--')
        end
    end
    
    hold off
elseif(pl==2)
    hold on
    ph=plot(x1,y1,'bx');  % plot the spot
    for k = sp%1:length(B)
        boundary = B{k};
        bs=[bs;plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'r')];%, 'LineWidth', 2)
        plot(rcvh(:,1),rcvh(:,2),'b',rcc(1),rcc(2),'ro',rcline(:,1),rcline(:,2),'r.-')
%         ep(1),ep(2),'g.',...
    end  
    
    % plot the old threshold
    if(oldth~=th)
        bw2=im2>oldth;
        [B2,L2] = bwboundaries(bw2);
        params2=regionprops(L2, 'Area', 'Orientation',  'Centroid');
        ars=[params2.Area];
        inds=find(ars>10);

        if(~isempty(inds))
            cas=[params2(inds).Centroid];
            cs=[cas(1:2:end)'+ex_x cas(2:2:end)'+ex_y];
            ds=CartDist(cs,predx);
            [mind,mindi]=min(ds);
            sp2=inds(mindi);
            bound2=B2{sp2};
            plot(bound2(:,2)+rc1(2)-1, bound2(:,1)+rc1(1)-1, 'c:')
        end
    end
    hold off
end

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
% s=dir('../SpotsAnalysis/*SpotsAnalysis.mat');
% s2=dir('../FilesWithIndexesOfPausesAndSaccades/*.mat');
% f2='../FilesWithIndexesOfPausesAndSaccades/';

filelist=dir('*Full.mat');% dir('FullFiles2011/*Full.mat');

% load FileList
full_dir=cd;

for i=1:length(filelist)
    fn1=filelist(i).name;%['FullFiles2011/' s(i).name];
    load(fn1)
    clear outf
    outf=[fn1(1:end-20) 'SpotsData.mat'];
%     fn2=[f2 fn1(1:end-17) 'PauseSacc.mat'];
%     [isf,fdr]=FolderName(fn1,'E:\LenaFlights2011\');
    fdr=['../' ImDir];
    
%     load(fn2)
%     ms=dir('HM*Hand_3.mat');
%     load(ms(1).name);
    if(isfile(outf))
        load(outf)
    end
    for j=1:size(inds_sacc,1)
        cd(fdr)
        IndsSaccDat(j).i=j;
        IndsSaccDat(j).is=inds_sacc(j,:);
        if(isfield(IndsSaccDat,'spot_thresh')&&(~isempty(IndsSaccDat(j).spot_thresh)))
            CheckSandT(inds_sacc(j,:),AntennaeBase,IndsSaccDat(j).spot_thresh)
            while 1
                goon=input('enter 1 to redo; 0 continue');
                if(ismember(goon,[0 1]))
                    break;
                end
            end            
        else
            goon=1;
        end
        
        if(isequal(goon,1))
            if(j==1)
                startsp=PickSandT_2(inds_sacc(j,:),AntennaeBase);
            else
                startsp=PickSandT_2(inds_sacc(j,:),AntennaeBase,startsp(end).th);
            end
            IndsSaccDat(j).spot_thresh=startsp;
            for k=1:length(startsp)
                allstartsp(startsp(k).f).th=startsp(k).th;
                allstartsp(startsp(k).f).x=startsp(k).x;
                allstartsp(startsp(k).f).f=startsp(k).f;
            end
            cd(full_dir)
            save(outf);
        else
            cd(full_dir)
        end
    end
%     fn3=s2(i).name;
%     load(fn3)
%     if((isempty(s2(i).isFDr))||(s2(i).isFDr==0))
%         s2(i).isFDr=CopyFiles(inds_sacc,fn3);
%     end
%     save FileList.mat s
    clear allstartsp startsp IndsSaccDat
end

function[startsp]=PickSandT_2(isacc,AntennaeBase,th)

if(nargin<3) 
    th=0.5;
    th=150;%0.5;
end

% get spot
np=4;
is=isacc(1):isacc(2);
p=[];
imad=[0.15 0.4];
thadd=2;%0.01;
bs=[];ph=[];sfh=[];
N=50;

Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));
ab1=AntennaeBase(1:2:end, :);
ab2=AntennaeBase(2:2:end, :);
ind=1;
cur_i=is(ind);
ims(1).im=imread(beefn(cur_i));
inds=is(min([1 ind:ind+np-2],length(is)));
for i=2:np
    ims(i).im=imread(beefn(inds(i)));
end
x=[];
while(cur_i<=is(end))
    for i=1:np
        if(np==2)
            h(i)=subplot(1,2,i);
        else
            h(i)=subplot(2,2,i);
        end        
        imagesc(ims(i).im)
        if(~isempty(x))            
            [bs,predx(i,:)]=SpotOutline(ims(i).im,x,y,th,N,dangs(i),vab,...
                ab1(inds(i),:),ab2(inds(i),:),mdi,1,imad,inds(i));
        else
        end
        title(['frame ' int2str(inds(i)) '; sacc' int2str(isacc) '; th=' num2str(th)])
    end
    hx=xlabel('click spot; return next frame; x bad; arrows threshold');
%     MoveXYZ(hx,-0.5,0,0)
    [p,q,b]=ginput(1);
    if(isempty(p))
        startsp(ind).x=[x,y];
        startsp(ind).f=cur_i;
        startsp(ind).th=th;
        ind=ind+1;
        if(ind>length(is))
            break;
        end
        x=predx(3,1);
        y=predx(3,2);
        cur_i=is(ind);
        inds=is(min([1 ind:ind+np-2],length(is)));
        for i=2:np-1
            ims(i).im=ims(i+1).im;
        end   
        ims(np).im=imread(beefn(inds(np)));
    elseif(b==120)    % bad frame
        startsp(ind).x=[-1 -1];
        startsp(ind).f=-1;
        startsp(ind).th=[];
        ind=ind+1;
%         x=predx(3,1);
%         y=predx(3,2);
        if(ind>length(is))
            break;
        end
        cur_i=is(ind);
        inds=is(min([1 ind:ind+np-2],length(is)));
        for i=2:np-1
            ims(i).im=ims(i+1).im;
        end   
        ims(np).im=imread(beefn(inds(np)));    
    elseif(b==30)  % move on a frame
        th=min(th+thadd,255);
    elseif(b==31)  % move on a frame
        th=max(th-thadd,0);
    elseif(b==1)
        x=p;
        y=q;
%         sfind=inds(gca==h);
        ds=CartDist([ab1(cur_i,:);ab2(cur_i,:)],[x y]);
        [m,mdi]=min(ds);
%         sfang=Ant(sfind);
        % vector to each of the antenna bases
        vab=[[x,y]-ab1(cur_i,:);[x,y]-ab2(cur_i,:)];
        dangs=[AngularDifference(oAnt(cur_i),oAnt(inds)) 0];
        if(mdi==1) 
            dabs=[ab1(cur_i,1)-ab1(inds,1) ab1(cur_i,2)-ab1(inds,2)];
%             oabs=ab1(inds,:);
        else
            dabs=[ab2(cur_i,1)-ab2(inds,1) ab2(cur_i,2)-ab2(inds,2)];
        end            
    end
end


function todo
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

function[startsp]=CheckSandT(isacc,AntennaeBase,startsp)

if(nargin<3) 
    th=0.5;
    th=150;%0.5;
end

% get spot
np=4;
is=isacc(1):isacc(2);
N=50;

Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));
ab1=AntennaeBase(1:2:end, :);
ab2=AntennaeBase(2:2:end, :);
i2=round([1 length(is)*.35 length(is)*.7 length(is)]);
inds=is(i2);
for i=1:np
    if(np==2)
        h(i)=subplot(1,2,i);
    else
        h(i)=subplot(2,2,i);
    end
    sp=startsp(i2(i));
    im=imread(beefn(inds(i)));
    imagesc(im)
    SpotOutline(im,sp.x(1),sp.x(2),sp.th,N,[],[],...
        ab1(inds(i),:),ab2(inds(i),:),[],2,[],[]);
    title(['frame ' int2str(inds(i)) '; sacc' int2str(isacc) '; th=' num2str(sp.th)])
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

function[bs,predx]=SpotOutline(im,x1,y1,th,N,rang,vab,ab1,ab2,oe,pl,imad,sfi)
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

ars=[params.Area];
inds=find(ars>10);
if(pl==1)
    R=[cos(rang) -sin(rang);sin(rang) cos(rang)];
    rv=(R*vab')'+[ab1;ab2];
    x=[ab1;rv(1,:);ab2;rv(2,:)];
    predx=x(oe*2,:);
else
    predx=[x1 y1];
end
if(~isempty(inds))
    cas=[params(inds).Centroid];
    cs=[cas(1:2:end)'+rc1(2)-1 cas(2:2:end)'+rc1(1)-1]; 
    ds=CartDist(cs,predx);
    [mind,mindi]=min(ds);
    sp=inds(mindi);
end
if(pl==1)
    hold on
    ph=plot(x1,y1,'gx');  % plot the spot
    plot(x(1:2,1),x(1:2,2),'b- .',x(3:4,1),x(3:4,2),'r- .')
    for k = inds%1:length(B)
        boundary = B{k};
        if(k==sp) 
        bs=[bs;plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'r')];%, 'LineWidth', 2)
        else
            plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'g--')
        end
    end
    
    hold off
elseif(pl==2)
    hold on
    ph=plot(x1,y1,'gx');  % plot the spot
    for k = sp%1:length(B)
        boundary = B{k};
        bs=[bs;plot(boundary(:,2)+rc1(2)-1, boundary(:,1)+rc1(1)-1, 'r')];%, 'LineWidth', 2)
    end    
    hold off
end




function[sn]=beefn(i)
if(i<10) sn=['0000' int2str(i) '.jpeg'];
elseif(i<100) sn=['000' int2str(i) '.jpeg'];
elseif (i<1000) sn=['00' int2str(i) '.jpeg'];
elseif (i<10000) sn=['0' int2str(i) '.jpeg'];
else sn=[int2str(i) '.jpeg'];
end




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
