function[bc] = BoundaryCrossed(NumObs,alvs,bctype)
if(nargin<3) bctype=0; end;
if(length(NumObs)<2) bc=0;
elseif(bctype==1) bc=BC_ALV(alvs);
else bc=BC_Obj(NumObs);
end

function[bc]=BC_Obj(NumObs)
if(NumObs(end)~=NumObs(end-1)) bc=1;
else bc=0;
end

function[bc]=BC_ALV(alvs)
[d,c]=CartDist(alvs(end,:),alvs(end-1,:));
if(d<0.02) bc=1;
else bc=0;
end