function FENSColorbar(LowLim,UpLim)

FHndl=figure;
AxHndl=axes;
NumTicks=0;
Poses=get(AxHndl,'Position');
Poses(3)=0.125;
set(AxHndl,'Position',Poses);
aff=2.5e-7;%./(0.00331*.04)
caxis('manual')
caxis([0 aff]);
shading interp
colorbar(AxHndl)

set(AxHndl,'TickLength',[0 0]);
AxLimit=get(AxHndl,'CLim');
TickInc=(AxLimit(2)-AxLimit(1))/NumTicks;
TickPoses=AxLimit(1):TickInc:AxLimit(2);
aff2=0.25;
LabInc=aff2/NumTicks;
TickNums=0:LabInc:aff2;
TickLabels=num2str(TickNums')
set(AxHndl,'YTick',TickPoses);
%TickLabels={'0';'0.125';'0.25 \muM'};
set(AxHndl,'YTickLabel',TickLabels);
%labHndl=ylabel('Concentration (\muM)','FontSize',12)
set(AxHndl,'Box','off')
print -dtiffnocompression -r300 Sq2Sp30/ColorbarThreshNoNums.tif