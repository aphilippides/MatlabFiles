% Enable compatibility mode to old PTB-2:
% Screen('Preference', 'EmulateOldPTB', 1);

% this function runs the reaction ... Mac version
function StartTestMacorig

close all
% change this bit to change where the data files go
cd ('/Users/rebeccahaynes/Desktop/RVIPFiles')
%oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [enableFlag]);
screenNumber = 0;

[window,screenRect] = Screen(screenNumber,'OpenWindow',WhiteIndex(0));

white=WhiteIndex(window);
black=BlackIndex(window);
gray=(white+black)/2;
HideCursor;

% Set up some text for user interface.
Screen(window,'TextFont','Times New Roman');
Screen(window,'TextSize',24);
replyFun='GetNumber';

% Screen(window, 'Flip');

SequenceLen=80;
NumPatterns=8;

fstr='NonePicked';
CarryOn=1;
number2=6;
go=0;
while(CarryOn==1)
	%HideCursor;
   Screen('TextFont',window,'Times New Roman');
   Screen('TextSize',window,24);
   
   Screen('DrawText',window,'1. Show demo',300,200,black);
   Screen('DrawText',window,'2. Run the test',300,250,black);
   Screen('DrawText',window,'3. Show results and quit',300,300,black);
   Screen('DrawText',window,'4. Change parameters',300,350,black);
   Screen('DrawText',window,'5. Quit',300,400,black);
%    Screen('DrawText',window,'Enter a number (followed by Enter or Return):',300,450,black);
   % Get the number, echoed
%    number = str2num(GetString)
   number=str2num(Ask(window,'Enter a number (followed by Enter or Return):   ',black,white,'GetChar'));
%   number = str2num(GetString(window,'Enter a number (followed by Enter or Return):',300,450,black,white));
%    Screen(window,'FillRect',white);
%    Screen('Flip',window);  
   
   if(number ==1)
      RTDemoPTB3(window);
      Screen(window,'TextSize',24);
      Ask(window,'Finished! Hit enter or return to proceed',black,white,'GetChar');
   elseif(number == 2)
      
% Enable compatibility mode to old PTB-2:
%    Screen('Preference', 'EmulateOldPTB', 1);      
    fstr = Ask(window,'   Enter filename:   ',black,white,'GetChar');
    TNumStr = Ask(window,'   Enter test number:   ',black,white,'GetChar');
%     GetEchoString(window,'Enter filename:',300,400,black,white);
%       TNumStr = GetEchoString(window,'Enter test number:',300,400,black,white);
      fname=[fstr TNumStr '.dat'];   
      while(IsFile(fname))
          fstr = Ask(window,'   Filename already used. Enter a new filename:   ',black,white,'GetChar');
          TNumStr = Ask(window,'   Enter test number:   ',black,white,'GetChar');
%          fstr = GetEchoString(window,'Filename already used. Enter a new filename:',300,400,black,white);
%          TNumStr = GetEchoString(window,'Enter test number:',300,400,black,white);
         fname=[fstr TNumStr '.dat']   
      end        
      [RndSet,SeqBegs,SeqEnds] = GetRandomDataSet(number2,SequenceLen,NumPatterns);
      [ins,outs]=RTTestCMU_PTB3(window,RndSet);
      DOut=WriteDataFile(outs,SeqEnds,ins,number2,fname,SequenceLen,NumPatterns);
      Screen(window,'TextSize',24);
      Ask(window,'Finished! Call tester',black,white,'GetChar');
        HideCursor;
 elseif(number == 3)
      [go,fns]=isfile([fstr '*.dat']);
      if(go)
         CarryOn=0;
      else
         Ask(window,'No results yet! Hit enter or return to proceed',black,white,'GetChar');
      end
  elseif(number == 4)
	  
      SequenceLen=0;
      while(SequenceLen<=0)
%          SequenceLen = GetEchoNumber(window,'Enter the sequence length (>0) of the test (followed by Enter or Return):',200,400,black,white);
SequenceLen = str2num(Ask(window,'Enter the sequence length (>0) of the test (followed by Enter or Return):  ',black,white,'GetChar'));
      end
      NumPatterns=-1;   
      while((NumPatterns<0)|(NumPatterns>(SequenceLen/5)))
%          NumPatterns = GetEchoNumber(window,'Enter the number of patterns (>0) of the test (followed by Enter or Return):',200,400,black,white);
NumPatterns = str2num(Ask(window,'Enter the number of patterns (>0) of the test (followed by Enter or Return):  ',black,white,'GetChar'));
      end   
  	  number2=0;
	  while(number2<=0)
%          number2 = GetEchoNumber(window,'Enter the length (>0) of the test (followed by Enter or Return):',200,400,black,white);
number2 = str2num(Ask(window,'Enter the length (>0) of the test (followed by Enter or Return):  'black,white,'GetChar'));
      end
   else
      CarryOn=0;
   end
end
% Close the Screen
ShowCursor;
Screen(window,'Close');
if(go)
   h=subplot(1,3,1);bar(DOut(:,2)),title('Hits'),xlabel('Minutes'),axis tight,set(h,'YLim',[0 NumPatterns])
   h=subplot(1,3,2);bar(DOut(:,3)),title('Misses'),xlabel('Minutes'),axis tight
   Maxmiss = max(max(DOut(:,3)),NumPatterns); 
   set(h,'YLim',[0 Maxmiss]);
   subplot(1,3,3),errorbar(DOut(:,4),DOut(:,5)),title('Mean Reaction Times'),xlabel('Minutes'),axis tight
   DOut
end