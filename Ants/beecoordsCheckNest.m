% this function checks to see if there are any 'gaps' in the bees we have
% which have been missed because it's hard to pick bees out over the nest
%
% it works by finding gaps in trace, and seeing if they're wihtin 3cm of
% the nest. If so, examine these frames

function[isadd]=beecoordsCheckNest(vidfn,FRLEN,vObj)

isadd=0;
dlim=3;
fn=[vidfn(1:end-4) 'All.mat'];
load(fn)
load([vidfn(1:end-4) 'NestLMData.mat']);

% find gaps in the trace. NB can't use NumBees as this is now different as
% some bees have been removed
tt=1:length(NumBees);
if(FullFrame)
    tt=tt*2-1;
    nb=Frequencies(FrameNum,tt);
    is=tt(nb==0);
    shad=[1 1];
else
    nb=Frequencies(FrameNum,tt);
    is=find(nb==0);
    shad=[1.2 0.8];
end

if(isempty(is))
    disp('all frames have bees')
    return;
end

% now find all frames before and after the gaps
for i=1:length(is)
    ind=is(i);
    % find nearest frame before the gap
    b4=find(FrameNum<ind,1,'last');
    
    if(isempty(b4))   % if no frame before the gap
        % find nearest frame after gap
        aft=find(FrameNum>ind,1);
        if(isempty(aft)) 
             % if no frame after gap [shouldn't really happen]
             % set predicted centre to the nest, and length/angle to
             % to 1cm above
             prC(i,:)=nest;
             prAng(i)=pi/2;
             prL(i)=1/cmPerPix;
        else
            % if frame exists after the gap then use this
             prC(i,:)=Cents(aft,:);
             prAng(i)=ang_e(aft);
             prL(i)=len_e(aft);
        end
    else
        % find nearest frame after gap
        aft=find(FrameNum>ind,1);
        if(isempty(aft)) 
             % if no frame after gap use the one before
             prC(i,:)=Cents(b4,:);
             prAng(i)=ang_e(b4);
             prL(i)=len_e(b4);
        else
            % if there's a frame before and after then do a prediction
            r=(ind-FrameNum(b4))/(FrameNum(aft)-FrameNum(b4));
            prC(i,:)=Cents(b4,:)*(1-r)+Cents(aft,:)*r;
            prAng(i)=circ_mean(ang_e([b4,aft])',[1-r;r]);
            prL(i)=len_e(b4)*(1-r)+len_e(aft)*r;
       end
    end    
end

% find frames which are withn 3cm of nest
% get distance to the nest of all bees
d2n=CartDist(prC,nest)*cmPerPix;
o=d2n<dlim;

is=is(o);
prC=prC(o,:);
prAng=prAng(o);
prL=prL(o);

if(isempty(prAng))
    disp(['no gaps with frames within ' int2str(dlim) ' of nest']);% return continue']);
    disp(' ');
    return;
end

[prEp(:,1) prEp(:,2)]=pol2cart(prAng,prL);
prEp=prEp+prC;
[dat]=CheckOrientsNest(prC,prEp,is,zeros(size(is)),...
    vidfn,Cents,FrameNum,EPt,ang_e,len_e,vObj,shad);
InsertFrames(fn,fn,dat,FRLEN);
isadd=1;


% % now find all frames before and after the gaps
% % not sure why I did the neighbours thing doesnt really work
% % have moved to a more straightforward version aboive
% % the rest of this can probably be ignored
% 
% % find the number of bees in each frame that has bees
% for i=1:length(FrameNum)
%     nb(i)=sum(FrameNum(i)==FrameNum);
% end
% neighb=[];
% inds=[];
% for ind=is
%     n=[];
%     n=find(FrameNum<ind,1,'last');
%     n=[n find(FrameNum>ind,1)];
%     inds=[inds ind*ones(size(n))];
%     neighb=[neighb n];
% end

% % plot stuff
% figure(4)
% subplot(2,2,1),
% plot(tt,NumBees,FrameNum(neighb),nb(neighb),'ro'),
% title(['Num bees in file ' fn '; os are by gaps'])
% subplot(2,2,3),
% plot(FrameNum,d2n,'b.-',FrameNum(neighb),d2n(neighb),'ro')
% title(['distance from nest; cutoff is ' int2str(dlim)])
% subplot(1,2,2),
% PlotNestAndLMs(LM,LMWid,nest)
% hold on
% plot(Cents(neighb,1),Cents(neighb,2),'o')
% hold off

% % find frames and neighbours whcih are withn 3cm of nest
% toredo=unique(inds(d2n(neighb)<dlim));
% ntodo=FrameNum(unique(neighb(d2n(neighb)<dlim)));
% if(isempty(toredo))
%     disp(['no gaps with frames within ' int2str(dlim) ' of nest']);% return continue']);
%     disp(' ');
% else
%     % get a vector of the nest frames and neighbours 
%     % currently just want to do the actual frames: 
%     % not sure why I did neighbours before but could change back
%     if 1   
%         [toredo,sis]=sort([toredo]);
%     else
%         [toredo,sis]=sort([ntodo toredo]);
%     end
%     isneigh=[ones(size(ntodo)) zeros(size(toredo))];
%     isneigh=isneigh(sis);
%     
%     figure(5)
%     clf
%     sps=[];
%     % find the nearest starting point
%     for j=1:length(toredo)
%         [dum,k]=min(abs(FrameNum-toredo(j)));
%         sps(j,:)=Cents(k,:);
%         if((CartDist(sps(j,:),nest)*cmPerPix)>dlim)
%             sps(j,:)=nest;
%         end
%         if(isneigh(j))
%             eps(j,:)=EPt(k,:);
%         else
%             eps(j,:)=sps(j,:);
%         end
%     end
%     [dat,Cents,EPt,ang_e,len_e]=CheckOrientsNest...
%         (sps,eps,toredo,isneigh,vidfn,Cents,FrameNum,EPt,ang_e,len_e,vObj,shad);
%     save(fn,'Cents','EPt','ang_e','len_e','-append');
%     InsertFrames(fn,fn,dat,FRLEN);
%     isadd=1;
% end