% function[fSr1,fSr2,Sr3] = GetTransform(ins,im,n,refpoints,Pic) 
%
% function which will return a general transformation matrix given some
% reference points refpoints (in some standard  (x y z 1)) the same points
% in ins picked out of an image im (ie 2d points). If Pic is selected the 
% points are drawn onto im
%
% Need to comment as can't remember how it works. Also need to write a less
% general one to do a transformation to straight down. 
% need to at least say what output variables are...

function[fSr1,fSr2,Sr3] = GetTransform(ins,im,n,refpoints,Pic) 

for i=1:size(refpoints,1)
    refx(i,:)=refpoints(i,1:3)*ins(i,1);
    refy(i,:)=refpoints(i,1:3)*ins(i,2);
end
LH = [-refpoints(n,:) zeros(length(n),4) refx(n,:);zeros(length(n),4) -refpoints(n,:) refy(n,:)];
RH=-[ins(n,1);ins(n,2)];
% S=LH\RH;
S=pinv(LH)*RH;
fSr1=S(1:4);
fSr2=S(5:8);
Sr3=[S(9:11); 1];
xs=(refpoints*fSr1)./(refpoints*Sr3);
ys=(refpoints*fSr2)./(refpoints*Sr3);
d=sqrt(sum(([xs ys]-ins).^2,2));
meanerr=sum(d)/length(xs)
meanerr2=sum(d(n))/length(n)
if(Pic) 
    imshow(im,[]) 
hold on
plot(xs,ys,'g+')
hold off
end