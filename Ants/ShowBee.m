function[ff]=ShowBee(n,t,nc,flip,olm)

% cd F:\bum'blebee flights\'
if(ischar(n)) s=dir(['*90_' int2str(t) '_out' n 'Prog*.mat']);
else s=dir(['*90_' int2str(t) '_out' int2str(n) 'Prog*.mat']);
end
if(isempty(s)) 
    disp('No file processed'); 
    ff=[];
    return;
end;
ff=s.name
i=strfind(ff,'Prog');
f=ff(1:i-1);
load(ff);

% ff=['90_21_out' int2str(n) '.avi']
% i=strfind(ff,'.avi');
% f=ff(1:i-1);
% in=aviinfo(ff);
% load([f 'ProgDataT0.5_1_' int2str(in.NumFrames) '.mat'])

% Get nest and LM position
fn=[f 'NestLMData.mat'];
if(~isfile(fn)) 
    if(nargin<5) GetNestAndLMData(f); 
    else GetNestAndLMData(f,olm); 
    end
end;
load(fn)
ml=length(Cents);
if(nargin<4) flip = 0; end;
if(nargin<3) nc = 2; end;
os=CleanOrients(Orients,flip);
[EndPt(:,1) EndPt(:,2)]=pol2cart(os,10);
EndPt=EndPt+Cents;

VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,os');
vel=diff(Cents);
speed = sqrt(sum(vel.^2,2));
t=FrameNum*0.02;
c=1;
pausing=1;
sk=[];
while(c<=ml)
    oc=c;
    c=c+nc;
    is=oc:min(c,ml);
    i2=1:min(c,ml);

    if(pausing)
        subplot(4,1,1)
        plot(nest(1),nest(2),'gs')
        hold on;
        MyCircle(LM,LMWid);
        plot(EndPt(i2,1),EndPt(i2,2),'y.')
        plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','y')
        plot(EndPt(is,1),EndPt(is,2),'r.')
        plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','r')
        hold off;

        subplot(4,1,2)
        plot(t(i2),NestOnRetina(i2)*180/pi);
        subplot(4,1,3)
        plot(t(i2),DToNest(i2));% XLim(t([1 end]))
        hold on;
        %plot(t(i2),speed(i2),'r')
        subplot(4,1,4)
        plot(t(i2),OToNest(i2)*180/pi);

        sk=input('return to continue, 0 return to skip, # to do more frames')
    end
    if(sk==0) pausing=0;
    elseif(isnumeric(sk)&~isempty(sk)) nc=sk;
    end
end
subplot(4,1,1)
plot(nest(1),nest(2),'gs')
hold on;
MyCircle(LM,LMWid);
plot(EndPt(i2,1),EndPt(i2,2),'y.')
plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','y')
plot(Cents(i2,1),Cents(i2,2),'r')
hold off;

subplot(4,1,2)
plot(t(i2),NestOnRetina(i2)*180/pi);axis tight;grid
subplot(4,1,3)
plot(t(i2),DToNest(i2));axis tight;grid
hold on;
% plot(t(i2),speed(i2),'r')
subplot(4,1,4)
plot(t(i2),OToNest(i2)*180/pi,t(i2),os*180/pi,'r');axis tight;grid
figure(2)
subplot(1,2,1)
rose(NestOnRetina,40)
subplot(1,2,2)
plot(NumBees)