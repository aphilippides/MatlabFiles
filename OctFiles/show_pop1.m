function show_pop1()

xgraph=2;
ygraph=3;
filename=['pop'];
eval(['load ' filename '.dat -ascii;']);
eval(['Popdat=' filename ';']);
Gen = Popdat(:,1);
TopFit= Popdat(:,2);
avgFit= Popdat(:,3);
FitNodes= Popdat(:,4);
LongestNodes= Popdat(:,5);
avgNodes= Popdat(:,6);
FitTest1= Popdat(:,7);
avgTest1= Popdat(:,8);
FitTest2= Popdat(:,9);
avgTest2= Popdat(:,10);
FitHt= Popdat(:,11);
avgHt= Popdat(:,12);

%FitLeft= Popdat(:,11);
%avgLeft= Popdat(:,12);
%FitBump= Popdat(:,13);
%avgBump= Popdat(:,14);
%FitPenStab= Popdat(:,15);
%avgPenStab= Popdat(:,16);
%set('Fontsize',10);
subplot(ygraph,xgraph,1);h1=plot(Gen,TopFit,Gen,avgFit);
title('Fitness');legend('Fit','avg');
%Y=get(gca,'YLim');set(gca,'Ylim',[Y(1) 2000]);
set(gca,'Ylim',[-1000 2100]);
subplot(ygraph,xgraph,2);h2=plot(Gen,FitNodes,Gen, LongestNodes, Gen,avgNodes);
title('NumNodes');legend('fit','long','avg');
subplot(ygraph,xgraph,3);h3=plot(Gen,FitTest1,Gen,avgTest1);
title('Test1 Fitness');legend('Fit','avg');
set(gca,'Ylim',[-1000 1100]);
subplot(ygraph,xgraph,4);h4=plot(Gen,FitTest2,Gen,avgTest2);
title('Test2 Fitness');legend('Fit','avg');
set(gca,'Ylim',[-1000 1100]);
subplot(ygraph,xgraph,5);h5=plot(Gen,FitHt,Gen,avgHt);
title('Ht Fitness');legend('Fit','avg');
R=input('enter number you want to see closer[1-8]or quit (0)');
while (R~=0)
   figure;
	axes
   eval(['copyobj(h' int2str(R) ',gca);']);
   R=input('enter number you want to see closer[1-8]or quit (0)');
end

return
