function templobe(X)
dumm3(X)

function dumm
Timez=500:500:2000
X=[4, 9, 16, 25, 36, 49, 64, 81, 100];
for i=1:length(X)
   dsmall
   fn=['Lobe/MeshSSt1Gr1000X' int2str(X(i)) 'Sq2Sp10Inn300Data.mat'];
   M=load(fn);
   for j=1:length(Timez)
      [Errs300(i,j), SDs300(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,0,150,0,M)
      [Errs200(i,j), SDs200(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,50,150,0,M)
      [Errs100(i,j), SDs100(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,100,150,0,M)
      [Errs250(i,j), SDs250(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,25,150,0,M)
      [Errs50(i,j), SDs50(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,125,150,0,M)
      [Errs150(i,j), SDs150(i,j)]=CheckFin2Inf(2,10,X(i),250,Timez(j),5e-3,75,150,0,M)
%      save ErrorsZ250.mat X Timez Errs300 SDs300 Errs250 SDs250 Errs200 SDs200 Errs150 SDs150 Errs100 SDs100 Errs50 SDs50  
   end
end

for i=1:length(X)
   dsmall
   fn=['Lobe/MeshSSt1Gr1000X' int2str(X(i)) 'Sq2Sp10Inn300Data.mat'];
   M=load(fn);
   for j=1:length(Timez)
      [Errs300(i,j), SDs300(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,0,150,0,M)
      [Errs200(i,j), SDs200(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,50,150,0,M)
      [Errs100(i,j), SDs100(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,100,150,0,M)
      [Errs250(i,j), SDs250(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,25,150,0,M)
      [Errs50(i,j), SDs50(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,125,150,0,M)
      [Errs150(i,j), SDs150(i,j)]=CheckFin2Inf(2,10,X(i),200,Timez(j),5e-3,75,150,0,M)
      save ErrorsZ200.mat X Timez Errs300 SDs300 Errs250 SDs250 Errs200 SDs200 Errs150 SDs150 Errs100 SDs100 Errs50 SDs50  
   end
end

function dumm2
Timez=500:500:2000
X=[4 , 16, 25, 36, 49, 64, 81, 100];
for i=1:length(X)
   dsmall
   fn=['Lobe/MeshSSt1Gr1000X' int2str(X(i)) 'Sq2Sp10Inn300Data.mat'];
   M=0;%load(fn);
   for j=1:length(Timez)
      [Errs250(i,j), SDs250(i,j)]=CheckFin2Inf(1,2,10,X(i),250,Timez(j),2.5e-7,0,150,0,M)
      [Errs200(i,j), SDs200(i,j)]=CheckFin2Inf(1,2,10,X(i),200,Timez(j),2.5e-7,0,150,0,M)
      [Errs200(i,j), SDs200(i,j)]=CheckFin2Inf(2,1,5,X(i),200,Timez(j),2.5e-7,0,150,0,M)
%      save FinInfMMEstErrsS1T4Tol0_25.mat X Timez Errs200 SDs200 Errs250 SDs250 
   end
end

function dumm3(X)
Timez=500:500:2000
X=[4, 16, 25, 36, 49, 64, 81, 100];
for i=1:length(X)
   for j=1:length(Timez)
%      [Errs250(i,j), SDs250(i,j)]=CheckMinMaxLobe(1,2,10,X(i),250,Timez(j),2.5e-7,0,0)
 %     [Errs200(i,j), SDs200(i,j)]=CheckMinMaxLobe(1,2,10,X(i),200,Timez(j),2.5e-7,0,0)
		[Errs200(i,j), SDs200(i,j)]=CheckMinMaxLobe(2,1,5,X(i),200,Timez(j),2.5e-7,0,0)
%      save MinMaxErrsS1T4Tol0_25.mat X Timez Errs200 SDs200 Errs250 SDs250 
   end
end
