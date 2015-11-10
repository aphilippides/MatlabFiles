function ShowSliceAvgDiffs3d(t,Skip,Line,Inn)

d3dmm
wid=[1 5];
Cols=['r:';'b-'];
for i=1:2;
	fn=['MaxW'x2str(wid(i)) 'Rho100/TreeSst1SliceAvgsGr300X100Z100Sq1Sp10T'x2str(t) '.mat'];
   load(fn);
   SliceAvg=SliceAvg.*1.324e-4;
   SliceStd=SliceStd.*1.324e-4;
   errorbar([1:Skip:300],SliceAvg(Line,1:Skip:end)*1e6,SliceStd(Line,1:Skip:end)*1e6,Cols(i,:));
   hold on;
   X=size(SliceStd,1);
   if(nargin<4)
      x1=1;
      x2=X;
   else
   	x1=round((X-Inn)/2);
      x2=x1+Inn;
   end
  	SDAvg(i)=MMean(SliceStd(x1:x2,x1:x2))
   SDStd(i)=MStd(SliceStd(x1:x2,x1:x2))
end
hold off
axis tight

xlabel('Distance (\mum)');
ylabel('Concentration (\muM)');
%SetLegend(Cols',{'1\mum';'5\mum'},1)
SetBox