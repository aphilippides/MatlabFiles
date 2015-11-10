function UnwrapImsDB
% Unwrap images a la Gantry for noise database
% GetPositions;
fs=dir('*.jpg');
im=double(rgb2gray(imread(fs(1).name)));
si=size(im);

% for i=1:length(fs)
%     im=double(rgb2gray(imread(fs(i).name)));
%     cs(i,:)=GetCentroid(im);
%     imagesc(im)
%     hold on;
%     plot(cs(i,1),cs(i,2),'r.')
%     hold off;
% end

% % params for 12-07 database and learn run database
% % Basically all ims that are 240 x 320 fvrom this date
% cent=[157 119];
% rads=50:120;

% % params for 5-01-08 database 
% % same as 12-07 but with a few radii taken out so its all image
% cent=[157 119];
% rads=55:115;

% params for 5-01-08 database 
% same as 12-07 but with a few radii taken out so its all image
cent=[1641 1171];
rads=10:10:1500;


% % params for env 2 database and ims that are 576 x 768
% % so try 2.4 x other ones
% cent=[157 119]*2.4;
% cent=[379 282];
% rads=[50:120]*2.4;

ts=[0:359]*pi/180;
UnwStruct=GetUnWStruct(si,rads,ts,cent)
for i=1:length(fs)
    a=[length(fs) i]
    fn=fs(i).name;
    [unw]=UnwrapPanBasic(fn,UnwStruct,1);
    save([fn(1:end-4) '.mat'],'unw');
    % plot horizon
%     figure(2)
%     hold on
%     plot([1 360],[35.5 35.5],'r')
%     hold off
end

function[UnwStruct]=GetUnWStruct(si,rads,ts,cent)
[UnwStruct.X,UnwStruct.Y]=meshgrid(1:si(2),1:si(1));
xM=[];yM=[];
for r=rads
    [xs,ys]=pol2cart(ts,r);
    xM=[xM; xs];
    yM=[yM; ys];
end
UnwStruct.xM=[xM+cent(1)];
UnwStruct.yM=[yM+cent(2)];
UnwStruct.cent=cent;

function[x,y]=GetPositions(dn)
if(nargin<1) fs=dir('*.jpg');
else fs=dir([dn '\*.jpg']);
end
for i=1:length(fs)
    fn=fs(i).name;
    x(i)=str2num(fn(1:4));
    y(i)=str2num(fn(6:9));
end
pos=[x' y'];
save positions x y pos fs

function[cent,fact]=GetCentroid(im)
im=im(1000:1400,1600:2000);
d=double(im<5);
% ma=zeros(size(d));
% ma(50:200,100:220)=1;
% d=d.*ma;
big=bwareaopen(d,1000,8);
big=imfill(big,'holes');
[l,n]=bwlabel(big);
s=regionprops(l,'Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength');
cent=[s(1).Centroid];
cent=cent + [1599 999];
fact = 1;
