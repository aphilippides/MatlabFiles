function[f,c]=ReadSSF(fn,TypeFlag)
if(TypeFlag==1) fnn=[fn 'Int.bmp'];
elseif(TypeFlag==2) fnn=[fn 'Ori.bmp'];
else fnn=[fn 'Sind.bmp']; end;
f=imread(fnn,'bmp');
info=imfinfo(fnn,'bmp');
c=info.Colormap;
f=f(:,76:end);          % get rid of dickish box