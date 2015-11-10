function[ObjC,ObjW,Obj,ObjR]=Linc_tmp(Obj,ObjR,nobj)

nfac=48;
fac=2*pi/nfac;
ndiv=1;
fac_d=fac/ndiv;
% nobj=5;
% Obj=rand(nobj,2)*10;
% ObjR=rand(nobj,1)*2+0.25;
Agent=[5,5];

MyCircle(Agent,0.25,'r');
hold on;
for i=1:nobj MyCircle(Obj(i,:),ObjR(i),'b'); end;
for i=1:nfac 
    [z,y]=pol2cart(i*fac,20);
    x=Agent+[z,y];
    plot([Agent(1) x(1)],[Agent(2) x(2)],'g');
end
hold off;
axis([0 10 0 10])

% get (r,theta) of vectors from agent to objects
vec_ao=Obj-ones(nobj,1)*Agent;
[th_ao,d_ao]=cart2pol(vec_ao(:,1),vec_ao(:,2));

% Get angular radii (half-widths) of objects
wids=atan(ObjR./d_ao);

% Get angular positions of left and right edges where left means 
% more anti-clockwise. enusre within 0 and 2pi
th_L=mod(th_ao+wids,2*pi);
th_R=mod(th_ao-wids,2*pi);
fac_L=round(th_L/fac_d);
fac_R=round(th_R/fac_d);

% Get mini-facets covered
mons=zeros(nobj,ndiv*nfac);
mfacs=[0:fac_d:(2*pi-fac_d)];
for i=1:nobj
    if(fac_L(i)>fac_R(i)) mons(fac_R(i):fac_L(i)) = 1;
    else mons([1:fac_L(i) fac_R(i):end])=1;
    end
end

% calc num of mini facets on
for i=0:(nfac-1) 
    so(i+1)=sum(mons((i*ndiv+1):ndiv*(i+1)));
end

% calc facets on
ons=so>floor(ndiv/2)

% Calc edges of objects
lr=ons-[ons(end) ons(1:end-1)]
objL=find(lr==-1);
objR=find(lr==1);

% If object wraps, shift lefts so always after right
if(objL(1)<objR(1)) objL=[objL(2:end) objL(1)+nfac]; end;
ObjW=objL-objR;
ObjC=round(0.5*(objR+objL-1));
if(ObjC(end)>nfac) ObjC(end)=ObjC(end)-nfac; end;
