function AdjustShadows
s=dir('*.avi');
x=cd;
IntS=[];IntFs=[];
if(isempty(s)) disp(['No Files to process in folder ' x]); end;
for i=1:length(s)
    fn=s(i).name;[int2str(i) ':  ' fn]
    pn=fn(1:strfind(fn,'.avi')-1);
    PathN=[pn 'Path.mat'];
    AllN=[pn 'All.mat'];

    %     if(CheckInterferingShadows(pn))
    %         IntS=[IntS i];
    %         IntFs=s(IntS);
    %         save InterferingShadows IntS IntFs
    %     end;
    if(isfile([pn 'ALev.mat']))
        Get1DataLastBit(AllN,pn);
        disp(['File ' AllN ' generated.\nPress return to continue']);
        pause;
        delete([pn 'ALev.mat'])
    end
end

function plotb(is,c1,e1,e2,ell,col)
bw=50;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=is 
    plot(ell(i).elips(:,1),ell(i).elips(:,2),col) 
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])
hold off

function RemoveData(fnin,fnout,i_out,set_os)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
t=FrameNum*0.02;
Areas=Areas(is);
Cents=Cents(is,:);
if(nargin<4) Orients=Orients(is);
else 
    Orients=set_os;
    clear set_os;
end
WhichB=WhichB(is);
EndPt=EndPt(is,:);
Bounds=Bounds(is,:);
MeanCol=MeanCol(is);
NLess=NLess(is);
len_e=len_e(is);
area_e=area_e(is);
EPt=EPt(is,:);
elips=elips(is);
odev=odev(is);
ang_e=ang_e(is);
eccent=eccent(is);
v1=MyGradient(Cents(:,1),FrameNum);
v2=MyGradient(Cents(:,2),FrameNum);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

clear i_out fnin;
save(fnout)

function Get1DataLastBit(AllN,ff)
load(AllN)
% Smooth the data
sm_len=0.1;
% [ang_e,Cents,len_e,bads,unsure]=SmoothAll_Expt2(ang_e,t,Cents,len_e,[ff '.avi'],sm_len);
[ang_e,Cents,len_e,bads,unsure]=SmoothOsExpt2(ang_e,t,Cents,len_e,...
    [ff '.avi'],sm_len,eccent,area_e,[],FrameNum,0,unsure,bads);
save(AllN,'ang_e','Cents','len_e','bads','unsure','-append')

sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
is=setdiff(1:length(sOr),unsure);
sOr(is)=TimeSmooth(AngleWithoutFlip(ang_e(is)),t(is),sm_len);

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
[sOr,unsure,Cents] = AdjOrients(sOr,Cents,FrameNum,[ff '.avi'],unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
input('Press return to continue');

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
clear i is a
save(AllN)

function[interf]=CheckInterferingShadows(pn)
imagesc(MyAviRead(pn,1,1))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end