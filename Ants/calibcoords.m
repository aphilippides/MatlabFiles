function calibcoords(s)%,vO)

% dwork;
% cd Bees\bees12\

if(nargin<1) 
    s=dir('Cal*.avi');
end
is=1:length(s);
if(isempty(is))
    return;
end
disp(' ');
Check=input('enter 1 to check the calibration files: ');
for j=is
    f=s(j).name;
    lmn=GetCalibData(f,Check);%,vO);
%     while 1
%         inp=input('type 0 to continue: ');
%         if(inp==0);
%             break;
%         end;
%     end
end


function[fn] = GetCalibData(ff,Check)

hold off
fn=[ff(1:end-4) 'CalData.mat'];
rul=zeros(2)*NaN;
comp=rul;
compassDir=NaN;
cmPerPix=NaN;
if(isfile(fn))
    if(isequal(Check,1))
        load(fn)
        [inp,rul,comp,cmPerPix,compassDir]=AdjustCal(rul,comp,calibim,cmPerPix,compassDir,fn,0);
        if(isequal(inp,0))
            return;
        end
    else
        return;
    end
%     inp=input(['File ' fn ' already exists. Type 0 to overwrite:  ']);
%     if(isempty(inp)||(inp~=0)); return; end;
end
rul=zeros(2)*NaN;
comp=rul;
compassDir=NaN;
cmPerPix=NaN;

hold off;
% Initialise
[vO,vObj]=VideoReaderType(ff);
calibim=MyAviRead(ff,1,vObj);
    
imagesc(calibim);
axis equal;
ax=axis;
hold on;

% Ruler
axl=50;
for i=1:2
    axis(ax);
    if(i==1); title('Click North end of the ruler');
    else title('Click 10 cm away');
    end
    [x,y]=ginput(1);
    h=PlotStuff(rul,comp);
    while 1
        axis([x-axl,x+axl,y-axl,y+axl])
        xlabel('adjust till good; return if ok')
        [x,y]=ginput(1);
        if(isempty(x))
            delete(h);
            break;
        end
        delete(h);
        rul(i,:)=[x y];
        h=PlotStuff(rul,comp);
    end
end
d=CartDist(rul(1,:),rul(2,:));
comp=rul([2 1],:);
cmPerPix=10/d;
% d*cmPerPix;
SepComp=0;
save(fn,'calibim','rul','comp','cmPerPix','compassDir','SepComp')
hold off
h1=PlotStuff(rul,comp,calibim,cmPerPix,compassDir);
hold on

SepComp=input('enter -1 to do the compass separately');
if(isequal(SepComp,-1))
    % get compass
    axl=75;
    for i=1:2
        axis(ax);
        if(i==1); title('Click S end of the compass');
        else title('Click N end of the compass');
        end
        [x,y]=ginput(1);
        h=PlotStuff(rul,comp);
        while 1
            axis([x-axl,x+axl,y-axl,y+axl])
            xlabel('adjust till good; return if ok')
            [x,y]=ginput(1);
            if(isempty(x))
                delete(h);
                break;
            end
            delete(h);
            comp(i,:)=[x y];
            h=PlotStuff(rul,comp);
        end
    end
else
    SepComp=0;
end
d=comp(2,:)-comp(1,:);
compassDir=cart2pol(d(1),d(2));
save(fn,'calibim','rul','comp','cmPerPix','compassDir','SepComp')
hold off
[rul,comp,cmPerPix,compassDir]=AdjustCal(rul,comp,calibim,cmPerPix,...
    compassDir,fn,SepComp);

function[inp,rul,comp,cmPerPix,compassDir]=...
    AdjustCal(rul,comp,calibim,cmPerPix,compassDir,fn,SepComp)

disp('adjust points by clicking in figure window. return in figure window to end')
inp=1;
axL=50;
while 1
    h1=PlotStuff(rul,comp,calibim,cmPerPix,compassDir);
    tst='click near point to move; o overwrite; return when done';
    if(isequal(SepComp,-1))
        % if ruler is differemt to compass
        pts=[rul;comp];
    else
        pts=rul;
    end
    [adj,b,c,d]=GetNearestClickedPt(pts,tst);
    if(isequal(d,111))
        break;
    elseif(adj==0) 
        % if all is ok
        inp=0;
        break;  
    else
        pts(adj,:)=[c d];
        if(isequal(SepComp,-1))
            % if ruler is differemt to compass
            PlotStuff(pts(1:2,:),pts(3:4,:),calibim,cmPerPix,compassDir);
        else
            PlotStuff(pts(1:2,:),pts([2 1],:),calibim,cmPerPix,compassDir);
        end
        a1=pts(adj,:)-axL;
        a2=pts(adj,:)+axL;
        axis([a1(1) a2(1) a1(2) a2(2)])
        while 1
            xlabel('adjust till good; return if ok')
            [x,y]=ginput(1);
            if(isempty(x))
                break;
            end
            pts(adj,:)=[x y];
            if(isequal(SepComp,-1))
                % if ruler is differemt to compass
                PlotStuff(pts(1:2,:),pts(3:4,:),calibim,cmPerPix,compassDir);
            else
                PlotStuff(pts(1:2,:),pts([2 1],:),calibim,cmPerPix,compassDir);
            end
            axis([x-axL,x+axL,y-axL,y+axL])
        end
    end;
    rul=pts(1:2,:);
    d=CartDist(rul(1,:),rul(2,:));
    cmPerPix=10/d;
    if(isequal(SepComp,-1))
        % if ruler is differemt to compass
        comp=pts(3:4,:);
    else
        comp=pts([2 1],:);
    end
    d=comp(2,:)-comp(1,:);
    compassDir=cart2pol(d(1),d(2));
    save(fn,'calibim','rul','comp','cmPerPix','compassDir','SepComp')
end

function[h,axo]=PlotStuff(rul,comp,calibim,cmPerPix,compassDir)
axL=75;
isho=ishold(gca);
if((nargin>2)&&(~isempty(calibim)))
    imagesc(calibim);
    axis equal;
    hold on
end
h=plot(rul(:,1),rul(:,2),'r-x',...
    comp(:,1),comp(:,2),'g-',comp(1,1),comp(1,2),'go',comp(2,1),comp(2,2),'gd',...
    'LineWidth',1.5,'MarkerSize',10);
mi=max(min([rul;comp])-axL,1);
ma=max([rul;comp])+axL;
ax=[mi(1) ma(1) mi(2) ma(2)];
if(sum(isnan(ax))==0)
    axis(ax);
end
if((nargin>3)&&(sum(isnan([cmPerPix,compassDir]))==0))
    CompassAndLine('w',cmPerPix,[],compassDir);
end
axo=ax;
if(~isho)
    hold off;
end


% function PlotStuff(im,nest,LM,NestWid,LMWid,AxX)
% imagesc(im);
% axis(AxX);
% axis equal;
% title('Order: nest; LM; nest width, LM width')
% hold on;
% plot(nest(1),nest(2),'gx')
% MyCircle(nest,NestWid/2,'g');
% plot(LM(:,1),LM(:,2),'rx')
% MyCircle(LM,LMWid/2,'r');
% hold off;