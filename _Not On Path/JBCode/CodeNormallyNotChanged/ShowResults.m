function[AugAlvRes]=ShowResults( Rads)
dmat; cd Linc;

% [a,b]=xlsread('result_AALV.xls');
% AugAlvRes=a(1:end,1:3);


AugAlvRes=load('result_AALV_new.txt','-ascii');
alvRes=load('result_ALV.txt','-ascii');
envs=1:30;
is=find(AugAlvRes(:,2)>=min(Rads));
AugAlvRes=AugAlvRes(is,:);
for i=1:30
    isb = find(AugAlvRes(:,1)==i);
    %     s_aug(i) = mean(AugAlvRes(is2,3))*100;
    num_succ(i) = sum(AugAlvRes(isb,3));
end
plot(num_succ)
[y,il]=sort(num_succ);
bads=envs(il);

for j=1:5
    isbad=find(AugAlvRes(:,1)==bads(j));
    AugAlvRes=RemoveRow(AugAlvRes,isbad);
    alvRes=RemoveRow(alvRes,isbad);
    for i=1:length(Rads)
        is = find(alvRes(:,2)==Rads(i));
        s_alv(i) = mean(alvRes(is,3))*100;
        sum_alv(i) = sum(alvRes(is,3));

        is2 = find(AugAlvRes(:,2)==Rads(i));
        s_aug(i) = mean(AugAlvRes(is2,3))*100;
        sum_aug(i) = sum(AugAlvRes(is2,3));
    end

    figure,
    plot(Rads*2,s_alv,'r--',Rads*2,s_aug,'LineWidth',3)
    set(gca,'FontSize',14)
    setbox
    xlabel('Object diameter')
    ylabel('Successful runs (%)')
    xlim([40 80])
end
keyboard
