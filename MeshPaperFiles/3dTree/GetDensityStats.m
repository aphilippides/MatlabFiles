function GetDensityStats(Sl)

GetDensityMaxStats(Sl)
%GetWidthDiffSliceStats

function GetDensityMaxStats(Sl)

Slices=[50,100,150,200,250,300];
Dens=[100 111 125];
for d=1:3
	fn=['MaxTreeRho'x2str(Dens(d)) '/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
   load(fn);
   [mma,i]=max(MaxAvg);
   sma=MaxStd(i);
   [mmi,i]=max(MinAvg);
   smi=MinStd(i);
   [mo,i]=max(OverAvg);
   so=OverStd(i);
   [mme,i]=max(MeanAvg);
   sme=MeanStd(i);
	[msd,i]=max(MeanAvg);
   ssd=MeanStd(i);
   Stats(d,:)=[Dens(d) Slices(Sl) [mma sma mmi smi mme sme msd ssd].*1e6 [mo so]./1e6];
end
Stats
Sl=4
for d=1:3
	fn=['MaxTreeRho'x2str(Dens(d)) '/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
   load(fn);
   [mma,i]=max(MaxAvg);
   sma=MaxStd(i);
   [mmi,i]=max(MinAvg);
   smi=MinStd(i);
   [mo,i]=max(OverAvg);
   so=OverStd(i);
   [mme,i]=max(MeanAvg);
   sme=MeanStd(i);
	[msd,i]=max(MeanAvg);
   ssd=MeanStd(i);
   Stats4(d,:)=[Dens(d) Slices(Sl) [mma sma mmi smi mme sme msd ssd].*1e6 [mo so]./1e6];
end
Stats4
save TreeDensMaxStatsSl1_4.dat Stats4 Stats -ascii 