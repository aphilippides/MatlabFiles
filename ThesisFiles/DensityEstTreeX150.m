function DensityEstTreeX150(t,X)
dmm3d
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
DrawDensities(150,[100,111,125,142,200,250,333,500,666]);
%DrawDensities(150,[100,200,250,333]);
subplot('Position',[0.6 0.15 0.375 0.8])
DrawOvers([100,200,333]);

function DrawDensities(X,N)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
t=[0.5,1,2,4];
rho=(1./N)
for i=1:length(t)
    [y]=DensityEst1(t(i),X,N);
    plot(rho,y./150^3,Cols(i,:));
%    plot(rho,sqrt(y./pi),Cols(i,:));
    hold on
end
hold off
Setbox
ylabel('Area over threshold (\mum^2)');
ylabel('Area over threshold (Synthesising vol.)');
%h=ylabel({'Threshold distance (\mum)'});
h=xlabel('Density (Vol. of source/synth. vol.)')
moveXYZ(h,0,-0.015,0)
if(X==50) SetXTicks(gca,1,1,3,rho)
    %else SetXTicks(gca,1,1,3,N([1,5:5:20]),x([1,5:5:20]))
end
SetYTicks(gca,5)
%legend(num2str(t'))
h=legend('0.5s','1s','2s','4s',2);
axis tight

function[Over]=DensityEst1(t,X,N)
Sl=4;
for i=1:length(N)
    fn=['MaxTreeRho'x2str(N(i)) '/TreeAvgsSst1MaxGr300X150Z150Sq1Sp10Sl' num2str(Sl) '.mat'];
    load(fn)
    ind=find(Times==t);
    N(i)
    Over(i)=OverAvg(ind);
end

function DrawOvers(N)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
Sl=4;
for i=1:length(N)
    fn=['MaxTreeRho'x2str(N(i)) '/TreeAvgsSst1MaxGr300X150Z150Sq1Sp10Sl' num2str(Sl) '.mat'];
    load(fn)
    plot(Times,OverAvg,Cols(i,:));
    hold on
end
hold off
Setbox
ylabel('Area over threshold (x10^6\mum^2)');
xlabel('Time (s)')
Ds=1./N;
h=legend(num2str(Ds',3),2);
SetYTicks(gca,5,1e-6)

