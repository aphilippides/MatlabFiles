% function[meanC,meanT,meanTind,len,in,ils,Cents,EndPt] ...
%     = LookingPtsExpt2(fn,th,iLen,dlim,iLenLM,skiplim)
% 
% function which calculates the looking events at nest and LM 
% in file fn between retinal angles th1 and th2 where th1<th2
% if th2 unspecified it is assumed that th2=-th1
%
% Can specify only events over length iLen (default=1) are returned
% Pl specifies whether to plot them or not (default 0)
%
% returned values are mean pos nest, mean pos lm, length nest events
% length lm events, mean time nest, mean time lm, inds looking both

function[in,meanInd,sn,en,meanT,ins,len,tlen]=Thru0Pts(angs,t,th,iLen,skiplim)%,dlim)

if((nargin<3)||isempty(th)) 
    th = pi/18; 
end
if((nargin<4)||isempty(iLen)) 
    iLen = 0; 
end
if((nargin<5)||isempty(skiplim)) 
    skiplim=0.05; 
end

if(size(th,2)==2)
    th2=th(:,2);
    th1=th(:,1);
else
    th2=abs(th);
    th1=-th2;
end
in=find((angs<=th2)&(angs>=th1));
[sn,en,len]=StartFinish(t,in,skiplim);

% get really brief ones
if(iLen==0) 
    [sn,en,len]=ShortLooks(angs,th2(1),sn,en,len); 
end

% limit by length of look
js=find(len>=iLen);sn=sn(js);en=en(js);
in=[];
for i=1:length(sn)
    is=sn(i):en(i);
    in=[in is];
    ins(i).lks=is;
    meanT(i)=mean(t(is));
    tlen=t(is(end))-t(is(1));
end
if(isempty(sn)) 
    meanInd=[];
    meanT=[];
    ins=[];
    tlen=[];
else
    meanInd=GetTimes(t,meanT');
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


% this returns the start and end points as part of the look
function[sn,en,len]=ShortLooksOLD(angs,th2,sn,en,len);
ad=diff(0.5*sign(angs));
p=find(abs(ad)==1);
p=p(find(abs(angs(p))<pi/4));
d1s=abs(angs(p));
d2s=abs(angs(p+1));
shorts=find((d1s>th2)&(d2s>th2));
sn=[sn p(shorts)'];
en=[en p(shorts)'+1];
len=[len zeros(size(shorts'))];
[sn is]=sort(sn);
en=en(is);
len=len(is);

function[mc]=meanc(mt,t,cs)
i1=find(t<=mt,1,'last');
i2=find(t>=mt,1);
if(i1==i2) mc=cs(i1,:);
else
    c1=cs(i1,:);
    c2=cs(i2,:);
    td=(t(i2)-mt)/(t(i2)-t(i1));
    mc=c1*td + c2*(1-td);
end

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