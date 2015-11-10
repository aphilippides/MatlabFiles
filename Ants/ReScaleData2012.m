function[nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,areas] = ...
    ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,NDir,areas)

% re-scale data so its in cms not pixels
DToNest=DToNest*cmPerPix;
LMWid=LMWid*cmPerPix;
LM(:,1)=(LM(:,1)-nest(1))*cmPerPix;
LM(:,2)=(LM(:,2)-nest(2))*cmPerPix;
areas=areas*cmPerPix*cmPerPix;

% re-scale positions of the bee and it's head so its in cms not pixels
% also, set the nest as 0,0
Cents(:,1)=(Cents(:,1)-nest(1))*cmPerPix;
Cents(:,2)=(Cents(:,2)-nest(2))*cmPerPix;
EndPt(:,1)=(EndPt(:,1)-nest(1))*cmPerPix;
EndPt(:,2)=(EndPt(:,2)-nest(2))*cmPerPix;
nest=[0,0];

% re-scale the angles relative to North. 
% Also, angles to nest/LM were originally from bee to object, hence the +pi
s=sOr-NDir;
sOr=mod(s,2*pi);
for i=1:length(LMs) 
    LMs(i).LM=LM(i,:);
    LMs(i).DToLM=(LMs(i).DToLM)*cmPerPix; 
    LMs(i).OToLM=mod(LMs(i).OToLM-NDir,2*pi);
end;
OToNest=mod(OToNest-NDir,2*pi);
v1=MyGradient(Cents(:,1),t);
v2=MyGradient(Cents(:,2),t);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));
Cent_Os=mod(Cent_Os-NDir,2*pi);