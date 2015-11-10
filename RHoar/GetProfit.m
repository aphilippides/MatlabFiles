function[Profit1,Profit2,TransTime]=GetProfit(buysell,t)

Profit1=[];Profit2=[];TransTime=[];
if(isempty(buysell)) return; end;

is=find(buysell(:,2)<0)';
ks=find(diff(is)==1);
buysell=RemoveRow(buysell,is(ks)+1);
is=find(buysell(:,2)<0)';
if(isempty(is)) [Profit1,Profit2]=GetP(buysell); 
else
    bsold=0;
    for bs=is
        temp_bs=buysell(bsold+1:bs,:);
        if(mod(buysell(bs,2),2)) temp_bs(end,2)=1;
        else temp_bs(end,2)=0;
        end
        %     if(buysell(bs,2)==-1) temp_bs(end,2)=1;
        %     else temp_bs(end,2)=0;
        %     end
        [p1,p2]= GetP(temp_bs);
        Profit1=[Profit1 p1];
        Profit2=[Profit2 p2];
        bsold=bs;
    end
end

function[Profit1,Profit2]=GetP(buysell)
m=size(buysell,1);
i=1;
k=1;
Profit1=[];Profit2=[];
while 1
    if(i>m) break; end
    bs=mod(buysell(i,2)+1,2);
    n=find(buysell(i+1:end,2)==bs,1);
    if(isempty(n)) break; end;
    nx=n+i;
    Profit1(k)=buysell(nx,3)-buysell(i,3);
    Profit2(k)=buysell(nx,3)*n-sum(buysell(i:nx-1,3));
    i=nx;
    if(bs)
        Profit1(k)=-Profit1(k);
        Profit2(k)=-Profit2(k);
    end
    k=k+1;
end