% function ShadowDirections
%
% function to interactively get shdow direction from all files in directory
% directions appended to *All file and also to ShadowDirections.mat

function ShadowDirections(fn)

if(nargin<1) fn=[]; end;
s=dir(['*' fn '*.avi']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers:   ');
if(isempty(Picked)) s=s;
else s=s(Picked);
end

is=[1:length(s)];
for j=is
    ShadowDirs(j).fn=s(j).name(1:end-4);
    ShadowDirs(j).dir=GetShadowDir(ShadowDirs(j).fn)*180/pi;
    ShadowDirs(j).out= [ShadowDirs(j).fn '   ' int2str(ShadowDirs(j).dir)];
end
ShadowDirs.out
fn=input('enter filename to save data in; return to skip:   ','s');
if(~isempty(fn)) save(fn,'ShadowDirs'); end



function[ShadowDir]=GetShadowDir(f);

% fn=[f 'All.mat'];

ff=[f '.avi'];
% Initialise
im=MyAviRead(ff,1,1);
% load(fn);
% sp=LMs(1).LM;
s=dir('*Calib.mat');
if(isempty(s)) compassDir=4.9393; 
else load(s(1).name);
end;
w=250;
imagesc(im);
hold on
title('Click the start point of the shadow (closest to the object);')
x=[];
while(isempty(x)) [x,y]=ginput(1); end
sp=[x y];
plot(sp(1),sp(2),'rx')
axis equal;
colormap gray;
% axis(AxX);
title('Click the end of the shadow; return if no shadow;')
hold off;
[x,y]=ginput(1);
if(isempty(x)) ShadowDir=NaN;
else
    p2=[x y];
    while 1
        d=p2-sp;
        th=cart2pol(d(1),d(2));
        ShadowDir=AngularDifference(th,compassDir);
        imagesc(im);
        hold on
        xlabel(['angle = ' int2str(round(ShadowDir*180/pi))])
        plot([sp(1) p2(1)],[sp(2) p2(2)],'r',sp(1),sp(2),'ro',p2(1),p2(2),'rv')
        axis equal;
        colormap gray;
        AxAboutPts([sp;p2],w);
        [adj,b,p,q]=GetNearestClickedPt([sp;p2],'Click near any point to select; return to end');
        hold off
        if(adj==0) break;
        elseif(adj==1) sp=[p q];
        else p2=[p q];
        end;
    end
end
% save(fn,'ShadowDir','-append');