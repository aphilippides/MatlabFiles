function[ins,out] = RTTestCMU()port=psychserial('open', '.Bin', '.Bout', 19200);t=getsecs;i=0;ins=[];b=1;pauset=getsecs;count=0;%while((getsecs-t)<5.75)while(count<20000)%	a=psychserial('read', port,10,5.75)	a=psychserial('read', port,1,0.0001);%	ins=[ins double(a)];%	if(uint8(a)==4) ins=[ins getsecs-t]; end;	if(~isempty(a))		if(uint8(a)==4)			ins=[ins getsecs-t];		end	end			%	ins=[ins getsecs-t];	count=count+1;end	tlength=getsecs-tpsychserial('close', port);countout=areturnt=getsecs;for i=1:1%(getsecs<t)	ins=psychserial('read', port,5,20);	count1=count1+1	if(~isempty(a))		%keyboard		ins(count)=double(a);		count=count+1;	endendreturnins=getsecs-tt=getsecs;for i=1:1%(getsecs<t)	a=psychserial('read', port,5,0.75);	count1=count1+1;	if(~isempty(a))		ins(count)=double(a);		count=count+1;	endendout=getsecs-treturncount1count=1;count1=0;t=getsecs+75;loop={'while(getsecs<t);''	a=psychserial(''read'', port,5,0.75);'	'count1=count1+1;'	'if(~isempty(a));''		ins(count)=double(a);''		count=count+1;''	end;''end;'};RUSH(loop,7);count1returnloop={'for i=1:1;'	'a=1;'    'ins= psychserial(''read'', port,5,4);'	%'ins(i)=getsecs-t;''end;'};RUSH(loop,7);getsecs-tpsychserial('close', port);returnloop={    'a= psychserial(''read'', port, 5,0.75);'};RUSH(loop,0.5);NumList=1:10;window = SCREEN(0,'OpenWindow',WhiteIndex(0));white=WhiteIndex(window);black=BlackIndex(window);% Report the number and wait for responseAsk(window,'Hit enter or return to start the test',black,white,'GetNumber');StrNum=int2str(NumList');ins=zeros(size(NumList));SCREEN(window,'TextSize',72);SCREEN(window,'TextFont','Times New Roman');%for i=1:1000secs=0;count=1;getsecs;NotStillPressed=1;out=[];tstart=getsecs;tend=tstart+0.75;SCREEN('Screens');		% Make sure all Rushed functions are in memory.port=psychserial('open', '.Bin', '.Bout', 14400);a0=psychserial('read', port,0.020);a= psychserial('read', port, 0.001);loop={    'SCREEN(window,''DrawText'',StrNum(1,:),500,350,black);'    'tstart=getsecs;'    'tend=tstart+0.75;'    'ins(1)=tstart;'    'while (getsecs<=tend);'    '   a= psychserial(''Read'', port,0.001);'    '       if(~isempty(a));'    '               if(double(a)==65410); '%    '	                NotStillPressed=0;'    '   	            out(count)=getsecs;'    '                   count=count+1;'%	'					fprintf(''count = %d a = %s\n'',a,count);'    '               end;'%    '           else;'%    '            NotStillPressed=1;'    '        end;'    'end;'    'for i=2:length(NumList);'    '   SCREEN(window,''DrawText'',StrNum(i-1,:),500,350,white);'    '   a= psychserial(''Read'', port, 0.001);'    '       if(~isempty(a));'    '               if(double(a)==65410); '%    '	                NotStillPressed=0;'    '   	            out(count)=getsecs;'    '                   count=count+1;'%	'					fprintf(''count = %d a = %s\n'',a,count);'    '               end;'%    '           else;'%    '            NotStillPressed=1;'    '        end;'    '    SCREEN(window,''DrawText'',StrNum(i,:),500,350,black);'    '	tstart=getsecs;'    '    tend=tend+0.75;'    '    ins(i)=tstart;'    '    while (getsecs<=tend);'    '       a= psychserial(''Read'', port, 0.001);'    '       if(~isempty(a));'    '               if(double(a)==65410); '%    '	                NotStillPressed=0;'    '   	            out(count)=getsecs;'    '                   count=count+1;'%	'					fprintf(''count = %d a = %s\n'',a,count);'    '               end;'%    '           else;'%    '            NotStillPressed=1;'    '        end;'    '    end;'    'end;'};RUSH(loop,0.5);psychserial('close', port);testend=getsecs;%fprintf( 'RT: %.5f .\n', (testend-ins(1)));SCREEN(window,'Close');