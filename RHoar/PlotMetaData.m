% function PlotMetaData(f,ns,ol3)
% ns=[1 20:20:100];
% fasts=[2:2:10];
% th=[0 10 20 25:25:100 150];
% es=[0 5 15 50 100 200 300]

% ns=1;
% for ns=1:6
for f=1:5
    for i=1:6
    for j=1:8
%         if((i==7)&(j==6)) return; end;
		f2ndXp1(i,j)=ol3(f,ns,j,i).f2ndXp1;
        f2ndXp2(i,j)=ol3(f,ns,j,i).f2ndXp2;
        f2ndXnt(i,j)=ol3(f,ns,j,i).f2ndXnt;

        f1stXp1(i,j)=ol3(f,ns,j,i).f1stXp1;
        f1stXp2(i,j)=ol3(f,ns,j,i).f1stXp2;
        f1stXnt(i,j)=ol3(f,ns,j,i).f1stXnt;

        fsm2ndXp1(i,j)=ol3(f,ns,j,i).fsm2ndXp1;
        fsm2ndXp2(i,j)=ol3(f,ns,j,i).fsm2ndXp2;
        fsm2ndXnt(i,j)=ol3(f,ns,j,i).fsm2ndXnt;

        fsm1stXp1(i,j)=ol3(f,ns,j,i).fsm1stXp1;
        fsm1stXp2(i,j)=ol3(f,ns,j,i).fsm1stXp2;
        fsm1stXnt(i,j)=ol3(f,ns,j,i).fsm1stXnt;

        smf2ndXp1(i,j)=ol3(f,ns,j,i).smf2ndXp1;
        smf2ndXp2(i,j)=ol3(f,ns,j,i).smf2ndXp2;
        smf2ndXnt(i,j)=ol3(f,ns,j,i).smf2ndXnt;

        smf1stXp1(i,j)=ol3(f,ns,j,i).smf1stXp1;
        smf1stXp2(i,j)=ol3(f,ns,j,i).smf1stXp2;
        smf1stXnt(i,j)=ol3(f,ns,j,i).smf1stXnt;

        fastslowp1(i,j)=ol3(f,ns,j,i).fastslowp1;
        fastslowp2(i,j)=ol3(f,ns,j,i).fastslowp2;
        fastslownt(i,j)=ol3(f,ns,j,i).fastslownt;
    end
    end
%     m_f2ndXp1(ns,:)=mean(f2ndXp1);
%     m_f1stXp1(ns,:)=mean(f1stXp1);
%     m_fsm2ndXp1(ns,:)=mean(fsm2ndXp1);
%     m_fsm1stXp1(ns,:)=mean(fsm1stXp1);
%     m_smf2ndXp1(ns,:)=mean(smf2ndXp1);
%     m_smf1stXp1(ns,:)=mean(smf1stXp1);
%     m_fastslowp1(ns,:)=mean(fastslowp1);
    m_f2ndXp1(f,:)=mean(f2ndXp1);
    m_f1stXp1(f,:)=mean(f1stXp1);
    m_fsm2ndXp1(f,:)=mean(fsm2ndXp1);
    m_fsm1stXp1(f,:)=mean(fsm1stXp1);
    m_smf2ndXp1(f,:)=mean(smf2ndXp1);
    m_smf1stXp1(f,:)=mean(smf1stXp1);
    m_fastslowp1(f,:)=mean(fastslowp1);
end
