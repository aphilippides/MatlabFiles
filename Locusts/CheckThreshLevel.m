function[thresh]=CheckThreshLevel(fn,mask,thresh,nums)
[v,vobj]=VideoReaderType(fn);

if(nargin<3)
    [inf,NumFrames]=MyAviInfo(fn);
    nums=1:NumFrames;
end

% get first image
ind=1;
im=MyAviRead(fn,nums(ind),vobj);
% Get Initial mask and Threshold
maskf=['mask' fn(1:end-4) '.mat'];
if((nargin<2)||(mask==0))
    % Get mask. 
    figure(1)
    title('first zoom in on the area, then click a polygon, double click in it to end')
    disp('first zoom in on the area, then click a polygon, double click in it to end')
    hold on
    [mask,x,y]=roipoly(im);
    save(maskf,'mask','x','y');
    hold off
elseif(isequal(mask,1))
    load(maskf,'mask','x','y');
end
if(nargin<3)
    thresh=10;
end


% set initial parameters
% start with rgb
tpr=1;
% start with all dimensions
dims=[1:3];

frameadd=5;

% get the threshold and reference image for the first frame
origim=im;
[im2thresh,tstr]=ProcessIm(origim,tpr);
refim=GetRefim(mask,origim,tpr,dims);
figure(1)
imagesc(im);
hold on
plot(x,y,'b')
hold off
title('mask')
figure(2)
imagesc(uint8(refim))
title('mask colour')
inp=input('press any key if ok; ctrl+c to end');
figure(1)
while 1
    %     [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,boun]= ...
    %         FindBeeExpt2(dif(i:2:end,:,:),mod(i,2),f(i:2:end,:,:),thresh,1);
    %     if(isempty(WhichB)) MaxBInd=0;
    %     else MaxBInd=max(WhichB);
    %     end
    %     [BPos,BInds] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
    %     [ind n]
    %     mn=min(9,n);
    [diffim,obj_im,boun]=DoThreshold(im2thresh,thresh,refim,dims);
    tadd=0.02*max(diffim(:))
    PlotStuff(im,im2thresh,thresh,diffim,obj_im,boun,dims,tstr,ind)
    subplot(2,2,3)
    xlabel(['up/down change threshold, 1=processing; t=threshold; n=Frame+' int2str(frameadd) '; 0=frames; return end'])
    [x,y,b]=ginput(1);
    if(isempty(x))
        break;
    elseif(b==30)
        thresh=thresh+tadd;
    elseif(b==31)
        thresh=thresh-tadd;
    elseif(b==48)
        disp(['frameadd=' int2str(frameadd) '; tadd=' num2str(tadd)]);
        frameadd=ForceNumericInput('enter number of frames to skip: ');
    elseif(b==116)
        disp(['thresh=' num2str(thresh)]);
        thresh=ForceNumericInput('enter threshold: ');
    elseif(b==49)
        disp(['currently using ' tstr '; dims ' int2str(dims) '; tadd=' int2str(tadd)]);
%         tpr=ForceNumericInput('enter 1 for rgb, 2 for lab, 3 hsv, 4 grey-scale: ');
        tpr=ForceNumericInput('enter 1 for rgb, 2 for hsv, 4 grey-scale: ');
        if(tpr<=3)
            dims=input('enter dimensions as a vector eg [1 3]: ');
        else 
            dims=1;
        end
        [im2thresh,tstr]=ProcessIm(im,tpr);
        refim=GetRefim(mask,origim,tpr,dims);
    elseif(b==110)
        ind=mod(ind+frameadd,length(nums));
        if(ind==0)
            ind=length(nums);
        end
        im=MyAviRead(fn,nums(ind),vobj);
        [im2thresh,tstr]=ProcessIm(im,tpr);
        refim=GetRefim(mask,origim,tpr,dims);
    end
end

function[refim]=GetRefim(mask,im,tpr,dims)
vmask=mask(:);
m=ProcessIm(im,tpr);
refim=ones(size(im));
for i=1:size(im,3)
    a=m(:,:,i);
    v=a(:);
    refim(:,:,i)=median(v(vmask));
end

function[im2thresh,tstr]=ProcessIm(im,tpr)
tstrs={'rgb';'hsv';'lab';'grey'};
if(tpr==1)
    im2thresh=im;
elseif(tpr==2)
    im2thresh=rgb2hsv(im);
elseif(tpr==3)
    im2thresh=rgb2lab(im);
elseif(tpr==4)
    im2thresh=rgb2gray(im);
end 
if(tpr<=4)
    tstr=char(tstrs(tpr));
end


function[diffim,obj_im,boun]=DoThreshold(im2thresh,thresh,refim,dims)
d=(double(im2thresh(:,:,dims))-refim(:,:,dims)).^2;
diffim=sqrt(sum(d,3));
t_im=abs(diffim<=thresh);
obj_im=bwlabeln(t_im);
boun=bwboundaries(t_im,8,'noholes');

function PlotStuff(im,im2thresh,thresh,diffim,obj_im,boun,dims,tstr,ind)
subplot(2,2,1)
imagesc(im);
title(['Frame ' int2str(ind) '; Thresh=' num2str(thresh)])
hold on
for k = 1:length(boun)
    boundary = boun{k};
    plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 1)
end
hold off
subplot(2,2,2)
imagesc(im2thresh);
title([ tstr ' Processed image'])
subplot(2,2,3)
imagesc(diffim);
colorbar
title(['Difference image. Dimensions ' int2str(dims)])
subplot(2,2,4)
imagesc(obj_im)
title(['Objects image' ])




function[c,r]=NumPl(mn)
if(mn<2)
    c=1;
    r=1;
elseif(mn<4)
    c=2;
    r=2;
elseif(mn<6)
    c=3;
    r=2;
else
    c=3;
    r=3;
end