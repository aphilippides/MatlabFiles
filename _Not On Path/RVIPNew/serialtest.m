function[out]= serialtestwindow = SCREEN(0,'OpenWindow',WhiteIndex(0));white=WhiteIndex(window);black=BlackIndex(window);port=psychserial('open', '.Bin', '.Bout', 14400);a0=psychserial('read', port,0.020);a0= psychserial('read', port, 0.001); tend=getsecsa= psychserial('read', port,0.001);c=1;loop={	'while(getsecs<(tend+1));'   'a= psychserial(''read'', port,0.001);'	'if(~isempty(a)); '	'if(double(a)==65410);'		'	out(c)=getsecs;'	'	c=c+1;'	'	end;'	'end;''end;'	'while(getsecs<(tend+2));'   'a= psychserial(''read'', port,0.001);'	'if(~isempty(a)); '	'if(double(a)==65410);'		'	out(c)=getsecs;'	'	c=c+1;'	'	end;'	'end;''end;'	'while(getsecs<(tend+3));'   'a= psychserial(''read'', port,0.001);'	'if(~isempty(a)); '	'if(double(a)==65410);'		'	out(c)=getsecs;'	'	c=c+1;'	'	end;'	'end;''end;'};RUSH(loop,0.5);psychserial('close', port);getsecs-tendout-tendSCREEN(window,'Close');