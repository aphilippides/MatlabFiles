%function[Differ, RelDiff, NewM, NewM2]=Compare2RegInt(M,M2,Tol)
% function which returns the difference and relative difference of 2 matrices M and M2
% within a region of interest specified by the area inside M2 above Tol 
% and returns the matrices M and M2 with  zeros outside the regoin of interest

function[Differ, RelDiff,NewM,NewM2]=Compare2RegInt(M,M2,Tol)

IntReg=(M2>Tol);
OppIntReg=abs(IntReg-1);
NewM2=M2.*IntReg;
NewM=M.*IntReg;
Differ=NewM2-NewM;
RelDiff=((abs(Differ)).*100./(NewM2+OppIntReg));
