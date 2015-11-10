function[pr,Profit1,Profit2]=GetProfAdder(bsf,bss)

bsf=RemoveMults(bsf);
bss=RemoveMults(bss);
[Profit1,Profit2,TransTime]=GetProfit(CombineProfs(bsf,bss));
pr=sum(Profit2);

% Profit1=[];Profit2=[];TransTime=[];
% if(isempty(buysell)) return; end;
% 
% is=find(buysell(:,2)<0)';
% ks=find(diff(is)==1);
% buysell=RemoveRow(buysell,is(ks)+1);
% is=find(buysell(:,2)<0)';
% if(isempty(is)) [Profit1,Profit2]=GetP(buysell); 
% else
%     bsold=0;
%     for bs=is
%         temp_bs=buysell(bsold+1:bs,:);
%         if(mod(buysell(bs,2),2)) temp_bs(end,2)=1;
%         else temp_bs(end,2)=0;
%         end
%         %     if(buysell(bs,2)==-1) temp_bs(end,2)=1;
%         %     else temp_bs(end,2)=0;
%         %     end
%         [p1,p2]= GetP(temp_bs);
%         Profit1=[Profit1 p1];
%         Profit2=[Profit2 p2];
%         bsold=bs;
%     end
% end
% 
% function[Profit1,Profit2]=GetP(bsF,bsS)
% m=size(bsf,1);
% i=1;
% k=1;
% Profit1=[];Profit2=[];
% while 1
%     if(i>m) break; end
%     FSig=bsF(i,2);
%     bF=mod(FSig+1,2);
%     stF=bsF(i,1);
%     nxSlow=find(bsS(:,1)>=stF,1);
%     if(isempty(nxSlow)) 
%         nxFast=find(bsF(i+1:end,2)==bF,1);
%         if(isempty(nxFast)) return;
%         else
%             nxFast=nxFast+i;
%             if(FSig) Prof(k)=bsF(nxFast,3)-bsF(i,3);
%             else Prof(k)=bsF(i,3)-bsS(nxFast,3);
%             end
%             i=nx;
%             k=k+1;
%         end
%     elseif(bsS(nxSlow,2)==FSig)
%         nxFast=find(bsF(i+1:end,2)==bF,1);
%         if(isempty(nxFast))
%             if(FSig) Prof(k)=bsS(nxSlow,3)-bsF(i,3);
%             else Prof(k)=bsF(i,3)-bsS(nxSlow,3);
%             end
%             return;
%         elseif(bsF(nxFast,1)<bsS(nxSlow,1))
%             if(FSig) Prof(k)=bsS(nxSlow,3)-bsF(i,3);
%             else Prof(k)=bsF(i,3)-bsS(nxSlow,3);
%             end
%             return;
%              nx=n+i;
%            i=nx;
%             k=k+1;
%         else
%             if(FSig) Prof(k)=bsS(nxSlow,3)-bsF(i,3);
%             else Prof(k)=bsF(i,3)-bsS(nxSlow,3);
%             end
%             return;
%              nx=n+i;
%            i=nx;
%             k=k+1;
%         end
%     else
%     end
%     eF=find(bsF(i+1:end,2)==bF,1);
%     if(isempty(n)) break; end;
% end