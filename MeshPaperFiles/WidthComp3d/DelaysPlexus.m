function DelaysPlexus

Singplot;
d3dmm;
load Times2RiseV50_79SSt1Gr300X100Sq1Wids1_5;
% load Times2RiseV100_130SSt1Gr200X100Sq1Wids1_5_100nM
axis tight;
BarErrorBar(invert(wid),AvgT*1000,SDT*1000);
set(gca,'FontSize',14)
xlabel('Diameter (\mum)');
ylabel('Delay (ms)');
Setbox;
%SetXTicks(gca,5,1,[],[0:0.1:0.2])
YLim([0,205])
SetYTicks(gca,3,1,[],[0:100:200])
% YLim([0,42])
% SetYTicks(gca,3,1,[],[0:10:40])
SetXTicks(gca,5,1,[],[1:5],int2str([5:-1:1]'))
