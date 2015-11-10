% function GetNestAndLMData(f)
%
% function to interactively get position of nest and landmark in file f
% (entered as a string without the .avi extension)
%
% Allows picking to initialise from a previous file
%
% USAGE:
%
% eg:   GetNestAndLMData('90_21_out10')

function[fn,rep] = GetNestAndLMData(f)

rep=-1;
fn=[f 'NestLMData.mat'];
ff=[f '.avi'];
[avf,lastframe]=MyAviInfo(ff);
%AxX=[400 1000 300 700];
AxX=[100 900 100 800];% 400 900 300 800];
% AxX=axis;
if(isfile(fn))
    load(fn)
    im=MyAviRead(ff,refim,1);
    imagesc(im);
    PlotStuff(im,nest,LM,NestWid,LMWid,AxX);
    inp=input(['File ' fn ' already exists. Type 0 to overwrite']);    
    if(isempty(inp)||(inp~=0)) 
        rep=1;
        return; 
    end;
end
if(isempty(strfind(f,'out'))) c=1;
else c=lastframe;
end
FirstTime=1;
while 1
    im=MyAviRead(ff,c,1);
    imagesc(im);
    title(fn)
%     axis(AxX); 
    axis equal;
    xlabel(['Frame ' int2str(c) ' out of ' int2str(lastframe)])
    a=input('return if no bee, frame number; negative to redo:  ');
    if(isempty(a)) break;
    elseif(a>0) c=a;
    elseif(FirstTime)
        c=lastframe;
        FirstTime=0;
    else c=mod(c+10,lastframe)
    end
end
refim=c;

% Initialise
Picked=PickFileFromList('*NestLMData.mat');
imagesc(im);
% axis(AxX);
AxX=axis;
axis equal;
if(ischar(Picked)) 
    load(Picked);
    refim=c;
else
    title('Click centre of nest then 4 points for width estimates')
    [x,y]=ginput(5);
    X=[x y];
    nest=X(1,:);
    ds=diff(X);
    d=sqrt(sum(ds.^2,2));
    NestWid=mean(d([2 4]));
    title('Click centre of LMs then 4 points for width estimates')
    [x,y]=ginput;
    X=[x y];
    ds=diff(X);
    d=sqrt(sum(ds.^2,2));
    LM=X(1:5:end,:);
    LMWid=[];
    k=2;
    while(k<length(x))
        LMWid=[LMWid;mean(d([k k+2]))];
        k=k+5;
    end
end

while 1
    PlotStuff(im,nest,LM,NestWid,LMWid,AxX);
    xlabel('return to finish; r rescale; a change axis')
    pts=[nest;LM];
    ptWid=[NestWid;LMWid];
    [adj,b]=GetNearestClickedPt(pts);
    if(adj==0) break;
    elseif(b==97)
            axis auto
            axis equal
%         while 1
%             AxX=input('pick new axes format [x1 x2 y1 y2]');
%             if(isequal(size(AxX),[1 4])) break; end;
%         end        
    elseif(b==97)
    else
        [pts(adj,:),ptWid(adj)]=GetNewPoint(pts(adj,:),ptWid(adj));
%         [pts(adj,:),ptWid(adj)]=GetNewPointOld(pts(adj,:),ptWid(adj));
    end;
    nest=pts(1,:);LM=pts(2:end,:);
    NestWid=ptWid(1);LMWid=ptWid(2:end);
    save(fn,'nest','LM','LMWid','NestWid','refim')
end
save(fn,'nest','LM','LMWid','NestWid','refim')

function[p,pw]=GetNewPoint(p,pw)
mm=4;
mma=25;
pwadd=1;
a1=p-max(mm*pw,mma);
a2=p+max(mm*pw,mma);
axis([a1(1) a2(1) a1(2) a2(2)])
hold on;
h=[];
while 1
    title('click new pt; arrows change radius; return end')
    [x,y,b]=ginput(1);
    if(isempty(x))
        delete(h);
        break;
    elseif(b==30)
        pw=pw+pwadd;
    elseif(b==31)
        pw=max(pw-pwadd,1);
    else
        p=[x y];
    end
    delete(h);
    h=MyCircle(p,pw/2,'b');
    a1=p-max(mm*pw,mma);
    a2=p+max(mm*pw,mma);
    axis([a1(1) a2(1) a1(2) a2(2)])
end
hold off;


function[p,pw]=GetNewPointOld(p,pw)
disp('may need debugging. See GetNewPoint')

mm=4;
mma=25;
a1=p-max(mm*pw,mma);
a2=p+max(mm*pw,mma);
axis([a1(1) a2(1) a1(2) a2(2)])
hold on;
h=[];
while 1
    disp(['Current point is (x,y,wid): ' num2str(p(1,1),4) ' ' num2str(p(1,2),4) ' ' num2str(pw,4)])
    inp =input('Enter new point [x,y,wid] or return : ');
    if(~isequal(size(inp),[1 3]))
        delete(h);
        break;
    end
    p=inp([1 2]);
    pw=inp(3);
    delete(h);
    h=MyCircle(p,pw/2,'b');
    a1=p-max(mm*pw,mma);
    a2=p+max(mm*pw,mma);
    axis([a1(1) a2(1) a1(2) a2(2)])
end
hold off;


function PlotStuff(im,nest,LM,NestWid,LMWid,AxX)
imagesc(im);
axis(AxX);
axis equal;
title('Order: nest; LM; nest width, LM width')
hold on;
plot(nest(1),nest(2),'gx')
MyCircle(nest,NestWid/2,'g');
plot(LM(:,1),LM(:,2),'rx')
MyCircle(LM,LMWid/2,'r');
hold off;