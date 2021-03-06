function[NObj,mx,my]=CheckVision(startpt,l,th,th2)

% thresh=160;
[X,Y]=meshgrid(0:10:200,0:10:170);
agentrad=10;
os=load('objects.txt');

if(length(startpt)==2)
    thresh=th;
    th=th2;
    sl=UnwrapPan(startpt(1),startpt(2),thresh,l);
    s=ObjectsFromFacets(sl);
    angs=s*pi/45;
    snapx=-mean(cos(angs));
    snapy=mean(sin(angs));
    % figure(1)
    % DrawEnvironment(os,[startpt agentrad]);
    % axis equal
    % return

    ssim=LincVision(os,startpt);
    angs=ssim*pi/45;
    snapxsim=mean(cos(angs));
    snapysim=mean(sin(angs));
else
    thresh=startpt;
end
redo=1;
if(redo)
for i=1:size(X,1)
    Y(i,1)
    for j=1:length(X)
        if(nargin==2) sl=UnwrapPan(X(i,j),Y(i,j),thresh,l);        
        else sl=UnwrapPan(X(i,j),Y(i,j),thresh,l,th); 
        end
        if(isempty(sl))
            NObj(i,j)=0;
            mx(i,j)=NaN;
            my(i,j)=NaN;

            NObjSim(i,j)=0;
            mxSim(i,j)=NaN;
            mySim(i,j)=NaN;
        else
            s=ObjectsFromFacets(sl);
            NObj(i,j)=length(s);
            if(NObj(i,j)==0)
                mx(i,j)=NaN;
                my(i,j)=NaN;
            else
                angs=s*pi/45;
                mx(i,j)=mean(cos(angs));
                my(i,j)=mean(sin(angs));
            end

            ssim=LincVision(os,[X(i,j) Y(i,j)]);
            NObjSim(i,j)=length(ssim);
            if(NObjSim(i,j)==0)
                mxSim(i,j)=NaN;
                mySim(i,j)=NaN;
            else
                angs=ssim*pi/45;
                mxSim(i,j)=mean(cos(angs));
                mySim(i,j)=mean(sin(angs));
            end
        end
    end
end
else
    load FirstGo
    load SimResults
end

if(length(startpt)==2)
    mx=mx-snapx;
    my=my-snapy;
    figure(1)
    DrawEnvironment(os,[startpt agentrad]);
    hold on;
    quiver(X,Y,mx,my)
    hold off
    axis tight
    figure(2)
    [c h]=contour(X,Y,NObj,[-1:max(max(NObj))]);%clabel(c,h)
    colorbar
    axis tight
    mx=mx+snapx;
    my=my+snapy;
    save(['RealResT' int2str(thresh)],'NObj','mx','my','X','Y');
    save SimResults NObjSim mxSim mySim  X Y
    keyboard
end