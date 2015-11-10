function ShowLoops(fn)
if(nargin<1) fn=[]; end;

if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end

outfn=input('enter output filename:  ','s');
outfn=[outfn '.mat'];
while(isfile(outfn))
    str=[outfn ' already exists. Return to overwrite or enter new name:  '];
    inp=input(str,'s');
    if(isempty(inp)) break;
    else outfn=inp;
    end
end

AllLoops=[];
loops=[];
PickedLoops=[];
AllP=[];
for j=1:length(fn)
    j
    load(fn(j).name);
    if(t(end)>0)
        lmo=LMOrder(LM)
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
        end
        fdir=AngularDifference(Cent_Os,sOr)*180/pi;
        [ls,ps]=GetLoops(Cents,DToNest,t,0,sOr*180/pi,fdir,Cent_Os*180/pi,0,...
            fn(j).name,EndPt,LM,LMWid,nest);
        loops(j).l=ls;
        loops(j).fn=fn(j).name;
%         loops(j).p=ps;
        AllLoops=[AllLoops ls];
%         AllP=[AllP ps];
%         PickedLoops=[PickedLoops ls(find(ps))];
        save(outfn,'loops','AllLoops','fn');%,'PickedLoops');
    end
end