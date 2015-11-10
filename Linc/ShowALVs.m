function[NObj,mx,my]= ShowALVs(nobj,objr,startpt,n)

if(nargin<4) n=10; end; 
[X,Y] = meshgrid([0:n:100+n]);
if(nargin<3) 
    mp=floor(length(X)/2);
    startpt=[X(mp,mp) Y(mp,mp)] ; 
end;
agentrad=2.5;
[O]=RndEnvironment(nobj,[n 100],objr,[startpt agentrad]);
angs=LincVision(O,startpt);
snapx=mean(cos(angs));
snapy=mean(sin(angs));

figure(1)
for i=1:length(X)
    for j=1:length(Y)
        agent=[X(i,j) Y(i,j) agentrad];
        if(InsideObject(O,agent))
            NObj(i,j)=-1;
            mx(i,j)=NaN;
            my(i,j)=NaN;
        else
            s=LincVision(O,agent([1 2]));
            NObj(i,j)=length(s);
            if(NObj(i,j)==0)
                mx(i,j)=NaN;
                my(i,j)=NaN;
            else
                angs=s;%*pi/45;
                mx(i,j)=mean(cos(angs));
                my(i,j)=mean(sin(angs));
            end
        end
    end
end
mx=mx-snapx;
my=my-snapy;
DrawEnvironment(O,[startpt agentrad]);
hold on;
quiver(X,Y,mx,my)
hold off

figure(2)
% pcolor(NObj),shading interp
% hold on
[c h]=contour(NObj,[-1:max(max(NObj))]);%clabel(c,h)
colorbar
%curr
% f=load('test.txt');
% pcolor(f)
% shading flat
% colormap hsv
% caxis([0 max(max(f))])
% colorbar
% %figure
% [i,j]=find(f==-1);
%
% d1=adjust(abs(f(2:end-1,2:end-1)-f(2:end-1,1:end-2)));
% d2=max(d1,adjust(abs(f(2:end-1,2:end-1)-f(2:end-1,3:end))));
% d3=max(d2,adjust(abs(f(2:end-1,2:end-1)-f(1:end-2,2:end-1))));
% d4=max(d3,adjust(abs(f(2:end-1,2:end-1)-f(3:end,2:end-1))));
% pcolor(d4.*(d4>t))
% colormap jet
% shading flat
%
% function[v]=adjust(d);
%
% under=(d<pi).*d;
% over=2*pi-(d>=pi).*d;
% newover=(over~=(2*pi)).*over;
% v=under+newover;