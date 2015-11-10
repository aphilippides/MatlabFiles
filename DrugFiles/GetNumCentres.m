function[NumCents]=GetNumCentres(X,Opts)

[x,y]=size(X);
Tr
for i=1:x/2
   centres=zeros(i,y);
   [centres,Options,Post,ErrLog]=kmeans(centres,X,Opts);
   Post
end
[Dum,I]=min(FinalErrors);
NumCents=I
	