function show_pop()

filename=['pop'];
eval(['load ' filename '.dat -ascii;']);
eval(['Popdat=' filename ';']);
Gen = Popdat(:,1);
TopFit= Popdat(:,2);
avgFit= Popdat(:,3);
FitNodes= Popdat(:,4);
LongestNodes= Popdat(:,5);
avgNodes= Popdat(:,6);
FitOff= Popdat(:,7);
avgOff= Popdat(:,8);
FitRight= Popdat(:,9);
avgRight= Popdat(:,10);
FitLeft= Popdat(:,11);
avgLeft= Popdat(:,12);
FitBump= Popdat(:,13);
avgBump= Popdat(:,14);
FitPenStab= Popdat(:,15);
avgPenStab= Popdat(:,16);
FitPenStan= Popdat(:,17);
avgPenStan= Popdat(:,18);
%set('Fontsize',10);
subplot(4,2,1);h1=plot(Gen,TopFit,Gen,avgFit);
title('Fitness');legend('Fit','avg');

subplot(4,2,2);h2=plot(Gen,FitNodes,Gen, LongestNodes, Gen,avgNodes);
title('NumNodes');legend('fit','long','avg');
subplot(4,2,3);h3=plot(Gen,FitOff,Gen,avgOff);
title('Off Fitness');legend('Fit','avg');
subplot(4,2,4);h4=plot(Gen,FitRight,Gen,avgRight);
title('Right Fitness');legend('Fit','avg');
subplot(4,2,5);h5=plot(Gen,FitLeft,Gen,avgLeft);
title('Left Fitness');legend('Fit','avg');
subplot(4,2,6);h6=plot(Gen,FitBump,Gen, avgBump);
title('Bumper Fitness');legend('Fit','avg');
subplot(4,2,7);h7=plot(Gen,FitPenStab,Gen,avgPenStab);
title('Stability Penalty');legend('Fit','avg');
subplot(4,2,8);h8=plot(Gen,FitPenStan,Gen,avgPenStan);
title('Standing Penalty');legend('Fit','avg');
R=input('enter number you want to see closer[1-8]or quit (0)');
while (R~=0)
   figure;
	axes
   eval(['copyobj(h' int2str(R) ',gca);']);
   R=input('enter number you want to see closer[1-8]or quit (0)');
end
