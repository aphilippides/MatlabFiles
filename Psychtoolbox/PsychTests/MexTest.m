function MexTest% MexTest%% A quick test of all the MEX functions in Psychtoolbox.%% (We omit the obsolete CMETER.mex from this test because it's% incompatible with some computers, eg PowerBook G3 Series.)% % NOTE: if MexTest detects a conflict and the error message generated by% the incompatible MEX file is too vague to identify it, then you should% use the Matlab debugger to single step though MexTest.m to figure out% which line the error occurs on, which will resolve the mystery since we% only call one MEX per line.% % To use the Matlab debugger: % 1. Type "edit mextest", followed by <return>. % 2. In the newly open MexTest.m window, click on the green bug symbol at% the top of the window. (Due to a cosmetic bug in Matlab 5.2, you might% get a beep and an error message printed in the command window. Don't% worry; ignore them.)% 3. In the newly open debugger window, also called MexTest.m, click on a% horizontal dash next to one of the line numbers (e.g. 62) at the left % edge of the window; the dash should become a pretty red ball. This is a% breakpoint.% 4. Hit command-zero to get back to the command window, and type% "mextest", followed by <return>; MexTest will run a bit, until it% reaches your breakpoint. Then the command window will display "K>>"% indicating that your breakpoint has been reached.% 5. Hit command-4 to get back to the debugger window. Now you can use the% single step button (second from left at the top of the window, it looks% like a triangle with a bar blunting its point). Single step until you% reach the error.%% Denis Pelli% 3/29/97	dgp	Wrote it.% 				Allow 1000 warnings, set severity to "warn",%				and reset count to zero.% 4/15/97	dgp Explicit screen number.% 4/26/97   dhb Add explicit screen number to all OpenWindow, OpenOffscreenWindow,%				and OpenScreen calls.  Each of these generates a fatal error%				otherwise.% 5/31/97	dgp Add "success" message at end.% 2/12/98	dgp Added new version of PutColorImage.%				Commented out some obsolete usages that are no longer allowed:%				OpenWindow,SetClut9,SetClutQ,BlitImage.% 2/28/98	dgp Invoke all mex functions in Psychtoolbox.% 3/5/98	dgp Add rest of allowed obsolete usages from Screen.c.% 4/7/98	dgp Comment out TIMER and DLOG tests since we're dropping them from the distribution.% 4/7/98	dgp Explain how to use the Matlab debugger.% 8/12/98	dgp Print PsychTableVersion.% 4/1/99	dgp Comment out CMETER, which is incompatible with PowerBook G3 Series, %				probably due to internal modem.%				Reduce size of rect in calls to Screen GetImage for compatibility with%				Student Matlab.% 3/12/00	dgp Added SERIAL, QT.% 7/11/00	dgp Print list of mex files.% 8/4/00	dgp	Added IccProfile.% 4/18/02   dgp Added Showtime (replaces QT), ActiveWire, Joystick, and Attenuator.% 6/29/02   dgp Use PsychtoolboxRoot to cope with user-changed folder name.% 2/19/04   awi Exit on Windows.  The set of Mex files is different on%               Windows than on Mac. There should be a section at the top %               defining lists for each platform and conditional execution %               of each test according to the detected platform.if(strcmp(computer,'PCWIN'))    error('Win: MexTest not yet supported..');endfprintf('Psychtoolbox %g, %s, Matlab %s\n',PsychtoolboxVersion,PsychtoolboxDate,version);fprintf('Calling every MEX function in Psychtoolbox, to check for compatibility.\n');fprintf('If MexTest discovers an incompatible MEX file, be sure to read \nwhat "help MexTest" has to say.\n');clear mex;clear mex;	% do it twice, in case there was something else called "mex".[mFiles,mexFiles]=inmem;if length(mexFiles)~=0	error('Can''t clear mex files from memory.');end% PsychBasicfprintf('PsychTable version %d created by %s.mex\n',Screen('Preference','PsychTableVersion'),Screen('Preference','PsychTableCreator'));Bytes;eval('Debugger(0);','if isempty(strmatch(''Usage:'',lasterr));error(lasterr);lasterr;end');DoNothing;EventAvail('keyDown');FileShare;FlushEvents('keyDown');eval('GetChar(0);','if isempty(strmatch(''Usage:'',lasterr));error(lasterr);end');eval('GetClicks(0,0);','if isempty(strmatch(''Usage:'',lasterr));error(lasterr);end');[x,y]=GetMouse;GetSecs;GetTicks;HideCursor;KbCheck;eval('KbWait(0);','if isempty(strmatch(''Usage:'',lasterr));error(lasterr);end');MaxPriority('GetSecs');PatchTrap('EventAvail',0);Priority;PsychSerial('Ports');Rush(';',0);Screen('Screens');ScreenSaver;SetMouse(x,y);   ShowCursor;Showtime('GetCodecNameList');Shuffle(0);Snd('Quiet');WaitSecs(0);  WaitTicks(0);% PsychBetacd(fullfile(PsychtoolboxRoot,'PsychBeta','Attenuator',''));Attenuator('ReadLuminanceRecord',9);% PsychCalIccProfile('Folder');% PsychClipboardCopyImage(0);PasteImage;CopyText('');PasteText;CopyCImage([0 0 0]);PasteCImage;% PsychFilesfiletype;% PsychHardwareActiveWire('CloseAll');JOYSTICK('GetNumJoysticks');clear gestalt.mex[mFiles,mexFiles]=inmem;fprintf('\nSuccess! All %d mex functions in the Psychtoolbox have been loaded into memory:\n',length(mexFiles));disp(sort(mexFiles))clear mex% PsychObsoleteSysBeep(0);bitImage=ZeroBitImage([1,1],1);InsertBitImage255(0,bitImage,1);% InsertBitImage(0,bitImage,1); % Commented out because it prints an annoying warning.eval('BlitBitImage(0);','if isempty(strmatch(''Invalid'',lasterr));error(lasterr);end');eval('ShowImage;','if isempty(strmatch(''ShowImage'',lasterr));error(lasterr);end');eval('ShowCImage(0);','if isempty(strmatch(''ShowCImage'',lasterr));error(lasterr);end');eval('ShowVec;','if isempty(strmatch(''Usage'',lasterr));error(lasterr);end');eval('ShowCVec;','if isempty(strmatch(''Usage'',lasterr));error(lasterr);end');% CMETER('CTS',0); % initialization fails on PowerBook G3 Series.[mFiles,mexFiles]=inmem;fprintf('\nSuccess! A further %d obsolete mex functions have been loaded into memory:\n',length(mexFiles));disp(sort(mexFiles))% fprintf('Now testing obsolete usages for Screen that are still allowed, producing \nappropriate warnings.\n');% Screen('UsageWarnings',1000,1,0);% [windowPtr,windowRect] = Screen(0,'OpenWindow',[],[],[]);% [windowPtr,windowRect] = Screen(0,'OpenOffscreenWindow',[],[],[]);% Screen(windowPtr,'Close');% Screen('CloseAll');% [windowPtr,windowRect]=Screen('GetMatlabWindow',[]);% n-th in Matlab's Window menu.% [windowPtr,windowRect]=Screen('GetFrontWindow');% [windowPtr,windowRect]=Screen('GetWindowByTitle',[]);% [windowPtr,windowRect] = Screen(0,'OpenWindow',[],[],[]);% [windowPtr,windowRect] = Screen(0,'OpenOffscreenWindow',[],[],[]);% rect = Screen(windowPtr,'Rect');% pixelSize = Screen(windowPtr,'PixelSize');% screenNumber = Screen(windowPtr,'WindowScreenNumber');% [windowPtr,windowRect]=Screen('GetFrontWindow');% title = Screen(windowPtr,'WindowTitle');% kind = Screen(windowPtr,'WindowKind');	% -1=our offscreen;0=bad;1=our onscreen;2=Matlab% Screen(windowPtr,'WindowToFront')		% bring window to front% Screen(windowPtr,'WindowToBack')		% send window to back% Screen('MatlabToFront',[])				% bring Matlab window to front% Screen(windowPtr,'MoveWindow',[],[])% screenRect = Screen(0,'Rect');% [pixelSize,isColor] = Screen(windowPtr,'PixelSize',[],[]);% [windowPtr,windowRect] = Screen(0,'OpenWindow',[],[],[]);% framesSinceLastWait=Screen(windowPtr,'WaitVBL',[]); % obsolete% framesSinceLastWait=Screen(windowPtr,'WaitBlanking',[]);% frameCount = Screen(windowPtr,'PeekBlanking');% frameCount = Screen(windowPtr,'PeekVBL'); % obsolete% Screen(windowPtr,'ClutMovie',[255:-1:0;255:-1:0;255:-1:0]');% err = Screen(windowPtr,'SetClut',[0:255;0:255;0:255]',[],[]);% srcWindowPtr=Screen(0,'OpenOffscreenWindow',0);% dstWindowPtr=Screen(0,'OpenWindow');% Screen('CopyWindow',srcWindowPtr,dstWindowPtr,[],[],[]);% Screen(windowPtr,'PutImage',magic(64),[],[])% [windowPtr,windowRect] = Screen(0,'OpenWindow',[],[0 0 100 100],[]);% imageMatrix = Screen(windowPtr,'GetImage',[0 0 64 64]); % small enough for Student Matlab% if Screen(windowPtr,'PixelSize')<16 & any(Screen(windowPtr,'PixelSizes')>8)% 	% if possible, reopen the window in 16 or 32 bit mode% 	pix=Screen(windowPtr,'PixelSizes');% 	Screen(windowPtr,'Close');% 	windowPtr=Screen(0,'OpenWindow',[],[],pix(end));% end% if Screen(windowPtr,'PixelSize')>8% 	Screen(windowPtr,'PutColorImage',magic(32),magic(32),magic(32),[],[])% 	Screen(windowPtr,'PutColorImage',ones(32,32,3),[],[])% 	[redMatrix,greenMatrix,blueMatrix] = Screen(windowPtr,'GetColorImage',[0 0 32 32]);% end% Screen(windowPtr,'FillRect',[],[])	% use it to clear the screen% Screen(windowPtr,'FillOval',[],[])% color=255;% Screen(windowPtr,'DrawLine',0,0,0,1000,1000,[],[],[])% Screen(windowPtr,'FillPoly',255,rect)% Screen(windowPtr,'FrameRect',255,rect,[],[],[])% Screen(windowPtr,'FrameOval',255,rect,[],[],[])% Screen(windowPtr,'FrameArc',color,rect,0,90,[],[],[])% [x,y]=Screen(windowPtr,'DrawText','Hello world',0,50,color);% width=Screen(windowPtr,'TextWidth','Hello');% [fontNumber,fontName]=Screen(windowPtr,'TextFont');% [fontNumber,fontName]=Screen(windowPtr,'TextFont',0);% [fontNumber,fontName]=Screen(windowPtr,'TextFont','Bookman');% fontSize=Screen(windowPtr,'TextSize',24);% style=Screen(windowPtr,'TextStyle',0);% copyMode=Screen(windowPtr,'TextMode',0);% Screen(windowPtr,'SetDrawingRegion',rect,[])% Screen('CloseAll');% windowPtr=Screen(0,'OpenWindow',0,[0 0 100 100]);% % Obsolete: still work, but produce warnings. % Screen(windowPtr,'BlitImage255',magic(2));	% use 'PutImage'% Screen(windowPtr,'BringWindowToFront');		% use 'WindowToFront'% Screen('BringMatlabToFront');				% use 'MatlabToFront'% Screen(windowPtr,'ClearScreen');			% use 'FillRect'% Screen(windowPtr,'CloseScreen');			% use 'Close'% windowPtr=Screen(0,'OpenWindow',0,[0 0 100 100]); % re-open the window.% Screen(windowPtr,'ClutMovieQ',[255:-1:0;255:-1:0;255:-1:0]'); % use 'ClutMovie'% Screen('CopyWindows',windowPtr,windowPtr);	% use 'CopyWindow'% Screen(windowPtr,'DrawRect');				% use 'FillRect'% Screen(windowPtr,'DrawOval');				% use 'FillOval'% Screen(windowPtr,'DrawPoly',255,[0 0 50 50]);	% use 'FillPoly'% Screen(windowPtr,'GetImage255',[0 0 64 64]);	% use 'GetImage', but small enough for Student Matlab% Screen('SelectMatlab');						% use 'MatlabToFront'% Screen(windowPtr,'SetClutQ',[255:-1:0;255:-1:0;255:-1:0]');		% use 'SetClut'% Screen(windowPtr,'SetGamma',[0:255]');		% use 'Gamma'% Screen(windowPtr,'TextFace');				% use 'TextStyle'% Screen('CloseAll');% % [more,severity,already]=Screen('UsageWarnings');% fprintf('\nSuccess! We just tested all the obsolete usages for Screen that are still allowed, \nproducing %d warning messages.\n',already);