% ShowtimePhotoTest% Checks out Showtime.mex and the presentation of color images. We read in a% JPEG image and display it in two windows, side by side.% The lefthand window is implemented by Screen.mex; the righthand window% is implemented by Showtime.mex. They should be identical.% Denis Pelli January, 2000% 4/24/02 awi Exit on PC with message.% 6/29/02 dgp Use PsychtoolboxRoot to cope with user-changed folder name.if strcmp('PCWIN',computer)    error('Win: Showtime not yet supported.');endclear mexfilename=fullfile(PsychtoolboxRoot,'PsychTests','ShowtimePhotoTest.jpg');q=imread(filename,'jpg');r=[0,0,size(q,2),size(q,1)];rr=AlignRect(r,screen(0,'Rect'),RectRight);whichScreen=0;for pixelsize=[16 32]	% set pixelSize	screen(whichScreen,'pixelsize',pixelsize);	if pixelsize==16		norm=256/32;	else		norm=1;	end		% show image, using Screen	w=screen(whichScreen,'openwindow',[],r);	screen(w,'putimage',double(q)/norm);	% put file on the desktop.	s=matlabroot;	n=findstr(filesep,s);	root=s(1:n(1));	cd(fullfile(root,'Desktop Folder',''));	filename='q.mov';		% put image in movie, and show it, using Showtime	window=Showtime('openwindow',whichScreen,[],rr);	rows=size(q,1);	cols=size(q,2);	trackTimescale=600;	frameDuration=round(trackTimescale/FrameRate(whichScreen)); 	preload=1;	movie=Showtime('MovieCreate',filename,window);	Showtime('VideoTrackCreate',movie,rows,cols,trackTimescale,preload);	Showtime('VideoMediaCreate',movie);	isRGB=1;	Showtime('VideoMediaSamplesAdd',movie,double(q)/norm,pixelsize,frameDuration,isRGB);	Showtime('VideoMediaSave',movie);	Showtime('VideoTrackSamplesSet',movie);	Showtime('VideoTrackSave',movie);	Showtime('Show',movie);	Showtime('MovieSave',movie);	frames=1;	fprintf('Your new %d-frame %d-bit QuickTime movie "%s" is on your desktop.\n',frames,pixelsize,filename);			screen('matlabtofront');	fprintf('Hit RETURN to continue:');	pause	fprintf('\n');	Showtime('CloseWindow',window);	screen(w,'close')end