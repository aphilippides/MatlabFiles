function[s] = file2struct(fn)
load(fn)
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end
s.DToNest=DToNest;
s.Speeds=Speeds;
s.sOr=sOr;
NDir=4.9393;
% s.OToNest=mod(OToNest-NDir,2*pi);
s.OToNest=mod(OToNest,2*pi);
s.Cent_Os=Cent_Os;
s.LMs=LMs;
s.t=t;
for i=1:length(LMs)
    s.LMs(i).LMOnRetina=mod(LMs(i).LMOnRetina+pi,2*pi)-pi;
    s.LMs(i).OToLM=mod(LMs(i).OToLM,2*pi);
end
s.t=t;
s.NestOnRetina=mod(NestOnRetina+pi,2*pi)-pi;