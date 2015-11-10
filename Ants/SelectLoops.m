function SelectLoops(fn)

athresh = 10;
NestArc=30;
if(nargin<1) fn=['out']; end;

% Get Data file
fs=dir('Loops*.mat');

WriteFileOnScreen(fs,1);
Picked=input('select output file; return to enter new one:  ');
if(isempty(Picked)) 
    fst=input('Enter new filename: Loops*.mat:  ','s');
    OutFn=['Loops' fst '.mat'];
    GetAllLoops(fn,OutFn);
    filesDone=[];
else
    OutFn=fs(Picked).name;
%     if(ino==0)
%         if(~isfield(loops,'zz')) loops(1).zz=[]; end
%     end
end

load(OutFn);

j=1;
while(j<=length(loops))
    j
    
    do=1;
    if(loops(j).proc)
        inp=input('File already processed, enter 1 to review:   ');
        if(~isequal(inp,1)) do=0; end;
    end
                
    if(do)
        if(isempty(loops(j).loop))
            disp(['no loops in file: ' loops(j).fn])
            dum=input('press any key to continue');
        else
            [l,p,jumpflt]=CheckLoops(loops(j).loop,loops(j).fn,loops(j).Picked);
            loops(j).loop=l;
            loops(j).Picked=p;
            loops(j).proc=1;
            save(OutFn,'loops','-append');
            if(jumpflt)
                nflt=input(['enter flt to go to, 1 to ' int2str(length(loops)) ':  ']);
                j=nflt-1;
            end
        end
    end
    j=j+1;
end

function[loops,Picked,newflt] = CheckLoops(loops,fn,Picked)
newflt=0;
athresh = 0; 
NestArc=30;
% compassDir=4.9393;
load(fn);
lmo=LMOrder(LM);
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,cs,e1,LMs,sOr,sc,Speeds,Vels,c_o,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,cs,e1,LMs,sOr,sc,Speeds,Vels,c_o,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end

fdir=AngularDifference(c_o,sOr)*180/pi;
nc=length(loops);
curr=1;
edg=5
while 1
    
    lo=[loops(curr).is];
    is=loops(curr).iall;
    i2=max(is(1),lo(1)-edg):min(is(end),lo(end)+edg);
    
    % all of flight
    figure(1)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    plot(cs(is,1),cs(is,2),'k')
    tp=find(Picked==1);
    for i=tp 
        il=loops(i).is;
        plot(cs(il,1),cs(il,2),'r')
    end
    if(Picked(curr)) plot(cs(lo,1),cs(lo,2),'b','LineWidth',2)
    else plot(cs(lo,1),cs(lo,2),'g','LineWidth',2)
    end
    title(['whole of flight ' fn])
    axis equal
    hold off

    %     for k=1:c-1
    figure(2)
    PlotNestAndLMs(LM,LMWid,nest,0);
    hold on
    plot(cs(i2,1),cs(i2,2),'r-',cs(i2(1),1),cs(i2(1),2),'rs')%,'MarkerFaceColor','r')
    text(cs(i2(1),1),cs(i2(1),2),'S')
    lo2=lo(1):4:lo(end);
    if(Picked(curr))
        plot(e1(lo2,1),e1(lo2,2),'b.',[cs(lo2,1) e1(lo2,1)]',[cs(lo2,2) e1(lo2,2)]','b',cs(lo,1),cs(lo,2),'b')
        title([fn ': loop ' int2str(curr) '/' int2str(nc) '; SELECTED'],'Color','b')
    else
        plot(e1(lo2,1),e1(lo2,2),'r.',[cs(lo2,1) e1(lo2,1)]',[cs(lo2,2) e1(lo2,2)]','r')
        title([fn ': loop ' int2str(curr) '/' int2str(nc) ],'Color','r')
    end
    axis equal,
    hold off
    figure(3)
    subplot(3,1,1)
    %         plot(t(i2),sOr(i2),'r- .',t(lo),sOr(lo),'b:o')
    plot(t(lo),AngleWithoutFlip(sOr(lo)),'b:o')%,t(i2),AngleWithoutFlip(sOr(i2)),'r- .')
    ylabel('Body orient'),axis tight,title(fn)
    subplot(3,1,2)
    plot(t(lo),AngleWithoutFlip(c_o(lo)),'b:o')%,t(i2),AngleWithoutFlip(c_o(i2)),'r- .')
    ylabel('Flight Dir'),axis tight,
    subplot(3,1,3)
    plot(t(lo),fdir(lo),'b:o')%t(i2),fdir(i2),'r- .')
    ylabel('Rel Flight dir'),axis tight,
    disp(' ');
    disp('enter 1 to select/deselect; return continue;');
    inp=input('u to go back one file; n for next file; f to jump:    ','s');
    if(isempty(inp)) curr=curr+1;
    elseif(isequal(inp,'u')) 
        curr=curr-1;
    elseif(isequal(inp,'n')) 
        break;
    elseif(isequal(inp,'f'))
        newflt=1;
        break;
    elseif(isequal(str2num(inp),1))
        Picked(curr)=mod(Picked(curr)+1,2);
        loops(curr).picked=Picked(curr);
        %             curr=curr+1;
    end
    curr=mod(curr,nc);
    if(curr==0) curr=nc; end;
    curr=min(nc,max(1,curr));
end


function[fla]=FlushResponse
while 1
    inp=input('Type 0 to continue; 1 to do another bit or r to redo this file:  ','s');
    if(isequal(inp,'0'))
        fla=0;
        break;
    elseif(isequal(inp,'1'))
        fla=1;
        break;
    elseif(isequal(inp,'r'))
        fla=2;
        break;
    end
end

function[fla]=FlushResponse2
while 1
    inp=input('Type 0 if ok; 1 if file is bad; u to go back one file; r to redo the file:  ','s');
    if(isequal(inp,'0'))
        fla=0;
        break;
    elseif(isequal(inp,'1'))
        fla=1;
        break;
    elseif(isequal(inp,'u'))
        fla=2;
        break;
    elseif(isequal(inp,'r'))
        fla=3;
        break;
    end
end

function PlotAngLine(angs,c)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',xs([2 4]),ys([2 4]),'g')

function GetAllLoops(fn,outfn)
if(nargin<1) fn=[]; end;

if(isequal(fn,'in'))
    inout=1;
else
    inout=0;
end

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
        [ls,ps]=GetLoops(Cents,DToNest,t,inout,sOr*180/pi,fdir,Cent_Os*180/pi,0,...
            fn(j).name,EndPt,LM,LMWid,nest);
        if(~isempty(ls))
            maxds=[ls.len]
            overd=find(maxds>2)
            ls=ls(overd);
        end
        loops(j).loop=ls;
        loops(j).fn=fn(j).name;
        loops(j).proc=0;
        loops(j).Picked=zeros(1,length(ls));
%         loops(j).p=ps;
        AllLoops=[AllLoops ls];
%         AllP=[AllP ps];
%         PickedLoops=[PickedLoops ls(find(ps))];
        save(outfn,'loops','AllLoops');%,'PickedLoops');
    end
end