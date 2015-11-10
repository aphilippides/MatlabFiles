function OutputsFigCode(action)

switch(action)
   
case 'PlotOutputs'
   AxisHdls=findobj(gcf,'Tag','SubFig'); %delete old plots
   delete(AxisHdls);
	AxisHdls=findobj(gcf,'Tag','TransFig'); %delete old plots
   delete(AxisHdls);
   
   Outdat=get(gcf,'UserData');	% Activity data
   TransDat=LoadDataFile('TransferActivity'); % Transfer data
   transx=-5:1:5;
   
   NdHdl=findobj(gcf,'Tag','edNodes');
   nodes=str2num(get(NdHdl,'String'));
   Pos=get(NdHdl,'Position');
   Gap=0.025;
   ItHdl=findobj(gcf,'Tag','edPlotLen');
   Len=str2num(get(ItHdl,'String'));
	Iters=get(ItHdl,'UserData');   
  	StartHdl=findobj(gcf,'Tag','edStart');
   Start=str2num(get(StartHdl,'String'));
	TrHdl=findobj(gcf,'Tag','edTransIt');
   TrNum=str2num(get(TrHdl,'String'))+1;
   FigHt=(1-Pos(4)-Gap)./length(nodes)-Gap;
   for i=1:length(nodes)	
      % draw outputs
      activ=Outdat(2:(Iters+1),nodes(i)+1);
      axish=axes('position',[ 0.15 (i*Gap+(i-1)*FigHt) 0.7 FigHt], ...
         'Userdata',activ,'nextplot', 'add', ...
         'Tag', 'SubFig');
   	plot(activ);
   	ylabel(int2str(nodes(i)));
   	axis([Start Start+Len -1.01 1.01])
      grid;
      % Draw transfers
      trans=TransDat(2:(Iters+3),nodes(i)+1);
      y=tanh(transx*trans(TrNum)+trans(1));
      axish=axes('position',[ 0.86 (i*Gap+(i-1)*FigHt) 0.13 FigHt], ...
         'Userdata',trans,'nextplot', 'add', ...
         'Tag', 'TransFig');
      plot(transx,y);
      axis([-5 5 -1.01 1.01])
   end
   
case 'SetAxes'
   AxisHdls=findobj(gcf,'Tag','SubFig');
   ItHdl=findobj(gcf,'Tag','edPlotLen');
   Iters=str2num(get(ItHdl,'String'));
  	StartHdl=findobj(gcf,'Tag','edStart');
   Start=str2num(get(StartHdl,'String'));
   set(AxisHdls,'XLim',[Start Iters+Start]);   
   
case 'SetTransNum'
   x=-5:1:5;
   TrHdl=findobj(gcf,'Tag','edTransIt');
   TrNum=str2num(get(TrHdl,'String'))+1;
	AxisHdls=findobj(gcf,'Tag','TransFig');
   for i=1:length(AxisHdls)
      trans=get(AxisHdls(i),'UserData');
      y1=tanh(x*trans(2)+trans(1));
      y2=tanh(x*trans(TrNum)+trans(1));
   	axes(AxisHdls(i)),cla,plot(x,y1,'b:',x,y2,'r');
   end
   
case 'TransIt'
   TrHdl=findobj(gcf,'Tag','edTransIt');
   TrNum=str2num(get(TrHdl,'String'));
   set(TrHdl,'String',num2str(TrNum+1));
   OutputsFigCode SetTransNum;
   
case 'OneIt'
  	Outdat=get(gcf,'UserData');	% Activity data
  	TransDat=LoadDataFile('TransferActivity'); 
  	nodes=0:1:NumNodes-1;
  	inputs=get(gcbo,'UserData');
  	danger=[zeros(160,1) ones(160,1)];
	  
end
