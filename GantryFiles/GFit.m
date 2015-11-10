function GFit(RunNum,Opt)

dvolsig1;
if(nargin==1) Opt=10;end		% default action

if(Opt==0)
   fn=['Data/VS_ExpData/Run' int2str(RunNum) '/pop.dat']; 
elseif(Opt==1)
   fn=['Data/VS_FlatData/Run' int2str(RunNum) '/pop.dat']; 
elseif(Opt==2)
   fn=['Data/VS_OrigData/Run' int2str(RunNum) '/pop.dat']; 
elseif(Opt==3)
   fn=['Data/VS_Flat2Data/Run' int2str(RunNum) '/pop.dat']; 
elseif(Opt==4)
    ddelay;
   fn=['Data/DelRec/Run' int2str(RunNum) '/pop.dat']; 
elseif(Opt==5)
    ddelay;
   fn=['Data/DecRec/Run' int2str(RunNum) '/pop.dat']; 
else
    ddelay;
   fn=['Data/VarFlat/Run' int2str(RunNum) '/pop.dat']; 
end

M=load(fn);
plot(M(:,1)',M(:,2:3)')