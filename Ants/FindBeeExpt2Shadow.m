function[Areas,Cents,Orients,MaxDiff,EndPt,NumBees,bounds, ...
    area_e,EPt,ang_e,ellips,len_e]=FindBeeExpt2(im,oddeven,t)

% Have i is background - image (maxed at zero)
d=double(rgb2gray(im));

% do auto thresh based on max values of d
% t=2;
% e=d>(t*(max(max(d))));
% e=d>(t*(median(max(d))));
e=d>50;
[ht wid]=size(e);

% remove all objects larger/smaller than bees
tbig=100;
bigs=bwareaopen(e,tbig,8);
tlil=10;  
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);

% fill in holes
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% Compute the major axis orientation and pixels of each component.
[L,NumBees] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength','Eccentricity','BoundingBox','PixelList');
if(NumBees>0)
    Areas=[S.Area];
    Orients=-[S.Orientation]*pi/180;
    bounds=[];
    % Get rid of shadows
    for i=1:NumBees
                a=S(i).BoundingBox;
        x1=max(floor(a(2)),1);
        x2=min(ceil(x1+a(4)),ht);
        y1=max(floor(a(1)),1);
        y2=min(ceil(y1+a(3)),wid);
        newim=d(x1:x2,y1:y2);
        pixs=S(i).PixelList;
        for j=1:length
    
    % Calculate MaxDiff and EndPt
    % Major Axis not working so will have to do something better 4 EndPt
    % Also need to do something about not by edge of screen via BB
    for i=1:NumBees
        Cents(i,:)=S(i).Centroid;
        a=S(i).BoundingBox;
        x1=max(floor(a(2)),1);
        x2=min(ceil(x1+a(4)),ht);
        y1=max(floor(a(1)),1);
        y2=min(ceil(y1+a(3)),wid);
        newim=d(x1:x2,y1:y2);
        [EndPt(i,1) EndPt(i,2)]=pol2cart(Orients(i),S(i).MajorAxisLength/2);
        % Adjust things as now using all pixels so y is squashed
        Cents(i,2)=Cents(i,2)*2-oddeven;
        EndPt(i,2)=EndPt(i,2)*2;
        a([2 4])=[a(2)*2-oddeven,a(4)*2];
        [x,y]=pol2cart(Orients(i),1);
        y=2*y;
        Orients(i)=cart2pol(x,y);
        bounds=[bounds;a];
        
        [maxim,ind]=max(d(:));
        [m_j,m_i]=ind2sub([ht wid],ind);
        MaxDiff(i,:) = [m_i, 2*m_j-oddeven];%0;%sum(sum(bwclean(x1:x2,y1:y2)-cleane(x1:x2,y1:y2)))/Areas(i);

        [area_e(i),axes_e,angles_e,elips] = ...
            ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2)*2-oddeven,[],0.8);
        ellips(i).elips=elips;
        [x,y]=pol2cart(angles_e(1),axes_e(1));
        EPt(i,:)=[x,y];
        ang_e(i)=angles_e(1);
        len_e(i)=axes_e(1);
    end
    % EndPt(:,2)=-EndPt(:,2);
    EndPt=EndPt+Cents;
    EPt=EPt+Cents;

else
    Areas=[];Cents=[];Orients=[];MaxDiff=[];EndPt=[];bounds=[];
    area_e=[];EPt=[];ellips=[];ang_e=[];len_e=[];
end
% plot([Cents(:,1) EndPt(:,1)]',[Cents(:,2) EndPt(:,2)]','g')