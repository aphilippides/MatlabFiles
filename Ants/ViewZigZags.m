function ViewZigZags(out)

% Get Data file
if((nargin<1)||(out==0)) 
    ino=1;
    fs=dir('*ZigZagData.mat');
    fn=['in'];
else
    ino=0;
    fs=dir('*ZZLoopData.mat');
    fn=['out'];
end;
WriteFileOnScreen(fs,1);
Picked=input('select output file to check:  ');
OutFn=fs(Picked).name;

% ino=0;
% OutFn='outswestZZLoopData';
load(OutFn)
if(ino) CheckLoops(zigzag);
else CheckLoops(loops);
end

function CheckLoops(loops)
athresh = 10; 
NestArc=30;
j=1;
if(~isfield(loops,'zz')) loops(1).zz=[]; end
while(j<=length(loops))
    j
    f=loops(j).fn;
    is=j;
    % Check Others
%     for i=(j+1):length(loops)
%         if(isequal(loops(i).fn,f)) is=[is i]; end;
%     end
    hs=ShowLoops(loops(is));    
    inp=input('return to continue; u go back one loop; c to end; j to jump ahead:  ','s');
    if(isequal(inp,'u')) j=j-1;
    elseif(isequal(inp,'c')) break;
    elseif(isequal(inp,'j')) 
        j=input('enter loop number to jump to:  ');
        j=max(1,j);
    else j=j+1; 
    end
end

function[h] = ShowLoops(zz)
athresh = 0; 
NestArc=30;
compassDir=4.9393;
fn=zz(1).fn;
load(fn);
lmo=LMOrder(LM);
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end

lcol=['r.';'k.';'y.';'g.'];
tb=5*pi/180;
po=0*pi/180;
for i=1:length(LMs)
    al(i)=cart2pol(LM(lmo(i),1),LM(lmo(i),2))-compassDir;
    als(i,:)=mod([al(i) al(i)]+[-tb tb],2*pi);
    is=find(als(i,:)>pi);
    als(i,is)=als(i,is)-pi;
end
als=als*180/pi;
[meanC,meanT,meanTind,len,ins,il2s]=LookingPtsExpt2(fn,[-10 10;als],[],[],[],[],LMs,DToNest,LM);
[meanC,meanT,meanTind,len,ins,ils]=LookingPtsExpt2(fn,10,[],[],[],[],LMs,DToNest,LM);
pois=find(abs(AngularDifference(sOr,po))<(10*pi/180));

for i=1:length(zz)
    iall=zz(i).is;
    figure(1)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    plot(Cents(:,1),Cents(:,2),'k',Cents(iall,1),Cents(iall,2),'r')
    title(['whole of flight ' fn])
    axis equal
    hold off
    h(i)=figure(i+1);
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;

    if((zz(i).good==0)||(length(iall)<2))
        plot(Cents(iall,1),Cents(iall,2),'g-*')
        title('section marked bad')
    else
        plot(Cents(iall,1),Cents(iall,2),'k')
        
        inps=intersect(ins,iall);
        plot(Cents(inps,1),Cents(inps,2),'bo')
        for j=1:length(ils)
            ks=intersect(ils(j).is,iall);
            plot(Cents(ks,1),Cents(ks,2),lcol(j,:))
        end
        for j=1:length(ils)
            ks=intersect(il2s(j).is,iall);
            plot(Cents(ks,1),Cents(ks,2),[lcol(j,1) 's'])
        end

        if(length(ils)==2) 
            ib=intersect(ils(1).is,ils(2).is);
            ks=intersect(ib,iall);
            plot(Cents(ks,1),Cents(ks,2),lcol(3,:))
        end
        ipos=intersect(pois,iall);
        plot([Cents(ipos,1) EndPt(ipos,1)]',[Cents(ipos,2) EndPt(ipos,2)]','k')
%         plot([EndPt(ipos,1)]',[EndPt(ipos,2)]','k*')
%             [area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
%             sp=Cents(iall(end),:);
            c=mean(Cents(iall,:));
%             angs=mod(angles-compassDir,2*pi);
%             dang=AngularDifference(angs(1),Cent_Os(iall))*180/pi;
%             zigs=iall(find(dang<-athresh));
%             zags=iall(find(dang>=athresh));
%             [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,Cents);
%             [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,Cents);
% 
%             plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'ko','MarkerFaceColor','k')
%             plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'ro','MarkerFaceColor','r')
%             PlotAngLine(angles,c);
            text(Cents(iall(1),1),Cents(iall(1),2),'Start')
            text(Cents(iall(end),1),Cents(iall(end),2),'End','Color','r')
            
%         if(isempty(zz(i).zz)) tstr=['unassigned'];
%         elseif(zz(i).zz==1) tstr=['zigzag'];
%         elseif(zz(i).zz==0) tstr=['crenellation'];
%         else tstr=['neither'];
%         end    
        t1=t(iall(1));
        t2=t(iall(end));
        title(['flight ' fn ', times ' num2str(t1) ' to ' num2str(t2)])% '. Currently ' tstr])
    end

    axis equal
    hold off
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

function[h] = ShowZigZags(zz)
compassDir=4.9393;
fn=zz(1).fn;
load(fn);
lmo=LMOrder(LM);
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end
[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,0.5);
EndPt=EndPt+Cents;

figure(1)
PlotNestAndLMs(LM,LMWid,nest);
hold on;
plot(Cents(:,1),Cents(:,2),'k')
title(['whole of flight ' fn])
axis equal
hold off

for i=1:length(zz)
    h(i)=figure(i+1);
    iall=zz(i).is;
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;

    if(zz(i).good==0)
        plot(Cents(iall,1),Cents(iall,2),'g-*')
        title('file marked bad')
    else
        [zig1,zig2,lzig,zigas]=GetZigOrZag(zz(i).zigs,Cents);
        [zag1,zag2,lzag,zagas]=GetZigOrZag(zz(i).zags,Cents);
        plot(Cents(iall,1),Cents(iall,2),'r')
        plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'ko','MarkerFaceColor','k')
        plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'ro','MarkerFaceColor','r')
        title(['ZigZag ' int2str(i)])
        text(Cents(iall(1),1),Cents(iall(1),2),'Start')
        text(Cents(iall(end),1),Cents(iall(end),2),'End','Color','r')
    end

    axis equal
    hold off
end


function PlotAngLine(angs,c)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',xs([2 4]),ys([2 4]),'g')