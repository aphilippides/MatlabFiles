function FixPlots(FixR,FixN,FixL,TotalR,TotalN,TotalL)
%1 is length 2 median angle
bincenters=[5:10:175];
figure
subplot(3,1,1)
a=find(FixL(:,2)<0);hist(180-(FixL(a,2)*-57.3),bincenters);axis([0 180 0 35])
subplot(3,1,2)
a=find(FixN(:,2)<0);hist(180-(FixN(a,2)*-57.3),bincenters);axis([0 180 0 35])
subplot(3,1,3)
a=find(FixR(:,2)<0);hist(180-(FixR(a,2)*-57.3),bincenters);axis([0 180 0 35])

disp('d')

bincenters2=[11.25:22.5:168.75];

figure
subplot(3,1,1)
a=find(FixL(:,2)<0);hist(180-(FixL(a,2)*-57.3),bincenters2);axis([0 180 0 65])
subplot(3,1,2)
a=find(FixN(:,2)<0);hist(180-(FixN(a,2)*-57.3),bincenters2);axis([0 180 0 65])
subplot(3,1,3)
a=find(FixR(:,2)<0);hist(180-(FixR(a,2)*-57.3),bincenters2);axis([0 180 0 65])




bincenters3=[22.5:45:157.5];

figure
subplot(3,1,1)
a=find(FixL(:,2)<0);hist(180-(FixL(a,2)*-57.3),bincenters3);axis([0 180 0 120])
subplot(3,1,2)
a=find(FixN(:,2)<0);hist(180-(FixN(a,2)*-57.3),bincenters3);axis([0 180 0 120])
subplot(3,1,3)
a=find(FixR(:,2)<0);hist(180-(FixR(a,2)*-57.3),bincenters3);axis([0 180 0 120])













% % size(FixR)
% % mean(FixR(:,1))
% % TotalR
% % percentR=sum(FixR(:,1))/TotalR
% % 
% % size(FixL)
% % mean(FixL(:,1))
% % TotalL
% % percentL=sum(FixL(:,1))/TotalL
% % 
% % size(FixN)
% % mean(FixL(:,1))
% % TotalN
% % percentN=sum(FixN(:,1))/TotalN