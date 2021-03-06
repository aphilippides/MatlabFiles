function RTTestFindBug

window = SCREEN(0,'OpenWindow',WhiteIndex(0));
white=WhiteIndex(window);
black=BlackIndex(window);
NumList=1:9;

StrNum=int2str(NumList');
SCREEN(window,'TextSize',72);
SCREEN(window,'TextFont','Times New Roman');

getsecs;
KbCheck;
SCREEN('Screens');		% Make sure all Rushed functions are in memory.

Ask(window,'Hit enter or return to start the test',black,white,'GetNumber');
while(KbCheck) end;
loop={
'for i=1:length(NumList);'
'    SCREEN(window,''DrawText'',StrNum(i,:),500,350,black);'
'    tend=getsecs+0.75;'
'    while (getsecs<=tend);'
'        if(KbCheck);'
'           fprintf(''Getting Keyboard input'');'
'        end;'
'    end;'
'    SCREEN(window,''DrawText'',StrNum(i,:),500,350,white);'
'end;'
};
RUSH(loop,2);  % if I rush at priority 1, KBCheck works, 
               % but if I rush at priority 2, keyboard input appear to be blocked
ShowCursor;
SCREEN(window,'Close');