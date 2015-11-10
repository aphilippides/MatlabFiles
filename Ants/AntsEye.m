function AntsEye
close all
s_start=0.0262;        % 2 degrees
s_end=0.07;        % 8 degrees
phis=[];ths=[];rs=[];
h1=figure;
WallPic=false;
if(WallPic) h2=figure; end;
walld=5000;         % eye radius = 0.5mm so wall=50 cm away

ccarts=[];
cpols=[];
s_es=[];
el=0;
lastth=0;
el=0;
max_el=pi/2-0.1;
RowCount =[];
while(el<=max_el) 
    th=0;
    s=s_start+el*(s_end-s_start)/max_el;
    %while(th>=(-(pi/2)+0.5)) 
    c=0;
    while(th>=(-pi+2*s))
        
        figure(h1);
        hold on
        if(el==0) 
            ph=el;
            if(th==0)
                lastph=ph;
                lasts=s;
                lastr=cos(s);
            end
        else
            if(th==0)
                d=sin(s)^2+sin(lasts)^2+2*sin(lasts)*sin(s)*cos(s+lasts);
                r=cos(s);
                p=lastph:0.0001:(el+s);
                ds=r^2+lastr^2-2*r*lastr*(cos(p).*cos(lastph).*cos(-lastth)+sin(p).*sin(lastph));
                [m,i]=min(abs(ds-d));
                ph=p(i);
                th=0;
                lastr=r;
                lastth=th;
                lastph=ph;
                lasts=s;
            else 
                e=cpols(end,2)+s-s_es(end);
                th=cpols(end,1)-2*s/cos(e);
                sst=[th e cos(s)];
                ds=SpherDist(sst,cpols(1:end-1,:));
                [y,i]=min(ds);
                n1=cpols(end,:);
                n2=cpols(i,:);
                [r,th,ph]=NewCircle(s,s,s,n1(1),n1(2),n1(3),n2(1),n2(2),n2(3));
            end
        end
        
        % if going to fit both ommatidia into the circle w.o. overlap
        if((pi+th)>=(2*s))
            [x,y,z,xc,yc,zc]=CircleOnCircle(s,cos(s),th,ph);        
            c=c+1;
            cpols=[cpols; th,ph,cos(s)];
            ccarts=[ccarts; xc,yc,zc];
            s_es=[s_es s];
            if(WallPic)
                figure(h2)
                hold on
                PlotImagesOnWall(x,y,z,xc,yc,zc,walld)
            end
            
            % if not dead centre, do a symmetric ommatidia
            if(th~=0)       
                [x,y,z,xc,yc,zc]=CircleOnCircle(s,cos(s),-th,ph);        
                c=c+1;
                ccarts=[ccarts; xc,yc,zc];
                s_es=[s_es s];
                if(WallPic)
                    figure(h2)
                    hold on
                    PlotImagesOnWall(x,y,z,xc,yc,zc,walld)
                end
            end
        end
        
        if(el==0) th=th-(2*s/cos(el)); 
        elseif(th==0) th=-1e-6;
        end;
    end
    RowCount=[RowCount c]
    el=lastph+lasts;
end
if(WallPic)
    hold off
    axis equal
    axis tight
    SetYTicks(gca,[],1e-2)
    SetXTicks(gca,[],1e-2)
    xlabel('y'),ylabel('z')
end
figure(h1);
hold off
axis equal
xlabel('x'),ylabel('y'),zlabel('z');

dmat
cd Ants
% save AntEyeData ccarts s_es RowCount

function[r,t,p]=NewCircle(s,s1,s2,t1,p1,r1,t2,p2,r2)
r=cos(s);
d1=sin(s)^2+sin(s1)^2+2*sin(s1)*sin(s)*cos(s+s1);
d2=sin(s)^2+sin(s2)^2+2*sin(s2)*sin(s)*cos(s+s2);
p=min(p1+s1,p2+s2);
ph=p:0.001:(p+s);
cosang=((d1-r^2-r1^2)/(2*r*r1)+sin(p1)*sin(ph))./(-cos(ph)*cos(p1));
is=find(abs(cosang)<1);
t=acos(cosang(is));
ph=ph(is);
if((t1+t2)<=0) t=-t; end;
th=t+t1;
ds=r^2+r2^2-2*r*r2*(cos(ph).*cos(p2).*cos(th-t2)+sin(ph).*sin(p2));
[d,i]=min(abs(ds-d2));
p=ph(i);
t=th(i);

function PlotImagesOnWall(x,y,z,xc,yc,zc,d)
[th,ph,r]=cart2sph(xc,yc,zc);
yc=d*tan(th);
zc=d*tan(ph)./cos(th);
[th,ph,r]=cart2sph(x,y,z);
ys=d*tan(th);
zs=d*tan(ph)./cos(th);
plot(yc,zc,'bx',ys,zs,'r')

function[x,y,z,xc,yc,zc]=CircleOnCircle(rad,r,az,el,n)
if(nargin<5) n=50; end;
[xc,yc,zc]=sph2cart(0,0,r);
t = 0:pi/50:2*pi;
z=zc+rad*cos(t);
y=yc+rad*sin(t);
x=ones(size(t))*xc;
[xc,yc,zc]=RigidRotate3D(xc,yc,zc,az,el);
[x,y,z]=RigidRotate3D(x,y,z,az,el);
%plot3([0;xc],[0;yc],[0;zc],'b-x',x,y,z,'r');
plot3(xc,yc,zc,'bx',x,y,z,'r');