function[NumBees,Cents,Areas]=FindBee_HiSpeed(t,lim,refim,s)
count=1;        
NumBees=zeros(1,lim);Areas=zeros(1,lim);Cents=zeros(lim,2);
%Orients=[];Stripiness=[];EndPt=[];bounds=[];
%cd E:\01170857\s0000110\
f='dvr0';
% refim = imread([f '5628.tif']);
ti=getsecs;
is=[1:t:lim]+s;
for i=is
%    i
    if(i<10) fn=[f '0000' int2str(i) '.tif'];
    elseif(i<100) fn=[f '000' int2str(i) '.tif'];
    elseif(i<1000) fn=[f '00' int2str(i) '.tif'];
    elseif(i<10000) fn=[f '0' int2str(i) '.tif'];
    else fn=[f int2str(i) '.tif'];
    end
    im=imread(fn);
    d=refim(:,:,1)-im(:,:,1);
    
    % Have i is background - image (maxed at zero)
    %d=double(rgb2gray(dif));

    % do auto thresh based on max values of d
    %*** GO BACK TO THIS TO GET ANTENNAE ETC
    %*** USE THRESH TO GET BEE AREA THEN RE_EXAMINE
    %************************
    
    t=3*median(max(d));
    e=d>t;
%    [ht wid]=size(e);

    % remove all objects larger/smaller than bees
%     tbig=500;
%     bigs=bwareaopen(e,tbig,8);
tlil=50;
%     lils=bwareaopen(e,tlil,8);
%     bwclean=imsubtract(lils,bigs);
% 
%     % fill in holes
%     bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);
    
    bwclean=bwareaopen(e,tlil,8);;
% Compute the major axis orientation and pixels of each component.
    [L,n] = bwlabeln(bwclean, 8);
    NumBees(i-s)=n;
    if(n==1)
        S = regionprops(L,'Area','Centroid');%,'Orientation','MajorAxisLength','Eccentricity','BoundingBox');%,'PixelList');
        Areas(count)=[S.Area];
%        Orients=-[S.Orientation]*pi/180;
%        for j=1:NumBees
%            c(j,:)=S(j).Centroid;
%             a=S(i).BoundingBox;
%             %         y1=max(floor(a(1)),1);
%             %         x1=max(floor(a(2)),1);
%             %         y2=min(ceil(y1+a(3)),wid);
%             %         x2=min(ceil(x1+a(4)),ht);
%             Stripiness(i) = S(i).Eccentricity;%0;%sum(sum(bwclean(x1:x2,y1:y2)-cleane(x1:x2,y1:y2)))/Areas(i);
%             [EndPt(i,1) EndPt(i,2)]=pol2cart(Orients(i),S(i).MajorAxisLength/2);
%             bounds=[bounds;a];
%        end
%        EndPt=EndPt+Cents;
        Cents(count,:)=[S.Centroid];
        count=count+1;
        % SPEED UP (via bounding box if needed)
        % bounds = S(:).BoundingBox;%bwboundaries(bwclean,'noholes');
    end
    % plot([Cents(:,1) EndPt(:,1)]',[Cents(:,2) EndPt(:,2)]','g')
end
Cents=Cents(1:count-1,:);
Areas=Areas(1:count-1);
getsecs-ti
% figure(1)
% imagesc(refim);
% hold on;
% plot(Cents(:,1),Cents(:,2),'rx')
% hold off
% figure(2)
% subplot(2,1,1)
% plot(NumBees)
% subplot(2,1,2)
% plot(Areas)