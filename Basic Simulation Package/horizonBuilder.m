function [X,Y,Z]=horizonBuilder(radius)
% function which allows you to draw a horizon
% Can enter a radius or defaults to 2000m
%
% click below 0 to get things that are at 0
% click points every 10/15 because ifnot it may joing things wrongly
% press rertun when donw
%
% it returns a flat object oriented maximally to the center
% it does keep the below horizon objects but these are low
% it does seem to see them as a line though so could get rid
% means it has input at every azimuth but low value
% can be got rid of by changing the lower bound of the height in getView at
% line 48: axis([-pi pi 0 1.2])

if nargin==0
    radius=2000;
end
% make the base
xx=[];
zz=[];
XX=[];
YY=[];
ZZ=[];
figure(1)
clf
axis equal
axis([0 2*pi -0.1 pi/2])
while(1)
    [x,z]=ginput(1);
    if isempty(x)
        plot([xx(end),xx(1)],[zz(end),zz(1)],'k-')
        break
    end
    if ~isempty(xx)
        plot(x,z,'kx')
        plot([x,xx(end)],[z,zz(end)],'k-')
    else
        plot(x,z,'kx')
        hold on
    end
    axis equal
    axis([0 2*pi -0.1 pi/2])
    xx=[xx,x];
    zz=[zz,z];
end
X0=xx;
Z0=zz;
j=0;

[XX,YY]=pol2cart(X0,1);
figure
[X,Y,Z]=buildPatches(XX,YY,Z0);
[X,Y,Z]=deal(X*radius,Y*radius,Z*radius);
fill3(X',Y',Z','k')
axis equal

function [X,Y,Z]=buildPatches(X0,Y0,Z1)
X1=X0;Y1=Y0;
X=[];
Y=[];
Z=[];
for i=1:length(X0)-1
    x01=X0(i);
    x02=X0(i+1);
    y01=Y0(i);
    y02=Y0(i+1);
    z01=0;
    z02=0;
    x11=X1(i);
    x12=X1(i+1);
    y11=Y1(i);
    y12=Y1(i+1);
    z11=Z1(i);
    z12=Z1(i+1);

%     fill3([x01,x02,x11],[y01,y02,y11],[0,0,z11],'w');
%     hold on
%     fill3([x02,x11,x12],[y02,y11,y12],[0,z11,z12],'w');
    X=[X;[x01,x02,x11];[x02,x11,x12]];
    Y=[Y;[y01,y02,y11];[y02,y11,y12]];
    Z=[Z;[0,0,z11];[0,z11,z12]];

end

x01=X0(end);
x02=X0(1);
y01=Y0(end);
y02=Y0(1);
x11=X1(end);
x12=X1(1);
y11=Y1(end);
y12=Y1(1);
z11=Z1(end);
z12=Z1(1);

% fill3([x01,x02,x11],[y01,y02,y11],[0,0,z11],'w');
% fill3([x02,x11,x12],[y02,y11,y12],[0,z11,z12],'w');
% hold off

X=[X;[x01,x02,x11];[x02,x11,x12]];
Y=[Y;[y01,y02,y11];[y02,y11,y12]];
Z=[Z;[0,0,z11];[0,z11,z12]];