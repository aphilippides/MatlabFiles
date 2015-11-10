% Enable compatibility mode to old PTB-2:
Screen('Preference', 'EmulateOldPTB', 1);

% this function runs the reaction ... Mac version
% function StartTest

close all
% change this bit to change where the data files go
cd ('/Users/rebeccahaynes/Desktop/RVIPFiles')

screenNumber = 0;

[window,screenRect] = SCREEN(screenNumber,'OpenWindow',WhiteIndex(0));
white=WhiteIndex(window);
black=BlackIndex(window);
%HideCursor;

% Set up some text for user interface.
%SCREEN(window,'TextFont','Times New Roman');
%SCREEN(window,'TextSize',24);
%replyFun='GetNumber';
return

SequenceLen=80;
NumPatterns=8;

fstr='NonePicked';
CarryOn=1;
number2=6;
go=0;
while(CarryOn==1)
	%HideCursor;
   %SCREEN(window,'TextFont','Times New Roman');
   %SCREEN(window,'TextSize',24);
   
   SCREEN(window,'DrawText','1. Show demo',300,200,black);
   SCREEN(window,'DrawText','2. Run the test',300,250,black);
   SCREEN(window,'DrawText','3. Show results and quit',300,300,black);
   SCREEN(window,'DrawText','4. Change parameters',300,350,black);
   SCREEN(window,'DrawText','5. Quit',300,400,black);
   
   % Get the number, echoed
   number = GetEchoNumber(window,'Enter a number (followed by Enter or Return):',300,450,black,white);
   
   SCREEN(window,'DrawText','1. Show demo',300,200,white);
   SCREEN(window,'DrawText','2. Run the test',300,250,white);
   SCREEN(window,'DrawText','3. Show results and quit',300,300,white);
   SCREEN(window,'DrawText','4. Change parameters',300,350,white);
   SCREEN(window,'DrawText','5. Quit',300,400,white);
   
   if(number ==1)
      RTDemo(window);
      SCREEN(window,'TextSize',24);
      Ask(window,'Finished! Hit enter or return to proceed',black,white,'GetNumber');
   elseif(number == 2)
      
      fstr = GetEchoString(window,'Enter filename:',300,400,black,white);
      TNumStr = GetEchoString(window,'Enter test number:',300,400,black,white);
      fname=[fstr TNumStr '.dat'];   
      while(IsFile(fname))
         fstr = GetEchoString(window,'Filename already used. Enter a new filename:',300,400,black,white);
         TNumStr = GetEchoString(window,'Enter test number:',300,400,black,white);
         fname=[fstr TNumStr '.dat']   
      end        
      [RndSet,SeqBegs,SeqEnds] = GetRandomDataSet(number2,SequenceLen,NumPatterns);
      [ins,outs]=RTTestCMUNew(window,RndSet);
%      [ins,outs]=RTTest2(window,RndSet);
      DOut=WriteDataFile(outs,SeqEnds,ins,number2,fname,SequenceLen,NumPatterns);
      SCREEN(window,'TextSize',24);
      Ask(window,'Finished! Call tester',black,white,'GetNumber');
        HideCursor;
 elseif(number == 3)
      [go,fns]=isfile([fstr '*.dat']);
      if(go)
         CarryOn=0;
      else
         Ask(window,'No results yet! Hit enter or return to proceed',black,white,'GetNumber');
      end
  elseif(number == 4)
	  
      SequenceLen=0;
      while(SequenceLen<=0)
         SequenceLen = GetEchoNumber(window,'Enter the sequence length (>0) of the test (followed by Enter or Return):',200,400,black,white);
      end
      NumPatterns=-1;   
      while((NumPatterns<0)|(NumPatterns>(SequenceLen/5)))
         NumPatterns = GetEchoNumber(window,'Enter the number of patterns (>0) of the test (followed by Enter or Return):',200,400,black,white);
      end   
  	  number2=0;
	  while(number2<=0)
         number2 = GetEchoNumber(window,'Enter the length (>0) of the test (followed by Enter or Return):',200,400,black,white);
      end
   else
      CarryOn=0;
   end
end
% Close the screen
ShowCursor;
SCREEN(window,'Close');
if(go)
   h=subplot(1,3,1);bar(DOut(:,2)),title('Hits'),xlabel('Minutes'),axis tight,set(h,'YLim',[0 NumPatterns])
   h=subplot(1,3,2);bar(DOut(:,3)),title('Misses'),xlabel('Minutes'),axis tight
   Maxmiss = max(max(DOut(:,3)),NumPatterns); 
   set(h,'YLim',[0 Maxmiss]);
   subplot(1,3,3),errorbar(DOut(:,4),DOut(:,5)),title('Mean Reaction Times'),xlabel('Minutes'),axis tight
   DOut
end

