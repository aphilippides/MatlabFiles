function[k,lag]=CorrelateFDirAndBody(Cent_Os,sOr,t);   
c=AngleWithoutFlip(Cent_Os)*180/pi;
s=AngleWithoutFlip(sOr)*180/pi;
subplot(2,1,1)
% plot(t,c-mean(c),t,s-mean(s),'r')
fdir=AngularDifference(Cent_Os,sOr)*180/pi;
plot(t,fdir,t,sOr*180/pi,'r',t,Cent_Os*180/pi,'k')
% subplot(3,1,2)
% plot(t,s)
subplot(2,1,2)
plot(Cent_Os*180/pi,sOr*180/pi,'-',fdir,sOr*180/pi,'r')
% plot(medfilt1(c,15),s,'-')
k=1;lag=0;