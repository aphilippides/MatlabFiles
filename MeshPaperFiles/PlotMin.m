% function to plot Max Conc from a diff equn. If Thresh: draw the threshold line

function PlotMin(M,h,LineC,Thresh)

if(nargin>=2) subplot(h); end;
if(nargin<3) LineC=Colour(1); end;
if(nargin<4) Thresh=1;end;
Y=size(M,1);
Times=M(2:end,1);
Thr=ones(Y-1)*.00188;
Minimums=M(2:Y,3);
if(Thresh)
   plot(Times,Minimums,LineC,Times,Thr,'r:');
else
   plot(Times,Minimums,LineC);
end
