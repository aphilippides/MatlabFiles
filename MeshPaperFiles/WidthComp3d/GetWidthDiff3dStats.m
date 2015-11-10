function GetWidthDiff3dStats(Sl)

GetDensityMaxStats(Sl)
%GetWidthDiffSliceStats

function GetWidthDiffMaxStats(Sl)

Dens=[100 111 125];
for d=1:3
	fn=['MaxTreeRho'x2str(Dens(d) '/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
   load(fn);
   [mma,i]=max(MaxAvg);
   sma=MaxStd(i);
   [mmi,i]=max(MinAvg);
   smi=MinStd(i);
   [mo,i]=max(OverAvg);
   so=OverStd(i);
   [mme,i]=max(MeanAvg);
   sme=MeanStd(i);
   Stats(d,:)=[mma sma mmi smi mo so mme sme];
end
Stats
save TreeDensMaxStats.dat Stats -ascii 