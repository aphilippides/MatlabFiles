% WindowDemo%% Demonstrate commands for bringing windows forward and back.% 2/1/97  dhb  Wrote it.% 2/2/97  dgp  Pause 1 sec before GetSecs to give Matlab time to draw window.%              Removed references to bugs that have now been fixed.% 2/3/97  dhb  Updated to reflect behavior I see under V4.% 2/23/97 dhb  Updated for 2.0 calling.% 2/26/97 dgp  Updated. Allow for title bar.% 3/3/97  dhb  Cosmetic editing.  Pause is no longer necessary to redraw.% 3/16/97 dgp  Arrow cursor.% 2/17/98 dgp  Reformat text.% 3/11/98 dgp  Updated for Screen's new white default.% 4/04/02 awi  Added windows conditional which exits. if strcmp(computer,'PCWIN')    error('Win: WindowDemo is not yet supported');else    screenNumber = 0;	pixelSize = 8;		% Open up the screen	ShowCursor(0);	% arrow cursor	fprintf('WindowDemo\n');	[window,screenRect] = Screen(screenNumber,'OpenWindow');	background=GrayIndex(window,0.5);	Screen(window,'FillRect',background);	HideCursor;		% Set up some text for user interface.	Screen(window,'TextFont','Arial');	Screen(window,'TextSize',32);		% Make a ramp to see all CLUT entries	ramp = ones(screenRect(rectBottom),1)*(0:255);	Screen(window,'PutImage',ramp,SetRect(0,0,256,screenRect(rectBottom)));		% Tell user to bring command window to front.  First we buffer our	% whole screen so we can put it back later.	ShowCursor(0);	Ask(window,'Click mouse to bring command window forward',BlackIndex(window),background);	[oWindow,oRect] = Screen(screenNumber,'OpenOffscreenWindow',background);	Screen('CopyWindow',window,oWindow);	Screen('MatlabToFront');		% Move to upper left. Both MoveWindow and GlobalRect can move windows.	% This example uses GlobalRect. 	fprintf('Click mouse to move the command window to the upper left. We allow for the title\n');	fprintf('bar and menu bar (which will return later). And we restore our window after the\n');	fprintf('move.\n');	fprintf('\n');	ShowCursor(0);	GetClicks;	menuBarOffset = 19;	titleBarOffset = 18;	globalScreenRect = Screen(window,'GlobalRect');	cWindow = Screen('GetMatlabWindow');	globalCommandRect = Screen(cWindow,'GlobalRect');	dx = globalScreenRect(RectLeft) - globalCommandRect(RectLeft);	dy = globalScreenRect(RectTop) - globalCommandRect(RectTop) + menuBarOffset+ titleBarOffset;	Screen(window,'WindowToFront');	Screen('CopyWindow',oWindow,window);	Screen(cWindow,'GlobalRect',OffsetRect(globalCommandRect,dx,dy));	Screen(cWindow,'WindowToFront');		% Bring Screen window back up. This example uses MoveWindow.	fprintf('Click mouse to bring our Screen window to the front again.\n');	fprintf('\n');	fprintf('Screen doesn''t automatically redraw its window, because that''s hard to implement.\n');	fprintf('But by buffering the window before bringing the Matlab window to the front (see\n');	fprintf('code above), we can restore our window just as it was before we brought the\n');	fprintf('Matlab window up (see code below).\n');	fprintf('\n');	ShowCursor(0);	GetClicks;	HideCursor;	Screen(cWindow,'MoveWindow',-dx,-dy);	Screen(window,'WindowToFront');	Screen('CopyWindow',oWindow,window);		% Close up	ShowCursor(0);	Ask(window,'Click mouse to exit',BlackIndex(window),background);	Screen('CloseAll');	ShowCursor;end    