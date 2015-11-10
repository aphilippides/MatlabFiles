% function AdmissionsStats

cd C:\Users\andrewop\Downloads
% cd C:\_MyDocuments\Current\Admissions\2011\AppLists

s=dir('Applicant List for Mail Merge*.xls');
fn='Apps2012Data.mat';
if 0%(isfile(fn))
    load(fn)
else
    C=NaN*zeros(length(s),1);
    U=C;UF=C;UI=C;CF=C;CI=C;XX=C;d=C;nyr=C;
end
% year='2011/2';
year='2012/3'
for i=1:length(s)
    dat=datenum(s(i).date);
    if 0%(ismember(dat,d))
    else
        i
        [a,b]=xlsread(s(i).name);
        % get 2011
        yrs=b(strmatch(year,b(:,1)),:);
        nyr(i)=size(yrs,1);
        d(i)=datenum(s(i).date);
        dst(i,:)=s(i).date(1:6);
        C(i)=length(strmatch('C',yrs(:,17)));
        U(i)=length(strmatch('U',yrs(:,17)));
        UF(i)=length(strmatch('UF',yrs(:,17)));
        CF(i)=length(strmatch('CF',yrs(:,17)));
        CI(i)=length(strmatch('CI',yrs(:,17)));
        UI(i)=length(strmatch('UI',yrs(:,17)));
        XX(i)=length(strmatch('XX',yrs(:,17)));
    end
end
[d,is]=sort(d);
C=C(is);UF=UF(is);CI=CI(is);U=U(is);XX=XX(is);CF=CF(is);nyr=nyr(is);
clear a b
save(fn)

subplot(2,1,1),
plot(d,C,d,CF,'b:x',d,CI,'r-s',d,XX,'k:')%,d,nyr,'r:')
% plot(d,CF,'b:x',d,CI,'r-s')%,d,nyr,'r:')
tp=get(gca,'XTick');
abb=datestr(tp);
d2st=abb(:,1:6);
SetXTicks(gca,[],[],[],[],d2st)
% SetXTicks(gca,[],[],[],d,dst(is,:))
axis tight,
subplot(2,1,2),
plot(d,U,d,UF,'b:x',d,UI,'r-s'),axis tight
SetXTicks(gca,[],[],[],tp,d2st)
% SetXTicks(gca,[],[],[],d,dst(is,:))
[UF(end) CF(end) CI(end) C(end) U(end) XX(end)]

figure(2)
subplot(2,1,1),
plot(d,CF,'b-x',d,CI,'r-s')%,d,nyr,'r:')
subplot(2,1,2),
plot(d,U,d,UF,'kx-',d,UI,'r-s'),axis tight

load('C:\_MyDocuments\Current\Admissions\2011\AppLists\Apps2011Data')
d2=d+datenum('1-1-2012')-datenum('1-1-2011');
subplot(2,1,1),
hold on
plot(d2,CF,'b:o',d2,CI,'r:')%,d,nyr,'r:')
tp=get(gca,'XTick');
abb=datestr(tp);
d2st=abb(:,1:6);
SetXTicks(gca,[],[],[],[],d2st)
hold off
axis tight,
subplot(2,1,2),
hold on
plot(d2,U,':',d2,UF,'k:',d2,UI,'r:'),axis tight
SetXTicks(gca,[],[],[],tp,d2st)
hold off
axis tight,
