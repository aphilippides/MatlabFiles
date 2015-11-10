function metatestRowland
dmat;
cd RHoar/LogData/;

fs=GetNames;
% for i=1:size(fs,1)
%     fn=['exceldata_' fs(i,:) '.txt'];
%     if(~isfile(fn))
%         a=[fn]
%     end
% end
% return
fs=fs(1:end,:);
% fs=GetNames(1)
ns=[1 20:20:100];
fasts=[2:2:10];
th=[0 10 20 25:25:100 150];
% es=[0 5 15 50 100 200 300] 

for i=1:length(fs)
    fn=fs(i).name;
    [tim,l1,l2,l3,buy,sell,vol,tvar,BV,AV]=ReadLogDataVol(fn);
    inp.l3=l3;
    inp.buy=buy;
    inp.sell=sell;
    for j=1:length(fasts)
        for k=1:length(ns)
            for l=1:length(th)
                a=[i j k l]
                [out]=TestCCI(inp,60,fasts(j),fasts(j)+6,ns(k),th(l),2);
                ol3(j,k,l,i).f2ndXp1=out.f2ndXp1;
                ol3(j,k,l,i).f2ndXp2=out.f2ndXp2;
                ol3(j,k,l,i).f2ndXnt=out.f2ndXnt;

                ol3(j,k,l,i).f1stXp1=out.f1stXp1;
                ol3(j,k,l,i).f1stXp2=out.f1stXp2;
                ol3(j,k,l,i).f1stXnt=out.f1stXnt;

                ol3(j,k,l,i).fsm2ndXp1=out.fsm2ndXp1;
                ol3(j,k,l,i).fsm2ndXp2=out.fsm2ndXp2;
                ol3(j,k,l,i).fsm2ndXnt=out.fsm2ndXnt;

                ol3(j,k,l,i).fsm1stXp1=out.fsm1stXp1;
                ol3(j,k,l,i).fsm1stXp2=out.fsm1stXp2;
                ol3(j,k,l,i).fsm1stXnt=out.fsm1stXnt;

                ol3(j,k,l,i).smf2ndXp1=out.smf2ndXp1;
                ol3(j,k,l,i).smf2ndXp2=out.smf2ndXp2;
                ol3(j,k,l,i).smf2ndXnt=out.smf2ndXnt;

                ol3(j,k,l,i).smf1stXp1=out.smf1stXp1;
                ol3(j,k,l,i).smf1stXp2=out.smf1stXp2;
                ol3(j,k,l,i).smf1stXnt=out.smf1stXnt;

                ol3(j,k,l,i).fastslowp1=out.fastslowp1;
                ol3(j,k,l,i).fastslowp2=out.fastslowp2;
                ol3(j,k,l,i).fastslownt=out.fastslownt;

%                 save(CCIData,'Trs1','ns','es','DiagData','b1','b2', ...
%                     'Trs','fs','meanb1','meanb2','meanTrs','rp');
                save('CCIData.mat','ol3');
            end
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
%'27-Sep_2006';
fs=dir('excel*sep*2007.txt');
fs=[fs;dir('excel*oct*2007.txt')];
fs=[fs;dir('excel*nov*2007.txt')];

% octs=[4,5,11,13,17:19,23:25,27,30,31];%16,26,
% nov=[1,2,6,7,9,10,13:16,20:24,27:30];
% dec=[1,5,6,8,11:13];
% jan=[3:5,9,10 18,23:26,29:31 ];% ,12,16,22,
% feb=[1,2,5,6,8,9,12:16 21:23 26:28];
% mar=[1 5:9 12:15 19];
% 
% for i=octs
%     if(i<10) fs=[fs;['0' int2str(i) '-Oct-2006']];
%     else fs=[fs;[int2str(i) '-Oct-2006']];
%     end
% end
% for i=nov
%     if(i<10) fs=[fs;['0' int2str(i) '-Nov-2006']];
%     else fs=[fs;[int2str(i) '-Nov-2006']];
%     end
% end
% for i=dec
%     if(i<10) fs=[fs;['0' int2str(i) '-Dec-2006']];
%     else fs=[fs;[int2str(i) '-Dec-2006']];
%     end
% end
% for i=jan
%     if(i<10) fs=[fs;['0' int2str(i) '-Jan-2007']];
%     else fs=[fs;[int2str(i) '-Jan-2007']];
%     end
% end
% for i=feb
%     if(i<10) fs=[fs;['0' int2str(i) '-Feb-2007']];
%     else fs=[fs;[int2str(i) '-Feb-2007']];
%     end
% end
% for i=mar
%     if(i<10) fs=[fs;['0' int2str(i) '-Mar-2007']];
%     else fs=[fs;[int2str(i) '-Mar-2007']];
%     end
% end
% if(nargin==1)
%     fs=[];
%     for i=mar(4:end)
%         if(i<10) fs=[fs;['0' int2str(i) '-Mar-2007']];
%         else fs=[fs;[int2str(i) '-Mar-2007']];
%         end
%     end
% end
%