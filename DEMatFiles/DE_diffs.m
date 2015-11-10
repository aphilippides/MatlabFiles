% function to get data from ascii big file
function[M] = DE_diffs(Time,x,y) 

cd d:/mydocuments/DiffEqun/
for k=1:1
Time = (k)*50
filename = ['Space/DE/twod10S_L1_' int2str(Time) '.mat']
filename2 = ['DE/twodXS_L1_' int2str(Time) '.mat']
load(filename );
M1 = DEdat;
max(max(M1))
load(filename2);
M2 = DEdat*.001;
max(max(M2))
%return
total = 0;
Difer = M1-M2;
[X,Y]=size(Difer);
for i=1:X
%vec = Difer(i,:);
%[maxi(i),inds(i)]=max(vec);
for j=1:Y
if(M2(i,j)==0)
RelDif(i,j) = 0;
else
   RelDif(i,j)=Difer(i,j)./M2(i,j);
   total = total+sqrt(RelDif(i,j).^2);
end
end
end
Tot(k)=total./(X*Y);
Rels(k)=max(max(RelDif))
Diffs(k)=max(max(Difer))
end
save Rellies.mat Rels  Diffs Tot

