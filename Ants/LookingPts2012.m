% function[meanC,meanT,meanTind,len,in,ils,sn,en]= LookingPts2012 ...
%     (NestOnRetina,LMs,DToNest,t,Cents,th,iLen,dlim,iLenLM,skiplim)
% 
% function which calculates the looking events at nest and LM 
% between retinal angles held in th (in degrees)
%
% Input arguments are: Retinal nest and LM angles (NestOnRetina and LMs)
% distance to nest and bee positions in cms (DToNest and Cents)
% time in seconds (t) and th, the angular range
%
% if th is a vector it finds retinal angles are in the range [th(1),th(2)]
% if th is a single value the range is [-th, th]
%
% typical usage: [meanC,meanT,meanTind,len,in,ils]= ...
%                   LookingPts2012(NestOnRetina,LMs,DToNest,t,Cents,10)
%
% which returns the looking points within 10 degrees
%
% returned values are:
% the position of nest looking events: meanC;
% time of nest looking events: meanT; 
% duration (in frames) of nest looking events: len;
% indices of the all the nest looking frames: in;
% the starts and ends of all the nest looking frames: sn and en;
%
% the same data is returned for landmark looking but in a structure ils
% with fields of the same names as above
% nest, mean pos lm, length nest events
% length lm events, mean time nest, mean time lm, inds looking both
%
% OPTIONAL PARAMETERS
% Can specify only events of nest looking over length iLen (default=1) 
% can specify only events of LM looking over length iLenLM (default=iLen)
%
% if dlim is defined, it finds only positions that are less then dlim cm
% from the nest (default is off)
%
% if skiplim is defined, this is the distance in time between points
% consdiered to be part of the same event (default 0.05 - change from
% previous version LookingPtsExpt2

function[meanC,meanT,meanTind,len,in,ils,sn,en] = LookingPts2012 ...
    (NestOnRetina,LMs,t,Cents,th,skiplim,iLen,iLenLM)

if((nargin<6)||isempty(skiplim)) 
    skiplim=0.05; 
end;
if((nargin<7)||isempty(iLen)) 
    iLen = 1; 
end;
if((nargin<8)||isempty(iLenLM)) 
    iLenLM=iLen; 
end;

if(size(th,2)==2)
    th2=th(:,2);
    th1=th(:,1);
else
    th2=abs(th);
    th1=-th2;
end
th1=th1*pi/180;
th2=th2*pi/180;
if(size(th1,1)==1) 
    th1=th1*ones(length(LMs)+1,1);
    th2=th2*ones(length(LMs)+1,1);
end

in=find((NestOnRetina<=th2(1))&(NestOnRetina>=th1(1)));
[sn,en,len]=StartFinish(t,in,skiplim);

% get really brief ones
if(iLen==0) 
    [sn,en,len]=ShortLooks(NestOnRetina,th2(1),sn,en,len); 
end

% limit by length of look
js=find(len>=iLen);sn=sn(js);en=en(js);

for i=1:length(sn)
    is=sn(i):en(i);
    ins(i).lks=is;
    meanT(i)=mean(t(is));
    meanC(i,:)=meanc(meanT(i),t(is),Cents(is,:));
end
if(isempty(sn)) 
    meanTind=[];
    meanC=[];
    meanT=[];
    ins=[];
else
    meanTind=GetTimes(t,meanT');
end

% do the same for the landmarks
for i=1:length(LMs)
    ll=LMs(i).LMOnRetina;
    ils(i).is=find((ll>=th1(i+1))&(ll<=th2(i+1)));
    [sl,el,ils(i).len]=StartFinish(t,ils(i).is,skiplim);
    
    % Get brief looks
    if(iLenLM==0) 
        [sl,el,ils(i).len]=ShortLooks(ll,th2(i+1),sl,el,ils(i).len);
    end
    
    % limit by look length
    js=find(ils(i).len>=iLenLM);
    sl=sl(js);
    el=el(js);
    
    % get looking point data
    for j=1:length(sl)
        is=sl(j):el(j);
        ils(i).meanT(j)=mean(t(is));
        ils(i).meanC(j,:)=meanc(ils(i).meanT(j),t(is),Cents(is,:));
    end
    if(isempty(sl)) 
        ils(i).meanTind=[];
        ils(i).meanC=[];
        ils(i).meanT=[];
    else
        ils(i).meanTind=GetTimes(t,[ils(i).meanT]');
    end
    ils(i).sl=sl;
    ils(i).el=el;
end

function[sn,en,len]=ShortLooks(angs,th2,sn,en,len)
if(size(angs,1)>size(angs,2)) 
    angs=angs'; 
end;
ad=diff(0.5*sign(angs));
p=find(abs(ad)==1);
d1s=abs(angs(p));
d2s=abs(angs(p+1));
p=p((d1s<pi/2)&(d2s<pi/2));
if(~isempty(p))
    d3=min([abs(angs(p));abs(angs(p+1))],[],1);
    p=p(d3<(pi/3));
end
% p=p(find(abs(angs(p))<(8*pi/18)));
d1s=abs(angs(p));
d2s=abs(angs(p+1));
shorts=find((d1s>th2)&(d2s>th2));
pshorts=p(shorts);
for i=1:length(pshorts)
    if(abs(angs(pshorts(i)))<abs(angs(pshorts(i)+1)))
        sn=[sn pshorts(i)];
        en=[en pshorts(i)];
    else
        sn=[sn pshorts(i)+1];
        en=[en pshorts(i)+1];
    end
end
% sn=[sn p(shorts)'];
% en=[en p(shorts)'+1];
len=[len zeros(size(shorts))];
[sn is]=sort(sn);
en=en(is);
len=len(is);

function[mc]=meanc(mt,t,cs)
i1=find(t<=mt,1,'last');
i2=find(t>=mt,1);
if(i1==i2) 
    mc=cs(i1,:);
else
    c1=cs(i1,:);
    c2=cs(i2,:);
    td=(t(i2)-mt)/(t(i2)-t(i1));
    mc=c1*td + c2*(1-td);
end

% Given a time vector, t, a set of indices of data, is this function finds
% the start and the finish of the incident. It allows a tolerance of th
% between the data included in an incident
function[s,e,l]=StartFinish(t,is,th)
s=[];e=[];l=[];
if(isempty(is)) return; end;
i=1;
while 1
    s=[s is(i)];
    ex=find(diff(t(is(i:end)))>th,1);
    if(isempty(ex)) 
        e=[e is(end)];
        break;
    else e=[e is(i+ex-1)];
    end
    i=i+ex;
end
l=e-s+1;