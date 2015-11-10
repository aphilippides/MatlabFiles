function StartTest

close all
cd('C:\My Documents\RVIPData');
screenNumber = 0;
[window,screenRect] = SCREEN(screenNumber,'OpenWindow',WhiteIndex(0));
white=WhiteIndex(window);
black=BlackIndex(window);
HideCursor;

% Set up some text for user interface.
SCREEN(window,'TextFont','Times New Roman');
SCREEN(window,'TextSize',24);
replyFun='GetNumber';

SequenceLen=80;
NumPatterns=8;

fstr='NonePicked';
CarryOn=1;
number2=0;
go=0;
while(CarryOn==1)
    SCREEN(window,'TextFont','Times New Roman');
    SCREEN(window,'TextSize',24);
    
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
            fname=[fstr TNumStr '.dat'];   
        end        
        while(number2<=0)
        		number2 = GetEchoNumber(window,'Enter the length (>0) of the test (followed by Enter or Return):',300,400,black,white);
        end
        [RndSet,SeqBegs,SeqEnds] = GetRandomDataSet(number2,SequenceLen,NumPatterns);
        
        for i=1:30
           [ins,dt(i)]=TestPiccies3(window,RndSet,0);
        [ins,dt1(i)]=TestPiccies3(window,RndSet,1);
        [ins,dt2(i)]=TestPiccies3(window,RndSet,2);
        [ins,dt3(i)]=TestPiccies4(window,RndSet,3);
     end
     plot(dt,'y')
     hold on,plot(dt1,'r'),plot(dt2,'b'),plot(dt3,'g')
		a0=[mean(dt) std(dt)]
		a1=[mean(dt1) std(dt1)]
		a2=[mean(dt2) std(dt2)]
		a3=[mean(dt3) std(dt3)]


  %      DOut=WriteDataFile(outs,SeqEnds,ins,number2,fname,SequenceLen,NumPatterns);
        
        SCREEN(window,'TextSize',24);
        Ask(window,'Finished! Call tester',black,white,'GetNumber');
      elseif(number == 3)
        [go,fns]=isfile([fstr '*.dat']);
        if(go)
            CarryOn=0;
        else
            Ask(window,'No results yet! Hit enter or return to proceed',black,white,'GetNumber');
         end
      elseif(number == 4)
      SequenceLen=0;
		NumPatterns=-1;   
        while(SequenceLen<=0)
        		SequenceLen = GetEchoNumber(window,'Enter the sequence length (>0) of the test (followed by Enter or Return):',300,400,black,white);
        end
        while((NumPatterns<0)|(NumPatterns>(SequenceLen/5)))
        		NumPatterns = GetEchoNumber(window,'Enter the number of patterns (>0) of the test (followed by Enter or Return):',300,400,black,white);
           end   
        else
           CarryOn=0;
    end
end
% Close the screen
ShowCursor;
SCREEN(window,'Close');
%DOut=WriteDataFile(outs,SeqEnds,ins,number2,fname,SequenceLen,NumPatterns);
if(go)
	subplot(1,3,1),bar(DOut(:,1)),title('Hits'),axis tight
	subplot(1,3,2),bar(DOut(:,2)),title('Misses'),axis tight
	subplot(1,3,3),errorbar(DOut(:,3),DOut(:,4)),title('Mean Times'),axis tight
   DOut
end

%ShowResults(fns)