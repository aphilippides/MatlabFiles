function[newf, c, a, bound, WirePts,XPt,minXPt,CrossPt,LoopAx,LoopBound,WireBound,COff]=GetLoop(f,im,t)

fopp=imcomplement(f);       %reverse image
if(nargin<3) t=graythresh(fopp); end;   % Get threshold: will do adaptive later
bw=im2bw(fopp,t);
% bw=im2bw(fopp,graythresh(fopp));
x=bwlabel(bw);
rprops=regionprops(x,'Area');
as=[rprops.Area];
[m,i]=max(as);
[r,c]=find(x==i);
bwloop=bwselect(bw,c(1),r(1));

bwloopfill=imfill(bwloop,'holes');
[newf,CutPt]=RemoveEdge(bwloopfill);
[WirePts,XPt,minXPt,CrossPt,LoopEnd]=GetWireStats(newf,CutPt,t);
d=bwlabel(newf);
dum=regionprops(d,'Centroid','Area','BoundingBox');
c=[dum.Centroid];
a=[dum.Area];
bbox=[dum.BoundingBox];
p=bwboundaries(newf,'noholes');
bound=p{1};
for i=1:size(bound,1)
    count=1;
    if(bound(i,2)<minXPt(2,1)) 
        lengths(count)=VecNorm(minXPt(2,:)-invert(bound(i,:)));
        inds(count)=i;
        count=count+1;
    end
end
[EndLength,ind]=max(lengths);
LoopAx=[minXPt(2,:);invert(bound(inds(ind),:))];
% Get cutoff boundary
COff=LoopEnd(2,:);
rLoopEnd=round(LoopEnd);
is=find(bound(:,2)==rLoopEnd(1,1));
[m,i1]=min(abs(bound(is,1)-rLoopEnd(1,2)));
CPt1=is(i1);
is=find(bound(:,2)==rLoopEnd(3,1));
[m,i2]=min(abs(bound(is,1)-rLoopEnd(3,2)));
CPt2=is(i2);
if(CPt2<CPt1) temp=CPt1; CPt1=CPt2; CPt2=temp; end;
if(bound(CPt1,2)<bound(CPt1+1,2))
    WireBound=[bound(CPt1:CPt2,:); bound(CPt1,:)];
    LoopBound=[bound(1:CPt1,:); bound(CPt1,:); bound(CPt2:end,:)];
else
    LoopBound=[bound(CPt1:CPt2,:); bound(CPt1,:)];
    WireBound=[bound(1:CPt1,:); bound(CPt1,:); bound(CPt2:end,:)];
end
if(im)
    imshow(fopp,'notruesize');
    hold on; plot(c(:,1),c(:,2),'gx'); hold off;
    hold on; plot(WireBound(:,2),WireBound(:,1),'LineWidth',0.5); 
    plot(CrossPt(1),CrossPt(2),'g *')
    plot(minXPt(:,1),minXPt(:,2),'r- x') 
    plot(XPt(:,1),XPt(:,2),'r- x')
    plot(WirePts(:,1),WirePts(:,2),'b-x')
    plot(LoopAx(:,1),LoopAx(:,2),'g-x')
    plot(LoopBound(:,2),LoopBound(:,1),'y-','LineWidth',0.5)
    hold off;
end
%figure, imshow(bw,'notruesize');

function[newf,CutWidth]=RemoveEdge(f)
if(sum(sum(f(1:3,end-3:end)))|sum(sum(f(end-3:end,end-3:end))))
    % get widths of bits connected to the side wall
    rows=find(f(:,end));
    for i=1:length(rows)
        width=0;
        val=size(f,2);
        while(f(rows(i),val))
            width=width+1;
            val=val-1;
        end
        widths(i)=width;
    end
    % get cut off point and make a cut
    [m,c]=min(widths(1:end-5));
    w=widths(c:end-5);
    overs=find(w>2*m);
    c_off=min(overs)+c;
    CutWidth=widths(c_off);
    f(rows(c_off-1),end-widths(c_off-1)+1:end)=0;
    % get rid of the bit not wanted
    d=bwlabel(f);
    dum=regionprops(d,'Area');
    as=[dum.Area];
    [m,i]=max(as);
    [r,c]=find(d==i);
    newf=bwselect(f,c(1),r(1));
    % find approx gradient of widths and get some white stuff
    g=0.1*mean(widths(c_off+10:c_off+13)-widths(c_off:c_off+3));
    for i=1:ceil(CutWidth/g)
        newf(rows(c_off)-i,end-round(CutWidth-i*g)+1:end)=1;
    end
else
    newf=f;
    CutWidth=0;
end

function[WirePts,XPt,minXPt,CrossPt,LoopEnd]=GetWireStats(f,CutPt,fn)
ws=sum(f);
nonz=find(ws);
h=fspecial('average',[1 5]);
sws=imfilter(ws(nonz),h,'replicate');
mids=[];
for i=nonz; mids=[mids; i mean(find(f(:,i)))]; end;
[m,wide]=max(sws);
[m,thin]=min(sws(wide:end-CutPt));
vec=[thin+wide:length(sws)-CutPt];
% imshow(f),hold on,scatter(mids(:,1),mids(:,2),'gx');
[p,s]=polyfit(mids(vec,1),mids(vec,2),1);
[y,errs]=polyval(p,nonz,s);
for i=1:length(nonz)
    if(f(round(y(i)), nonz(i))) 
        StartPt=[nonz(i) y(i)];
        break;
    end
end
% Get main axis
ThinPt=[mids(thin+wide,1),mids(thin+wide,2)];
EndPt=[nonz(end) y(end)];
WirePts=[StartPt;ThinPt;EndPt];
% Get other axis
th=atan(-p(1))*180/pi;
[r,xp]=radon(f,th);
r=imfilter(r',h,'replicate');
% Get max width pt
[m,i]=max(r);
cent=invert(ceil(size(f)/2));
c1=cent(2)-cent(1)*p(1);
t=atan(p(1));
sx=cent+[cos(t) sin(t)]*xp(i);
m2=-1/p(1);
c2=sx(2)-sx(1)*m2;
%Get end points and MidPt
ys=[m2 c2]*[1 size(f,2);1 1];
[cx,cy,c]=improfile(f,[1 size(f,2)],ys);
is=find(c==1);
xy=mean([cx(is(1)) cy(is(1));cx(is(end)) cy(is(end))]);
XPt=[cx(is(1)) cy(is(1));xy;cx(is(end)) cy(is(end))];
% Get point where they cross
CrossPt=[-p(1) 1;-m2 1]\[p(2);c2];
% get thinnest crossing
ds=ceil(size(f,2)/2)+cos(t)*xp;
if(p(1)<0) npt=[size(f,2) max(find(f(:,size(f,2))))];
else npt=[size(f,2) min(find(f(:,size(f,2))))];
end
c3=npt(2)-npt(1)*m2;
cpt=[-p(1) 1;-m2 1]\[c1;c3];
l=max(find(ds<cpt(1)));
newr=r(i:l);
[n,j]=min(newr);
minx=cent+[cos(t) sin(t)]*xp(i+j-1);
c4=minx(2)-minx(1)*m2;
ys=[m2 c4]*[1 size(f,2);1 1];
[cx,cy,c]=improfile(f,[1 size(f,2)],ys);
is=find(c==1);
minxy=mean([cx(is(1)) cy(is(1));cx(is(end)) cy(is(end))]);
minXPt=[cx(is(1)) cy(is(1));minxy;cx(is(end)) cy(is(end))];
% Get WireEndPt
[ma,mi]=findextrema(r);
EndWidth=r(floor(ma(end)));
[m,j]=max(r);
LoopEndPt=min(find(r(i+1:end)<EndWidth))+j;
sx=cent+[cos(t) sin(t)]*xp(LoopEndPt); % actual x and y
c2=sx(2)-sx(1)*m2;  % calc line
ys=[m2 c2]*[1 size(f,2);1 1];
[cx,cy,c]=improfile(f,[1 size(f,2)],ys);  % calc improfile across the line
is=find(c==1);
xy=mean([cx(is(1)) cy(is(1));cx(is(end)) cy(is(end))]);
LoopEnd=[cx(is(1)) cy(is(1));xy;cx(is(end)) cy(is(end))];

% filen=[fn(1:end-4) 'Widths.mat'];
% save(filen,'ws','sws','r');
% figure,imshow(f),hold on
% plot(CrossPt(1),CrossPt(2),'g *')
% plot(minXPt(:,1),minXPt(:,2),'r- x') 
% plot(XPt(:,1),XPt(:,2),'r- x')
% plot(WirePts(:,1),WirePts(:,2),'b-x')
% plot(LoopEnd(:,1),LoopEnd(:,2),'y-x')
