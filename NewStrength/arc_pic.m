% Function which draws a section of a sphere

function arc_pic

r = 7;
a = 12;
dr = 3;
dthe = pi./15;
dphi = pi./5;
l = -pi./40;
m = pi./8;
l2 = -pi./50;
m2 = pi./9;
n = 0
o = pi./5;

PTS =10;

o2a = 0:(r/PTS):r;
rdr = r:(dr/PTS):r+dr;
b2p = r+dr:((a-r-dr)/PTS):a;
thdth = 0:(dthe/PTS):dthe;
phdph = 0:(dphi/PTS):dphi;
lm = l:((m-l)./PTS):m
lm2 = l2:((m2-l2)./PTS):m2
no = n:((o-n)./PTS):o

num = PTS+1;
for i=1:num
	[OPx(i),OPy(i), OPz(i)] = sph2cart(0,0,o2a(i));	
end
plot3(OPx,OPy, OPz,'r:')

hold on;

for i=1:num
	[ODx(i),ODy(i), ODz(i)] = sph2cart(0,dthe,o2a(i));	
end
plot3(ODx,ODy, ODz,'r:')

for i=1:num
	[ABx(i),ABy(i), ABz(i)] = sph2cart(0,0,rdr(i));	
end
plot3(ABx,ABy, ABz)

for i=1:num
	[DCx(i),DCy(i), DCz(i)] = sph2cart(0,dthe,rdr(i));	
end
plot3(DCx,DCy, DCz)

for i=1:num
	[EFx(i),EFy(i), EFz(i)] = sph2cart(dphi,dthe,rdr(i));	
end
plot3(EFx,EFy, EFz)

for i=1:num
	[GHx(i),GHy(i), GHz(i)] = sph2cart(dphi,0,rdr(i));	
end
plot3(GHx,GHy, GHz)

for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(0,0,b2p(i));	
end
plot3(BPx,BPy, BPz,'r:')

for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(dphi,0,o2a(i));	
end
plot3(BPx,BPy, BPz,'r:')
for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(dphi,0,b2p(i));	
end
plot3(BPx,BPy, BPz,'r:')
for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(0,dthe,b2p(i));	
end
plot3(BPx,BPy, BPz,'r:')
for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(dphi,dthe,b2p(i));	
end
plot3(BPx,BPy, BPz,'r:')
for i=1:num
	[BPx(i),BPy(i), BPz(i)] = sph2cart(dphi,dthe,o2a(i));	
end
plot3(BPx,BPy, BPz,'r:')


for i=1:num
	[AGx(i),AGy(i), AGz(i)] = sph2cart(phdph(i),0,r);	
end
plot3(AGx,AGy, AGz)

for i=1:num
	[DEx(i),DEy(i), DEz(i)] = sph2cart(phdph(i),dthe,r);	
end
plot3(DEx,DEy, DEz)

for i=1:num
	[BHx(i),BHy(i), BHz(i)] = sph2cart(phdph(i),0,r+dr);	
end
plot3(BHx,BHy, BHz)

for i=1:num
	[CFx(i),CFy(i), CFz(i)] = sph2cart(phdph(i),dthe,r+dr);	
end
plot3(CFx,CFy, CFz)

for i=1:num
	[ADx(i),ADy(i), ADz(i)] = sph2cart(0,thdth(i),r);	
end
plot3(ADx,ADy, ADz)

for i=1:num
	[BCx(i),BCy(i), BCz(i)] = sph2cart(0,thdth(i),r+dr);	
end
plot3(BCx,BCy, BCz)

for i=1:num
	[GEx(i),GEy(i), GEz(i)] = sph2cart(dphi,thdth(i),r);	
end
plot3(GEx,GEy, GEz)

for i=1:num
	[HFx(i),HFy(i), HFz(i)] = sph2cart(dphi,thdth(i),r+dr);	
end
plot3(HFx,HFy, HFz)



ind = length(lm)
for i=1:ind
	[OUTx(i),OUTy(i), OUTz(i)] = sph2cart(0,lm(i),a);	
end
plot3(OUTx,OUTy, OUTz,'r:')
ind = length(lm2)
for i=1:ind
	[OUTx(i),OUTy(i), OUTz(i)] = sph2cart(dphi,lm2(i),a);	
end
plot3(OUTx,OUTy, OUTz,'r:')
ind = length(lm)
for i=1:ind
	[INNx(i),INNy(i), INNz(i)] = sph2cart(0,lm(i),r+dr);	
end
%plot3(INNx,INNy, INNz,'r:')

for i=1:num
	[ARx(i),ARy(i), ARz(i)] = sph2cart(no(i),0,a);	
end
plot3(ARx,ARy, ARz,'r:')
for i=1:num
	[ARx(i),ARy(i), ARz(i)] = sph2cart(no(i),dthe,a);	
end
plot3(ARx,ARy, ARz,'r:')
text(r,0,-0.3,'r')
text(a-0.2,0,-0.3,'a')
text(0.1,0,-0.3,'0')
text(r+dr-0.8,0,-0.3,'r+\delta r')
text(r+dr+0.4,0,0.1,'\theta')
text(r+dr,0,1.9,'\theta+\delta \theta')
text(r+dr-0.2,0,2.4,'\phi')
text(r+dr-2.5,1.75,2.6,'\phi+\delta \phi')

view(0,0.9)
axis([-0.5 25 0 4 -1 16])
axis off
print -dps arc_pic.ps
hold off;
