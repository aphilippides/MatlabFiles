function ShowHiSpeed(s,is,t)
% cd F:\FolderName
[dn,m,nf] = FolderInfo(s);
if(nargin<2) is=1:m; end;
if(nargin<3) t=0.001; end;
if(isempty(dn)) return;
else cd(dn);
end;
for i=is
    imagesc(imread(GetDVRname(i,m)));
   % pause%(t)
end