function[stopline]=StopL1(t,p,ts,l2)
gs=(p-l2)./(t-ts);
[m,j]=min(gs);
stopline=[t p;l2(j) t(j);m 0];