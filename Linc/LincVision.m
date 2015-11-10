% function[ObjC,ObjW,ons]=LincVision(Obj,Agent,AgentAng,nfac)
%
% function which returns the angular positions (ObjC) and widths (ObjW) (in
% mnumber of facets) and a binary array of on or off facets (ons) of a set
% of Objects (listed as [x,y,radius;x,y,radius,...] for an agent at x,y
% position Agent at an angular heading of AgentAng 
% default angle of agent is 0: so right edge of facet 1 is on x-axis 
% with number of facets nfac (default 90))

function[ObjC,ObjW,ons]=LincVision(Obj,Agent,AgentAng,nfac)

% default angle of agent is 0: so right edge of facet 1 is on x-axis
if(nargin<3) AgentAng=0; end;

% number facets of the model ant's eye
if(nargin<4) nfac=90; end
fac=2*pi/nfac; 
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

% Rotate world to account for agent rotation
th_ao=th_ao-AgentAng;

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

% NB THIS WOULS BE OBJECT CENTERS APART FROM OCCLUSION
% ObjC=(floor(th_ao(seen)/fac)+0.5)*fac;

ons=zeros(1,nfac);
for i=1:length(fac_R) 
%     if((fac_R(i)~=0)|fac_L(i)~=(nfac-1)) ons([fac_R(i):fac_L(i)]+1)=1;
%     elseif(fac_L(i)<fac_R(i))
%         if((fac_L(i)-fac_R(i))>=(nfac/2))
%             ons([1:fac_L(i) fac_R(i):nfac]+1)=1; 
%         end
%     end
    if(fac_L(i)<fac_R(i))
        if((fac_R(i)-fac_L(i))>=(nfac/2))
            ons([0:fac_L(i) fac_R(i):(nfac-1)]+1)=1;
        end
    elseif((fac_R(i)~=0)|fac_L(i)~=(nfac-1)) ons([fac_R(i):fac_L(i)]+1)=1;
    end
end
        
% Calc edges of objects
lr=ons-[ons(end) ons(1:end-1)];
objL=find(lr==-1);
objR=find(lr==1);

% If object wraps, shift lefts so always after right
if(isempty(objL)) 
    ObjC=[]; 
    ObjW=[];
else
    if(objL(1)<objR(1))
        objL=[objL(2:end) objL(1)+nfac];
    end
    ObjW=objL-objR;
    ObjC=round(0.5*(objR+objL-1));
    if(ObjC(end)>nfac)
        ObjC(end)=ObjC(end)-nfac;
    end
end
% Turn facet number into an angle
ObjC=(ObjC-0.5)*fac;