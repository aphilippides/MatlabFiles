function[Areas,Cents,Orients,meancol,EndPt,NumBees,bounds,NLess ...
    area_e,EPt,ang_e,ellips,len_e,eccent,outlines]=FindBeeExpt2(im,odeven,t,thresh,opt,bigsmall)

% sets the default size to remove big or small objects
if(nargin<6)
    bigsmall=[400 20];
end

if(nargin<5)
    opt=0;
end
outlines=[];

% Have i is background - image (maxed at zero)
d=double(rgb2gray(im));
origim=double(rgb2gray(t));

% do auto thresh based on max values of d
% t=2;
% e=d>(t*(max(max(d))));
% e=d>(1.5*(median(max(d))));
if(nargin<4)
    e=d>50;  % for 2007 etc experiments
else
    e=d>thresh;
end
%  e=d>15;    % 25 (!!) for wasps
[ht wid]=size(e);

% % Check the areas of all objects
% [L,NumBees] = bwlabeln(e, 8);
% S = regionprops(L,'Area');
% a=[NumBees [S.Area]]

% remove all objects larger/smaller than bees
% tbig=150; tlil=25;   % for 2007 etc experiments
tbig=bigsmall(1);% 400;  % for 2012 etc experiments
bigs=bwareaopen(e,tbig,8);
tlil=bigsmall(2);% 20;  % for 2012 etc experiments
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);

% fill in holes
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% Compute the major axis orientation and pixels of each component.
[L,NumBees] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength','Eccentricity','BoundingBox','PixelList');
% ProperBees=[];
if(NumBees>0)
    for i=1:NumBees
        adum=S(i).BoundingBox;
        r1=max(ceil(adum(2)),1);
        r2=min(floor(r1+adum(4)),ht);
        c1=max(ceil(adum(1)),1);
        c2=min(floor(c1+adum(3)),wid);
        newim=double(origim(r1:r2,c1:c2).*e(r1:r2,c1:c2));
        nim=newim(:);
        nim=nim(find(nim));
        meancol(i)=median(nim);
        NLess(i)=length(find(nim<75));
%         meancol=sum(newim(:))/S(i).Area;
        % threshold is around 90
        % however, bees can also be co-opted into shadows which gives a bad
        % outline. Could get rid of all pixels less than x then
        % fill holes...
%         if(meancol<90)
%             ProperBees=[ProperBees i];
%         end;
    end
end
% S=S(ProperBees);
% NumBees=length(ProperBees);

if(NumBees>0)
    Areas=[S.Area];
    Orients=-[S.Orientation]*pi/180;
    bounds=[];

    % Calculate mean_col and EndPt
    % Major Axis not working so will have to do something better 4 EndPt
    % Also need to do something about not by edge of screen via BB
    for i=1:NumBees
        a=S(i).BoundingBox;
        r1=max(floor(a(2)),1);
        r2=min(ceil(r1+a(4)),ht);
        c1=max(floor(a(1)),1);
        c2=min(ceil(c1+a(3)),wid);
%         newim=e(r1:r2,c1:c2);

        Cents(i,:)=S(i).Centroid;
        [EndPt(i,1) EndPt(i,2)]=pol2cart(Orients(i),S(i).MajorAxisLength/2);
        
        % Adjust things as now using all pixels so y is squashed
        Cents(i,2)=Cents(i,2)*2-odeven;
        EndPt(i,2)=EndPt(i,2)*2;
        a([2 4])=[a(2)*2-odeven,a(4)*2];
        [x,y]=pol2cart(Orients(i),1);
        y=2*y;
        Orients(i)=cart2pol(x,y);
        bounds=[bounds;a];
        
        [maxim,ind]=max(d(:));
        [m_j,m_i]=ind2sub([ht wid],ind);

        [area_e(i),axes_e,angles_e,elips] = ...
            ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2)*2-odeven,[],0.8);
        ellips(i).elips=elips;
        [x,y]=pol2cart(angles_e(1),axes_e(1));
        EPt(i,:)=[x,y];
        ang_e(i)=angles_e(1);
        len_e(i)=axes_e(1);
        eccent(i)=axes_e(1)/axes_e(2);
    end
    % EndPt(:,2)=-EndPt(:,2);
    EndPt=EndPt+Cents;
    EPt=EPt+Cents;
    if(opt)
        outlines=bwboundaries(bwclean,8,'noholes');
    end
% imagesc(origim),hold on
% plot([Cents(:,1) EPt(:,1)]',([Cents(:,2) EPt(:,2)]'+odeven)*0.5,'g')
% axis([c1-100 c1+100 r1-100 r1+100])
% hold off
else
    Areas=[];Cents=[];Orients=[];meancol=[];EndPt=[];bounds=[];
    area_e=[];EPt=[];ellips=[];ang_e=[];len_e=[];NLess=[];eccent=[];
end
