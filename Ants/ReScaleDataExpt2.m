function[nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,scalefac,Speeds,Vels,Cent_Os,OToNest] = ...
    ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,scalefac,NDir)

% NB scalefac and NDir should really be variable arguments but I want
% errors to be thrown to catch mixed old/new program versions
if(isempty(scalefac))
    d=median(CartDist(LM,nest));
    if(isequal(fn(2),'8'))  scalefac=8/d;
    elseif(isequal(fn(1),'b'))  scalefac=0.1;%2.25/2.25;%LMWid;
    else scalefac=20/d;
    end
end
if(isempty(NDir)) NDir=4.9393; end;

DToNest=DToNest*scalefac;
LMWid=LMWid*scalefac;
LM(:,1)=(LM(:,1)-nest(1))*scalefac;
LM(:,2)=(LM(:,2)-nest(2))*scalefac;

Cents(:,1)=(Cents(:,1)-nest(1))*scalefac;
Cents(:,2)=(Cents(:,2)-nest(2))*scalefac;
EndPt(:,1)=(EndPt(:,1)-nest(1))*scalefac;
EndPt(:,2)=(EndPt(:,2)-nest(2))*scalefac;

s=sOr-NDir;
sOr=mod(s,2*pi);
% re-scale the angles relative to North. Also, angs to nest/LM are from bee
% to object, hence the + pi
for i=1:length(LMs) 
    LMs(i).DToLM=(LMs(i).DToLM)*scalefac; 
    LMs(i).OToLM=mod(LMs(i).OToLM-NDir,2*pi);
end;
OToNest=mod(OToNest-NDir,2*pi);
nest=[0,0];
v1=MyGradient(Cents(:,1),t);
v2=MyGradient(Cents(:,2),t);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));
Cent_Os=mod(Cent_Os-NDir,2*pi);
% save(fn,'scalefac','-append');