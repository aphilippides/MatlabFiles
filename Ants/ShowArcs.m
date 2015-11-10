function[mr,ps,nps,awis,cwis] = ShowArcs(fn);

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

% out stuff
% if((nargin<2)|isempty(dout))
%     disp('  ');
%     disp('Enter range of distances from nest as [d1 d2] in cm.');
%     %     disp('Enter a negative value -d for [d end].');
%     dout=input('Enter: d for [0 d], -d for [d inf], return for all flight: ');
% end;
% if(isempty(dout)) dout=[0 1e6];
% elseif(length(dout)==1)
%     if(dout>0) dout=[0 dout];
%     else dout=[-dout 1e6];
%     end
% end

angs=[];cs=[];ep=[];lor=[];ns=[];
for i=1:4 lm(i).lm=[]; end

for j=1:length(fn)
    j
    load(fn(j).name);
    lmo=LMOrder(LM)
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
    end
    figure(1)
    subplot(2,1,1)
    oarcs=SelectArcs(sOr,t,0.349,0.05);
    grid,axis tight
    subplot(2,1,2)
    parcs=SelectArcs(OToNest,t,0.349,0.05);
    grid,axis tight
    figure(2)
    PlotBee(Cents,EndPt,[],'y')
            hold on;
    ios=oarcs(:,3);
    ips=parcs(:,3);
        PlotBee(Cents(ios,:),EndPt(ios,:))
        PlotBee(Cents(ips,:),EndPt(ips,:),[],'r')
            PlotNestAndLMs(LM,LMWid,nest);
            hold off
% 
%     for i=1:size(Arcs,1)-1
%         is=[Arcs(i,3):Arcs(i+1,3)];
% 
%     end
end