function[NObj,mx,my]= ShowALVsGantry(startpt,n,m)
dwork
cd GantryProj\ALV\RealGantry\

if(nargin<2) n=5; end;
if(nargin<3) m=n; end;
[X,Y] = meshgrid([0:n:283],[0:n:170]);
if(nargin<1)
    mp=floor(size(X,1)/2);
    np=floor(size(X,2)/2);
    startpt=[X(mp,np) Y(mp,np)];
end;
agentrad=10;

ls objects_*.mat
s=input('enter end of filename to load, return for default (objects_1)\n','s');
if(isempty(s)) fn='objects_1.mat';
else fn=['objects_' s '.mat'];
end
load(fn)

s=LincVision(os,startpt);
angs=s*pi/45;
snapx=mean(cos(angs));
snapy=mean(sin(angs));

while(1)
    [obj,mx,my]=ALVsForEnvironment(X,Y,agentrad,os,startpt,snapx,snapy);
    figure(3)
    PlotTransects(1,50,obj,mx,my);
    figure(1)
    title('click inside an object to move it, right click delete it')
    xlabel('click anywhere else to put in a new object. Return to end')
    [x,y,b]=ginput(1);
    if(isempty(b)) break;
    elseif(b==3)
        [in,inobj]=InsideObject(os,[x y 0])
        if(in)
            inp=input('Delete this object? 1=yes, enything else=no\n');
            if(inp==1)
                os=os([1:(inobj(1)-1) (inobj(1)+1):end],:);
            end
        end
    else
        [in,inobj]=InsideObject(os,[x y 0]);
        if(in)
            title('click new position, return to re-do')
            [x,y,b]=ginput(1);
            if(~isempty(b))
                inp=input(['Change radius from ' num2str(os(inobj,3)) '? return to leave\n']);
                if(isempty(inp)) os(inobj,[1 2])=[x y];
                else
                    os(inobj,:)=[x y inp];
                end
            end
        else
            inp=input(['Enter radius. return to leave at ' num2str(os(1,3)) '\n']);
            if(isempty(inp)) os=[os;[x y os(1,3)]];
            else os=[os;[x y inp]];
            end
        end
    end
end
% a=input('');
% f=input('enter filename end\n','s');
% 
% fn1=['Objects' f '.txt'];
% OutputObjects(os,fn1);
% fn2=['PlaceList' f '.txt'];
% OutputPlaceList(X,Y,obj,fn2);
% 
% a=input('save objects as matlab file? 1=Yes\n');
% if(a==1) save(['objects_' f '.mat'],'os'); end;

function OutputObjects(os,fn)
fid=fopen(fn,'w');
fprintf(fid,'%f %f %f\n',os');
fclose(fid);

function OutputPlaceList(X,Y,obj,fn)
fid=fopen(fn,'w');
for i=1:size(X,1)
    for j=1:length(X)
        if(obj(i,j)~=-1)
            fprintf(fid,'%f %f\n',X(i,j),Y(i,j));
        end
    end
end
fclose(fid);

function[NObj,mx,my]=ALVsForEnvironment(X,Y,agentrad,O,startpt,snapx,snapy)

for i=1:size(X,1)
    for j=1:length(X)
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
                angs=s*pi/45;
                mx(i,j)=mean(cos(angs));
                my(i,j)=mean(sin(angs));
            end
        end
    end
end
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