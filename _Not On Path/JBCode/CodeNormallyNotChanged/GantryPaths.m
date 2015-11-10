function GantryPaths(n,is,fs)
dwork
cd ../Current/Linc/results
if(nargin<2) is=1:8; end;

if(nargin==3) 
    PlotSimplePaths(fs); 
    return;
end;
ds={'north';'northeast';'east';'southeast';'south';'southwest';'west';'northwest'};

FirstTime=1;
for i=1:size(is,1)
    if(ischar(is(i,:))) 
        d=is(i,:);
%         fs=[d '/' d];
         fs=['longrun/longrun_' d];
        os=fs;
    else
        d=['enviro' int2str(n)];
%         d=['AD'];
%         d=['occlusion'];
        os=[d '/' d];
        fs=[os  '_' char(ds(is(i)))];
%         fs=[os  '_' int2str(is(i))]
    end
    [lPos,lALV,lWPts] = ParseFile([fs '_learn.txt']);
     [nPos,nALV,nWPts] = ParseFile([fs '_nav.txt']);
%    [lPos,lALV,lWPts] = ParseFile(['AD/AD_learn.txt']);

%     starts(i,:)=nPos(1,:)
%     goal=lPos(end,:);
%     save([os '_objects.mat'],'starts','goal','-append')

    load([os '_objects.mat']);
    
    if(FirstTime)
        figure(1)
        DrawEnvironment(obj,[goal 75]);
        hold on; plot(starts(:,1),starts(:,2),'k*');
        figure(2)
        DrawEnvironment(obj,[goal 75]);
        hold on; plot(starts(:,1),starts(:,2),'k*');
        FirstTime=0;
    end

    figure(1)
    plot(lWPts(:,2),lWPts(:,3),'gs')
    plot(lPos(:,1),lPos(:,2),'c:')
    plot(nWPts(:,2),nWPts(:,3),'rx')
    plot(nPos(:,1),nPos(:,2))
    
    figure(2)
    [aPos,aALV,aWPts] = ParseFile([fs '_alv_nav.txt']);
    plot(aPos(:,1),aPos(:,2))
    plot(aWPts(:,2),aWPts(:,3),'rx')
end
figure(1)
hold off; axis tight; axis equal;xs=axis;
figure(2)
hold off; axis tight; axis equal
if(isequal(d,'circle')) axis(xs); end;
if(isequal(d,'barrier')) 
    figure(1);
    hold on; plot(barrier(:,1),barrier(:,2),'r','LineWidth',3); hold off;
    figure(2);
    hold on; plot(barrier(:,1),barrier(:,2),'r','LineWidth',3); hold off;
end;

function PlotSimplePaths(fs)

cd singleruns
% DrawEnvironment(obj,[goal 75]);
hold on; 
fn=fs(1).name;
[Pos,ALV,WPts] = ParseFile([fn(1:3) 'learn.txt']);
plot(WPts(:,2),WPts(:,3),'gs')
plot(Pos(:,1),Pos(:,2),'c:')

for i=1:length(fs)
    [Pos,ALV,WPts] = ParseFile(fs(i).name);
    starts(i,:)=Pos(1,:);
    plot(WPts(:,2),WPts(:,3),'rx')
    plot(Pos(:,1),Pos(:,2))
end
plot(starts(:,1),starts(:,2),'k*');
hold off; axis tight; axis equal


function[Pos,ALV,WPts]=ParseFile(fn)
h=dlmread(fn);
x=h(:,1);
y=h(:,2);
Pos=[x y];
alvCurrentx=h(:,3);
alvCurrenty=h(:,4);
ALV=[alvCurrentx alvCurrenty];
WayPtx=h(:,5);
WayPty=h(:,6);
visibleLandmarks=h(:,7);

ichange=find(diff(visibleLandmarks));
WPts=[ichange Pos(ichange,:) visibleLandmarks(ichange) ALV(ichange,:)];

rawMoveVectorx=h(:,8);
rawMoveVectory=h(:,9);
moveVectorPreviousx=h(:,10);
moveVectorPreviousy=h(:,11);
sigma=h(:,12);
moveVectorx=h(:,13);
moveVectory=h(:,14);
im1=h(:,15:104);
im2=h(:,105:194);
im3=h(:,195:end);