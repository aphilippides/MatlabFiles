function [XX,YY,ZZ]=objectBuilder
% this function is for building a 3D object
%
% idea is that you draw various slices from a to down view, starting 
% from the bottom
%
% Do the shape in the bottom layer. Then alter these points
% in the next layer. You need the same number of control points in each
% layer. When done with a layer click return
% when finished click return and it will finish
% if you want a solid top need to do another layer with all points 
% close to the centre
%
% can reedit later
% eg to change height of layer 3 do ZZ(ZZ==3)=2.5

% make the base
xx=[];
yy=[];
XX=[];
YY=[];
ZZ=[];
figure(1)
clf
axis([-1 1 -1 1])
th=linspace(0,2*pi,10);
plot(cos(th),sin(th),'g')
hold on
while(1)
    [x,y]=ginput(1);
    if isempty(x)
        plot([xx(end),xx(1)],[yy(end),yy(1)],'k-')
        break
    end
    if ~isempty(xx)
        plot(x,y,'kx')
        plot([x,xx(end)],[y,yy(end)],'k-')
    else
        plot(x,y,'kx')
        hold on
    end
%     axis(10*[-1 1 -1 1])
    xx=[xx,x];
    yy=[yy,y];
end
X0=xx;
Y0=yy;
j=0;
while(1)
    j=j+1;
    X1=X0;
    Y1=Y0;
    % make next level
    action='select';
    while(1)
        [x,y]=ginput(1);
        if isempty(x)
            break
        end
        switch action
            case 'select'
                % find the nearest point
                d2=dist2([x,y],[X1(:),Y1(:)]);
                [val,ind]=min(d2);
                action='place';
            case 'place'
                % replace
                X1(ind)=x;
                Y1(ind)=y;
                hold off
                plot(X0,Y0,'kx')
                hold on
                plot(X0,Y0,'k-')
                plot(X1,Y1,'r')
                action='select';
        end
    end
    [X,Y,Z]=buildPatches(X0,Y0,X1,Y1);
    XX=[XX;X];
    YY=[YY;Y];
    ZZ=[ZZ;Z+j];
    figure(2)
    fill3(XX',YY',ZZ','g')
    figure(1)
    X0=X1;
    Y0=Y1;
    [x,y]=ginput(1);
    if isempty(x)
        break
    end
end

Z=Z-1;

function [X,Y,Z]=buildPatches(X0,Y0,X1,Y1)
X=[];
Y=[];
Z=[];
for i=1:length(X0)-1
    x01=X0(i);
    x02=X0(i+1);
    y01=Y0(i);
    y02=Y0(i+1);
    x11=X1(i);
    x12=X1(i+1);
    y11=Y1(i);
    y12=Y1(i+1);

%     fill3([x01,x02,x11],[y01,y02,y11],[0,0,1],'w');
%     hold on
%     fill3([x02,x11,x12],[y02,y11,y12],[0,1,1],'w');
    X=[X;[x01,x02,x11];[x02,x11,x12]];
    Y=[Y;[y01,y02,y11];[y02,y11,y12]];
    Z=[Z;[0,0,1];[0,1,1]];

end

x01=X0(end);
x02=X0(1);
y01=Y0(end);
y02=Y0(1);
x11=X1(end);
x12=X1(1);
y11=Y1(end);
y12=Y1(1);

% fill3([x01,x02,x11],[y01,y02,y11],[0,0,1],'w');
% fill3([x02,x11,x12],[y02,y11,y12],[0,1,1],'w');

X=[X;[x01,x02,x11];[x02,x11,x12]];
Y=[Y;[y01,y02,y11];[y02,y11,y12]];
Z=[Z;[0,0,1];[0,1,1]];
