function [keyIsDown,secs] = KbCheck% [keyIsDown,secs,keyCode] = KbCheck% % Return keyboard status (keyIsDown), time (secs) of the status check, and% keyboard scan code (keyCode).% %    keyIsDown      1 if any key, including modifiers such as <shift>,%                   <control> or <caps lock> is down. 0 otherwise.% %    secs           time of keypress as returned by GetSecs.% %    keyCode        Mac: a 128-element logical array.  Each bit within the%                   logical array represents one keyboard key. If a key is%                   pressed, its bit is set, othewise the bit is clear. To %                   convert a keyCode to a vector of key numbers use %                   FIND(keyCode). To find a key's keyNumber use KbName %                   or KbDemo.% %                   Win: a 256-element array. It seems that the first %                   128 elements correspond to the%                   ascii sequence of the characters, and may be consistent%                   with the Mac key codes.%% KbCheck and KbWait determine whether any key is down now, including the meta% keys: <caps lock>, <shift>, <command>, <control>, and <option>. The only key% not reported is the start key (triangle) used to power on your computer.% % GetChar and CharAvail are character-oriented (and slow), whereas KbCheck% and KbWait are keypress-oriented (and fast). If only a meta key was hit,% KbCheck will return true, because a key was pressed, but CharAvail will% return false, because no character was generated. See GetChar.%% The Mac OS Event Manager detects and queues typed characters in the % background. GetChar will return any characters typed before the % call to GetChar. FlushEvents can be used to clear the character event % buffer read by GetChar. Unlike GetChar, KbCheck only reports keys % depressed at the moment KbCheck is called.  FlushEvents has no effect % on KbCheck.% % Mac: Command-Period causes an immediate exit.% % NOTE: Hitting CapsLock makes KbCheck and KbWait think that you're holding% the shift key down. They will continue to think so (returning 1) until% you release the shift by hitting CapsLock again.% % NOTE: KbCheck and KbWait are MEX files, which take time to load when% they're first called. They'll then stay loaded until you flush them% (e.g. by changing directory or calling CLEAR MEX).% % NOTE: KbCheck and KbWait detect that a key is down by using the low-level% Mac OS call GetKeys. It's not clear what temporal accuracy this% provides, but it's much better than going through the higher-level% Event Manager. Our impression from reading the documentation in Dan% Costin's KeMo package% web http://psychtoolbox.org/kemo.html% <ftp://ftp.stolaf.edu/pub/macpsych/KemMo_1.5.sit.hqx>% is that this low-level call still has uncertainty on the order of 11 ms% because of the way the Mac OS polls ADB devices. Someone clever could% probably use his advice to develop MEX files that timed keypresses more % accurately than KbCheck does.% % See also: FlushEvents, KbName, KbDemo, KbWait, GetChar, CharAvail, KbDemo.% % David Brainard and Allen Ingling% 3/6/97  dhb  Wrote it.% 8/2/97  dgp  Explain difference between key and character.% 1/28/98 dgp  Explain CapsLock.% 2/4/98  awi  Explain keyCode.% 2/13/98 awi  Changed keyCode to logical array, pointers to KbDecode, KbExplore.% 2/19/98 dgp  Shortened by moving some text to GetChar.m.% 3/15/99 xmz  Added comment for Windows version.% 6/23/00 awi  Added paragraph contrasting queuing of GetChar and KbCheck.% 7/7/00  dgp  Cosmetic.