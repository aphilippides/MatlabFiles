for i=3:length(g1)
    c1s(i-2,:)=g1(i).cent;
    c2s(i-2,:)=g2(i).cent;
end

[EPt(:,1) EPt(:,2)]=pol2cart(ana,15);
EPt=EPt+cas;
[ep1(:,1) ep1(:,2)]=pol2cart(an1,15);
ep1=ep1+c1s;
[ep2(:,1) ep2(:,2)]=pol2cart(an2,15);
ep2=ep2+c2s;

d1=abs(AngularDifference(an1,ana));
d2=abs(AngularDifference(an2,ana));
d3=abs(AngularDifference(an1,an2));
md=max([d3;d2;d1]);
% [s,is]=sort(md,'descend');
[s,is]=sort(d2,'descend');
bests=[];
refim=MyAviRead(fn,1,1);
odev(find(odev==0))=2;
for i=is

    fr=floor(0.5*(FrameNum(i)+1));
    f=MyAviRead(fn,fr,1);
    im=refim;
    im(odev(i):2:end,:,:)=f(odev(i):2:end,:,:);
    imagesc(im);
    plotb(i,cas,EPt,elips,'b')
    plotb(i,c1s,ep1,[],'g')
    plotb(i,c2s,ep2,[],'r')
    inp=input(['FNum=' int2str(FrameNum(i)) '; return ?, 1 blue, 2 green 3 red, 4 b+g, 5 b+r, 6 r+g\n']);
    if(~isempty(inp)) bests=[bests;i inp]; end;
end