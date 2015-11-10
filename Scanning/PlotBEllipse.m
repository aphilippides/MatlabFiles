function PlotBEllipse(vidfn,i1,FrameNum,Cents,EPt,EndPt,elips,col)
ho=ishold;
fr=FrameNum(i1(round(0.5*end)));
f=MyAviRead(vidfn,fr,0);
imagesc(f);
axis equal;
plotb(i1,Cents,EPt,EndPt,elips,col)
if(~ho) 
    hold off; 
end;

function plotb(is,c1,e1,e2,ell,col)
bw=25;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=is 
    plot(ell(i).elips(:,1),ell(i).elips(:,2),col) 
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])