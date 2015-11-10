function[m,i]=TomsDataAnalysis
% ntowns = 175000
nsamps = 1000;
% n=GetSecs;
% load TomData
% % [a,b]=xlsread('DummyDataForAndy.csv');
% % means=a(:,1)';
% % stds=a(:,2)';
% ntowns=length(means);
% randn('state',sum(100*clock));
% ranks=zeros(1,ntowns);
% save dummy
% ts=GetSecs;
% ts-n
% % f='outfile.dat';
% %         str=['outfile.txt'];
% %         f=fopen(str,'a');
% for i=1:nsamps    
%     scores=means+stds.*randn(1,ntowns);
%     [s,inds]=sort(scores);
%     for j=1:ntowns
%         ranks(inds(j))=j;
%     end
%      str=['out' int2str(i) '.mat'];
%      save(str,'ranks')%,'tt')
% %      tt(i)=GetSecs-ts    
% %         fprintf(f,'%d ',ranks);
% %          fprintf(f,'\n');
% end

ts=GetSecs;
sn=1e4;
me=zeros(1,165665);
pcm=zeros(3,165665);
rankM=zeros(nsamps,sn);
il=1:sn;
for j=0:15
    is=il+j*sn;
    for i=1:nsamps
        str=['out' int2str(i) '.mat'];
        load(str);
        rankM(i,:)=ranks(is);
        %      tt(i)=GetSecs-ts
        %         fprintf(f,'%d ',ranks);
        %          fprintf(f,'\n');
    end
    me(is)=mean(rankM);
    pcm(:,is)=prctile(rankM,[2.5 50 97.5]);
    GetSecs-ts
end
is=160001:165665;
rankM=zeros(nsamps,5665);
for i=1:nsamps
    str=['out' int2str(i) '.mat'];
    load(str);
    rankM(i,:)=ranks(is);
    %      tt(i)=GetSecs-ts
    %         fprintf(f,'%d ',ranks);
    %          fprintf(f,'\n');
end
me(is)=mean(rankM);
pcm(:,is)=prctile(rankM,[2.5 50 97.5]);
GetSecs-ts
save Tomoutdata me pcm
load TomNameData
fid=fopen('test6.csv','w');
fprintf(fid,'OA Code,Mean,Median,2.5 percentile,97.5 percentile,\n');
for i=1:165665
     fprintf(fid,'%s,%f,%f,%f,%f\n',char(b(i)),me(i),pcm(2,i),pcm(1,i),pcm(3,i));
end
% % fprintf(fid,'%s\n',b(end));
% for i=1:165664
%     fprintf(fid,'%f,',me(i));
% end
% fprintf(fid,'%f\n',me(end));
% for j=1:3
%     for i=1:165664
%         fprintf(fid,'%f,',pcm(j,i));
%     end
%     fprintf(fid,'%f\n',pcm(j,end));
% end
fclose(fid)
GetSecs-ts
% fclose(f);
% tt
