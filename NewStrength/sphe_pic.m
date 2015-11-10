function sphe_pic

r = 5;
a = 12;
dr = 10;
dthe = 2*pi;
dphi = pi;
l = -pi./40;
m = pi./8;
l2 = -pi./50;
m2 = pi./9;
n = 0
o = pi./5;

PTS =40;

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
	[ABx(i),ABy(i), ABz(i)] = sph2cart(0,0,rdr(i));	
end
plot3(ABx,ABy, ABz)

for i=1:num
	[AGx(i),AGy(i), AGz(i)] = sph2cart(phdph(i),0,r);	
end
plot3(AGx,AGy, AGz,'r:')
for i=1:num
	[AGx(i),AGy(i), AGz(i)] = sph2cart(-phdph(i),0,r);	
end
plot3(AGx,AGy, AGz)

for i=1:num
	[AGx(i),AGy(i), AGz(i)] = sph2cart(phdph(i),0,r+dr);	
end
plot3(AGx,AGy, AGz,'r:')
for i=1:num
	[AGx(i),AGy(i), AGz(i)] = sph2cart(-phdph(i),0,r+dr);	
end
plot3(AGx,AGy, AGz)


for i=1:num
	[ADx(i),ADy(i), ADz(i)] = sph2cart(0,thdth(i),r);	
end
plot3(ADx,ADy, ADz)

for i=1:num
	[BCx(i),BCy(i), BCz(i)] = sph2cart(0,thdth(i),r+dr);	
end
plot3(BCx,BCy, BCz)
hold off


p=text(r,0,0,'a','Fontsize',15)
set_text([r+dr 0 0],'b',15)
rotate3d
view(2,7.5)
return

text(a-0.2,0,-0.3,'a')
text(0.1,0,-0.3,'0')
text(r+dr-0.8,0,-0.3,'r+\delta r')
text(r+dr+0.4,0,0.1,'\theta')
text(r+dr,0,1.9,'\theta+\delta \theta')
text(r+dr-0.2,0,2.4,'\phi')
text(r+dr-2.5,1.75,2.6,'\phi+\delta \phi')


axis([-0.5 25 0 4 -1 16])
axis off

hold off;

