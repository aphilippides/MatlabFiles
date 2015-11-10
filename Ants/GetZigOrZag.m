function[zig1,zig2,lzig,zang]=GetZigOrZag(zigs,cents,lt,br)
zig1=[];zig2=[];lzig=[];zang=[];
if(isempty(zigs)) return; end;

if(nargin<3) lt = 3; end
if(nargin<4) br = 1; end

d=diff(zigs);
bps=find(d>br);

if(isempty(bps)) 
    zig1=zigs(1);
    zig2=zigs(2);
    lzig=zig1-zig2+1;
else
    zig1=[1 bps+1];
    zig2=[bps length(zigs)];
    lzig=zigs(zig2)-zigs(zig1)+1;
    is=find(lzig>=lt);
    zig1=zigs(zig1(is));
    zig2=zigs(zig2(is));
    lzig=lzig(is);
end
for i =1:length(zig1)
    cs=cents(zig1(i):zig2(i),:);
    [area,axes,angles,ellip] = ellipse(cs(:,1),cs(:,2),[],0.8535);
    x=cs(end,1)-cs(1,1);
    y=cs(end,2)-cs(1,2);
    t=cart2pol(x,y);
    if(abs(AngularDifference(t,angles(1)))>(pi/2)) 
        angles=mod(angles+pi,2*pi);
    end
    zang(i)=angles(1);
    d=sqrt(x^2+y^2);
    [xs,ys]=pol2cart(zang(i),[0 d]);
%     plot(xs+cs(1,1),ys+cs(1,2))
end