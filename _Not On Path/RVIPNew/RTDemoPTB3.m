function RTDemoPTB3(window)%window = SCREEN(0,'OpenWindow',WhiteIndex(0));white=WhiteIndex(window);black=BlackIndex(window);% Report the number and wait for responseAsk(window,'Hit enter or return to start the demo',black,white,'GetChar');NumList=1:9;StrNum=int2str(NumList');ins=zeros(size(NumList));% set font size for numbersSCREEN('TextSize',window,72);% set position of text% r=SCREEN(window,'Rect');% XPos=0.5*(r(3)-r(1));% YPos=0.5*(r(4)-r(2));SCREEN('TextFont',window,'Times New Roman');%for i=1:1000secs=0;count=1;getsecs;NotStillPressed=1;out=0;while(KbCheck) end;tstart=getsecs;tend=tstart+0.75;tstart=getsecs;% DrawFormattedText(w, StrNum(1,:), 'center', 'center', 0);%    Screen('Flip',window);  % SCREEN(window,'DrawText',StrNum(1,:),XPos,YPos,black);%tend=tstart+0.75;ins(1)=tstart;% while (getsecs<=tend)%    if(KbCheck)%       if(NotStillPressed)%          NotStillPressed=0;%          out(count)=getsecs;%          count=count+1;%       end%    else%       NotStillPressed=1;%    end% endtend=getsecs;for i=1:length(NumList)%     SCREEN(window,'DrawText',StrNum(i-1,:),XPos,YPos,white);%     if(KbCheck)%         if(NotStillPressed)%             NotStillPressed=0;%             out(count)=getsecs;%             count=count+1;%         end%     else%         NotStillPressed=1;%     end%     SCREEN(window,'DrawText',StrNum(i,:),XPos,YPos,black);    DrawFormattedText(window, StrNum(i,:), 'center', 'center', black);     Screen('Flip',window);  %     Screen('Flip',window,[],[],2);  %     tend=tend+0.75; 	tend=getsecs+0.75;    %     Screen('Flip',window,tend);  	ins(i)=getsecs;    while (getsecs<=tend)        if(KbCheck)            if(NotStillPressed)	           NotStillPressed=0;   	           out(count)=getsecs;               count=count+1;            end        else            NotStillPressed=1;        end    endend% testend=9*0.75-getsecs+tstart% SCREEN(window,'DrawText',StrNum(i,:),XPos,YPos,white);ins-ins(1)out-ins(1)%OutList=[1 3 4 6 8 10];%WriteDataFile(out,OutList,ins,mins);%SCREEN(window,'Close');