function res=NearestResolution(screenNumber,width,height,hz,pixelSize)% res=NearestResolution(screenNumber,[width,height,hz,pixelSize])% res=NearestResolution(screenNumber,desiredRes)%% Finds the available screen resolution most similar (in log cartesian space) to that% requested. Any argument that is [] or NaN will be ignored in assessing similarity.% If you specify pixelSize then the returned res will specify pixelSize. Typically% you'll use the returned "res" to set your screen's resolution:% Screen(screenNumber,'Resolution',res)% % Also see SetResolution, ResolutionTest, and Screen Resolution and Resolutions.% HISTORY:% 1/28/00 dgp Wrote it.% 9/17/01 dgp Frans Cornelissen, f.w.cornelissen@med.rug.nl, discovered that iBooks %			  always report a framerate of NaN. So we ignore framerate when %			  Screen Resolutions returns NaN Hz.% 4/29/02 dgp Screen Resolutions is only available on Mac.% 6/6/02  dgp Accept res instead of parameter list.if nargin<2 | nargin>5	error(sprintf('%s\n%s','USAGE: res=NearestResolution(screenNumber,[width,height,hz,pixelSize])',...	                   '           res=NearestResolution(screenNumber,desiredRes)'));endif nargin<5	pixelSize=[];endif nargin<4	hz=[];endif nargin<3	height=[];endif nargin==2	if isa(width,'struct')		res=width;		if isfield(res,'width')			width=res.width;		end		if isfield(res,'height')			height=res.height;		end		if isfield(res,'hz')			hz=res.hz;		end		if isfield(res,'pixelSize')			pixelSize=res.pixelSize;		end	endendif screenNumber<0 | screenNumber>Screen('Screens')	error(sprintf('Invalid screenNumber %d.',screenNumber));endif ~strcmp(computer,'MAC2')	res.width=width;	res.height=height;	res.hz=hz;	res.pixelSize=pixelSize;	returnendres=Screen(screenNumber,'Resolutions'); % get a list of available resolutionswish.width=width;wish.height=height;wish.hz=hz;wish.pixelSize=pixelSize;for i=1:length(res)	d(i)=distance(wish,res(i));end[x,i]=min(d);res=res(i);if isfinite(wish.pixelSize)	[dp,ip]=min(log10(wish.pixelSize ./ res.pixelSizes) .^ 2);	res.pixelSize=res.pixelSizes(ip);endreturnfunction d=distance(a,b)% "a" may omit values, for which you "don't care".% "a" has "pixelSize" field, but "b" has "pixelSizes" field.d=0;if isfinite(a.width)	d=d+log10(a.width/b.width)^2;endif isfinite(a.height)	d=d+log10(a.height/b.height)^2;endif isfinite(a.hz) & isfinite(b.hz)	d=d+log10(a.hz/b.hz)^2;endif isfinite(a.pixelSize)	d=d+min(log10(a.pixelSize ./ b.pixelSizes) .^ 2);endreturn