% function test
% 
% Agent=[300 300] ;
% nest=[Agent 8] ;
% Obj = RndEnvironment(10,[1 600],10,nest,1)
% % Obj = [500 300 10 ;
% %        450 450 10 ;
% %        300 500 10 ;
% %        250 300 10 ;
% %        510 90 10 ]
% 
% % Obj = [ 250 400 40 ;
% %         350 400 40 ;
% %         350 200 20 ]
%    
% % Obj = [ 280 500 40 ;
% %         320 400 40 ;
% %         350 200 20 ]
%       
% % Obj = [ 300 500 40 ;
% %         300 400 10 ;
% %         350 200 20 ]
%        
% % Obj = [ 460 300 40 ;
% %         390 350 30 ]
% 
% % Obj = [ 460 300 40 ;
% %         390 250 30 ]
% 
% BigestObject =10 ; % max(Obj(:,3)) ;
% fac_awidth = 2*pi/90;
% SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;
% clf;
% DrawEnvironment(Obj,nest) ;
% hold on;
% MyCircle(Agent,SideEffectWidth,'k') ;
% hold on;
% axis([0  600  0  600]) ;
% 
% [ObjC,ObjW,Ons]=PerfectVision2(Obj,Agent)
% % ObjC
% % ObjW
% % [Ons(1:15)' Ons(16:30)' Ons(31:45)' Ons(46:60)' Ons(61:75)' Ons(76:90)']
 


function[ObjC,ObjW,Ons]=PerfectVision(Obj,Agent)

% Not necessary anymore but we still use this so as to avoid modifying
% other functions such as Get_ALV. The "angle" of each object will be in
% the range [0 nfac], though [0 2*pi] would be more logical.
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
    Ons = -1 ;
    return;
end
[th_ao,d_ao]=cart2pol(vec_ao(:,1),vec_ao(:,2));

% Get angular radii (half-widths) of objects and
% find all 'visible' objects (>half a facet)
wids=asin(ObjR./d_ao);
seen = find(wids>=(0.5*fac));

if(isempty(seen)) 
    ObjC=[]; 
    ObjW=[];
    Ons = -1 ;
    return;
end

th_ao_seen=th_ao(seen);
th_ao_seen(find(th_ao_seen<0))=th_ao_seen(find(th_ao_seen<0))+2*pi;
tmp_L=mod(th_ao_seen+wids(seen),2*pi);
tmp_R=mod(th_ao_seen-wids(seen),2*pi);

th_L=[];
th_R=[];
added=0;
for j=1:size(tmp_L,1)
    if(tmp_L(j)>tmp_R(j))
        th_L=[th_L;tmp_L(j)];
        th_R=[th_R;tmp_R(j)];
    else
        th_L=[th_L;  tmp_L(j); 2*pi-1e-15 ];
        th_R=[th_R;  0       ; tmp_R(j)   ];
        added=added+1;
    end
end

Ons=[[th_R(1);0],[th_L(1);1]];
for i=2:(size(seen,1)+added)

    tmp=find(Ons(1,:)>th_R(i));
    if(isempty(tmp))
        Ind_R=size(Ons,2)+1;
        Edge_R=[th_R(i);0];
    else
        Ind_R=tmp(1);
        if (Ons(2,Ind_R))
            Edge_R=[];
        else
            Edge_R=[th_R(i);0];
        end
    end
    tmp=find(Ons(1,:)>th_L(i));
    if(isempty(tmp))
        Ind_L=size(Ons,2)+1;
        if(Ons(end))
            Edge_L=[th_L(i);1];
        else
            Edge_L=[];
        end
    else
        Ind_L=tmp(1);
        if (Ons(2,Ind_L))
            Edge_L=[];
        else
            Edge_L=[th_L(i);1];
        end
    end

    Ons=[Ons(:,1:Ind_R-1),Edge_R,Edge_L,Ons(:,Ind_L:end)];
end

if(added)
    Ons=[Ons(:,end-1)-[2*pi;0] Ons(:,2:end-2)];
    ObjW=Ons(1,2:2:end)-Ons(1,1:2:end);
    ObjC=(nfac/(2*pi))*(Ons(1,1:2:end)+Ons(1,2:2:end))/2;
else
    ObjW=Ons(1,2:2:end)-Ons(1,1:2:end);
    ObjC=(nfac/(2*pi))*(Ons(1,1:2:end)+Ons(1,2:2:end))/2;
end