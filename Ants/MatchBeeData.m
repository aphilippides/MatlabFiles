function MatchBeeData(b,day,nStr,f2)

dwork; cd GantryProj/Bees/Indoor

% Get the trackit data
[cs,os_t,sp,vel,ht,t] = GetTrackitData(b,day);

% Load the clicked data
fn=['beesin' int2str(day) '_bee' int2str(b) '_tr_out' nStr];
load([fn 'Data_1.mat'])

% Get the nest and landmark data
cd ../21
flm=[fn 'NestLMData.mat'];
if(~isfile(flm))
    %     if(nargin<4) GetNestAndLMData(fn)
    %     else GetNestAndLMData(fn,f2)
    %     end
end;
% load(flm)
cd ..

% NB for Hi Speed, 1m =1188 pixels
% for vid, 1 m = 673 pixels (x0.98 from estimation)
% eg Cents = (Cents-ones(size(Cents,1),1)*nest)*0.98/673;
% However, better to estimate from LM width
% sc=0.0275/LMWid;
sc=.98/673;
% Get only those frames clicked
% Cents = (Cents(iEntered,:)-ones(length(iEntered),1)*nest)*sc;
Cents = (Cents(iEntered,:)-ones(length(iEntered),1)*[100 300])*sc;
Cents(:,1)=-Cents(:,1);

tc=FrameEntered*0.02;
cs = cs-ones(size(cs,1),1)*cs(1,:);

rot=0;
inp=[];
if(~isfile([fn 'MatchVals.mat']))
    while(isempty(inp)|(inp~='x'))
        plotpaths(Cents,cs)
        inp=input('enter p for start points, s to scale, r to rotate, x to end\n','s');
        if(isempty(inp))
            % Pick Points to check the data
            [checkv,checkt]=PickStartPts(Cents,cs);
            CheckDiff=tc(checkv)-t(checkt);
            a = [TimeDiff,CheckDiff,TimeDiff-CheckDiff]

        elseif(inp(1)=='s')
            % Scale the data
            Cents=Cents*str2double(inp(2:end));
            sc=sc*str2double(inp(2:end));

        elseif(inp(1)=='r')
            % rotate the data
            r=str2double(inp(2:end));
            r_m=[cos(r) sin(r);-sin(r) cos(r)];
            Cents=Cents*r_m;
            rot=rot+r;

        elseif(inp=='p')
            % Get start points to centre the data
            [startv,startt]=PickStartPts(Cents,cs);
            Cents=Cents-ones(size(Cents,1),1)*Cents(startv,:);
            cs=cs-ones(size(cs,1),1)*cs(startt,:);
            TimeDiff=tc(startv)-t(startt);
        end;
    end

    save([fn 'MatchVals.mat'],'startv','startt','rot','sc');
else
    load([fn 'MatchVals.mat'])
    Cents=Cents-ones(size(Cents,1),1)*Cents(startv,:);
    cs=cs-ones(size(cs,1),1)*cs(startt,:);
    r_m=[cos(rot) sin(rot);-sin(rot) cos(rot)];
    Cents=Cents*(sc*673/.98)*r_m;
end

% Pick New Start Points
inp=0;
while(~isempty(inp))
    plotpaths(Cents,cs)
    hold on;
    plot(Cents(startv,1),Cents(startv,2),'go')
    plot(cs(startt,1),cs(startt,2),'go')
    hold off;
    inp=input('1 to pick alternative start points? return to end\n');
    if(inp==1)
        % Get new start points
        [startv,startt]=PickStartPts(Cents,cs);
        TimeDiff=tc(startv)-t(startt);
    end;
end
save([fn 'MatchVals.mat'],'startv','startt','rot','sc');

% Pick End Point
if(isfile([fn 'MatchVals.mat']))
    plotpaths(Cents,cs)
    hold on;
    plot(Cents(endv,1),Cents(endv,2),'go')
    hold off;
    inp=input('1 to pick alternative end point, return to skip\n');
else inp=0;
end
% inp=0;
while(~isempty(inp))
    plotpaths(Cents,cs)
    title('Pick end point of blue line')
    x=ginput(1);
    Vs=Cents-ones(size(Cents,1),1)*x;
    Ds=sum(Vs.^2,2);
    [m,endv]=min(Ds);
    hold on;
    plot(Cents(endv,1),Cents(endv,2),'go')
    hold off;
    inp=input('1 to pick alternative end point, return to end\n');
end
save([fn 'MatchVals.mat'],'startv','startt','rot','sc','endv');

ds=TipsEntered-EndsEntered;
os=cart2pol(ds(:,1)/2,ds(:,2));
os=CleanOrients(os);

% reset all variables to the starting point
iv=[startv:endv];
tc=tc(iv)-tc(startv);
t=t(startt:end)-t(startt);
Cents=Cents(iv,:);
cs=cs(startt:end,:);
os=os(iv);
os_t=os_t(startt:end);
[isv,ist,gap] = MatchPositions(Cents,cs,tc,t,os,os_t)

% os=FlipPoints(os(isv),tc(isv));
% os_t=FlipPoints(os_t(ist),t(ist));
plot(t(ist),AngleWithoutFlip(os_t(ist)),'r-x',tc(isv),AngleWithoutFlip(os(isv)))
while(1)
    handr=input('shift blue\n');
    if(isempty(handr)) break; end;
    os=AngleWithoutFlip(os)-handr;
    plot(t(ist),AngleWithoutFlip(os_t(ist)),'r-x',tc(isv),os(isv))
    % plot(t(ist),os_t(ist),'r-x',tc(isv),os(isv)-handr)
end

er1=abs(AngularDifference(AngleWithoutFlip(os_t(ist)),AngleWithoutFlip(os(isv))));
dists=Cents(isv,:)-cs(ist,:);
d=sqrt(sum(dists.^2,2));
mme_st_med=[mean(er1), std(er1),median(er1)]*180/pi

save([fn 'MatchedIs'],'ist','isv','t','os_t','os','tc','cs','Cents','rot','dists','d','er1','gap','mme_st_med')


figure(2)
subplot(3,1,1)
plot(t(ist),os_t(ist),'r-x',tc(isv),os(isv))
subplot(3,1,2)
plot(t(ist),er1,'b-x')
subplot(3,1,3)
plot(t(ist),d)
title(['Cents error = ' num2str(mean(d))])
rot=pi+rot;
keyboard;

function[o]=FlipPoints(o,t);
hold off
while(1)
    plot(t,o,'-x')
    title('click point or range of points to flip then return. return to end')
    x=ginput(2);
    if(isempty(x)) break; end;
    [m,s]=min(abs(t-x(1,1)));
    [m,e]=min(abs(t-x(2,1)));
    is=s:e;
    hold on;
    plot(t(is),o(is),'go')
    hold off;
    inp=input('return to accept, 1 to pick again\n');
    if(isempty(inp))
        if(o(is(1))<0) o(is)=o(is)+pi;
        else o(is)=o(is)-pi;
        end;
    end
end

function[isv,ist,gap] = MatchPositions(cs,bs,tc,t,Orients,os)
% if(length(tc)<length(t)) 
if(1) 
    ttest=tc;
    ts=t;
    flag=1;
else
    ttest=t;
    ts=tc;
    flag=0;
end

is1=[];gap=[];is2=[];
for i=1:length(ttest)
    tn=ts-ttest(i);
    [m,iover]=min(abs(tn));         % >=0,1,'first');
    if(m<0.02)
        is1=[is1 iover];
        gap=[gap ts(iover)-ttest(i)];
        is2=[is2 i];
    elseif((ttest(i)-tc(end))>0.02) break;
    end
end
%         gap=(t2(iover)-t1(i))/0.008;
%         x=cs(iover,:)*(1-gap) + gap*cs(iover-1,:);
if(flag) ist=is1; isv=is2;
else ist=is2; isv=is1;
end

function[startv,startt]=PickStartPts(Cents,cs)
title('Pick Start Points, blue then red')
s=ginput(2);
VtoVid=Cents-ones(size(Cents,1),1)*s(1,:);
Ds=sum(VtoVid.^2,2);
[m,startv]=min(Ds);
VtoTrak=cs-ones(size(cs,1),1)*s(2,:);
Ds=sum(VtoTrak.^2,2);
[m,startt]=min(Ds);

function plotpaths(Cents,cs)
plot(Cents(:,1),Cents(:,2))
hold on
plot(cs(:,1),cs(:,2),'r')
hold off

function dummy
n=length(t);

Errs=[];is=[];
% for i=n:-1:1
for i=225:234
    if(~isnan(t(i)))
        bs=cs(1:i,:)-ones(i,1)*cs(i,:);
        e=[];
        %         for s=0.95:0.01:1.05
        %             [es,se,is,i_cs]=MatchPosFromNest(s*Cents,bs,t(1:i),tc);
        %             e= [e es];
        %         end
        [e,se,i_bs,i_cs]=MatchPosFromNest(Cents,bs,t(1:i),tc);
        is=[is i];
        %             plot(Cents(i_cs,:),'r')
        %             hold on
        %             plot(bs(i_bs,:),'b')
        %             hold off
        %             figure
        Errs=[Errs;e];
    end
end

[m,j]=min(Errs);
TrIn = is(j);

bs=cs(1:TrIn,:)-ones(TrIn,1)*cs(TrIn,:);
[e,se,i_bs,i_cs]=MatchPosFromNest(Cents,bs,t(1:TrIn),tc);

plot(Cents(i_cs,1),Cents(i_cs,2),'rx')
hold on
plot(bs(i_bs,1),bs(i_bs,2),'bx')
hold off
title(['Error = ' num2str(m)])

% save(['beesin16_bee' int2str(b) '_tr_in' int2str(trnum) 'TrakVid.mat'], ...
%     'TrIn','VIn','VNest','TrNest','BPos','Orient','TStamp')


function[er,se,is_b,is_c] = MatchPosFromNest(cs,bs,t,tc)
n=length(cs);
len=100;
t=t-t(end);
t2=tc-tc(end);
ds=[];is_b=[];is_c=[];
m=length(t);
if((m-len)<1)
    is_b=0;
    is_c=0;
    er=1000;
    se=0;
else
    for i=m:-1:1
        if(~isnan(t(i)))
            [m,j]=min(abs(t2-t(i)));
            if(m>0.02) break;end;
            if(i>(m-len)) ds=[ds sqrt(sum((cs(j,:)-bs(i,:)).^2))]; end;
            is_b=[is_b i];
            is_c=[is_c j];
        end
    end
    er=mean(ds);
    se=std(ds);
end

function[nest,tin] = GetNest(cs)
ds=sqrt(sum(diff(cs).^2,2));
d=0;
n=length(cs);
tin=n;
while((d<2)&(tin>=2))
    nest=mean(cs(tin:n,:),1);
    tin=tin-1;
    d=sqrt(sum((cs(tin,:)-nest).^2));
end