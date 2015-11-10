function[f]=ReadSSFOld(fn,TypeFlag)
if(TypeFlag==1) fnn=[fn 'Int.ssf'];
elseif(TypeFlag==2) fnn=[fn 'Ori.ssf'];
else fnn=[fn 'Sind.ssf']; end;
fwithEOL=dlmread(fnn,'\t');
f=fwithEOL(:,1:end-1);