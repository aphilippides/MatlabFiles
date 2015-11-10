function result = KbName(arg)% function result = KbName(arg)% 	% 	KbName maps between KbCheck-style keyscan codes and key names.% 	% 	-	If arg is a string designating a key label then KbName returns the % 		keycode of the indicated key.  % 	-	if arg is a keycode, KbName returns the label of the designated key. % 	-	if no argument is supplied then KbName waits one second and then %       calls KbCheck.  KbName then returns a cell array holding the names%       of all keys which were down at the time of the KbCheck call. The %       one-second delay preceeding the call to KbCheck avoids catching the %       <return> keypress used to execute the KbName function. % 			% 	KbName deals with keys, not characters. See KbCheck help for an % 	explanation of keys, characters, and keycodes.   % 	% 	There are standard character sets, but there are no standard key % 	names.  The convention KbName follows is to name keys with % 	the primary key label printed on the key.  For example, the the "]}" % 	key is named "]" because "]" is the primary key label and "}" is the % 	shifted key function.  In the case of  labels such as "5", which appears % 	on two keys, the name "5" designates the "5" key on the numeric keypad % 	and "5%" designates the QWERTY "5" key. Here, "5" specifies the primary % 	label of the key and the shifted label, "%" refines the specification, % 	distinguishing it from keypad "5".  Keys labeled with symbols not % 	represented in character sets are assigned names describing those symbols % 	or the key function, for example the space bar is named "space" and the apple % 	key is named "apple".  Some keyboards have identically-labelled keys distinguished %   only by their positions on the keyboard, for example, left and right shift %   keys.  Windows operating systems more recent than Windows 95 can distinguish%   between such keys.  To name such keys, we precede the key label with either %   "left_" or "right_", to create the key name.  For example, the left shift key %   is called "left_shift".% 	% 	Use KbName to make your scripts more readable and portable, using key % 	labels instead of keycodes, which are cryptic and vary between Mac and Windows%   computers.  % 	For example, % 	% 	yesKey = KbName('return');           % 	[a,b,keyCode] = KbCheck;% 	if keyCode(yesKey)% 		flushevents('keyDown');% 		...% 	end;%%   Differences between Windows and Macintosh: %%   Windows and Macintosh versions of KbCheck return different keycodes.  You can mostly %   overcome those differences by using KbName, but with some complications:%%   -While most keynames are shared between Windows and Macintosh, not all are.%   Some key names are used only on Windows, and other key names are used only on Macintosh.%   For a lists of key names common to both platforms and unique to each see the comments in the %   body of KbName.m.%%   -Your computer might be able to distinguish between identically named keys.  For example,%   left and right shift keys, or the "enter" key on the keyboard and the enter key on the%   numeric keypad. Which of these keys it can destinguish depends on the operating system.%   For details, see comments in the body of KbName.m.% 	% 	See also KbCheck, KbDemo, KbWait.                               % 	12/16/98    awi     wrote it% 	02/12/99    dgp     cosmetic editing of comments% 	03/19/99    dgp     added "enter" and "function" keys. Cope with hitting multiple keys.%   02/07/02    awi     added Windows keycodes%   02/10/02    awi     modified to return key names within a cell array in the case%                       where no arguments are passed to KbName and it calls KbCheck.%   02/10/02    awi     Modifed comments for changes made to Windows version. %   04/10/02	awi		-Cosmetic%						-Fixed bug where "MAC2"  case was not in quotes%						-Fixed bug where Mac loop searching for empty cells overran max index.%   09/27/02    awi     Wrapped an index in Find() becasue Matlab will no longer index%						matrices with logicals.  %_________________________________________________________________________% Windows partswitch computercase 'PCWIN'     kk = cell(1,255);        % These Key names are shared between Mac and Windows    kk{65} = 'a';    kk{83} = 's';    kk{68} = 'd';    kk{70} = 'f';    kk{72} = 'h';    kk{71} = 'g';    kk{90} = 'z';    kk{88} = 'x';    kk{67} = 'c';    kk{86} = 'v';    kk{66} = 'b';    kk{81} = 'q';    kk{87} = 'w';    kk{69} = 'e';    kk{82} = 'r';    kk{89} = 'y';    kk{84} = 't';    kk{49} = '1!';    kk{50} = '2@';    kk{51} = '3#';    kk{52} = '4$';      kk{53} = '5%';    kk{54} = '6^';    kk{187} = '=+';    kk{57} = '9(';    kk{55} = '7&';    kk{189} = '-_';    kk{56} = '8*';    kk{48} = '0)';    kk{221} = ']';    kk{79} = 'o';    kk{85} = 'u';    kk{219} = '[';    kk{73} = 'i';    kk{80} = 'p';    kk{13} = 'return';    kk{76} = 'l';    kk{74} = 'j';    kk{222} = char(39);       % single quote    kk{75} = 'k';    kk{186} = ';';    kk{220} = '\';    kk{188} = ',';    kk{191} = '/?';    kk{78} = 'n';    kk{77} = 'm';    kk{190} = '.>';    kk{9} = 'tab';    kk{32} = 'space';    kk{192} = '`';    kk{46} = 'delete';    kk{27} = 'esc';    kk{16} = 'shift';  % Note: Windows distinguishes between left an right shift keys.    kk{20} = 'capslock';    kk{17} = 'control'; % Note: Windows distinguishes between left and right control keys    kk{110} = '.';          kk{106} = '*';    kk{107} = '+';    kk{12} = 'clear';      kk{111} = '/';    kk{109} = '-';    kk{96} = '0';    kk{97} = '1';    kk{98} = '2';    kk{99} = '3';    kk{100} = '4';    kk{101} = '5';    kk{102} = '6';    kk{103} = '7';    kk{104} = '8';    kk{105} = '9';    kk{116} = 'f5';    kk{117} = 'f6';    kk{118} = 'f7';    kk{114} = 'f3';    kk{119} = 'f8';    kk{120} = 'f9';    kk{122} = 'f11';    kk{124} = 'f13';    kk{125} = 'f14';    kk{121} = 'f10';    kk{123} = 'f12';    kk{126} = 'f15';      kk{47} = 'help';        kk{36} = 'home';    kk{33} = 'pageup';    kk{115} = 'f4';    kk{35} = 'end';    kk{113} = 'f2';    kk{34} = 'pagedown';    kk{112} = 'f1';    kk{37} = 'left';    kk{39} = 'right';    kk{40} = 'down';    kk{38} = 'up';        % Keynames used only on Windows    kk{91} = 'windows_left';    kk{92} = 'windows_right';    kk{93} = 'applications';    kk{108} = 'seperator';    kk{127} = 'f16';    kk{128} = 'f17';    kk{129} = 'f18';    kk{130} = 'f19';    kk{131} = 'f20';    kk{132} = 'f21';    kk{133} = 'f22';    kk{134} = 'f23';    kk{135} = 'f24';    kk{144} = 'numlock';    kk{145} = 'scrolllock';    kk{246} = 'attn';    kk{247} = 'crsel';    kk{248} = 'exsel';    kk{251} = 'play';    kk{252} = 'zoom';    kk{254} = 'pa1';    kk{8} = 'backspace';    kk{1} = 'left_mouse';    kk{2} = 'right_mouse';    kk{4} = 'middle_mouse';    kk{45} = 'insert';    kk{18} = 'alt';        % Keynames used only in Windows >95    kk{160} = 'left_shift';    kk{161} = 'right_shift';    kk{162} = 'left_control';    kk{163} = 'right_control';    kk{91} = 'left_menu';    kk{92} = 'right_menu';        unused = [];    for i = 1:255        if isempty(kk{i})            unused = [unused, i];        end     end    			    used = setdiff(1:255,unused); % used codes    clear result    if nargin==0	    waitsecs(1);	    keyPressed = 0;	    while (~keyPressed)		    [keyPressed, secs, keyCode] = KbCheck;	    end        if isempty(find(keyCode))            result = '';        else            result = {kk{find(keyCode)}};        end    elseif isa(arg,'double')  % argument is a number, so find the code	    % if more than one key is hit, we return an array	    result = [kk{find(arg)}];    elseif ischar(arg)      % argument is a character, so find the code	    for i = used		    if strcmp(upper(kk{i}), upper(arg))			    result = i;			    break;		    end	    end    end		%_________________________________________________________________________% MAC partcase 'MAC2'        kk = cell(128,1);        % These Key names are shared between Mac and Windows    kk{1} = 'a';    kk{2} = 's';    kk{3} = 'd';    kk{4} = 'f';    kk{5} = 'h';    kk{6} = 'g';    kk{7} = 'z';    kk{8} = 'x';    kk{9} = 'c';    kk{10} = 'v';    kk{12} = 'b';    kk{13} = 'q';    kk{14} = 'w';    kk{15} = 'e';    kk{16} = 'r';    kk{17} = 'y';    kk{18} = 't';    kk{19} = '1!';    kk{20} = '2@';    kk{21} = '3#';    kk{22} = '4$';    kk{23} = '6^';    kk{24} = '5%';    kk{25} = '=+';    kk{26} = '9(';    kk{27} = '7&';    kk{28} = '-_';    kk{29} = '8*';    kk{30} = '0)';    kk{31} = ']';    kk{32} = 'o';    kk{33} = 'u';    kk{34} = '[';    kk{35} = 'i';    kk{36} = 'p';    kk{37} = 'return';    kk{38} = 'l';    kk{39} = 'j';    kk{40} = char(39);       % single quote    kk{41} = 'k';    kk{42} = ';';    kk{43} = '\';    kk{44} = ',';    kk{45} = '/?';    kk{46} = 'n';    kk{47} = 'm';    kk{48} = '.>';    kk{49} = 'tab';    kk{50} = 'space';    kk{51} = '`';    kk{52} = 'delete';      %the key in the same position on a Windows keyboard is named backspace.      kk{54} = 'esc';    kk{57} = 'shift';    kk{58} = 'capslock';    kk{60} = 'control';    kk{66} = '.';    kk{68} = '*';    kk{70} = '+';    kk{72} = 'clear';    kk{76} = '/';    kk{79} = '-';    kk{83} = '0';    kk{84} = '1';    kk{85} = '2';    kk{86} = '3';    kk{87} = '4';    kk{88} = '5';    kk{89} = '6';    kk{90} = '7';    kk{92} = '8';    kk{93} = '9';    kk{97} = 'f5';    kk{98} = 'f6';    kk{99} = 'f7';    kk{100} = 'f3';    kk{101} = 'f8';    kk{102} = 'f9';    kk{104} = 'f11';    kk{106} = 'f13';    kk{108} = 'f14';    kk{110} = 'f10';    kk{112} = 'f12';    kk{114} = 'f15';    kk{115} = 'help';    kk{116} = 'home';    kk{117} = 'pageup';    kk{118} = 'del';    kk{119} = 'f4';    kk{120} = 'end';    kk{121} = 'f2';    kk{122} = 'pagedown';    kk{123} = 'f1';    kk{124} = 'left';    kk{125} = 'right';    kk{126} = 'down';    kk{127} = 'up';    %Mac only key names    kk{77} = 'enter';       %Windows does not distinguish between keypad enter and keyboard return.    kk{56} = 'apple';       %There is no Apple key on a Windows Keyboard    kk{59} = 'option';      %There is no option key on a Windows Keyboard.  There is an "alt" key insead.    kk{82} = '=';           %Windows does not have numeric keypad =.    %Mac PowerBook G3 Keycodes    kk{64} = 'function';	% PowerBook G3 Series        kk{53} = 'enter';		% PowerBook G3 Series            unused = [];    for i = 1:128        if isempty(kk{i})            unused = [unused, i];        end     end    used = setdiff(1:128,unused); %used codes        clear result    if nargin==0	    waitsecs(1);	    keyPressed = 0;	    while (~keyPressed)		    [keyPressed, secs, keyCode] = KbCheck;	    end %while	    flushevents('keyDown');	    result = {kk{find(keyCode)}};    elseif isa(arg,'double')  %argument is a number, so find the code	    % if more than one key is hit, we return an array	    result = [kk{arg}];    elseif ischar(arg)      %argument is a character, so find the code	    for i = used		    if strcmp(upper(kk{i}), upper(arg))			    result = i;			    break;		    end %if	    end %for i    end %elseif%_________________________________________________________________________% Neither MAC nor Windows partotherwise    error('Unsupported Platform');end %case