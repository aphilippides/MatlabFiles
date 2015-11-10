function[Areas,Cents,Orients,Stripiness,EndPt,NumBees,bounds]=FindBee(im,t)

% Have i is background - image (maxed at zero)
d=double(rgb2gray(im));

% do auto thresh based on max values of d
t=2;
% e=d>(t*(max(max(d))));
e=d>(t*(median(max(d))));
[ht wid]=size(e);

% remove all objects larger/smaller than bees
tbig=100;
bigs=bwareaopen(e,tbig,8);
tlil=15;
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);

% fill in holes
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% Compute the major axis orientation and pixels of each component.
[L,NumBees] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','Eccentricity','BoundingBox');%,'PixelList');
if(NumBees>0)
    Areas=[S.Area];
    Orients=-[S.Orientation]*pi/180;
    bounds=[];

    % Calculate stripiness and EndPt
    % Major Axis not working so will have to do something better 4 EndPt
    % Also need to do something about not by edge of screen via BB
    for i=1:NumBees
        Cents(i,:)=S(i).Centroid;
        a=S(i).BoundingBox;
        %         y1=max(floor(a(1)),1);
        %         x1=max(floor(a(2)),1);
        %         y2=min(ceil(y1+a(3)),wid);
        %         x2=min(ceil(x1+a(4)),ht);
        Stripiness(i) = S(i).Eccentricity;%0;%sum(sum(bwclean(x1:x2,y1:y2)-cleane(x1:x2,y1:y2)))/Areas(i);
        [EndPt(i,1) EndPt(i,2)]=pol2cart(Orients(i),S(i).MajorAxisLength/2);
        bounds=[bounds;a];
    end
    % EndPt(:,2)=-EndPt(:,2);
    EndPt=EndPt+Cents;

    % SPEED UP (via bounding box if needed)
    % bounds = S(:).BoundingBox;%bwboundaries(bwclean,'noholes');
else
    Areas=[];Cents=[];Orients=[];Stripiness=[];EndPt=[];bounds=[];
end
% plot([Cents(:,1) EndPt(:,1)]',[Cents(:,2) EndPt(:,2)]','g')
