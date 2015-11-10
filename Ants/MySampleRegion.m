function [r,c,cent]=MySampleRegion(R,nsamp)
% Sample an image patch with sampling probability related to intensity of
% pixels.
% R - image to be sampled
% nsamp - number of samples
% [r,c] - row and column indices of samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(nargin<2) nsamp=1e5; end;

% cube R to emphasise brighter regions
R=double(R);
% R=R.^3;
% normalize to sum to 1 making entries probabilities of being sampled
tot=sum(R(:));
[rs,cs]=size(R);
mr=[1:rs]*sum(R,2);
mc=sum(R,1)*[1:cs]';

% [xs,ys]=ind2sub(size(R),1:length(Rnorm));
% cent=(([ys;xs]*R(:))/tot)';

cent=[mc,mr]/tot;

ind=1;
for ri=1:rs
    for cj=1:cs
        f=ind+R(ri,cj);
        r(ind:f-1)=ri;
        c(ind:f-1)=cj;
        ind=f;
    end
end