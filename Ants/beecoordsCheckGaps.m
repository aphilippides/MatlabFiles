% this function checks to see if there are any 'gaps' in the bees we have
% which have been missed because of the pre-filtering
%
% it works by finding gaps in trace, then interpolating within neigbouring
% frames

function[isadd]=beecoordsCheckGaps(vidfn,FRLEN,vObj)

isadd=0;
dlim=3;
fn=[vidfn(1:end-4) 'All.mat'];
load(fn)
load([vidfn(1:end-4) 'NestLMData.mat']);
% 
% % get distance to the nest of all bees
% d2n=CartDist(Cents,nest)*cmPerPix;

% find gaps in the trace. NB can't use NumBees as this is now different as
% some bees have been removed
tt=1:length(NumBees);
if(FullFrame)
    tt=tt*2-1;
    nb=Frequencies(FrameNum,tt);
    is=tt(nb==0);
else
    nb=Frequencies(FrameNum,tt);
    is=find(nb==0);
end

% first discard any with no bees before it and no bees after
% (beecoordsCheckNest will catch important ones ie ones near nest) 
is=is((is>FrameNum(1))&(is<FrameNum(end)));
if(isempty(is))
    disp('all frames have bees')
    disp(' ');
    return;
end

% now find all frames before and after the gaps
for i=1:length(is)
    ind=is(i);
    b4(i)=find(FrameNum<ind,1,'last');
    aft(i)=find(FrameNum>ind,1);
    r=(ind-FrameNum(b4(i)))/(FrameNum(aft(i))-FrameNum(b4(i)));
    prC(i,:)=Cents(b4(i),:)*(1-r)+Cents(aft(i),:)*r;
    prAng(i)=circ_mean(ang_e([b4(i),aft(i)])',[1-r;r]);
    prL(i)=len_e(b4(i))*(1-r)+len_e(aft(i))*r;
end
% Now get rid of any where the bee is within edgeL pixels of the edge
% based on position from frame before + time * velocity
td=(is-FrameNum(b4))';
pr=Cents(b4,:)+[td.*Vels(b4,1) td.*Vels(b4,2)];
[h,w]=size(refim_im);
edgeL=10;
o=(pr(:,1)<edgeL)|(pr(:,2)<edgeL)|(pr(:,1)>(w-edgeL))|(pr(:,2)>(h-edgeL));
is=is(~o);
b4=b4(~o);
aft=aft(~o);
prC=prC(~o,:);
prAng=prAng(~o);
prL=prL(~o);

if(isempty(prAng))
    return;
end
[prEp(:,1) prEp(:,2)]=pol2cart(prAng,prL);
prEp=prEp+prC;

% % plot stuff
% figure(4)
% subplot(2,1,1),
% plot(tt,nb,FrameNum(b4),nb(b4),'ro',FrameNum(aft),nb(aft),'gx'),
% title(['# bees in file; os are by gaps'])
% subplot(2,1,2),
% PlotNestAndLMs(LM,LMWid,nest)
% plotb([],prC,prEp,[],'g',0)
% hold on
% plotb(b4,Cents,EPt,[],'b',0)
% hold on
% plotb(aft,Cents,EPt,[],'w',0)
% hold off
% title('bees before (blue), after (white) and predicted positions (green)')

figure(4)
clf
% find the nearest starting point
[dat]=CheckOrientsNest(prC,prEp,is,zeros(size(is)),...
    vidfn,Cents,FrameNum,EPt,ang_e,len_e,vObj,[1 1]);

save(fn,'edgeL','-append');
InsertFrames(fn,fn,dat,FRLEN);
isadd=1;