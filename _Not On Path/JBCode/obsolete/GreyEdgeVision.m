% function test
% 
% Agent=[300 300] ;
% nest=[Agent 5] ;
% %Obj = RndEnvironment(10,[1 600],10,nest,1)
% Obj = [500 300 10 ;
%        450 450 10 ;
%        300 500 10 ;
%        250 300 10 ;
%        510 090 10 ]
% 
% BigestObject = max(Obj(:,3)) ;
% fac_awidth = 2*pi/90;
% SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;
% DrawEnvironment(Obj,nest) ;
% hold on ;
% MyCircle(Agent,SideEffectWidth,'k') ;
% hold off
% 
% [ObjC,ObjW,ons]=LincVision(Obj,Agent);
% ObjC
% ObjW
% [ons(1:15)' ons(16:30)' ons(31:45)' ons(46:60)' ons(61:75)' ons(76:90)']


function[ObjC,ObjW,ons,lr]=GreyEdgeVision(Obj,Agent)

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

% Get angular positions of left and right edges where left means 
% more anti-clockwise. ensure within 0 and 2pi
th_L=th_ao+wids;
th_R=th_ao-wids;
fac_L=mod(th_L/fac_d,nfac);
fac_R=mod(th_R/fac_d,nfac);


%########warning : overlaping badly dealt with
ons=zeros(1,nfac);
for i=1:length(fac_R) 
    if(fac_L(i)<fac_R(i))
        if((fac_R(i)-fac_L(i))>=(nfac/2))
            ons(floor(fac_L(i))+1)=fac_L(i)-floor(fac_L(i));
            ons([0:floor(fac_L(i))-1 floor(fac_R(i))+1:(nfac-1)]+1)=1;
            ons(floor(fac_R(i))+1)=1-fac_R(i)+floor(fac_R(i));
        end
    elseif((fac_R(i)~=0)|fac_L(i)~=(nfac-1))
        ons(floor(fac_L(i))+1)=fac_L(i)-floor(fac_L(i));
        ons([floor(fac_R(i))+1:floor(fac_L(i))-1]+1)=1;
        ons(floor(fac_R(i))+1)=1-fac_R(i)+floor(fac_R(i));
    end
end

% % Calc edges of objects
% lr=ons-0.5*[ons(end) ons(1:end-1)]-0.5*[ons(2:end) ons(1)];
% lr=(lr>0).*lr;
% ObjC=find(lr~=0);
% ObjW= lr(ObjC) ;

% new strategy
lr=min( ons , max(zeros(size(ons)),ons-[ons(end) ons(1:end-1)]) + max(zeros(size(ons)),ons-[ons(2:end) ons(1)]) );
ObjC = find(lr~=0);
ObjW = lr(ObjC) ;