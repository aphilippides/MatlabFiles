function tmpscriptRowland(rp)
dmat;
cd RHoar/LogData/;

s=dir('ex*sep*2007.txt')
for i=2:length(s)
    fn=s(i).name
    [m1,m2]=TestSetting_Treble_New(fn,600,15,0.5,1500,0,0.5,3300,0,0.5,240,24,1000)
    close all
end
return
fs=GetNames;
% for i=1:size(fs,1)
%     fn=['exceldata_' fs(i,:) '.txt'];
%     if(~isfile(fn))
%         a=[fn]
%     end
% end
% return
fs=fs(1:3:end,:);
% fs=GetNames(1)
% ns=[100:100:1000 1250:250:2000];
% es=[0:5:25 50 100];
% ns=[600 900 1200 1800 2400 3600];
ns=[100 300 600:300:3600];
% es=[0 5 15 50 100 200 300] 
es=[0 15 100 300] 
if(nargin<1)
    fo='DiagDataNew'
    rp=0; 
else 
%     fo=['UpDownData_All3_Rp' x2str(rp) '.mat']
    fo='DiagDataNew'
end;
c=1;
for i=1:size(fs,1)
     fn=['exceldata_' fs(i,:) '.txt']
%     fn='exceldata_06-Feb-2007.txt'
    [t,l1,l2,l3,b,s]=ReadLogData(fn);
    for j=7%1:length(ns)
        for k=1%:length(es)
             [Pr1,Pr2,nt,bs1,bs2]=TestSettingAll(l1,l2,l3,b,s,t,ns(j),es(k),rp,0,fn,0);
%             [Pr1,Pr2,nt,bs1,bs2]=TestSettingAll(l1,l2,l3,b,s,t,600,15,0.5,0,fn,1);
            b1(i,j,k)=Pr1;
            b2(i,j,k)=Pr2;
            Trs(i,j,k)=nt;
            Trs1(i,j,k)=max(length(bs1)-1,0);

            DiagData(c).ns=ns(j);
            DiagData(c).es=es(k);
            DiagData(c).fn=fn;
            DiagData(c).ntrs=nt;
            DiagData(c).p1=Pr1;
            DiagData(c).p2=Pr2;
            DiagData(c).bs1=bs1;
            DiagData(c).bs2=bs2;
            c=c+1;
            meanb1(j,k)=sum(b1(:,j,k))
            meanb2(j,k)=sum(b2(:,j,k))
            meanTrs(j,k)=sum(Trs(:,j,k))
%             save UpDownData_NewL3_Rp0 ns es DiagData b1 b2 Trs fs meanb1 meanb2 meanTrs rp
%             save(['DiagData_All_Rp' x2str(rp) '.mat'],'ns','es','DiagData','b1','b2','Trs','fs','meanb1','meanb2','meanTrs','rp');
            save(fo,'Trs1','ns','es','DiagData','b1','b2','Trs','fs','meanb1','meanb2','meanTrs','rp');
%             save DiagDataNew ns es DiagData b1 b2 Trs fs meanb1 meanb2 meanTrs rp
        end
    end
end
% keyboard
% 
% for i=1:length(DiagData)
%     ps(i)=GetProfitWithStop(DiagData(i).bs2,-10);
% end
% ps

% To get a settings diag data do:
% (j-1)*length(es) + k:length(es)*length(ns):end

function[fs]=GetNames(late)
fs=[];%'27-Sep_2006';
octs=[4,5,11,13,17:19,23:25,27,30,31];%16,26,
nov=[1,2,6,7,9,10,13:16,20:24,27:30];
dec=[1,5,6,8,11:13];
jan=[3:5,9,10 18,23:26,29:31 ];% ,12,16,22,
feb=[1,2,5,6,8,9,12:16 21:23 26:28];
mar=[1 5:9 12:15 19];

for i=octs
    if(i<10) fs=[fs;['0' int2str(i) '-Oct-2006']];
    else fs=[fs;[int2str(i) '-Oct-2006']];
    end
end
for i=nov
    if(i<10) fs=[fs;['0' int2str(i) '-Nov-2006']];
    else fs=[fs;[int2str(i) '-Nov-2006']];
    end
end
for i=dec
    if(i<10) fs=[fs;['0' int2str(i) '-Dec-2006']];
    else fs=[fs;[int2str(i) '-Dec-2006']];
    end
end
for i=jan
    if(i<10) fs=[fs;['0' int2str(i) '-Jan-2007']];
    else fs=[fs;[int2str(i) '-Jan-2007']];
    end
end
for i=feb
    if(i<10) fs=[fs;['0' int2str(i) '-Feb-2007']];
    else fs=[fs;[int2str(i) '-Feb-2007']];
    end
end
for i=mar
    if(i<10) fs=[fs;['0' int2str(i) '-Mar-2007']];
    else fs=[fs;[int2str(i) '-Mar-2007']];
    end
end
if(nargin==1)
    fs=[];
    for i=mar(4:end)
        if(i<10) fs=[fs;['0' int2str(i) '-Mar-2007']];
        else fs=[fs;[int2str(i) '-Mar-2007']];
        end
    end
end
%