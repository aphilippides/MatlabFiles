function[l1,l2,l3,s1,s2,s3,s12,s22,s32,Up3,Down3,Up32,Down32,Up2,Down1,Up22,Down12,Lud,Lud2,en] ...
    = InitialiseDouble(dat,opt,ns,ep,rp,ns2,ep2,rp2,nsud,epud,rpud,nsud2,epud2,rpud2);

c=datenum(dat);
for i=1:10
    d=datestr(c-i,1);
    fin=['exceldata_' d '.txt'];
    if(isfile(fin)) break; end;
end
% Blank Initialisation
if(opt|(~isfile(fin)))
    keyboard
    l1=[];l2=[];l3=[];s1=[];s2=[];s3=[];s12=[];s22=[];s32=[];
    Up3=[];Down3=[];Up32=[];Down32=[];Up2=[];Down1=[];Up22=[];Down12=[];
    ex=0;
    return
end

[tim,l1,l2,l3,B,S]=ReadLogData(fin);
% Get the start and end times
tsecs=TimeSecs(tim(:,4:6));
te=TimeSecs([16,29,59]);
e=find([tsecs<=te],1,'last');
st=1:e-1;
B=B(st)'; S=S(st)'; l3=l3(st)'; l1=l1(st)'; l2=l2(st)';
tsecs=tsecs(st);

% Run the testsettings and prepare the start variables
[bs,Up3,Down3,s3]=DiagonalProfit('t',l1,l2,l3,B,S,tsecs,tim,ns,ep,rp,0);
[bs,Up32,Down32,s32]=DiagonalProfit('t',l1,l2,l3,B,S,tsecs,tim,ns2,ep2,rp2,0);
[ud,Up2,Down1,s1,s2,Lud]=UDProfit('t',l1,l2,l3,B,S,tsecs,tim,nsud,epud,rpud,0);
[ud,Up22,Down12,s12,s22,Lud2]=UDProfit('t',l1,l2,l3,B,S,tsecs,tim,nsud2,epud2,rpud2,0);

% set times to what they should be: think the min to the max
% get the unsmoothed lines to start the data
m=max([7200,ns,ns2,nsud,nsud2])-1;
en=length(l1);
l1=l1((end-m):end);
l2=l2((end-m):end);
l3=l3((end-m):end);
s1=s1((end-m+0.5*nsud):end);
s12=s12((end-m+0.5*nsud2):end);
s2=s2((end-m+0.5*nsud):end);
s22=s22((end-m+0.5*nsud2):end);
s3=s3((end-m+0.5*ns):end);
s32=s32((end-m+0.5*ns2):end);
Up3(:,2)=Up3(:,2)-en;
Up32(:,2)=Up32(:,2)-en;
Up2(:,2)=Up2(:,2)-en;
Up22(:,2)=Up22(:,2)-en;
Down3(:,2)=Down3(:,2)-en;
Down32(:,2)=Down32(:,2)-en;
Down1(:,2)=Down1(:,2)-en;
Down12(:,2)=Down12(:,2)-en;
en=length(l1);

% smoothed data: last 3 points needed - if not plotting old stuff
% s1=s1((end-2):end);
% s12=s12((end-2):end);
% s2=s2((end-2):end);
% s22=s22((end-2):end);
% s3=s3((end-2):end);
% s32=s32((end-2):end);