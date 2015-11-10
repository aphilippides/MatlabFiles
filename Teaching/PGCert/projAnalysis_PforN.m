function projAnalysis_PforN

ddocs;
cd ../Current/PeerAssProject/
%cd Teaching\PGCertHE\PeerAssProject\
%[a,b]=xlsread('FCSResponses.xls');
%load FCSResponses.mat 

[a,b]=xlsread('PhysForNeuro_PAResponses.xls');
save PForN_Responses.mat 
%PlotCol(30,a)
for i=1:size(a,2)
    fs(i,:)=[i frequencies(a(:,i),[0:5])];
    pcs(i,:)=[i fs(i,2:end)*100/sum(fs(i,2:end))];
end
for i=3:7 
    Compare2Cols(i,i+7,a);
    figure
end
fs
pcs
% [r,p] = corrcoef(a,'rows','pairwise');
% pcolor(p), colorbar,
is=[3:7 10:15];
% CorrelateCols(8,is,a)
% CorrelateCols(9,is,a)

keyboard

function Compare2Cols(i,j,a)
NonNans=a(find(~isnan(a(:,i))),i);
[y1,x]=hist(NonNans,[0:5]);
NonNans=a(find(~isnan(a(:,j))),j);
[y2,x]=hist(NonNans,[0:5]);
subplot(2,1,1);
bar(x,[y1;y2]')
set(gca,'FontSize',14),Setbox,xlabel('Score'),ylabel('Frequency'),legend('initial','final')
NonNans=a(find(~isnan(a(:,i))&~isnan(a(:,j))),[i j]);
[y,x]=hist(NonNans(:,2)-NonNans(:,1),[-4:4]);
subplot(2,1,2),bar(x,y)
set(gca,'FontSize',14),Setbox,xlabel('Change'),ylabel('Frequency')
mstd=[mean(NonNans(:,1)) mean(NonNans(:,2)) mean(NonNans(:,2)-NonNans(:,1))]

function[AllMs,AllSDs,AllNs]=CorrelateCols(x,ys,a)
subplot(2,1,1);
plot(a(:,x),a(:,ys)+0.5*rand(size(a(:,ys)))-0.25,'x')
AllMs=[];AllSDs=[];AllNs=[];
for y=ys
    NonNans=a(find(~isnan(a(:,x))&~isnan(a(:,y))),[x y]);
    for i=0:5
        Means(i+1)=mean(NonNans(find(NonNans(:,1)==i),2));
        SDs(i+1)=std(NonNans(find(NonNans(:,1)==i),2));
        Ns(i+1)=length(find(NonNans(:,1)==i));
    end
    AllMs=[AllMs;Means];
    AllSDs=[AllSDs;SDs];
    AllNs=[AllNs;Ns];
end
AllMs
AllSDs
AllNs
subplot(2,1,2);
plot([0:5],AllMs')

function PlotCol(is,a)
ys=[];
for i=is
    NonNans=a(find(~isnan(a(:,i))),i);
    [y,x]=hist(NonNans,[0:5]);
    ys=[ys,y'];
    mstd=[mean(NonNans) std(NonNans)]
end
bar(x,ys)
set(gca,'FontSize',14),Setbox,xlabel('Score'),ylabel('Frequency')

