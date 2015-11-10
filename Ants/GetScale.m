% function GetScale(f)
%
% function to interactively get scale from file f
% (entered as a string without the .avi extension)
%
% Allows picking to initialise from a previous file
%
% USAGE:
%
% eg:   GetScale('90_21_out10')

function[fn] = GetScale(f,Picked)

fn=[f 'Scale.mat'];

ff=[f '.avi'];
AxX=[400 1000 300 700];
im=MyAviRead(ff,1,1);
imagesc(im);
axis(AxX);
axis equal;
title(fn)
if(isfile(fn))
    load(fn)
    PlotStuff(im,nest,LMBs,LM,LMWid,AxX);
    inp=input(['File ' fn ' already exists. Type 0 to overwrite']);    
    if(isempty(inp)|(inp~=0)) return; end;
end

% Initialise
if(nargin<2) Picked=PickFileFromList('*Scale.mat'); end;
if(ischar(Picked)) load(Picked);
else
    title('Click nest then for each LM (starting with N)')
    xlabel('base, centre of LM then 4 points for widths')
    [x,y]=ginput;
    X=[x y];
    nest=X(1,:);
    LMBs=X(2:6:end,:);
    LM=X(3:6:end,:);
    ds=diff(X);
    d=sqrt(sum(ds.^2,2));
    LMWid=[];
    k=4;
    while(k<length(x))
        LMWid=[LMWid;mean(d([k k+2]))];
        k=k+6;
    end
end

while 1
    hdls=PlotStuff(im,nest,LMBs,LM,LMWid,AxX);
    xlabel('press return to finish. right click to change axis')
    pts=[nest;LMBs;LM];
    nLM=length(LMWid);
    ptWid=[12.5*ones(nLM+1,1);LMWid];
    [adj,b]=GetNearestClickedPt(pts)
    if(adj==0) % break;
    elseif(b==3)
        break;
        while 1
            AxX=input('pick new axes format [x1 x2 y1 y2]');
            if(isequal(size(AxX),[1 4])) break; end;
        end        
    else
        a1=pts(adj,:)-max(2*ptWid(adj),25);
        a2=pts(adj,:)+max(2*ptWid(adj),25);
        axis([a1(1) a2(1) a1(2) a2(2)])
%         delete(hdls)
        hdl=[];
        while 1
            disp(['Current point is (x,y,wid): ' num2str(pts(adj,1),4) ' ' num2str(pts(adj,2),4) ' ' num2str((ptWid(adj)),4)])
            if(adj<(nLM+2)) 
                [x y]=ginput(1);
                inp=[x y];
            else 
                inp =input('Enter new point [x,y,wid] or return : ');
            end
            if(isempty(inp)) break; end
            delete(hdl)
            pts(adj,:)=inp([1 2]);
            hold on;
            if(adj>(1+nLM)) 
                ptWid(adj)=inp(3);
                hdl=MyCircle(pts(adj,:),ptWid(adj)/2,'b');
            else hdl=plot(pts(adj,1),pts(adj,2),'b.');
            end
            hold off;
        end
    end;
    nest=pts(1,:);LMBs=pts(2:nLM+1,:);LM=pts(nLM+2:end,:);
    LMWid=ptWid(nLM+2:end);
    save(fn,'nest','LMBs','LM','LMWid')
end
save(fn,'nest','LMBs','LM','LMWid')
while(1)
    a=input('input 1 to continue\n');
    if(a==1) break; end;
end

function[hdls]=PlotStuff(im,nest,LMBs,LM,LMWid,AxX)
imagesc(im);
axis(AxX);
axis equal;
hold on;
h1=plot([nest(1) LMBs(1,1)],[nest(2) LMBs(1,2)],'g-x');
h2=plot([nest(1) LMBs(2,1)],[nest(2) LMBs(2,2)],'g-x');
h3=MyCircle(LM,LMWid/2,'r');
hdls=[h1 h2 h3];
hold off;