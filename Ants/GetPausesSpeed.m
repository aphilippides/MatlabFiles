% [dat,smSp]=GetPausesSpeed(Speeds,t,vLim,tLim,sm_len,pl)
%
% This function filters for pauses based on Speeds which is the 1st input
% 
% It first smooths the Speeds over time, t, the 2nd input with a smoothing
% length governed by sm_len which is the length of smoothing in time
% increase sm_len for longer somoothing
%
% It then looks for connected sets of frames that are under vLim which are
% pauses
%
% Finally, it merges any pauses which are within tLim seconds of each other
% this step could be made more sophisticated
%
% the final input argument is pl. pl=1 means plot as you go along which is 
% good for debugging and making sure the various parameters are ok, 
% pl=0 means don't plot
%
% output paramters are dat, which is a structure which holds the dat on the
% pauses. 
% of length sm_len which is in seconds

function[dat,smSp]=GetPausesSpeed(Speeds,t,vLim,tLim,sm_len,pl)
% Smooth the Speeds
% mean smoothing
smSp=TimeSmooth(Speeds,t,sm_len);
% median smoothing
% smSp=medfilt1(Speeds);

dat=[];
ist=1;
c=1;
if(pl); plotPauses(t,smSp,Speeds,dat); end
while 1
    % get the indices from the end of the last pause
    is=ist:length(smSp);
    % find the next point where speed goes below vLim
    i1=find(smSp(is)<vLim,1)+ist-1;
    if(isempty(i1))
        % if none, break out of the while loop
        break;
    else
        % set start of the pause;
        dat(c).sp=i1;
        dat(c).tsp=t(i1);
        
        % set the end by finding the next time it rises above vLim
        i2=find(smSp(i1:end)>vLim,1)+i1-1;
        if(isempty(i2))
            % if there isn't a next point it's the end of the flight
            dat(c).ep=length(smSp);
            dat(c).tep=t(end);
            break
        else
            % if there is, set it as end of the pause
            dat(c).ep=i2-1;
            dat(c).tep=t(i2-1);  
            ist=i2;
        end
        % increment pause count
        c=c+1;
    end
    if(pl); 
        plotPauses(t,smSp,Speeds,dat); 
    end
end

% now merge pauses that are too close
%
% might have to do something more subtle to do with 
% a) speed bee reaches between pauses
% b) distance travelled between end and next start
% c) orientation etc changes between end and next start
%
% currently it just uses time to say that if the pauases are within tLim of
% each other it merges them
while(length(dat)>1)
    ts=[dat.tsp];
    te=[dat.tep];
    td=ts(2:end)-te(1:end-1);
    i=find(td<tLim,1);
    if(isempty(i))
        break;
    else
        dat(i).ep=dat(i+1).ep;
        dat(i).tep=dat(i+1).tep;
        dat=dat([1:i i+2:end]);
    end
    if(pl); plotPauses(t,smSp,Speeds,dat); end
end

for i=1:length(dat)
    dat(i).len=dat(i).tep-dat(i).tsp;
    dat(i).mp=round(0.5*(dat(i).sp+dat(i).ep));
end

function plotPauses(t,smSp,Speeds,dat)
plot(t,smSp,'k',t,Speeds,'g:')
hold on
for i=1:length(dat)
    is=dat(i).sp:dat(i).ep;
    plot(t(is),smSp(is),'r.-')
end
hold off