function MaxMinDiffPicsX100(V,Sl,Rho)
d3dmm
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
MMDiffs100(1,5,100)
subplot('Position',[0.6 0.15 0.375 0.8])
MMDiffs100(1,1,100)

function MMDiffs100(V,Sl,Rho)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
MaxOver=[];
OverD=[];
MinOver=[];
for i=1:length(V)			% Get average data
    fn=['MaxTreeRho'x2str(Rho) '/TreeSSt1V'x2str(V(i)) 'MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.dat'];
    M1=load(fn);
    fn=['MinTreeRho'x2str(Rho) '/TreeSSt1V'x2str(V(i)) 'MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.dat'];
    M2=load(fn);
    MEst=0.5*(M1+M2);
    MD=M1-M2;
    S=M1(2,4);
    MaxOver=[MaxOver;S-M1(2:end,4)'];
    MinOver=[MinOver;S-M2(2:end,4)'];
    OverD=[OverD;-MD(2:end,4)'];
    T=M2(2:end,1)';
end
plot(T,MaxOver./(100^3),Cols(1,:),T,MinOver./(100^3),Cols(2,:))
Setbox
ylabel('Area over threshold (\mum^2)');
ylabel('Area over threshold (synthesising vol.)');
%h=ylabel({'Threshold distance (\mum)'});
h=xlabel('Time (s)')
legend('Max. estimate','Min. estimate',2)
function MMDiffs150(V,Sl,Rho)

FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
plot(T,AvgD)
subplot('Position',[0.6 0.15 0.375 0.8])
plot(T,AvgRel)