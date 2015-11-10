% function test
% 
% Agent=[300 300] ;
% nest=[Agent 5] ;
% %Obj = RndEnvironment(10,[1 600],10,nest,1)
% Obj = [500 300 10 ;
%        450 450 10 ;
%        300 500 10 ;
%        250 300 10 ;
%        510 90 10 ]
% 
% BigestObject = max(Obj(:,3)) ;
% fac_awidth = 2*pi/90;
% SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;
% DrawEnvironment(Obj,nest) ;
% hold on ;
% MyCircle(Agent,SideEffectWidth,'k') ;
% hold off ;
% 
% [ObjC,ObjW,ons]=EdgeVisionB(Obj,Agent);
% ObjC
% ObjW
% [ons(1:15)' ons(16:30)' ons(31:45)' ons(46:60)' ons(61:75)' ons(76:90)']


function[ObjC,ObjW,ons]=EdgeVision(Obj,Agent)

nfac=90; % number facets of the model ant's eye
fac=2*pi/nfac; % angular width of a facet
ndiv=1;
fac_d=fac/ndiv;
if(nargin<1)
    Obj=[rand(5,2)*10 rand(5,1)]*2; 
    Agent=rand(1,2)*10;
end;

ObjR=Obj(:,3); % radius of objects

% get (r,theta) of vectors from agent to objects : (d_ao,th_ao)
[d_ao,vec_ao]=CartDist(Obj(:,[1 2]),Agent);
% if agent is in an object, return
if(sum(ObjR>=d_ao)) 
    ObjC=-1;
    ObjW=-1;
    ons = -1 ;
    return;
end
[th_ao,d_ao]=cart2pol(vec_ao(:,1),vec_ao(:,2));

% Get angular radii (half-widths) of objects and
% find all 'visible' objects (>half a facet)
wids=asin(ObjR./d_ao);
seen = find(wids>=(0.5*fac));

% Get angular positions of left and right edges where left means 
% more anti-clockwise. ensure within 0 and 2pi
th_L=th_ao(seen)+wids(seen);
th_R=th_ao(seen)-wids(seen);
fac_L=mod(floor((th_L-0.5*fac_d)/fac_d),nfac);
fac_R=mod(round(th_R/fac_d),nfac);

% mfacs=fac_d/2:fac_d:2*pi;
ons=zeros(1,nfac);
for i=1:length(fac_R) 
    if(fac_L(i)<fac_R(i))
        if((fac_R(i)-fac_L(i))>=(nfac/2))
            ons([0:fac_L(i) fac_R(i):(nfac-1)]+1)=1;
        end
    elseif((fac_R(i)~=0)|fac_L(i)~=(nfac-1)) ons([fac_R(i):fac_L(i)]+1)=1;
    end
end
        
% Calc edges of objects
lr=ons-[ons(end) ons(1:end-1)];
objL=find(lr==-1)-1;
objR=find(lr==1);

% If object wraps, shift lefts so always after right
if(isempty(objL)) 
    ObjC=[]; 
    ObjW=[];
else
    ObjC=[objL objR];
    if(objL(1)<objR(1))
        objL=[objL(2:end) objL(1)+nfac];
    end
    ObjW=objL-objR+1;
end