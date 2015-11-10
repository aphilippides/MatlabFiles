function EpsDemo% EpsDemo shows how to save an image (grating in noise) to disk.% 8/31/00 dgp Wrote it, based on GratingDemo.m and SaveAsEpsTest.m.% There may be a bug in 'SaveAsEps'. Most of the time it worked fine, but% in one instance the ps data are fine, but the PICT preview is wrong, % because it includes the whole window, not just the selected rect.%% 4/10/02  awi -Added platform conditional to use SaveAsEps.m on windows.%			   - Use font Arial instead of Helvetica because Arial is %			     available on both Win and Mac.% interesting parameterswidth=200;checkpix=2;csignal=.5;cnoise=.5;orientation=0;% of grating, in deg.whichScreen=0;% Need pixelSize of 8 for 'SaveAsEps'.window=Screen(whichScreen,'OpenWindow',[],[],8);white=WhiteIndex(window);black=BlackIndex(window);gray=(white+black)/2;if round(gray)==white	gray=black;endinc=white-gray;Screen(window,'FillRect',gray);% gratingchecks=width/checkpix;half=round(checks/2);[x,y]=meshgrid(-half:half,-half:half);angle=orientation*pi/180; f=5*2*pi/checks;a=cos(angle)*f;b=sin(angle)*f;signal=exp(-((x/(checks/4)).^2)-((y/(checks/4)).^2)).*sin(a*x+b*y);rect=[0 0 size(signal,2) size(signal,1)];%rect=CenterRect(rect,Screen(window,'Rect'));% noisenoiseBound=1;noiseList=-1:1/1024:1;noisePowerFactor=std(noiseList,1)^2;x=-noiseBound:.01:noiseBound;pdf=ones(size(x));idealNoisePowerFactor=sum(pdf.*x.^2)/sum(pdf);noise=randsample(noiseList,size(signal));rect=rect*checkpix;Screen(window,'PutImage',gray+inc*(csignal*signal+cnoise*noise),rect);% Save image to disk.cd(diskroot);if strcmp(computer,'MAC2')	cd(DesktopFolder);endpageRect=rect.*[1,-1,1,-1];% convert from Apple to Adobe coordinates% Win: Screen 'SaveAsEps' is not yet available so% we use SaveAsEps.m instead.  if strcmp('PCWIN',computer)	psimg = Screen(window,'GetImage',rect);	SaveAsEps('grating.eps',psimg,pageRect);else	Screen(window,'SaveAsEps','grating.eps',rect,pageRect);end% rect=Screen(window,'Rect');% paperRect=SetRect(0,11*72,8.5*72,0);% pageRect=rect.*[1,-1,1,-1];% convert from Apple to Adobe coordinates% pageRect=CenterRect(pageRect,paperRect);% Screen(window,'SaveAsEps','test.eps',rect,pageRect)% pauseScreen(window,'TextFont','Arial');Screen(window,'TextSize',18);Ask(window,'Done. Hit return to quit.',black,gray,'GetString');Screen(window,'Close');