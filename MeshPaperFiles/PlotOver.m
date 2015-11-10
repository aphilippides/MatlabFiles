% function to plot NumOver from a diff equn. Dimension is dimension of Approx default 3
% function PlotOver(M,h,LineC,Dimension)

function PlotOver(M,h,LineC,Dimension)

if(nargin>=2) subplot(h); end;
if(nargin<3) LineC=Colour(1); end;
if(nargin<4) Dimension=3;end;
Y=size(M,1);
Times=M(2:end,1);
NumOver=(M(1,3)-M(1,2)).^Dimension-M(2:Y,4);
plot(Times,NumOver,LineC);