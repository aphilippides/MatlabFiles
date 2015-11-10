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

function[fn] = GetNestAndLMData(f)

fn=[f 'NestLMData.mat'];

ff=[f '.MOV'];
[avf,lastframe]=MyAviInfo(ff);
%AxX=[400 1000 300 700];
AxX=[400 900 300 800];
if(isfile(fn))
    load(fn)
    im=MyAviRead(ff,refim,1);
    imagesc(im);
    PlotStuff(im,nest,LM,NestWid,LMWid,AxX);
    inp=input(['File ' fn ' already exists. Type 0 to overwrite']);    
    if(isempty(inp)|(inp~=0)) return; end;
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
    a=input('press return if no bee, a number to go to that value or negative to-re-do:   ');
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
axis equal;
if(ischar(Picked)) 
    load(Picked);
    refim=c;
else
    title('Click centre of point then 4 points for width estimates')
    xlabel('Order: Nest then LMs')
    [x,y]=ginput;
    X=[x y];
    nest=X(1,:);
    ds=diff(X);
    d=sqrt(sum(ds.^2,2));
    NestWid=mean(d([2 4]));
    LM=X(6:5:end,:);
    LMWid=[];
    k=7;
    while(k<length(x))
        LMWid=[LMWid;mean(d([k k+2]))];
        k=k+5;
    end
end

while 1
    PlotStuff(im,nest,LM,NestWid,LMWid,AxX);
    xlabel('press return to finish. right click to change axis')
    pts=[nest;LM];
    ptWid=[NestWid;LMWid];
    [adj,b,newx,newy]=GetNearestClickedPt(pts)
    if(adj==0) break;
    elseif(b==3)
        while 1
            AxX=input('pick new axes format [x1 x2 y1 y2]');
            if(isequal(size(AxX),[1 4])) break; end;
        end        
    else
        a1=pts(adj,:)-max(4*ptWid(adj),25);
        a2=pts(adj,:)+max(4*ptWid(adj),25);
        axis([a1(1) a2(1) a1(2) a2(2)])
            pts(adj,:)=[newx,newy];%inp([1 2]);
%         while 1
%             disp(['Current point is (x,y,wid): ' num2str(pts(adj,1),4) ' ' num2str(pts(adj,2),4) ' ' num2str((ptWid(adj)),4)])
% %             inp =input('Enter new point [x,y,wid] or return : ');
%             if(~isequal(size(inp),[1 3])) break; end
% %             ptWid(adj)=inp(3);
%             hold on; MyCircle(pts(adj,:),ptWid(adj)/2,'b'); hold off;
%         end
    end;
    nest=pts(1,:);LM=pts(2:end,:);
    NestWid=ptWid(1);LMWid=ptWid(2:end);
    save(fn,'nest','LM','LMWid','NestWid','refim')
end
save(fn,'nest','LM','LMWid','NestWid','refim')

function PlotStuff(im,nest,LM,NestWid,LMWid,AxX)
imagesc(im);
% axis(AxX);
axis equal;
title('Order: nest; LM; nest width, LM width')
hold on;
plot(nest(1),nest(2),'gx')
MyCircle(nest,NestWid/2,'g');
plot(LM(:,1),LM(:,2),'rx')
MyCircle(LM,LMWid/2,'r');
hold off;