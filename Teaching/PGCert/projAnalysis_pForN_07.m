function projAnalysis

dwork; cd ..\Current\PForN2007
[a,b]=xlsread('PForN2007_QuestionnaireSummary.xls');

% put 0 where nan is
for i=1:21 a(i,find(isnan(a(i,:))))=0; end

% get 07 and 05 means
for i=1:2:21
    % compensate for didn't use
    if(i==19)
        Mean07(i) = sum(a(i,1:5).*[1:5])/sum(a(i,1:5));
        Mean05(i) = sum(a(i+1,1:5).*[1:5])/sum(a(i+1,1:5));
    elseif(i==21)
        Mean07(i) = sum(0.01*a(i,1:5).*[1:5]);
    else
        Mean07(i) = sum(0.01*a(i,1:5).*[1:5]);
        Mean05(i) = sum(0.01*a(i+1,1:5).*[1:5]);
    end
end

[a2,b]=xlsread('PhysForNeuro_2007.xls');
an=a2(2:end-2,:);
MathsLevels=frequencies(an(:,1)')/28
meanMathsLevel=MathsLevels*[1:4]'
for i=1:14
    Fs(i,:)=frequencies(round(an(:,i+1)),[1:5])/28
    meanFs(i)=Fs(i,:)*[1:5]'
end

MathsOf11=frequencies(a2(19:29,1)',1:4)/11
ab=a2(19:29,2:15);
af=a2(19:29,16:29);
d=af-ab
for i=1:14
    FFinals(i,:)=frequencies(round(af(:,i)),[1:5])/11
    meanFinalFs(i)=FFinals(i,:)*[1:5]'
    FsIncreased(i)=sum((d(:,i)>0))
    FsDecreased(i)=sum((d(:,i)<0))
    FsSame(i)=sum((d(:,i)==0))
end
[round(100*FsIncreased/11)' round(100*FsDecreased/11)']

imp=a2([19 20 23:31],30:43)
PCImp=round(100*sum(imp,1)/11)

PlotCol(30,a)
for i=1:30
    fs(i,:)=[i frequencies(a(:,i),[0:5])];
    pcs(i,:)=[i fs(i,2:end)*100/sum(fs(i,2:end))];
end
fs
pcs
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
[y,x]=hist(NonNans(:,2)-NonNans(:,1),[-3:3]);
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

