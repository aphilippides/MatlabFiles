function[m,t50,g50,t100]=MushroomPics(J,pc,Vs,Tube,B)
dwork
if((nargin<4)|(~Tube)) cd DiffEqun\MeshTube\Mushroom\Mush
else cd DiffEqun\MeshTube\Mushroom\Tube
end
m=GetAllAvgs(J,pc,Vs,B)
%[m,t50,g50,t100]=DrawPics(J,pc)
%GetAvgs(J,pc,Vs)

function[InterQuarts]=GetAllAvgs(Js,pc,Vs,B)
for j=Js
    j
    InterQuarts=[];
    for p=pc 
        p
        GetRMaxes(j,p,Vs,B)
        %GetAvgs(j,p,Vs)
%         if(ismember(p,[7.5 12.5 17.5]))
%             fn=['Jitter' int2str(j) 'Pc' x2str(p) '0SSt0_5B5MaxGr1000Inn33Out99'];
%         else
%             fn=['Jitter' int2str(j) 'Pc' x2str(p) 'SSt0_5B5MaxGr1000Inn33Out99'];
%         end
        fn=['Jitter' int2str(j) 'Pc' x2str(p) 'SSt0_5B' int2str(B) 'Gr1000Inn33Out99'];
        load([fn 'ReceptMaxes.mat']);
%        InterQuarts=[InterQuarts iqr(maxes)];
        InterQuarts=[InterQuarts; median(maxes) iqr(maxes)];
        %iqr(tmaxes)
    end
    plot(pc,InterQuarts)
end

function GetAvgs(j,p,Vs)
fn=['Jitter' int2str(j) 'Pc' x2str(p) 'SSt0_25B3Gr1000Inn60Out125'];
for i=1:length(Vs)
    mall=load([fn 'V' int2str(Vs(i)) 'Line500.dat'])*1.324e-6;
    m=mall(:,500);
    [MaxC(i),m_ind]=max(m);
    TMax(i)=m_ind;
    THalf(i)=TtoC(MaxC(i)*0.5,m(1:m_ind));
    GradHalf(i)=GradAtC(MaxC(i)*0.5,m(1:m_ind));
    plot(m)
    hold on
end
hold off
save([fn 'Line500x500Avgs.mat'],'MaxC','TMax','THalf','GradHalf','Vs');
% mean(MaxC)
% std(MaxC)
% mean(THalf)
% std(THalf)

function[t]=TtoC(C,m)
t=max(find(m<=C));

function[g]=GradAtC(C,m)
t=max(find(m<=C));
sm=2;
if(t>sm) g=0.1*(m(t+sm)-m(t-sm));
elseif(length(m)>=(t+2*sm)) g=0.1*(m(t+2*sm)-m(t));
else g=0.1*(m(end)-m(t));
end

function[Maxes,Thalfs,GradHalfs,TMaxs]=DrawPics(Js,pc)
for i=1:length(Js)
    for j=1:length(pc)
        load(['Jitter' int2str(Js(i)) 'Pc' x2str(pc(j)) 'SSt0_25B3Gr1000Inn60Out125Line500x500Avgs.mat']);
        Maxes(i,j)=mean(MaxC);
        Thalfs(i,j)=mean(THalf);
        TMaxs(i,j)=mean(TMax);
        GradHalfs(i,j)=mean(GradHalf);
    end
end
surf(pc,Js,Maxes*1e9)
xlabel('% of 37000 KCs active');
XLim([0.1 5]),SetXTicks(gca,[],1,[],[0.1 0.5 1:5])
ylabel('Random firing interval (ms)');
zlabel('Maximum NO Concentration (nM)')
figure
surf(pc,Js,Thalfs)
xlabel('% of 37000 KCs active');
XLim([0.1 5]),SetXTicks(gca,[],1,[],[0.1 0.5 1:5])
ylabel('Random firing interval (ms)');
zlabel('Time to 50% of max [NO] (ms)')
figure
surf(pc,Js,TMaxs)
xlabel('% of 37000 KCs active');
XLim([0.1 5]),SetXTicks(gca,[],1,[],[0.1 0.5 1:5])
ylabel('Random firing interval (ms)');
zlabel('Time to max [NO] (ms)')
figure
surf(pc,Js,GradHalfs)
xlabel('% of 37000 KCs active');
XLim([0.1 5]),SetXTicks(gca,[],1,[],[0.1 0.5 1:5])
ylabel('Random firing interval (ms)');
zlabel('Gradient of [NO] wrt time (dC/dt) at 50% of max [NO]')