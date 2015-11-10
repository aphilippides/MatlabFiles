function[errs] = CalculateOrientErrors(fn,os,cents)

load(fn)
% c_os=CleanOrients(os);
if(abs(os(1)-Orients(1))>pi/2) flip=1;
else flip=0;
end
c_ors=CleanOrients(Orients,flip);

if(length(os')==length(c_ors)) errs=os'-c_ors;
else
    for i =1:length(c_ors);
        dist(:,1) = (cents(:,1) - Cents(i,1)).^2;
        dist(:,2) = (cents(:,2) - Cents(i,2)).^2;
        [d,closest]=min(sum(dist,2));
        errs(i)=os(closest)-c_ors(i);
    end
end
i1=find(errs>pi);
errs(i1)=2*pi-errs(i1);
i2=find(errs<-pi);
errs(i2)=2*pi+errs(i2);
mean(abs(errs))*180/pi
median(abs(errs))*180/pi
figure
plot(os)
hold on;
plot(c_ors,'r')
plot(errs,'g')
hold off