function[tim,l1,l2,l3,buy,sell]=ReadLogData(fn)
fid =fopen(fn);
fgetl(fid);fgetl(fid);
x=zeros(32400,8);
for c=1:32400
    tline = fgetl(fid);
    if ~ischar(tline), break, end
     a=sscanf(tline,'%d:%d:%d\t%f\t%f\t%f\t%f\t%f');
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