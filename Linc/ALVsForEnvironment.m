function[NObj,mx,my]=ALVsForEnvironment(X,Y,O,agentrad,startpt,Plotting)
if(nargin<6) Plotting=0; end;

[obc,obw]=LincVision(O,[startpt(1) startpt(2)]);
[no,snap]=GetALVs(obc,obw);
snapx=snap(1);
snapy=snap(2);
for i=1:size(X,1)
for j=1:length(X)
%         agent=[X(i,j) Y(i,j) agentrad];
        [obc,obw]=LincVision(O,[X(i,j) Y(i,j)]);
        [NObj(i,j),alv]=GetALVs(obc,obw);
        mx(i,j)=alv(1);
        my(i,j)=alv(2);
    end
end
if(Plotting)
    mx=mx-snapx;
    my=my-snapy;
    figure(1)
    DrawEnvironment(O,[startpt agentrad]);
    hold on;
    quiver(X,Y,mx,my)
    hold off
    axis tight
    figure(2)
    % pcolor(NObj),shading interp
    % hold on
    [c h]=contour(NObj,[-1:max(max(NObj))]);%clabel(c,h)
    colorbar
    axis tight
end