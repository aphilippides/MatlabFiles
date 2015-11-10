% VisualCompass(im1,im2,np)
%
% This takes two images im1, im2 (which are matrices)
% it performs the visual compass comparison to get an RIDF
% by rotating one image through a number of orientations relative to it's
% current heading and finding the difference between it and the non-rotated
% other image. 
%
% It defaults to rotating thruogh all possible angles
% however if np is specified it will only do +/- np/2
% eg if np=90 it will check -45 and +45 columns around the current heading
%
% it returns the index of the best matching direction in mini, im2 rotatted 
% to the best matching amount in rim, imin is a helper which is the indices 
% of the best matching columns (see last two lines for how this works)
% mind is the minimum difference across all angles, d is the RIDF itself
%
% note that this function works on the columns if the image NOT in degrees 
% so outputs are in columns%
%
% it calls zeildiff which does sum-squared difference. this could be
% changed
%
% it's also not very efficient because the rotation is done in zeildiff
% . I'll update when i get round to it

function[mini,rim,imin,mind,d]=VisualCompass(im1,im2,np)
endpt=size(im1,2);
if(nargin<3) np=endpt; end;
d=zeros(1,np);
len=floor(np/2);
% im3=[im2 im2];
for i=1:len
%     i
    d(i)=zeildiff(im1,im2,i);
    ep=(endpt-i+1);
    ep2=(np-i+1);
    d(ep2)=zeildiff(im1,im2,ep);
%     md=min(d);
end
if(mod(np,2)) 
    d(len+1)=zeildiff(im1,im2,len+1); 
end;
[mind,mini]=min(d);
imin=[mini:endpt 1:(mini-1)];
rim=im2(:,imin);