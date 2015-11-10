function ShowResults(l1,l2,l3,tvar,tsT,sT,buy,sell,TLength,TOv)

iv=1:length(l1);
plot(iv,l1,'g',iv,l2,'g')
hold on;
plot(iv,l3,'r',iv,tvar,'y',tsT,sT,'c','LineWidth',2);
[t1t2,tProf1,tProf2,NumTradesT]=GetTProf(tvar,l3,iv,buy,sell,TLength,TOv);

for k=1:size(t1t2,1)
    ind=t1t2(k,1);
    if(t1t2(k,2)==1) plot([ind ind],[l3(ind)-0.125 l3(ind)+0.125],'b--p','Linewidth',1);
    elseif(t1t2(k,2)==0) plot([ind ind],[l3(ind)-0.125 l3(ind)+0.125],'r--p','Linewidth',1);
    elseif(t1t2(k,2)==-1) plot([ind ind],[l3(ind)-0.125 l3(ind)+0.125],'b--s','Linewidth',1);
    else plot([ind ind],[l3(ind)-0.125 l3(ind)+0.125],'r--s','Linewidth',1);
    end
end
hold off;


function[t1t2,tProf1,tProf2,NumTradesT]= ...
    GetTProf(tvar,l3,iv,buy,sell,TLength,TOv)
if(nargin<6) TOv=0; end;
% get sells
ovs=find(tvar>(l3+TOv));
[s_o,e_o,l_o]=StartFinish(iv,ovs,1);
ss=find(l_o>TLength);
sells=s_o(ss)+TLength;
t1t2=[sells' zeros(length(sells),1) sell(sells)'];

% get buys
unders=find(tvar<(l3-TOv));
[s_o,e_o,l_o]=StartFinish(iv,unders,1);
bs=find(l_o>TLength);
buys=s_o(bs)+TLength;
t1t2=[t1t2;buys' ones(length(buys),1) buy(buys)'];
[dum,is]=sort(t1t2(:,1));
t1t2=t1t2(is,:);

if(t1t2(end,2)) t1t2=[t1t2;iv(end),-2,sell(end)];
else t1t2=[t1t2;iv(end),-1,buy(end)];
end

[t1,t2]=GetProfit(t1t2);
tProf1=sum(t1)
tProf2=sum(t2)
NumTradesT=length(t1)