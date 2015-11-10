function[NumBees,Cents,Areas,Orients,Eccents,Head,Tail,Neck,MinAx,bounds,mNeck,Nwid]=FindBee_HeadPos(refim,im)
Cents=[];Areas=[];Orients=[];Eccents=[];Head=[];Tail=[];Neck=[];MinAx=[];bounds=[];mNeck=[];Nwid=[];
d=max(max(im(:,:,1)))-im(:,:,1);
% h=fspecial('gaussian',10,3);
% d=imfilter(d,h);

% do auto thresh based on max values of d
%*** GO BACK TO THIS TO GET ANTENNAE ETC
%*** USE THRESH TO GET BEE AREA THEN RE_EXAMINE
%************************

t=min(3*median(max(d)),50);
e=d>100;
[ht wid]=size(e);

% remove all objects larger/smaller than bees
%     tbig=500;
%     bigs=bwareaopen(e,tbig,8);
tlil=1000;
%     lils=bwareaopen(e,tlil,8);
%     bwclean=imsubtract(lils,bigs);
%
%     % fill in holes
%     bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

bwclean=bwareaopen(e,tlil,8);
% beeim=bwareaopen((im(:,:,1)<20),tlil,8);
% bwclean=imopen(bwclean,ones(3));
% Compute the major axis orientation and pixels of each component.
[L,n] = bwlabeln(bwclean, 8);
NumBees=n;
if(n>=1)
    S = regionprops(L,'Area','Centroid','Orientation','BoundingBox','Eccentricity','MajorAxisLength','MinorAxisLength');%,'PixelList');
    Areas=[S.Area];
    Orients=-[S.Orientation]*pi/180;
    Eccents=[S.Eccentricity];
%    Tail=[S.MajorAxisLength]/2;
    MinAx=[S.MinorAxisLength]/2;
    for j=1:NumBees
        Cents(j,:)=S(j).Centroid;
        a=S(j).BoundingBox;
        y1=max(floor(a(1))-2,1);
        x1=max(floor(a(2))-2,1);
        y2=min(ceil(y1+a(3))+2,wid);
        x2=min(ceil(x1+a(4))+2,ht);
        %             Stripiness(i) = S(i).Eccentricity;%0;%sum(sum(bwclean(x1:x2,y1:y2)-cleane(x1:x2,y1:y2)))/Areas(i);
        % Orients(j)=GetThinEnd(beeim,Orients(j),Cents(j,:),Tail(j),4);
        % Orients(j)=GetThinEnd((im(:,:,1)),Orients(j),);
        [Orients(j), Head(j,:), Tail(j,:),Neck(j,:),mNeck(j,:),Nwid]=GetHeadTail(bwclean,Orients(j),Cents(j,:));
        % [Head(j,1) Head(j,2)]=pol2cart(Orients(j),S(j).MajorAxisLength/2);
        bounds=[bounds;a];
    end
    % SPEED UP (via bounding box if needed)
%    imagesc(bwclean)
    % TODO: open close to get rid of antennae then re-get as difference
    % between removed and thresholded
     colormap gray
   % imagesc(uint8(bwclean).*d)%<20)
end