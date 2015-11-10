function StartTestKBCheck

close all
%cd('C:\My Documents\RVIPData');
cd('C:\Documents and Settings\administrator\My Documents\Documents\Jenny\RVIPData');
screenNumber = 0;
[window,screenRect] = SCREEN(screenNumber,'OpenWindow',WhiteIndex(0));
white=WhiteIndex(window);
black=BlackIndex(window);
HideCursor;

% Set up some text for user interface.
SCREEN(window,'TextFont','Times New Roman');
SCREEN(window,'TextSize',24);
replyFun='GetNumber';

SequenceLen=10;
NumPatterns=2;

fstr='NonePicked';
CarryOn=1;
number2=1;
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
    
    if(number == 4)
        SequenceLen=0;
        NumPatterns=-1;   
        while(SequenceLen<=0)
            SequenceLen = GetEchoNumber(window,'Enter the sequence length (>0) of the test (followed by Enter or Return):',300,400,black,white);
        end
        while((NumPatterns<0)|(NumPatterns>(SequenceLen/5)))
            NumPatterns = GetEchoNumber(window,'Enter the number of patterns (>0) of the test (followed by Enter or Return):',300,400,black,white);
        end   
    elseif(number==5)
        CarryOn=0;
    else
        fstr = 'test';
        TNumStr = ['10'];
        fname=['test10.dat'];   
        while(IsFile(fname))
            fstr = GetEchoString(window,'Filename already used. Enter a new filename:',300,400,black,white);
            TNumStr = GetEchoString(window,'Enter test number:',300,400,black,white);
            fname=[fstr TNumStr '.dat'];   
        end        
        
        while(number2<=0)
            number2 = 2;%GetEchoNumber(window,'Enter the length (>0) of the test (followed by Enter or Return):',300,400,black,white);
        end
        [RndSet,SeqBegs,SeqEnds] = GetRandomDataSet(number2,SequenceLen,NumPatterns);
        [ins,outs]=RTTest2KBCheck(window,RndSet)
        fname2=[fstr TNumStr '.mat'];  
        save(fname2,'ins','outs');
        Data=[outs ins];
        save(fname,'Data','-ascii');
        outs-ins(1)
        SCREEN(window,'TextSize',24);
        Ask(window,'Finished! Call tester',black,white,'GetClicks');
        CarryOn=0;
    end
end
% Close the screen
ShowCursor;
SCREEN(window,'Close');
if(go)
    subplot(1,3,1),bar(DOut(:,2)),title('Hits'),xlabel('Minutes'),axis tight
    subplot(1,3,2),bar(DOut(:,3)),title('Misses'),xlabel('Minutes'),axis tight
    subplot(1,3,3),errorbar(DOut(:,4),DOut(:,5)),title('Mean Reaction Times'),xlabel('Minutes'),axis tight
    DOut
end