% FHNeuron(StartV,StartW,NS,tstep)
%
% Some typical start values
% FHNeuron(0.5,0.5,400,0.25)
% FHNeuron(0,0,200,0.25)

function FHNeuron(StartV,StartW,NS,tstep)
% MaxT=1000;
% tstep=0.1;
% Initialise x and y
v(1) = StartV;
w(1) = StartW;
ts=[1:NS]*tstep;
I = Current(ts,6);
% number of time steps (length of time)/(size of time step)
for t=1:NS
    
    % iterate through the predator-prey equations storing the resultant
    % points in vectors for plotting
    dvdt=-v(t).^3-w(t)+I(t);
    v(t+1)=v(t)+tstep*dvdt;
    w(t+1) = w(t)+tstep*0.08*(v(t)+0.7-0.8*w(t));
    subplot(1,2,1),
    plot(ts(t:t+1),v(t:t+1),'b-*',ts(t:t+1),w(t:t+1),'r-s','LineWidth',2)
    hold on
    plot(ts(1:t+1),v,'b',ts(1:t+1),w,'r',ts,I,'k--')
    xlim([0 max(ts(t+1),1.5)])
    ylim([-1 1.4])
    hold off
    xlabel('t')
    subplot(1,2,2),
    plot(v,w),hold on; 
    plot(v(t:t+1),w(t:t+1),'r-*','LineWidth',2)
    text(0.05,0.05,['V = ' num2str(v(t+1),2)],'Units','normalized','color','b');
    text(0.35,0.05,['dV/dt = ' num2str(dvdt,2)],'Units','normalized','Color','k');
    text(0.75,0.05,['W = ' num2str(w(t+1),2)],'Units','normalized','Color','r');
    xlabel('V')
    ylabel('W')
    hold off
    pause(0.1)
end

% generate a time vector and plot x and y against time and the phase plane
% t=[0:length(x)-1]*tstep;
% subplot(1,2,1),plot(t,x,'b',t,y,'r')
% subplot(1,2,2),plot(x,y) 

function[I] = Current(ts,period);
I=sin(ts*(2*pi)/period)>0;