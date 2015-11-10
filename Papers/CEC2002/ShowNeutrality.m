function ShowNeutrality

dvolsig
%cd VS_HalfFlatAll
cd VS_ExpData
load NeutralityGeneElite
BarErrorBar(1:21,AvgN2,SDN2);
SetBox;
xlabel('Gene Value');
ylabel('% Neutrality');
axis tight

figure
%cd ../VS_OrigData
cd ../HalfFlatControl
load NeutralityGeneElite
whos
x=[1:14 17:21]
BarErrorBar(1:19,AvgN2(x),SDN2(x));
SetBox;
xlabel('Gene Value');
ylabel('% Neutrality');
axis tight