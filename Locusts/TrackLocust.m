function[sfn] = TrackLocust(fn,nums,ThreshVal)

fn='00005.MTS'
Check=1;
sfn=[fn(1:end-4) '_Prog.mat']
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];
area_e=[];EPt=[];elips=[];odev=[];ang_e=[];len_e=[];eccent=[];

MaxBInd=0;
MaxD=20;
picwid=25;

lmn=[fn(1:end-4) 'CalData.mat'];
if(isfile(lmn))
    load(lmn);
    refimN
%     [refim]=MyAviRead(fn,refim,1);
%     if(isempty(refim))
%         refim=MyAviRead(fn,1,1);
%     end
else
    [inf,NumFrames]=MyAviInfo(fn);
    refimN=NumFrames;
    [refim]=MyAviRead(fn,refimN,1);
    save(lmn,'inf','NumFrames','refim','refimN')
end

if(nargin<2)
    nums=1:40:NumFrames;
end;
if(nargin<3)
    ThreshVal=25;
end;
% BlurIm=zeros(size(refim(:,:,1)));
CheckThresh=0;

for num=nums
    f=MyAviRead(fn,num);
    if(isempty(f))
        return;
    end
%     dif=imsubtract(refim,f);
    [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc]= ...
        FindLocust(refim,f,ThreshVal,1);
    title(['Frame Num = ' int2str(num) '/' int2str(NumFrames)]);
%     for j=1:n

        if 0%(CheckThresh)
            ThreshVal=GetThreshValue(refim,f,ThreshVal,c(j,:));
            CheckThresh=0;
        end
        %             FrameNum=[FrameNum 2*num-1];%because of half frame
        %             interlacing
        FrameNum=[FrameNum num];
        pause
        %             odev=[odev mod(i,2)];
%         if(Check)
%             subplot(2,2,1)
%             imagesc(f)
%             %                 title(['Frame Num = ' int2str(num) ';    num bees = ' num2str(n)])
%             figure(2)
%             imagesc(dif)
%             pause
%         end
%     end


    %
    %
    %         if(isempty(WhichB)) MaxBInd=0;
    %         else MaxBInd=max(WhichB);
    %         end
    %         [BPos,BInds,w,unused] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
    %         NumBees=[NumBees n];
    %         Bounds=[Bounds; b];
    %         Areas=[Areas a];
    %         Cents=[Cents; c];
    %         Orients=[Orients o];
    %         EndPt=[EndPt;e];
    %         MeanCol=[MeanCol md];
    %         WhichB=[WhichB w];
    %         elips=[elips ell];
    %         area_e=[area_e ae];
    %         ang_e=[ang_e oe];
    %         EPt=[EPt;ee];
    %         len_e=[len_e len];
    %         NLess=[NLess nlss];
    %         eccent=[eccent ecc];
    %         if(n>1)
    %             CheckThresh=1;
    %         elseif((CheckThresh==0)&&(n==0))
    %             CheckThresh=1;
    %         end

    %         save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    %             'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    %             'area_e','EPt','elips','odev','ang_e','len_e','eccent');
    [num n]
end

save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent');

function[ThreshVal] = GetThreshValue(refim,f,ThreshVal,c)
imdiff=imsubtract(refim,f);
d=double(rgb2gray(imdiff));
origim=double(rgb2gray(f));

while 1
    figure(1)
    BW=double(d>ThreshVal);
    [B,L] = bwboundaries(BW,'noholes');
    imagesc(d)
    axis equal;
    %     axis([c(1)-35 c(1)+35 c(2)-35 c(2)+35])
    hold on
    title(['Thresh level ' num2str(ThreshVal)])
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'g');
    end
    colorbar;
    hold off

    figure(2)
    imagesc(f);
    axis equal;
    axis([c(1)-35 c(1)+35 c(2)-35 c(2)+35])
    hold on
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'g');
    end
    hold off

    disp(['Thresh level = ' num2str(ThreshVal)]);
    ninp=input(['enter new level or return:  ']);
    if(isempty(ninp)) break;
    else ThreshVal=ninp;
    end
end

function[Areas,Cents,Orients,meancol,EndPt,NumBees,bounds,NLess, ...
    area_e,EPt,ang_e,ellips,len_e,eccent]=FindLocust(im,t,threshval,pl)

% Have i is background - image (maxed at zero)
d=double(rgb2gray(im));
origim=double(rgb2gray(t));

dabs=abs(d-origim);
% do auto thresh based on max values of d
% t=2;
% e=d>(t*(max(max(d))));
% e=d>(t*(median(max(d))));
% e=d>50;
e=dabs>threshval;  % for paul
[ht wid]=size(e);

% remove all objects larger/smaller than bees
% tbig=350;
% bigs=bwareaopen(e,tbig,8);
tlil=100;  
lils=bwareaopen(e,tlil,8);
bwclean=lils;%imsubtract(lils,bigs);

% fill in holes
bwclean=imfill(bwclean,'holes');%imclose(e,[0 1 0;0 1 0;0 1 0]);

% Compute the major axis orientation and pixels of each component.
[L,NumBees] = bwlabeln(bwclean, 8);
S = regionprops(L,'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength','Eccentricity','BoundingBox','PixelList');
ProperBees=[];

if(pl)
    subplot(2,2,1)
    imagesc(t),title('orig')
    subplot(2,2,3)
    imagesc(origim<70),title('orig thresh')
    subplot(2,2,2)
    imagesc(dabs),title('diff image')
    subplot(2,2,4)
    imagesc(L),title('diff objects')   
end
if 0%(NumBees>0)
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

if 0%(NumBees>0)
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
%         Cents(i,2)=Cents(i,2)*2-odeven;
%         EndPt(i,2)=EndPt(i,2)*2;
%         a([2 4])=[a(2)*2-odeven,a(4)*2];
%         [x,y]=pol2cart(Orients(i),1);
%         y=2*y;
%         Orients(i)=cart2pol(x,y);
        bounds=[bounds;a];
        
        [maxim,ind]=max(d(:));
        [m_j,m_i]=ind2sub([ht wid],ind);

        [area_e(i),axes_e,angles_e,elips] = ...
            ellipse(S(i).PixelList(:,1),S(i).PixelList(:,2),[],0.8);
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