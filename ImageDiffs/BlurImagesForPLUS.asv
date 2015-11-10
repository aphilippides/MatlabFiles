% function BlurImagesForPLUS

dwork
cd ../Current/Ants/
im=imread('nest1-left.tif');
w=size(im,2);
bw=rgb2gray(im(101:5:1800,1:5:w,1:3));
figure(1)
imagesc(bw),axis image
figure(2)
imagesc(im(100:1800,:,1:3)),axis image
f=fspecial('gaussian',60,15);
antim=imfilter(bw,f,'replicate');
figure(3),imagesc(antim),axis image

eyeim=bw(:,1701:2700);
ss=([0:0.05:1].^1)*10;
numlev=length(ss);
figure(3)
for i=1:numlev
    subplot(7,3,i)
    if(ss(i)>0)
        fims(i).f=fspecial('gaussian',60,ss(i));
        fims(i).im=imfilter(eyeim,fims(i).f,'replicate');
    else
        fims(i).f=1;
        fims(i).im=eyeim;
    end
    imagesc(fims(i).im),colormap gray,%axis image
end
[h,w]=size(eyeim);
[X,Y]=meshgrid(1:w,1:h);
cp=round(0.5*[w,h])
X=X-cp(1);
Y=Y-cp(2);
d=sqrt((0.5*X).^2+(1*Y).^2);
levs=max(min(ceil((numlev)*d/max(d(:))),numlev),1);
fullim=uint8(zeros(size(eyeim)));
figure(4)
for i=1:numlev
    fims(i).mask=uint8(levs==i).*(fims(i).im);
    subplot(7,3,i)
    imagesc(fims(i).mask),
    fullim=fullim+fims(i).mask;
end
figure(5)
imagesc(fullim);axis image

figure(6)
[x,y]=meshgrid(-2:.1:2);
[x,y]=meshgrid(-2:.1:2,0:.1:2);
d=1-exp(-(x.^2+y.^2)/0.5);
n=rand(size(d)).*0.05;
% n(20:22,20:22)=0;
pd=(d).^.6+n;
mesh(x,y,pd),axis tight%shading flat

