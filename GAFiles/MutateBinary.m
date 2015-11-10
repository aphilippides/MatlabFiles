function[MutV]=MutateBinary(V,Rate)

MLen=length(V);
Mutates=rand(1,MLen)<Rate;
MutV=mod(V+Mutates,2);
