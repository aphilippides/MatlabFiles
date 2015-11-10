function GetALVFromDB(fs)
% dwork;
% cd ../_Current/Linc/NoisePaper/noise_results\
% cd 'learn run database/'

% UnwrapImsDB;
% [x,y]=GetPositions;
% cd ../'env2 database/'
% [x2,y2]=GetPositions;
% plot(x,y,'rx',x2,y2,'gx'); 
% lrun=ParseGantryFile('../ev1/learn.txt');
% [raw,t,finl,filled]=GetALVIms;
% save dBaseEnv2Ims.mat
% load dBaseEnv2Ims.mat
% for i=1:size(finl,1)
%     %     [obj(i).pos,obj(i).ws]=ObjectsFromFacets(finl(i,:));
%     i
%     [obj(i).pos,obj(i).ws]=ObjectsFromFacets(t(i,:));
%     [nob(i),alv(i,:)]=GetALVs((obj(i).pos-1.5)*pi/45,obj(i).ws);
% end
% [obj,ht]=GetHeightsFromPos(obj,0);
% [alvth,r]=cart2pol(alv(:,1),alv(:,2));
% save dBaseEnv2.mat
DBase

function DBase
load dBaseEnv2.mat
xs=0:50:1500;
ys=0:50:1700;
% WPts=1:7;
% [ht2,alv2,WPts] = ScaleByNLM(alv,ht,nob,WPts);
% [objM,alvxM,alvyM,nlM,htM,rM,alvthM]=TransformToMatrix(xs,ys,obj,alv,nob,alvth,r,ht)
% [alvth2,r2]=cart2pol(alv2(:,1),alv2(:,2));
% [objMs,alvxMs,alvyMs,nlMs,htMs,rMs,alvthMs]=TransformToMatrix(xs,ys,obj,alv2,nob,alvth2,r2,ht2)
% save dBaseEnv2.mat
for i=1:length(xs)
pb(i,:)=CheckTransect(alvxM,alvyM,nlM,htM,rM,alvthM,xs(i))';
end
for i=1:length(ys)
pb(i+length(xs),:)=CheckTransect(alvxM,alvyM,nlM,htM,rM,alvthM,[],ys(i))';
end

for i=1:length(xs)
pbs(i,:)=CheckTransect(alvxMs,alvyMs,nlM,htMs,rMs,alvthMs,xs(i))';
end
for i=1:length(ys)
pbs(i+length(xs),:)=CheckTransect(alvxMs,alvyMs,nlM,htMs,rMs,alvthMs,[],ys(i))';
end

keyboard

function[pcb] = CheckTransect(alvxM,alvyM,nlM,htM,rM,alvthM,x,y);
if((nargin<8)|isempty(y))
    r=(x/50)+1;
    cs=find(nlM(r,:)>0);
    nob=nlM(r,cs);
    alv=[alvxM(r,cs)' alvyM(r,cs)'];
    alvth=alvthM(r,cs)';
    pos=[x*ones(size(cs')) (cs-1)'*50];
    ht=htM(r,cs);
else
    c=(y/50)+1;
    rs=find(nlM(:,c)>0);
    nob=nlM(rs,c)';
    ht=htM(rs,c)';
    alvth=alvthM(rs,c);
    alv=[alvxM(rs,c) alvyM(rs,c)];
    pos=[(rs-1)*50 y*ones(size(rs))];
end
[WPt,WhichWpt] = GetWaypoints(nob,alv,pos,ht,alvth);

opts=1:5;
for i=1:length(opts)
    [bm(i).m,bm(i).d1,bm(i).nb,bm(i).ds,bm(i).cs]=...
        BestMatch(WPt,WhichWpt,alv,alvth,ht,opts(i));
    nb(i,:)=[bm(i).nb];
end
pcb=100*nb(:,1)./nb(:,2);

function[WPts,WhichWpt] = GetWaypoints(nob,alv,pos,ht,alvth)
ts=[find(diff(nob)) length(nob)];
WPts=[ts' alv(ts,:) pos(ts,:) alvth(ts) ht(ts)'];
oldn=1;
for j=1:length(ts)
    n=ts(j);
    WhichWpt(oldn:n)=j;
    oldn=n+1;
end


function GetLocalesFromNLM

function LearnRun
% load DataFromLearnRunIms

% load positions
% [WPts,WhichWpt] = GetWaypoints(nob,alv,pos,ht,alvth);
% [m1,d1,nb1,ds,cs]=BestMatch(WPts,WhichWpt,alv,alvth,ht,1);
% [m1,d1,nb2,ds,cs]=BestMatch(WPts,WhichWpt,alv,alvth,ht,2);
% [m1,d1,nb3,ds,cs]=BestMatch(WPts,WhichWpt,alv,alvth,ht,3);
% [m1,d1,nb4,ds,cs]=BestMatch(WPts,WhichWpt,alv,alvth,ht,4);
% % save temp
% t=1:length(ht);
% plot(t,ht,t(WPts(:,1)),ht(WPts(:,1)),'rs',t(cs),ht(cs),'k.')
% figure(2),plot(t,alvth,'b',t(WPts(:,1)),alvth(WPts(:,1)),'rs',t(cs),alvth(cs),'k.')
% [ht,alv,WPts] = ScaleByNLM(alv,ht,nob,WPts);
% keyboard;

function[ht,alv,WPts] = ScaleByNLM(alv,ht,nob,WPts);
ht=ht.*nob;
me=mean(ht);st=std(ht);
ht=(ht-me)/st;
WPts(:,7)=(WPts(:,7).*nob(WPts(:,1))'-me)/st;
alv(:,2)=alv(:,2).*nob';
alv(:,1)=alv(:,1).*nob';
% me=mean(alv);st=std(alv);
me=[mean(alv(:)) mean(alv(:))];st=[std(alv(:)) std(alv(:))];
alv(:,1)=(alv(:,1)-me(1))/st(1);
alv(:,2)=(alv(:,2)-me(2))/st(2);
WPts(:,2)=(WPts(:,2).*nob(WPts(:,1))'-me(1))/st(1);
WPts(:,3)=(WPts(:,3).*nob(WPts(:,1))'-me(2))/st(2);

function[objM,alvxM,alvyM,nlM,htM,rM,alvthM]= ...
    TransformToMatrix(xs,ys,obj,alv,nob,alvth,r,ht)
fs=dir('*.mat');
fs=fs(1:932);
ns=struct2cell(fs);
ns=ns(1,:);
for i=1:length(xs)
    i
    for j=1:length(ys)
        objM(i,j).fn=GetName(xs(i),ys(j));
        if(isfile(objM(i,j).fn))
            ind=strmatch(objM(i,j).fn,ns);
            objM(i,j).ind=ind;
            objM(i,j).pos=obj(ind).pos;
            objM(i,j).ws=obj(ind).ws;
            alvxM(i,j)=alv(ind,1);
            alvyM(i,j)=alv(ind,2);
            alvthM(i,j)=alvth(ind);
            nlM(i,j)=nob(ind);
            htM(i,j)=ht(ind);
            rM(i,j)=r(ind);
        else
            objM(i,j).ind=NaN;
            objM(i,j).pos=NaN;
            objM(i,j).ws=NaN;
            alvxM(i,j)=NaN;
            alvyM(i,j)=NaN;
            alvthM(i,j)=NaN;
            nlM(i,j)=0;
            htM(i,j)=0;
            rM(i,j)=NaN;
        end
    end
    save MData
end

function[fn]=GetName(x,y)
fn=[GetN(x) '_' GetN(y) '.mat'];

function[f]=GetN(x)
if(x<10) f=['000' int2str(x)];
elseif(x<100) f=['00' int2str(x)];
elseif(x<1000) f=['0' int2str(x)];
else f=int2str(x);
end

function[m1,d1,NBad,ds,cs]=BestMatch(wpts,whichWpt,alvp,alvth,ht,opt)
t=length(whichWpt);
% vwpts=out.final(wpts(:,1),:);
for i=1:t
    alv=alvp(i,:);
    angi=alvth(i);
    h=ht(i);
%     vis=out.final(i,:);
    for j=1:size(wpts,1)
        if((nargin<1)|(opt==1)) ds(i,j)=sqrt(sum((alv-wpts(j,[2 3])).^2));
        elseif(opt==2) ds(i,j)=abs(AngularDifference(wpts(j,6),angi));
        elseif(opt==3) 
            ds(i,j)=sqrt(sum(([h]-wpts(j,[7])).^2));
        elseif(opt==4)  
            ds(i,j)=sqrt(sum(([alv h]-wpts(j,[2 3 7])).^2));
        else 
            ds(i,j)=sum(abs([alv h]-wpts(j,[2 3 7])));
        end
    end
    [d1(i) m1(i)]=min(ds(i,:));
end
cs = find([whichWpt]==m1); 
NBad=[sum([whichWpt]~=m1) t];

function[raw,thresh,f,in]=GetALVIms(x,y)
innR = 29; % Linc's 78-50+1 as my mat-files start at 50 
outR = 36;
% horizonRadius = 82;
fs=dir('*.jpg');
for i=1:length(fs)
    i
    fn=fs(i).name;
    load([fn(1:end-4) '.mat'])
    OneD(i,:)=mean(unw(innR:outR,:));
    raw(i,:)=SmoothWithEdges(OneD(i,:),4,2);
end
thresh=raw<193;
[f,in]=SmoothVision(thresh);

function[obj,ht]=GetHeightsFromPos(obj,plotting)
if(nargin<2) plotting=1; end;
innR = 29; % Linc's 78-50+1 as my mat-files start at 50 
outR = 36;
Bottom=65;
% horizonRadius = 82;
fs=dir('*.jpg');
for i=1:length(fs)
    fn=fs(i).name
    load([fn(1:end-4) '.mat'])
    s=SmoothWithEdges(unw(outR:Bottom,:),4,2);
    th=s<193;
    if(plotting) 
        imagesc(th); 
        hold on;
    end;
    for j=1:length(obj(i).pos)
        w2=0.5*(obj(i).ws(j)-1);
        ks=mod(obj(i).pos(j)-w2:obj(i).pos(j)+w2,90);
        ks(find(ks==0))=90;
        h=[];
        for k=ks
            he=find(th(:,k)==0,1);
            if(isempty(he)) he=Bottom; end;
            h = [h he];
        end
        obj(i).ht(j) = mean(h);
        if(plotting) plot([obj(i).pos(j) obj(i).pos(j)],[1 obj(i).ht(j)],'r'); end;
    end
    ht(i)=mean(obj(i).ht);
    if(plotting) hold off; end
end

function[x,y]=GetPositions(dn)
if(nargin<1) fs=dir('*.jpg');
else fs=dir([dn '\*.jpg']);
end
for i=1:length(fs)
    fn=fs(i).name;
    x(i)=str2num(fn(1:4));
    y(i)=str2num(fn(6:9));
end