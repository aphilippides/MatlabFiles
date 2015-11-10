% function[d,dim,nim2]=zeildiff(im1,im2,i)
% 
% this function calculates the RMS difference between two image matrices,
% im1 and im2 where im2 is rotated by i-1 columns (ie if i=1, there's no
% rotation. 
%
% this is old but it works but it's slow and could be updated. Could also
% overload it to include other functions eg abs difference instead of RMS

function[d,dim,nim2]=zeildiff(im1,im2,i)
np=size(im1,2);
% [i:np 1:(i-1)]

% rotate the image 2 by i-1 columns
nim2=im2(:,[i:np 1:(i-1)]);
% nim2=circshift(im2,1-i,2);
% nim2=im2(:,[i:(np+i-1)]);

% calculate a difference matrix
dim=nim2-im1;

% subplot(3,1,2)
% imagesc(nim2),axis equal;
% subplot(3,1,3)
% imagesc(dim.^2),axis equal;
% caxis([0 255.^2])

% make this into a vector
v=dim(:);

% calc RMS difference 
d=sqrt(sum(v.^2)/length(v));

% % calc absolute ddifference instead
% % d=sum(abs(v)/length(v));
