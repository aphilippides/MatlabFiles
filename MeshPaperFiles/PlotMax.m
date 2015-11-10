% function to plot Max Conc from a diff equn. If Thresh: draw the threshold line

function PlotMax(M,h,LineC,Thresh)

if(nargin>=2) subplot(h); end;
if(nargin<3) LineC=Colour(1); end;
if(nargin<4) Thresh=1;end;
Y=size(M,1);
Times=M(2:end,1);
Thr=ones(Y-1)*.00188;
Maximums=M(2:Y,2);
if(Thresh)
   plot(Times,Maximums,LineC,Times,Thr,'r:');
else
   plot(Times,Maximums);
end
