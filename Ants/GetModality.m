function GetModality

s=dir('*All.mat');
LM1=[];
LM2=[];
ns=[];
jnds=1:length(s)
xs=[0:10:360];
for i=jnds
    fn=s(i).name;
    load(fn)
    lmo=LMOrder(LM);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end
%     o=(mod(sOr,2*pi))*180/pi;
    o=sOr_sc*180/pi;
    fo=AngHist(o,xs,1,1);
%     inp=input('return if unimodal, 1 if bimodal, 0 else');
%     if(isequal(inp,1)) mods(i)=2;
%     elseif(isequal(inp,0)) mods(i)=0;
%     else mods(i)=1;
% %     end
%     save unibi mods
end
