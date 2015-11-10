function CheckZigZags(out)

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
if(ino) CheckZZ(zigzag,OutFn);
else CheckLoops(loops,OutFn);
end

function CheckLoops(loops,OutFn)
athresh = 10; 
NestArc=30;
j=1;
if(~isfield(loops,'zz')) loops(1).zz=[]; end
while(j<=length(loops))
    j
    f=loops(j).fn;
    is=j;
    % Check Others
    for i=(j+1):length(loops)
        if(isequal(loops(i).fn,f)) is=[is i]; end;
    end
    hs=ShowLoops(loops(is));    
    inp=FlushResponse2;
    
    if(inp==0)
        i=1;
        len=length(is);
%         while 1
%             figure(hs(i));
%             if(isempty(loops(is(i)).zz)) tstr=['unassigned'];
%             elseif(loops(is(i)).zz==1) tstr=['zigzag'];
%             elseif(loops(is(i)).zz==0) tstr=['crenellation'];
%             else tstr=['neither'];
%             end
%             title(['Loop ' int2str(i) '. Select zigzag or crenellation. Currently ' tstr])
%             disp(' ');
%             disp('type z=zigzag, c=crenellation, b=neither');
%             czz=input(['return to skip, 0 to end. Currently ' tstr ':  '],'s')
%             if(isequal(czz,'z')) loops(is(i)).zz=1;
%             elseif(isequal(czz,'c')) loops(is(i)).zz=0;    
%             elseif(isequal(czz,'b')) loops(is(i)).zz=2;
%             elseif(isequal(czz,'0')) break;
%             end
%             i=i+1;
%             if(i>len) i=1; end;
%         end
        
        if(len==1) j=j+1;
        elseif(max(diff(is))<=1) j=j+len;
        else j=j+1;
        end
        for i=2:length(is) close(hs(i)); end;
    elseif(inp==4) break;
    elseif(inp==5) 
        j=input('enter loop number to jump to:  ');
        j=max(1,j);
    elseif(inp==1)
        bad=input('enter zig zag/loop number to be declared bad (or good if already bad):  ');
        if(bad==0)
            for i=is
                if(loops(i).good==0) loops(i).good=1;
                else loops(i).good=0;
                end
            end
        else
            if(loops(is(bad)).good==0) loops(is(bad)).good=1;
            else loops(is(bad)).good=0;
            end
        end
    elseif(inp==2) 
        j=max(1,j-1);
        for i=2:length(is) close(hs(i)); end;
    else
        for i=2:length(is) close(hs(i)); end;
        zz=GetLoop(f,athresh,NestArc);
        for i=1:length(zz) zz(i).zz=[]; end;
        loops=[loops(1:j-1) zz loops((j+length(is)):end)];
%         l=length(zz);
%         j=j+l;
    end
    save(OutFn,'loops');
end


function CheckZZ(zigzag,OutFn)
athresh = 10; 
NestArc=30;
j=1;
while(j<=length(zigzag))
    j
    f=zigzag(j).fn;
    is=j;
    % Check Others
    for i=(j+1):length(zigzag)
        if(isequal(zigzag(i).fn,f)) is=[is i]; end;
    end
    hs=ShowZigZags(zigzag(is));    
    inp=FlushResponse2;
    
    if(inp==0)
        len=length(is);
        if(len==1) j=j+1;
        elseif(max(diff(is))<=1) j=j+len;
        else j=j+1;
        end
        for i=2:length(is) close(hs(i)); end;
    elseif(inp==4) break;
    elseif(inp==5) 
        j=input('enter zigzag number to jump to:  ');
        j=max(1,j);
    elseif(inp==1)
        bad=input('enter zig zag/loop number to be declared bad (or good if already bad):  ');
        if(bad==0)
            for i=is
                if(zigzag(i).good==0) zigzag(i).good=1;
                else zigzag(i).good=0;
                end
            end
        else
            if(zigzag(is(bad)).good==0) zigzag(is(bad)).good=1;
            else zigzag(is(bad)).good=0;
            end
        end
    elseif(inp==2) 
        j=max(1,j-1);
        for i=2:length(is) close(hs(i)); end;
    else
        for i=2:length(is) close(hs(i)); end;
        zz=GetZigZag(f,athresh,NestArc);
        zigzag=[zigzag(1:j-1) zz zigzag((j+length(is)):end)];
%         l=length(zz);
%         j=j+l;
    end
    save(OutFn,'zigzag');
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
        title('section marked bad')
    else
        plot(Cents(iall,1),Cents(iall,2),'r')
        if(length(iall)>2)
            [area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
            sp=Cents(iall(end),:);
            c=mean(Cents(iall,:));
            angs=mod(angles-compassDir,2*pi);
            dang=AngularDifference(angs(1),Cent_Os(iall))*180/pi;
            zigs=iall(find(dang<-athresh));
            zags=iall(find(dang>=athresh));
            [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,Cents);
            [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,Cents);

            plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'ko','MarkerFaceColor','k')
            plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'ro','MarkerFaceColor','r')
            PlotAngLine(angles,c);
            text(Cents(iall(1),1),Cents(iall(1),2),'Start')
            text(Cents(iall(end),1),Cents(iall(end),2),'End','Color','r')
        end
            
        if(isempty(zz(i).zz)) tstr=['unassigned'];
        elseif(zz(i).zz==1) tstr=['zigzag'];
        elseif(zz(i).zz==0) tstr=['crenellation'];
        else tstr=['neither'];
        end    
        title(['Loop ' int2str(i) '. Currently ' tstr])
    end

    axis equal
    hold off
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
    inp=input('Type 0 if ok; 1 if file is bad; u to go back one file; r to redo the file; c to quit; j to jump to another bit:  ','s');
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
    elseif(isequal(inp,'c'))
        fla=4;
        break;
    elseif(isequal(inp,'j'))
        fla=5;
        break;
    end
end

function PlotAngLine(angs,c)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',xs([2 4]),ys([2 4]),'g')