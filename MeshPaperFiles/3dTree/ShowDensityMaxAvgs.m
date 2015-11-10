function ShowDensityMaxAvgs(Dens,Sl)

d3dmm;
Thr=0.25e-6;
Slices=[50,100,150,200,250,300];
Maxes=[];Mins=[];Overs=[];Means=[];SDs=[];MTs=[];
MaStd=[];MiStd=[];OvStd=[];MeStd=[];SStd=[];

for i=1:length(Dens)
    fn=['MaxTreeRho'x2str(Dens(i)) '/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
   load(fn);
   Maxes=[Maxes,MaxAvg'];
   Mins=[Mins,MinAvg'];
   Overs=[Overs,OverAvg'];
   Means=[Means,MeanAvg'];
   SDs=[SDs,SDAvg'];
   MaStd=[MaStd,MaxStd'];
   MiStd=[MiStd,MinStd'];
   OvStd=[OvStd,OverStd'];
   MeStd=[MeStd,MeanStd'];
   SStd=[SStd,SDStd'];
   MTs=[MTs,Times];
end

MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(MTs,Maxes,MaStd);hold on;
plot(MTs(:,1)',Thr*ones(1,length(Times)),'k:');
errorbar(MTs,Mins,MiStd);
hold off;axis('tight');
title(['Max and Min: Inner ' int2str(Slices(Sl+1)) ' \mum']);
legend('\rho=0.01','\rho=0.009','\rho=0.008',2)%,'Thresh',2)
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(MTs,Overs,OvStd);axis('tight');title('# Over');

MeanHndl=subplot('position',[0.05 0.05 0.4 0.4]);
errorbar(MTs,Means,MeStd);axis('tight');title('mean Conc');

SDHndl=subplot('position',[0.55 0.05 0.4 0.4]);
errorbar(MTs,SDs,SStd);axis('tight');title('s.d. conc');

