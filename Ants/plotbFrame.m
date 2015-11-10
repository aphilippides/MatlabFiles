function plotbFrame(fn,i,FrameNum,vObj,c1,e1,ell,tstr,col)
if(nargin<9)
    col='r';
end
fr=floor(0.5*(FrameNum(i)+1));
f=MyAviRead(fn,fr,vObj);
imagesc(f);
bw=75;
hold on;

plot(e1(i,1),e1(i,2),[col '.'])
plot([c1(i,1) e1(i,1)]',[c1(i,2) e1(i,2)]',col)
plot(ell(i).elips(:,1),ell(i).elips(:,2),col) 
a1=round(c1(i,:)-bw);
a2=round(c1(i,:)+bw);
axis equal
axis([a1(1) a2(1) a1(2) a2(2)])
if(nargin<8)
    title(['frame ' int2str(FrameNum(i))])
else
    title([tstr ': frame ' int2str(FrameNum(i))])
end
hold off