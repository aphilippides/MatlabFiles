% function[fn] = Calibration(f)
%
% function to interactively get scale and N direction from file f
% (entered as a string without the .avi extension)
%
% USAGE:
%
% eg:   Calibration('90_21_out10')

function[fn] = Calibration(f)

fn=[f 'Calib.mat'];

ff=[f '.avi'];
% Initialise
im=MyAviRead(ff,1,1);
imagesc(im);
% axis(AxX);
axis equal;
colormap gray;
title('Click each end of the ruler, then the compass, S to N')
[x,y]=ginput(4);
pts=[x y];

while 1
    minx=min(pts)*0.75;
    maxx=max(pts)*1.25;
    AxX=[minx(1) maxx(1) minx(2) maxx(2)];
    PlotStuff(im,pts,AxX);
    title('Click near a point to zoom in on it')
    xlabel('press return to finish. right click to change axis')
    [adj,b]=GetNearestClickedPt(pts);
    if(adj==0) break;
    elseif(b==3)
        while 1
            AxX=input('pick new axes format [x1 x2 y1 y2]');
            if(isequal(size(AxX),[1 4])) break; end;
        end
    else
        while 1
            a1=pts(adj,:)-50;%max(4*ptWid(adj),25);
            a2=pts(adj,:)+50;%max(4*ptWid(adj),25);
            AxSm=[a1(1) a2(1) a1(2) a2(2)];
            PlotStuff(im,pts,AxSm);
            xlabel(['Click new point; return to zoom out'])
            inp=ginput(1);
            if(~isequal(size(inp),[1 2])) break; end
            pts(adj,:)=inp;
        end
    end;
    ruler=pts([1 2],:);
    compassPts=pts([1 2],:);
    ds=diff(pts);
    rlen=sqrt(sum(ds(1,:).^2,2));
    compassDir=cart2pol(ds(3,1),ds(3,2));
    save(fn,'ruler','compassPts','rlen','compassDir')
end
% while 1
%     inp=input('type 0 to continue:  ');
%     if(inp==0) break; end;
% end
while 1
    numCm=input('enter length of ruler clicked:   ');
    if(~isempty(numCm)&isfloat(numCm)) break; end;
end
ruler=pts([1 2],:);
compassPts=pts([1 2],:);
ds=diff(pts);
rlen=sqrt(sum(ds(1,:).^2,2));
compassDir=cart2pol(ds(3,1),ds(3,2));
cmPerPix=numCm/rlen;
save(fn,'ruler','compassPts','rlen','compassDir','numCm','cmPerPix')

function PlotStuff(im,pts,AxX)
imagesc(im);
hold on;
plot(pts([1 2],1),pts([1 2],2),'b',pts([3 4],1),pts([3 4],2),'r','LineWidth',2)
text(pts(1,1)*0.9,pts(1,2)*0.9,'Ruler','Color','b','FontSize',14)
text(pts(3,1)*0.9,pts(3,2)*0.9,'South','Color','r','FontSize',14)
text(pts(4,1)*0.9,pts(4,2)*0.9,'North','Color','r','FontSize',14)
axis(AxX);
hold off;