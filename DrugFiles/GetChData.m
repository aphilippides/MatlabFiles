function[Chems,Fs,Inds]=GetChData(V)

Chems=V(:,2:end-1);
Fs=V(:,end);
Inds=V(:,1);
