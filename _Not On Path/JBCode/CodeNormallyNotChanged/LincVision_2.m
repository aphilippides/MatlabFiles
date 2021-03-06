function[ObjC,ObjW]=LincVision(Obj,Agent)

nfac=90;
fac=2*pi/nfac;
ndiv=1;
fac_d=fac/ndiv;
if(nargin<1) 
    Obj=[rand(5,2)*10 rand(5,1)]*2; 
    Agent=rand(1,2)*10;
end;
ObjR=Obj(:,3);

% get (r,theta) of vectors from agent to objects
[d_ao,vec_ao]=CartDist(Obj(:,[1 2]),Agent);
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
% for i=0:nfac-1
%     is=(fac_R<=i).*(fac_L>=i)
%     if(sum(is)) ons(i+1)=1; end;
%     ons
% end
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
    if(objL(1)<objR(1)) objL=[objL(2:end) objL(1)+nfac]; end;
    ObjW=objL-objR;
    ObjC=round(0.5*(objR+objL-1));
    if(ObjC(end)>nfac) ObjC(end)=ObjC(end)-nfac; end;
end