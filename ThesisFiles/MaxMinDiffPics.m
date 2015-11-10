function MaxMinDiffPics(V,Sl,Rho)
dmm3d
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
MMDiffs150V2(10,5,100)
dthesisdat
subplot('Position',[0.6 0.15 0.375 0.8])
fn=['MinMaxDiffsRho100Sst1MaxGr300X100Z100Sq1Sp10Sl5.mat'];
load(fn);
plot(T,RelDAvg,ThCols(1));
hold on
fn=['MinMaxDiffsRho100Sst1MaxGr300X100Z100Sq1Sp10Sl1.mat'];
load(fn);MaxMinDiffPics
plot(T,RelDAvg,ThCols(2));
hold off
legend('Whole vol.','Synth vol.',2)
Setbox
xlabel('Time (s)')
ylabel('Relative difference (%)')


function MMDiffs150V2(V,Sl,Rho)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
MaxOver=[];
OverD=[];
MinOver=[];
for i=1:length(V)			% Get average data
    fn=['MaxTreeRho'x2str(Rho) '/TreeV'x2str(V(i)) 'MaxGr300Sq1Sl'x2str(Sl) '.dat'];
    M1=load(fn);
    fn=['MinTreeRho'x2str(Rho) '/TreeV'x2str(V(i)) 'MaxGr300Sq1Sl'x2str(Sl) '.dat'];
    M2=load(fn);
    MEst=0.5*(M1+M2);
    MD=M1-M2;
    S=M1(2,4);
    MaxOver=[MaxOver;S-M1(2:end,4)'];
    MinOver=[MinOver;S-M2(2:end,4)'];
    OverD=[OverD;-MD(2:end,4)'];
    T=M2(2:end,1)';
end
plot(T,MaxOver./(150^3),Cols(1,:),T,MinOver./(150^3),Cols(2,:))
Setbox
ylabel('Area over threshold (\mum^2)');
ylabel('Area over threshold (synthesising vol.)');
%h=ylabel({'Threshold distance (\mum)'});
h=xlabel('Time (s)')
legend('Max. estimate','Min. estimate')
function MMDiffs150(V,Sl,Rho)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
OverD=[];
RelOD=[];
for i=1:length(V)			% Get average data
    fn=['MaxTreeRho'x2str(Rho) '/TreeV'x2str(V(i)) 'MaxGr300Sq1Sl'x2str(Sl) '.dat'];
    M1=load(fn);
    fn=['MinTreeRho'x2str(Rho) '/TreeV'x2str(V(i)) 'MaxGr300Sq1Sl'x2str(Sl) '.dat'];
    M2=load(fn);
    S=M1(1,3)^3;
    MEst=S-0.5*(M1+M2);
    MD=M2-M1;
    OverD=[OverD;MD(2:end,4)'];
    RelOD=[RelOD;[MD(2:end,4)./MEst(2:end,4)]'];
    T=M2(2:end,1);
end
if(i==1) 
    AvgD=OverD;
    AvgRel=RelOD;
else
    AvgD=mean(OverD);
    AvgRel=mean(RelOD);    
end
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
plot(T,AvgD)
subplot('Position',[0.6 0.15 0.375 0.8])
plot(T,AvgRel)