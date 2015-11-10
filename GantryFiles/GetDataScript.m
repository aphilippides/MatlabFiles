function GetDataScript

dwork
cd Gantry\VolSig1\Data
% getdata
testdata
% cd VS_HalfFlatAll
% cd VS_OrigData
% 
% for i=1:40
%     h=load(['ConnMatrixRun' int2str(i) '.dat']);
%     numnodes(i) = length(h)/3
% end
% m = mean(numnodes) 
% sd = std(numnodes) 
% save NumNodes.mat numnodes m sd

% getdata
% testdata

function[d,c]=testdata
c=[];d=[];e=[];f=[];
ce=[];de=[];ee=[];fe=[];
for i=1:2
%     load(['PlexusControl' int2str(i) '.mat'])    
    load(['PlexusControl' int2str(i+1) 'Bests.mat'])
    c=[c RunLengths];
    ce=[ce etimes];
%     load(['PlexusInst' int2str(i) '.mat'])
%     d=[d RunLengths];
%     de=[de etimes];
%     load(['PlexusSpace_Whole' int2str(i) '.mat'])
    load(['PlexusWhole' int2str(i) 'Bests.mat'])
    e=[e RunLengths];
    ee=[ee etimes];
%     load(['PlexusSpace_Decoupled' int2str(i) '.mat'])
%     f=[f RunLengths];
%     fe=[fe etimes];
end
[h,med_p]=ranksum(e,c)
[h,tt_p]=ttest2(e,c)

subplot(1,3,1),errorbar(1:2,mean([d;c],2),std([d;c]'))
subplot(1,3,2),bar(1:2,median([d;c],2))
subplot(1,3,3),
plot(sort(d))
hold on
plot(sort(c),'r')
hold off

function getdata
%cd VS_HalfFlat2/
%cd PlexusInst/
% cd PlexusSpace_Whole/Test1
%cd PlexusSpace_DeCoupled
cd Plexus_Control/Test3
bests=ones(10000,20);
etimes=[];TuningTimes=[];
for i=1:20
    p=load(['Run' int2str(i) '/pop.dat']);
    n=size(p,1);
    bests(1:n,i)=p(:,2);
     RunLengths(i)=p(end,1);
   fid=fopen(['Run' int2str(i) '/IndFittest.dat'],'r');
    a=fgetl(fid);
    n=sscanf(a,'%d');
    fclose(fid);
    ts=n(12:21:end);
    if(RunLengths(i)<2499)
        meane(i)=mean(ts);
        sde(i)=std(ts);
        etimes=[etimes ts'];
    end
    a=min(find(p(:,2)>=1));
    if(~isempty(a)) TuningTimes=[TuningTimes RunLengths(i)-a]; end;
end
% save ../PlexusInst2.mat RunLengths bests meane sde etimes
save ../../PlexusControl3Bests.mat RunLengths bests meane sde etimes
c='r';
subplot(1,3,1)
[s,is]=sort(RunLengths);
plot(s,c), hold on
subplot(1,3,2) 
plot(sort(TuningTimes),c), hold on
subplot(1,3,3)
plot(median(bests(1:2500,:),2),c), hold on
figure
subplot(1,2,1),errorbar(meane,sde)
subplot(1,2,2),hist(etimes,[5:10:100])
m=[mean(TuningTimes) std(TuningTimes)]
median(RunLengths)