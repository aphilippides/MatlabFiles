% function plotlms(fn,ts)
%
% This function plots data pertaining to each landmark vs time
% Top subplot is distance to the nest
% 2nd subplot is retinal position of the 1st LM (0 is directly ahead)
% 3rd subplot is angle between bee and 2nd LM (0 is...)
 
function plotlms(fn,ts)

load(fn)
if(~exist('t')) t=FrameNum*0.02; end;
if((nargin<2)|isempty(ts)) is=1:length(t);
else is=GetTimes(t,ts);
end

n=4;
for j=1:size(LMs,1)
%     for i=1:fs
        subplot(n,1,1)
        plot(t(is),DToNest(is)),
        title('Distance to nest'),axis tight 
        ylim([0 max(DToNest(is))])
        subplot(n,1,2)
        plot(t(is),AngleWithoutFlip(LMs(j).LMOnRetina(is))*180/pi);
        title(['Retinal position of LM at ' num2str(LMs.LM(j,:))]),axis tight 
        subplot(n,1,3)
        plot(t(is),AngleWithoutFlip(LMs(j).OToLM(is))*180/pi);
        title('Angular position relative to LM'),axis tight 
        subplot(n,1,4)
        plot(t(is),LMs(j).DToLM(is));
        title('Distance to LM'),axis tight
        ylim([0 max(LMs(j).DToLM(is))])
        xlabel(fn);
        if(j<size(LMs,1)) figure; end;

%     end
end
% if(nargin<2) 
%     disp('Variables are:\n') 
%     disp('1: Dist To Nest;     2: Body Orientation\n')
%     disp('3: Angle wrt nest;   4: Speed\n')
%     disp('5: Flight Direction; 2: Body Orientation\n')
%     disp('7: Dist To Nest;     2: Body Orientation\n')
%     disp('9: Dist To Nest;     2: Body Orientation\n')
%     disp('11: Dist To Nest;    2: Body Orientation\n')
%     
%     fs=input('Select variables to plot\n')
%     fs=[1:4]; 
% 
% end;
% if(nargin<4) xs = zeros(size(fs)); end;
% 
% n=length(fs);
% 
% for i=1:n
%     subplot(n,1,i)
%     x=GetData(fn,fs(i))
%     plot(t(is),x(is))
% end
% 
