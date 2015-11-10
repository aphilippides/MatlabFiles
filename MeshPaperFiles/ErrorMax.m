% function to plot Max Conc from a diff equn. If Thresh: draw the threshold line
% ErrorMax(Times,Maxes,MaxesStd,h,Thresh,LineC)

function ErrorMax(Times,Maxes,MaxesStd,h,Thresh,LineC)

if(nargin>=4) subplot(h); end;
if(nargin<5) Thresh=0;end;
if(nargin<6) Cols=0;else Cols=1; end;
[XM,YM]=size(Maxes);
Thr=ones(XM)*2.5e-7;
N=ndims(Times);
if(N==1)
   MTimes=Times';
   for i=2:YM MTimes=[MTimes,Times']; end;
else
   MTimes=Times;
end
if(Cols) errorbar(MTimes,Maxes,MaxesStd,LineC);
else errorbar(MTimes,Maxes,MaxesStd); end;
if(Thresh)
   hold on;
   plot(MTimes(:,1),Thr,'r:');
   hold off;
end
