function SphericalVision

% GetEyeModel(200,2)
% return

% in Sussex_campus.png each pixel is 19cm apart so height is really 19m
% load eyemodel_ht100_wid2
% im_fn='Sussex_campus.png';

% in Andy.png each pixel is 38cm apart so height is really ht*.38
im_fn='Andy.png';
im=imread(im_fn);
z=rgb2gray(im);
clear im
% eyefn='eyemodel_ht200_wid2';
eyefn='eyemodel_ht100_wid2';
load(eyefn)
GetAllEyeData(dat,z,im_fn,eyefn)

function GetAllEyeData(dat,z,im_fn,eyefn)
[ymax,xmax]=size(z);
%width of strip around the edge we're not assessing
bord=999;
% 1=every pixel, 2 = every 2nd
gap=20;

eyedat=zeros(size(dat));
for i=(bord+1):gap:(xmax-bord)
    for j=(bord+1):gap:(ymax-bord)
        t=GetSecs;
        posx=i;
        posy=j;
        outf=[eyefn '_' im_fn(1:end-4) '_X' int2str(posx) ...
            '_Y' int2str(posy) '.mat'];
        if(~isfile(outf))
            eyedat=GetEyeData(dat,z,posx,posy,eyedat);
            save(outf,'eyedat');
            GetSecs-t
        end
    end
end

function ShowEyeDat(posx,posy)
outf=['eyedat_ht100_wid2_Sussex_campus_X' int2str(posx) ...
    '_Y' int2str(posy) '.mat'];
load(outf);
imagesc(eyedat')
set(gca,'YDir','normal')
axis equal
axis tight
% anginc=1;           % angular increment
% % aziumthal and elevation angles for the 'standard' eye model
% maxel=5;
% azes=(0:anginc:(360-anginc))*pi/180;
% elevs=(-90:anginc:-maxel)*pi/180;
% [A,E]=meshgrid(azes,elevs);


function[eyedat]=GetEyeData(dat,z,posx,posy,eyedat)
[ymax,xmax]=size(z);
greycol=200;
naz_el=size(dat);
for i=1:naz_el(1)
    for j=1:naz_el(2)
        x=dat(i,j).x+posx;
        y=dat(i,j).y+posy;
        if(isempty(x))
            eyedat(i,j)=NaN;
        else
            clear m;
            m=ones(size(x))*greycol;
            goods=(x>0)&(x<=xmax)&(y>0)&(y<=xmax);
            for n=1:length(x)
                if(goods(n))
                    m(n)=z(x(n),y(n));
                end
            end
            eyedat(i,j)=mean(m);
        end
    end
end



function GetEyeModel(ht,wid)
% first bit set up things that 'won't' change
% width of a 'facet'
% wid=2;

% 'acuity' of the plane: this is 1m
xy_ac=1;

% this sets the height above the plane
% ht=100;

% get the extent of the plane
% this could all be done more efficiently by generating a small strip of
% plane and then rotating the angles via a mtarix rotation
maxel=5;
% ext=ht/tan((maxel-wid/2)*pi/180);
ext=ceil(ht/tan((1)*pi/180));

% this sets the x - y extent of the plane, a z component for height then
% transforms into spherical polars and then puts them into vectors
% [X,Y]=meshgrid(-ext:xy_ac:ext);

% this bit for a thin strip of meshgrid
mw=ceil(1.1*ext*tan(0.5*wid*pi/180));
[X,Y]=meshgrid(-mw:xy_ac:ext,-mw:xy_ac:mw);
z=-ht*ones(size(X));
[th,ph]=cart2sph(X,Y,z);
phv=ph(:);
thv=th(:);
vx=X(:);
vy=Y(:);
if 0
    % this bit plots a square and circular facet as an example
    
    % azimuth and elevation of the facet;
    % elevation -90 is straight down then works out radially for the eye
    % azimuth goes CCW in a circle from 0 x-direction (ie properly)
    el=-90*pi/180;
    az=-0*pi/180;

    [x,y,is]=GetPixelsForFacets(phv,thv,vx,vy,el,az,wid,0);
    [x,y,ic]=GetPixelsForFacets(phv,thv,vx,vy,el,az,wid,1);

    cs=['r.';'k.';'y.';'c.';'g.';'m.';'b.'];
    plot(vx,vy,'b.',vx(is),vy(is),cs(3,:),vx(ic),vy(ic),cs(1,:))
    [x,y]=GetExtentOfFacets(ht,el,az,wid,0);
    [x,y]=GetExtentOfFacets(ht,el,45*pi/180,wid,0);
    [x,y]=GetExtentOfFacets(ht,el,90*pi/180,wid,0);
    axis equal
elseif 0
    % this bit plots a square and circular facet as an example but without
    % using the meshgrid
    
    % azimuth and elevation of the facet;
    % elevation -90 is straight down then works out radially for the eye
    % azimuth goes CCW in a circle from 0 x-direction (ie properly)
    el=-50*pi/180;
    az=-180*pi/180;

    [x,y,is]=GetExtentOfFacets(ht,el,az,wid,0);
%     [x,y,ic]=GetPixelsForFacets(phv,thv,vx,vy,el,az,wid,1);

    cs=['r.';'k.';'y.';'c.';'g.';'m.';'b.'];
    plot(vx,vy,'b.',vx(is),vy(is),cs(3,:),vx(ic),vy(ic),cs(1,:))
    axis equal

else
    CorS=1;   % circular facets
    wid=2;    % width of the facet
    anginc=1;           % angular increment
    
%     t=[];
    % could just generate one half or a quarter and reflect it
    azes=(0:anginc:(360-anginc))*pi/180;
    elevs=(-90:anginc:-maxel)*pi/180;
    clear X Y th ph z phv thv
    %     c=1;
    for j=1:length(elevs)
        el=elevs(j)
%         [x0,y0]=GetPixelsForFacets(phv,thv,vx,vy,el,0,wid*1.1,CorS);
        [pol0,bbox]=GetExtentOfFacets(ht,el,0,wid,0);
        in=inpolygon(vx,vy,pol0(:,1),pol0(:,2));
%         pol_ar=polyarea(pol(:,1),pol(:,2));
        x0=vx(in)';
        y0=vy(in)';
        for i=1:length(azes)
            az=azes(i);
            fac=[cos(az) -sin(az);sin(az) cos(az)]*[x0;y0];
            x=round(fac(1,:));
            y=round(fac(2,:));
            pol=([cos(az) -sin(az);sin(az) cos(az)]*pol0')';
            
            % NB THIS SHOULD REALLY BE DONE AS BELOW AS IT MISSES SOME
            % POINTS BUT THIS IS TOO TIME-CONSUMING
%             in=inpolygon(vx,vy,rpol(:,1),rpol(:,2));
%             x=vx(in)';
%             y=vy(in)';
%             dat(i,j).ht=ht;
            dat(i,j).az=az;
            dat(i,j).el=el;
%             dat(i,j).azel=[az el];
%             dat(i,j).wid=wid;
%             dat(i,j).CorS=CorS;
            dat(i,j).x=x;
            dat(i,j).y=y;
            dat(i,j).pol=pol;
            %             c=c+1;
        end
%         t=[t GetSecs];
%         diff(t)
    end
    save(['eyemodel_ht' int2str(ht) '_wid' num2str(wid) '.mat'],'dat');
end

% this is a sham function which assumes we've generated the eye data as
% above and then we want to get a circular field of view around az and el
function MakeCircVision(az,el,rad,dat,x,y,azall,elall)

azes=(-rad:inc:rad)+az;
elevs=(-rad:inc:rad)+el;

azall=(0:anginc:(360-anginc))*pi/180;
elall=(-90:anginc:-maxel)*pi/180;
for i=1:length(azes)
    ix=find(azall==azes(i));
    for j=1:length(elevs)
        iy=find(elall==elevs(j));
        d=AngularDifference(elevs(j),el).^2+AngularDifference(azes(i),az).^2;
        if(d<=(rad^2))
            VisM(i,j)=meanimage(image,dat(ix,iy));
        else
            VisM(i,j)=NaN;
        end
    end
end

elevs=[dat.el];

function[facpol,bbox]=GetExtentOfFacets(ht,el,az,wid,CorS)

rad=0.5*wid*pi/180;
el=-el;%*pi/180;
angs=[el-rad el el+rad];
% maxx=ht/tan(el-rad);
% minx=ht/tan(el+rad);
% midx=ht/tan(el);
x=ht./tan(angs);
r=ht./sin(angs);
y=sin(rad)*r;
facpol=[x' y'; x(end:-1:1)' -y(end:-1:1)'; x(1) y(1)]; 
facpol=facpol*[cos(az) -sin(az);sin(az) cos(az)]';
bbox=[max(facpol);min(facpol)];
% if(minx>maxx)
%     minx=maxx;
% hold on
% plot(facpol(:,1),facpol(:,2),'k')
% hold off
% inpolygon



% this function gets the x and y positions for a certain elevation el,
% azimuth, az and width, wid
% if CorS=1, the facet is circular; if 0, square
function[x,y,is]=GetPixelsForFacets(phv,thv,vx,vy,el,az,wid,CorS)

rad=0.5*wid*pi/180;

if(CorS)
    % circular area of width wid; make a vector of distances
%     d=(phv-el).^2+(thv-az).^2;
    d=AngularDifference(phv,el).^2+AngularDifference(thv,az).^2;
    is=d<=(rad^2);
else
    % square area of width wid
%     iph=(phv>=(el-rad))&(phv<(el+rad));
%     ith=(thv>=(az-rad))&(thv<(az+rad));
    iph=abs(AngularDifference(phv,el))<=rad;
    ith=abs(AngularDifference(thv,az))<=rad;
    is=iph&ith;
end
x=vx(is);
y=vy(is);