function MetaDrugAllGA

Equal=0;
load CleanRndDataLH4.mat;
Thresh=4.0;
Scales=7:-1:0
for i=2:8
   i
   SaveFName=(['RbfSvmGAPopDataSc' int2str(Scales(i)) 'Test.mat']);
	%DrugAllGA(TrainSet,TestSet,Thresh,Equal,SaveFName,Scales(i));
end
for i=7:8
   i
   SaveFName=(['RbfSvmGAPopDataSc' int2str(Scales(i)) 'X.mat']);
	DrugAllGA_X(TrainSet,TestSet,Thresh,Equal,SaveFName,Scales(i));
end
