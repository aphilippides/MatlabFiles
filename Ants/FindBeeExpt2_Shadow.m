function[Areas,Cents,Orients,meancol,EndPt,NumBees,bounds,NLess ...
    area_e,EPt,ang_e,ellips,len_e,eccent]=FindBeeExpt2_Shadow(im,odeven,t,...
    SLev,threshV,opt,bigsmall)

% % sets the default size to remove big or small objects
% if(nargin<7)
%     bigsmall=[400 20];   % these are default 2012 values
% end

if(nargin<6)
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
if(nargin<5)
    e=d>50;  % for 2007 etc experiments
else
    e=d>threshV;
end

[ht wid]=size(e);

% remove all objects larger/smaller than bees
tbig=bigsmall(1);  % 100; % this was 2007 data valuew
bigs=bwareaopen(e,tbig,8);
tlil=bigsmall(2);  % 15; % this was 2007 data valuew 
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);
bwclean=bwclean.*(origim<SLev);
% fill in holes
bwclean=bwareaopen(bwclean,tlil,8);
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% Compute the major axis orientation and pixels of each component.
[L,NumBees] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength','Eccentricity','BoundingBox','PixelList');

% don't always to do this bit: it takes time and is prob not necessary as
% it was more for doing some old shadow stuff
if(opt)
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
else
    meancol=[];
    NLess=[];
end

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
                % If using half-frames, adjust things as now using all pixels 
        % so y is squashed
        if(odeven>=0)
            Cents(i,2)=Cents(i,2)*2-odeven;
            EndPt(i,2)=EndPt(i,2)*2;
            a([2 4])=[a(2)*2-odeven,a(4)*2];
            [x,y]=pol2cart(Orients(i),1);
            y=2*y;
            Orients(i)=cart2pol(x,y);
            [area_e(i),axes_e,angles_e,elips] = ...
                ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2)*2-odeven,[],0.8);
        else
            [area_e(i),axes_e,angles_e,elips] = ...
                ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2),[],0.8);
        end
        bounds=[bounds;a];
        
%         [maxim,ind]=max(d(:));
%         [m_j,m_i]=ind2sub([ht wid],ind);
        
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
% imagesc(origim),hold on
% plot([Cents(:,1) EPt(:,1)]',([Cents(:,2) EPt(:,2)]'+odeven)*0.5,'g')
% axis([c1-100 c1+100 r1-100 r1+100])
% hold off
else
    Areas=[];Cents=[];Orients=[];meancol=[];EndPt=[];bounds=[];
    area_e=[];EPt=[];ellips=[];ang_e=[];len_e=[];NLess=[];eccent=[];
end
