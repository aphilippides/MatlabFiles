function[ins,out] = RTTestKBCheck(window,NumList)

%window = SCREEN(0,'OpenWindow',WhiteIndex(0));
white=WhiteIndex(window);
black=BlackIndex(window);

% Report the number and wait for response
Ask(window,'Hit mouse to start the test',black,white,'GetNumber');

StrNum=int2str(NumList');
ins=zeros(size(NumList));
SCREEN(window,'TextSize',72);
SCREEN(window,'TextFont','Times New Roman');
[keyIsDown,secs,keyCode] = KbCheck;
%for i=1:1000
secs=0;
count=1;
getsecs;
NotStillPressed=1;
out=[];
tstart=getsecs;
tend=tstart+0.75;
SCREEN('Screens');		% Make sure all Rushed functions are in memory.
while(KbCheck) end;
    SCREEN(window,'DrawText',StrNum(1,:),500,350,black);
tstart=getsecs;
   tend=tstart+0.75;
ins(1)=tstart;
while (getsecs<=tend);
   if(KbCheck);
      if(NotStillPressed);           
         NotStillPressed=0;
         out(count)=getsecs;
         count=count+1;
     end;
 else;
      NotStillPressed=1;
  end;
end;
for i=2:length(NumList);
    SCREEN(window,'DrawText',StrNum(i-1,:),500,350,white);
    if(KbCheck);
        if(NotStillPressed);            	
            NotStillPressed=0;
            out(count)=getsecs;
            count=count+1;
        end;
    else;
        NotStillPressed=1;
    end;
    SCREEN(window,'DrawText',StrNum(i,:),500,350,black);
	tstart=getsecs;
    tend=tend+0.75;
    ins(i)=tstart;
    while (getsecs<=tend);
        if(KbCheck);
            if(NotStillPressed);            
	           NotStillPressed=0;
   	           out(count)=getsecs;
               count=count+1;
           end;
       else;
            NotStillPressed=1;
        end;
    end;
end;
SCREEN(window,'DrawText',StrNum(i,:),500,350,white);
tend=tend+0.25;
while (getsecs<=tend);
    if(KbCheck);
        if(NotStillPressed);            	
            NotStillPressed=0;
            out(count)=getsecs;
            count=count+1;
        end;
    else;
        NotStillPressed=1;
    end;
end;

testend=getsecs;
%fprintf( 'RT: %.5f .\n', (testend-ins(1)));
ins-ins(1)
out-ins(1)
