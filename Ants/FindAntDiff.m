% function[Areas,Cents,Orients,meancol,EndPt,NumAnts,bounds,NLess ...
%     area_e,EPt,ang_e,ellips,len_e,eccent]=FindAnt(im,t)
%
% function which processes an image im into ants which are defined as
% objects within a certain area range ( see lines 30-35) and less than t in
% grey-scale
%
% output values are (in order): area, centroid, orientation (in radians and
% rotated so it is correct in image coordinates, the mean colour of the
% 'ant' pixels, esteimated had position, number of ants found, their
% bounding boxes, number of 'ant' pixels less than a given vaule (currently
% 150% of t, area, head estimate, orientation, bouding ellipse, length and 
% ellipse eccentricity for a potentially more robust version of orientation
% extraction
%
% some of the variables could be removed to speed things up

function[Areas,Cents,Orients,meancol,EndPt,NumAnts,bounds,NLess ...
    area_e,EPt,ang_e,ellips,len_e,eccent]=FindAnt(im,t)

Areas=[];Cents=[];Orients=[];meancol=[];EndPt=[];bounds=[];
area_e=[];EPt=[];ellips=[];ang_e=[];len_e=[];NLess=[];eccent=[];

% make the image into grey-scale
d=double(rgb2gray(im));

% threshold the image and get sizes 
% e=d<t;
e=d>t;
[ht wid]=size(e);

% remove all objects larger/smaller than ants
% CHANGE THESE VALUES AS APPROPRIATE
%
% BIG OBJECT AREA
tbig=50;
% SMALL OBJECT AREA
tlil=5;  
bigs=bwareaopen(e,tbig,8);
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);

% fill in holes
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% label up the image and extract data on each 'object' 
[L,NumAnts] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength','Eccentricity','BoundingBox','PixelList');

% set up output variables
if(NumAnts>0)
    Areas=[S.Area];
    
    % gets orientation into radians and flips it into the correct
    % coordinate fram
    Orients=-[S.Orientation]*pi/180;
    bounds=[];

    for i=1:NumAnts
        
        % set the bounding box as integers
        a=S(i).BoundingBox;
        r1=max(floor(a(2)),1);
        r2=min(ceil(r1+a(4)),ht);
        c1=max(floor(a(1)),1);
        c2=min(ceil(c1+a(3)),wid);
        bounds=[bounds;a];

        % Calculate the EndPt (head of ant) relative to body centropid
        % from heading and major axis
        Cents(i,:)=S(i).Centroid;
        [EndPt(i,1) EndPt(i,2)]=pol2cart(Orients(i),S(i).MajorAxisLength/2);
                
        % Calculate a potentially more robust heading and EndPt
        [area_e(i),axes_e,angles_e,elips] = ...
            ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2),[],0.8);
        ellips(i).elips=elips;
        [x,y]=pol2cart(angles_e(1),axes_e(1));
        EPt(i,:)=[x,y];
        ang_e(i)=angles_e(1);
        len_e(i)=axes_e(1);
        eccent(i)=axes_e(1)/axes_e(2);
    end
    
    % get head estimates in  absolute frame of reference
    EndPt=EndPt+Cents;
    EPt=EPt+Cents;
    
% old code to aid debugging    
% imagesc(origim),hold on
% plot([Cents(:,1) EPt(:,1)]',([Cents(:,2) EPt(:,2)]'+odeven)*0.5,'g')
% axis([c1-100 c1+100 r1-100 r1+100])
% hold off
end