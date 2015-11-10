function[AugAlvRes]=ShowResults2( Rads)
% dmat; cd Linc;

[a,b]=xlsread('results_newmaybe.xls');
AugAlvRes=a(1:1080,1:10);
envs=1:30;
is=find(AugAlvRes(:,2)>=min(Rads));
AugAlvRes=AugAlvRes(is,:);
for i=1:length(Rads)
    isb = find(AugAlvRes(:,2)==Rads(i));
    %     s_aug(i) = mean(AugAlvRes(is2,3))*100;
    num_succ(i) = sum(AugAlvRes(isb,3));
    nb=find(AugAlvRes(isb,9)<2)
    num_bad(i) = length(find(AugAlvRes(isb,9)<=2))
end
s_aug2=(num_succ*100)./(30*ones(size(Rads))-num_bad);

keyboard;
plot(Rads*2,s_alv,'r--',Rads*2,s_aug,'LineWidth',3)
set(gca,'FontSize',14)
setbox
xlabel('Object diameter')
ylabel('Successful runs (%)')
plo
% xlim([40 80])

% 
% plot(num_succ)
% [y,il]=sort(num_succ);
% bads=envs(il);
% 
% for j=1:5
%     isbad=find(AugAlvRes(:,1)==bads(j));
%     AugAlvRes=RemoveRow(AugAlvRes,isbad);
%     alvRes=RemoveRow(alvRes,isbad);
%     for i=1:length(Rads)
%         is = find(alvRes(:,2)==Rads(i));
%         s_alv(i) = mean(alvRes(is,3))*100;
%         sum_alv(i) = sum(alvRes(is,3));
% 
%         is2 = find(AugAlvRes(:,2)==Rads(i));
%         s_aug(i) = mean(AugAlvRes(is2,3))*100;
%         sum_aug(i) = sum(AugAlvRes(is2,3));
%     end
% 
%     figure,
%     plot(Rads*2,s_alv,'r--',Rads*2,s_aug,'LineWidth',3)
%     set(gca,'FontSize',14)
%     setbox
%     xlabel('Object diameter')
%     ylabel('Successful runs (%)')
%     xlim([40 80])
% end
% keyboard
