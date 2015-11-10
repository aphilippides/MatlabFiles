function[m,s,t1,t2,is,ie]=PivotPoints(fn,t1,a,b,n)
if(nargin<5) n=1; end;
load(fn)
if(nargin<2) t1=t(1); end
if(nargin<3) a=4; end
if(nargin<4) b=3; end
si=find(t>=t1,1);
is=si;
while 1
    % Get ts
    t2=t(min(si+1,length(t)));
    ts=[t1,t2];
    % Plot figs
%     figure(a), 
%     [c,p]=PlotArcCentre(Cents,sOr,[nest;LM],t,ts(1),ts(2));
%     hold on, x=axis;
%     plot(p(:,1),p(:,2),'b.'),
%     title(['Start = ' num2str(t1) '; End = ' num2str(t2)])
%     axis(x); hold off
%     m=mean(p,1); 
    figure(b),PlotArc(Cents,EndPt,[nest;LM],t,ts(1),ts(2));
%     hold on; plot(m(1),m(2),'r.')
%     s=std(p,0,1);MyCircle(m,mean(s)); hold off
    % Get input and carry on
    title(['Start = ' num2str(t1) '; End = ' num2str(t2)])
    inp=input('return=continue, u=go up one, f=finish\nt-number is new start time:\n','s');
    if(isempty(inp)) 
        si=si+n;
    elseif(inp(1)=='t')
        if(length(inp)==1) si=is;
        else
            t1=str2num(inp(2:end));
            si=find(t>=t1,1);
            is=si;
        end
    elseif(inp(1)=='f') break;
    elseif(inp(1)=='n') n=str2num(inp(2:end));
    else si=si-n;
    end
end
ie=si;