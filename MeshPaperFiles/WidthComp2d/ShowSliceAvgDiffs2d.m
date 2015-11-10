function ShowSliceAvgDiffs2d(t,Skip,Inn)

d2dmm
wid=[4 8];
Cols=['r:';'b-'];
for i=1:2;
	fn=['MaxTreeRho100/TreeSst0_125SliceAvgsGr2500X800Sq1W'x2str(wid(i)) 'T'x2str(t) '.mat'];
   load(fn);
   SliceAvg=SliceAvg.*1.324e-4;
   SliceStd=SliceStd.*1.324e-4;
   errorbar(SliceAvg(1:Skip:end),SliceStd(1:Skip:end),Cols(i,:));
   hold on;
   X=size(SliceStd,1);
   if(nargin<3)
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