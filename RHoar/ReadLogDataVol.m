function[tim,l1,l2,l3,buy,sell,vol,ts,bv,av]=ReadLogDataVol(fn)
fid =fopen(fn);
fgetl(fid);fgetl(fid);

tline = fgetl(fid);
a=sscanf(tline,'%d:%d:%d\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%f');
x=zeros(32400,size(a,1));
x(1,:)=a';

for c=2:32400
    tline = fgetl(fid);
    if ~ischar(tline), break, end
     a=sscanf(tline,'%d:%d:%d\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%f');
     x(c,:)=a';
end
fclose(fid);
h=x(1:c-1,1);
m=x(1:c-1,2);
s=x(1:c-1,3);
tim=[zeros(c-1,3) h m s];
l1=x(1:c-1,4);
l2=x(1:c-1,5);
l3=x(1:c-1,6);
buy=x(1:c-1,7);
sell=x(1:c-1,8);
bads=find(buy==0);
for i=bads
    if(i>1) buy(i)=buy(i-1); 
    else buy(1)=buy(find(buy~=0,1));
    end
end
bads=find(sell==0);
for i=bads
    if(i>1) sell(i)=sell(i-1); 
    else sell(1)=sell(find(sell~=0,1));
    end
end
if(size(x,2)<9) vol=zeros(size(sell));
else vol=x(1:c-1,9);
end
if(size(x,2)<10) ts=l3;
else ts=x(1:c-1,10);
end
if(size(x,2)<12) 
    bv=sell;
    av=buy;
else 
    bv=x(1:c-1,11);
    av=x(1:c-1,12);
end