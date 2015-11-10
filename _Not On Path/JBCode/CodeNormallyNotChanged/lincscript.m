Ts=[1 2 4 8 16 32 64]
for n=Ts
% VardyTest(n);
load(['resultsSn30_' int2str(n) '.mat']);
i=[1:(length(headM))]-30;
figure(n)
% plot(i,AngleWithoutFlip(headM)*180/pi,'b- .',i,AngleWithoutFlip(headV)*180/pi,'r- .')
% plot(i,headM*180/pi,'b- .',i,headV*180/pi,'r- .')
plot(i,angM*180/pi,'b- .',i,angV*180/pi,'r- .')
% plot(i,AngularDifference(headM,headV)*180/pi,'b- .')
axis tight
end