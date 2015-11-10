function ImportInsightData

% fn='Data0008.txt';
% change this to what you want
fn='Data0018.txt';
getStuff(fn)

% s=dir('*.txt');
% for i=1:length(s)
%     fn=s(i).name;
%     getStuff(fn);
% end


function SaveChannelData(fout)
load(fout,'ChanNum')
f2=[fout(1:end-4) 'Spikes.mat'];

% columns
% A_Nodes=[12:1:17 21:1:28 31:1:38];
% B_Nodes=[41:1:48 51:1:58 61:1:68 71:1:78 82:1:87];
% C_Nodes=[];

% rows
A_Nodes=[16:10:86 17:10:87 28:10:78];
B_Nodes=[12:10:82 21:10:71 13:10:83 14:10:84];
C_Nodes=[15:10:85];

% define the active ones
% A_Act=[47 67 77 87 28 68 78];
% B_Act=[21 41 51 61 12 22 42 52 62 82];
% C_Act=[33 43 53 14 34 44 54 26 76];

A_Act=[17 46 77 86 87];
B_Act=[22 33 34 53 54 61 63 71 73 82 84];
C_Act=[];

% ignore below here

ChanAct(1).ch=ChanNum(A_Act);
ChanAct(1).name=A_Act;
ChanAct(2).ch=ChanNum(B_Act);
ChanAct(2).name=B_Act;
ChanAct(3).ch=ChanNum(C_Act);
ChanAct(3).name=C_Act;

ChanAll(1).ch=ChanNum(A_Nodes);
ChanAll(1).name=A_Nodes;
ChanAll(2).ch=ChanNum(B_Nodes);
ChanAll(2).name=B_Nodes;
ChanAll(3).ch=ChanNum(C_Nodes);
ChanAll(3).name=C_Nodes;

save(fout,'Chan*','A_*','B_*','C_*','-append');

function getStuff(fn)
fout=[fn(1:end-4) '.mat'];
% fout2=[fn(1:end-4) '_2.mat'];
nl=1e6;
maxlen=3e6;

d=zeros(nl,61);
fid=fopen(fn);

for i=1:4
    tl=fgetl(fid);
end

dat=[];
i=1;
tic
while 1
    tl=fgetl(fid);
    if((~ischar(tl))||(i>maxlen))
%         save(fout,'d2');
        dat=[dat;d(1:(i-1),:)];
        t=dat(:,1)/1000;
        dat=dat(:,2:end);
        save(fout,'dat','t');
        break;
    else
        d(i,:)=str2num(tl);
    end
    if(mod(i,nl)==0)
        dat=[dat;d];
        a=size(dat,1)
        i=0;
%         save(fout,'dat');
        toc
    end
    i=i+1;
end
toc

% for i=1:nl
%     tl=fgetl(fid);
% end
fclose(fid)
ChanNum=GetChannelNames(fn,fout);

function getStuffV2(fn)
fout=[fn(1:end-4) '.mat'];
fout2=[fn(1:end-4) '_3.mat'];
nl=1e6;
d=zeros(nl,61);
fid=fopen(fn);

for i=1:4
    tl=fgetl(fid);
end

dat=zeros(nl*5,61);
i=1;
tic
while 1
    tl=fgetl(fid);
    if ~ischar(tl)
        save(fout,'dat','t');        
        dat=dat(1:(i-1),:);
        t=dat(:,1)/1000;
        dat=dat(2:end,:);
        save(fout2,'dat','t');
        break;
    else
        d(i,:)=str2num(tl);
    end
    if(mod(i,nl)==0)
        i
        save(fout,'dat');
        toc
    end
    i=i+1;
    if(i>size(dat,1))
        dat=[dat;d];
    end
end
toc
% for i=1:nl
%     tl=fgetl(fid);
% end
fclose(fid)
ChanNum=GetChannelNames(fn,fout);


function[ChanNum]=GetChannelNames(fn,fout)
fid=fopen(fn);

for i=1:3
    tl=fgetl(fid);
end
fclose(fid)
ChanNames=ExtractNumbers(tl);
ChanNum=zeros(1,88);
for i=1:88
    c=find(ChanNames==i);
    if(~isempty(c))
        ChanNum(i)=c;
    end
end
save(fout,'ChanNames','ChanNum','-append');
SaveChannelData(fout)


