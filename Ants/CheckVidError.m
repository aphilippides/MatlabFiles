function CheckVidError(f,smoothhand)
if(nargin<2) smoothhand=0; end;
dwork
cd GantryProj\Bees\

load(['OFs16-21\' f 'HandData'])
load(['OutdoorOF\' f 'All'])
isEntered=[];
isOs=[];
[Frs,isOs,isEntered]=intersect(FrameEntered,FrameNum);
ff=['OutdoorOF\' f '.avi']; 

if(smoothhand)
    t_new=Frs*0.02;
    [os,t_new,s_os,bp]=SmoothOs(os(isOs),t_new,1,Cents(isEntered,:),ff,sm_len);
    goodpts=setdiff(1:length(os),bp);
    t_new=t_new(goodpts);
    adjos=os(goodpts);
    save(['OFs16-21\' f 'HandData'],'s_os','t_new','adjos','-append');
end
t=FrameNum*0.02;

% Match bees
[ti,ios,iOr]=intersect(t_new,t);
os=adjos;

figure(1)
plot(ti,AngleWithoutFlip(os(ios)),ti,AngleWithoutFlip(Orients(iOr)),'r')
figure(2)
ers=AngularDifference(os(ios),Orients(iOr))*180/pi;
m_sd_med=[mean(ers) std(ers) median(ers)]
a=abs(ers);
m_sd_med_abs=[mean(a) std(a) median(a)]

figure(1)
ers=AngularDifference(s_os(ios),sOr(iOr))*180/pi;
plot(ti,AngleWithoutFlip(s_os(ios)),ti,AngleWithoutFlip(sOr(iOr)),'r-x')
a=abs(ers);
m_sd_med_abs=[mean(a) std(a) median(a)]
hist(a,40)
fs=round(ti/0.02);
origIs=[];
for i=fs origIs=[origIs find(FrameNum==i)]; end;

keyboard
[a,b,c]=AdjOrients(sOr(iOr),Cents(origIs,:),fs,ff,a,s_os(ios)); 
a=abs(ers)
NotErrors=[b c];
ActualErrors=setdiff(a,NotErrors);
acter=[mean(ActualErrors) std(ActualErrors)]
hist(ActualErrors)
save(['OFs16-21\' f 'HandData'],'ActualErrors','NotErrors','-append'); 
keyboard

function[hand,ok,prog] = AdjOrients(Orients,Cents,FrameNum,fn,Er,os)
% Get the correct frames from Framenum
% Look at the offending data 
% Flip any that are necessary via return to flip, 
% anything else to skip eg
bads=[];
[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;
[e2(:,1) e2(:,2)]=pol2cart(os,10);
e2=e2+Cents;
ok=[];
hand=[];
prog=[];
is=find(Er>=10);
for k=is%1:length(FrameNum)
    fr=(FrameNum(k))/2;
    f=aviread(fn,fr);
    imagesc(f.cdata);
    hold on;
    %    plot(EndPt(k,1),EndPt(k,2),'b.')
    plot([Cents(k,1) EndPt(k,1)]',[Cents(k,2) EndPt(k,2)]','b')
    plot([Cents(k,1) e2(k,1)]',[Cents(k,2) e2(k,2)]','r')
    axis(round([Cents(k,1)-50,Cents(k,1)+50,Cents(k,2)-50,Cents(k,2)+50]))
    hold off
    title(['Fr ' int2str(FrameNum(k)) '; Er= ' num2str(Er(k)) ';  hand-red, prgram blue'])
    xlabel('return if no error, click if hand better, right click if prog better')
    [p,q,r]=ginput(1);
    if(isempty(p)) ok=[ok Er(k)];    %break; end;
    elseif(r==1) hand=[hand Er(k)];
    else prog=[prog Er(k)];
    end
end