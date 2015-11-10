function bounds=TextCenteredBounds(w,text)% bounds=TextCenteredBounds(window,text)%% Returns the smallest enclosing rect for the drawn text, relative to the% current location. This bound is based on the actual pixels drawn, so it% incorporates effects of text smoothing, etc. All text is drawn on the% same baseline, horizontally centered by using the x offset% -Screen(w,'TextWidth',string)/2. "text" may be a cell array or matrix of% 1 or more strings. The strings are drawn one on top of another, all% horizontally centered at the current position, before the bounds are% calculated. This returns the smallest box that will contain all the% strings. The prior contents of the scratch window are lost. Usually it% should be an offscreen window, so the user won't see it. If you only% know your nominal text size and number of characters, you might do this% to create your scratch window: % 	w=Screen(0,'offscreenwindow',[],[0 0 3*size*chars 3*size]);% % Also see TextBounds and Screen 'TextWidth' and 'DrawText'.% 9/1/98 dgp wrote it.% 3/19/00 dgp debugged it.% 11/17/02 dgp Added fix, image1(:,:,1),  suggested by Keith Schneider to %              support 16 and 32 bit images.Screen(w,'FillRect',0);r=Screen(w,'Rect');x0=(r(RectLeft)+r(RectRight))/2;y0=round((r(RectTop)+2*r(RectBottom))/3);for i=1:size(text,1)	string=char(text(i,:));	width=Screen(w,'TextWidth',string);	Screen(w,'DrawText',string,x0-width/2,y0,255);end;Screen(w,'DrawText','',x0,y0);image1=Screen(w,'GetImage');[y,x]=find(image1(:,:,1));if isempty(y) | isempty(x)	bounds=[0 0 0 0];else		bounds=SetRect(min(x)-1,min(y)-1,max(x),max(y));	bounds=OffsetRect(bounds,-x0,-y0);end