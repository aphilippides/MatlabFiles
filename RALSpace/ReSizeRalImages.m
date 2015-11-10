% this function takes in an mp4 and outputs a mat file which has one 
% ims which is a structure with one field, im, which is 
% each frame, in grey-scale and cropped to the dimensions of the
% panoramic camera and resized to im_size which is currently set to 90 high
% by 360 wide

function ReSizeRalImages
% vO=1 means use videoReader, 0 = use mmread (slow)
% vO=1;

FList12=dir('*wd.mp4');

sk=1;
im_size=[90 360];

is=[1:length(FList12)];
for i=is
    [vO,vObj]=VideoReaderType(FList12(i).name);        
    [dat,nfr]=MyAviInfo(FList12(i).name,vObj);
    inds=1:sk:(nfr-1);
    ResizeImages(im_size,FList12(i).name,inds,vObj);
end

function ResizeImages(im_size,fn,is,vObj)
minrow=297;
maxrow=784;
outf=[fn(1:end-4) 'RS.mat']
tic
if(isfile(outf))
    return;
end
ims(is(end)).im=zeros(im_size); 
for i=is
    if(mod(i,10)==1)
        toc
        i
    end
    im=MyAviRead(fn,i,vObj);
    im2=rgb2gray(im);
    im=im2(minrow:maxrow,:);
    ims(i).im=double(imresize(im,im_size));
end
save(outf,'is','im_size','ims');