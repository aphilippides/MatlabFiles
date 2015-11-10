function CheckTrackBee2012%(AllN)
s=dir('*.avi')
is=[3 7 13 14 4];
% plot(NumBees)
Ts=30:10:50;
alles=[];
for i=1:5
    CheckNumBees([30 50],s(is(i)).name,2,0)
%     [dat,handf]=CheckMultThresholds(Ts,s(is(i)).name,2,0);
%     [dat,es,es_s]=GetErrors(handf);
%     alles=[alles [es;es_s]];
end


figure(3)
subplot(2,1,1),hist(alles(1:3,:)'*180/pi)
subplot(2,1,2),hist(alles(4:6,:)'*180/pi)
[mean(alles,2) median(alles,2)]
keyboard;

function CheckNumBees(Ts,AllN,m,opt)
    fn=[AllN(1:end-4) '_ProgThresh' int2str(Ts(m)) '.mat'];
    load(fn)
mb=NumBees;
figure(1)
plot(Areas)
for i=1:length(Ts)
    fn=[AllN(1:end-4) '_ProgThresh' int2str(Ts(i)) '.mat'];
    load(fn)
    dat(i).frn=FrameNum;
    dat(i).os=Orients;
    dat(i).so=CleanOsCents(Cents,Orients,FrameNum,WhichB);
    dat(i).cs=Cents;
    dat(i).ls=len_e;
    nb=NumBToNB(NumBees);
    
    bad=find((NumBees>0).*(mb==0))
    badis=find(ismember(dat(i).frn,bad))
    hold on;
    plot(Areas,'r')
    plot(badis,Areas(badis),'ro')
    hold off;
figure(2)
[NewOs,cs,ls,b,u]=CheckOrients2012(dat(i).so,dat(i).cs,dat(i).ls,...
        dat(i).frn,badis,AllN,0);

end


function[dat,handf]=CheckMultThresholds(Ts,AllN,m,opt)
for i=1:length(Ts)
    fn=[AllN(1:end-4) '_ProgThresh' int2str(Ts(i)) '.mat'];
    load(fn)
    dat(i).frn=FrameNum;
    dat(i).os=Orients;
    dat(i).so=CleanOsCents(Cents,Orients,FrameNum,WhichB);
    dat(i).cs=Cents;
    dat(i).ls=len_e;
    nb=NumBToNB(NumBees);
    if(i==1)
        frlist=FrameNum(nb==1);
    else
        frlist=intersect(frlist,FrameNum(nb==1));
    end
end
if(opt==1)
    [badflist,badis]=GetBads(frlist,dat,20,opt);
    handf=[AllN(1:end-4) 'Hand.mat'];
else
    [badflist,badis]=GetBads(frlist,dat,20,opt);
    handf=[AllN(1:end-4) 'HandV2.mat'];
end
dm=dat(m);
figure(2)

if(~isfile(handf))
    [NewOs,cs,ls,b,u]=CheckOrients2012(dm.so,dm.cs,dm.ls,dm.frn,badis(m,:),AllN,0);
    badfs=dm.frn(b);
    badis=badis(:,~ismember(badis(m,:),b));
    % [NewOs,cs,ls,b,u]=CheckOrients2012(dm.so,dm.cs,dm.ls,dm.frn,1:8,AllN,0);
    iCh=setdiff(badis(m,:),b);
    osCh=NewOs(iCh);
    save(handf,'NewOs','cs','ls','b','u','dm','iCh','badfs','osCh','badis','dat');
end

function[dat,es,es_s]=GetErrors(handf)
load(handf);
c=['b';'r';'k'];
figure(1)
plot(dm.frn,AngleWithoutFlip(NewOs),'g:x')
hold on
es=[];
es_s=[];
for i=1:length(dat)
    o=AngleWithoutFlip(dat(i).so);
    smo=TimeSmooth(o,dat(i).frn,5);
    gs=setdiff(badis(i,:),b);
    plot(dat(i).frn,o,c(i),dat(i).frn(gs),o(gs),[c(i) 'o']);
    % find the differences but account for the fact that it could be a 180 flip
    dat(i).es=min(abs(AngularDifference(o(gs),osCh)),...
        abs(AngularDifference(o(gs),osCh+pi)));
    es=[es;dat(i).es];
    dat(i).es_s=min(abs(AngularDifference(smo(gs),osCh)),...
        abs(AngularDifference(smo(gs),osCh+pi)));
    es_s=[es_s;dat(i).es_s];
end
plot(dm.frn(iCh),osCh,'kd')
hold off
figure(3)
subplot(2,1,1),hist(es'*180/pi)
subplot(2,1,2),hist(es_s'*180/pi)

% find which is the best match


% [NewOs,cs,ls,b,u]=CheckOrients2012(dat(m).so,dat(m).cs,dat(m).ls,dat(m).frn,6:10,AllN)


function[bflist,badis]=GetBads(frlist,dat,ncheck,opt)
for j=1:length(frlist)
    for i=1:length(dat)
        badis(i,j)=find(dat(i).frn==frlist(j));
        angs(i)=dat(i).so(badis(i,j));
    end
    d(1)=min(abs(AngularDifference(angs(2),angs(1))),...
        abs(AngularDifference(angs(2)+pi,angs(1))));
    d(2)=min(abs(AngularDifference(angs(2),angs(3))),...
        abs(AngularDifference(angs(2)+pi,angs(3))));
    d(3)=min(abs(AngularDifference(angs(1),angs(3))),...
        abs(AngularDifference(angs(1)+pi,angs(3))));
    err(j)=max(abs(d));
end
% pick the most discordant
if(opt==1)
    [serr,is]=sort(err,'descend');
else
    % pick regular ones
    is=5:5:length(frlist);
end
bflist=frlist(is(1:min(ncheck,length(is))));
badis=badis(:,is(1:min(ncheck,length(is))));
