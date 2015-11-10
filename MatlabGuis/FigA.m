function fig = FigA()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load FigA

h0 = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'PointerShapeCData',mat1, ...
	'Position',[79.5 87 439.5 357.75], ...
	'Tag','Fig1', ...
	'UserData',mat2);
h1 = uimenu('Parent',h0, ...
	'Label','Load', ...
	'Tag','menLoad');
h2 = uimenu('Parent',h1, ...
	'Callback','figAcode ListMat', ...
	'Tag','smenDir');
h3 = uimenu('Parent',h2, ...
	'Label','uimenu', ...
	'Tag','smenList');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat3, ...
	'Position',[33 30 394 380], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'Tag','Axes1Line1', ...
	'XData',mat4, ...
	'YData',mat5);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4987277353689568 -0.0633245382585752 17.32050807568877], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.07379134860050891 0.4960422163588392 17.32050807568877], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',mat6, ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',mat7, ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode Set', ...
	'ListboxTop',0, ...
	'Position',[58 341 25 13], ...
	'String','0.9', ...
	'Style','edit', ...
	'Tag','EtxtY1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[44 341 13.5 12], ...
	'String','Y1', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[3 341 13.5 12], ...
	'String','X1', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode Set', ...
	'ListboxTop',0, ...
	'Position',[58 326.25 25 13], ...
	'Style','edit', ...
	'Tag','EtxtY2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[42.75 327 13.5 12], ...
	'String','Y2', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode Set', ...
	'ListboxTop',0, ...
	'Position',[15.75 326.25 25 13], ...
	'Style','edit', ...
	'Tag','EtxtX2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[3 327 14 12], ...
	'String','X2', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode Set', ...
	'ListboxTop',0, ...
	'Position',[15.75 341.25 25 13], ...
	'Style','edit', ...
	'Tag','EtxtX1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode Browse', ...
	'Position',[321.75 160.5 82.5 66], ...
	'String',mat8, ...
	'Style','listbox', ...
	'Tag','listLoad', ...
	'UserData',[1 0 0 0], ...
	'Value',4);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','FigAcode LoadA', ...
	'ListboxTop',0, ...
	'Position',[408 204 27.75 22.5], ...
	'String','Load', ...
	'Tag','ButLoad', ...
	'UserData',[0 1 0 1]);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','FigAcode Reset', ...
	'ListboxTop',0, ...
	'Position',[58 310.5 24.75 13.5], ...
	'String','Reset', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','FigAcode Clear', ...
	'ListboxTop',0, ...
	'Position',[406.5 181.5 30 21], ...
	'String','Clear', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','FigAcode ClearAll', ...
	'ListboxTop',0, ...
	'Position',[363.75 267 30 15], ...
	'String','ClAll', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','FigAcode Set', ...
	'ListboxTop',0, ...
	'Position',[35 310.5 18.75 13], ...
	'String','Set', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','FigAcode GridOn', ...
	'ListboxTop',0, ...
	'Position',[2 310.5 28 13], ...
	'String','Grid', ...
	'Style','checkbox', ...
	'Tag','GridTag');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','FigAcode ListMat', ...
	'ListboxTop',0, ...
	'Position',[323.25 230.25 19.5 15], ...
	'String','File', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ListMat', ...
	'ListboxTop',0, ...
	'Position',[344.25 229.5 85.5 15], ...
	'String','dummy.mat', ...
	'Style','edit', ...
	'Tag','edtxtFilen');
h1 = uicontextmenu('Parent',h0, ...
	'Tag','ctext');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ChDir', ...
	'ListboxTop',0, ...
	'Position',[325.5 248.25 104.25 15], ...
	'String','d:\mydocuments\MatlabGuis\', ...
	'Style','edit', ...
	'Tag','edtxtDir', ...
	'TooltipString','`''');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[378.75 60.75 60.75 66.75], ...
	'String','Yfiles''', ...
	'Style','popupmenu', ...
	'Tag','ListYfiles', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ChDir', ...
	'ListboxTop',0, ...
	'Position',[340 42.5 95 15], ...
	'String','d:\mydocuments\MatlabGuis\', ...
	'Style','edit', ...
	'Tag','edtxtXfile');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ChDir', ...
	'ListboxTop',0, ...
	'Position',[340 3 95 15], ...
	'String','d:\mydocuments\MatlabGuis\', ...
	'Style','edit', ...
	'Tag','edtxtYfile');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ChDir', ...
	'ListboxTop',0, ...
	'Position',[340 62.25 95 15], ...
	'String','d:\mydocuments\MatlabGuis\', ...
	'Style','edit', ...
	'Tag','edtxtX');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','FigAcode ChDir', ...
	'ListboxTop',0, ...
	'Position',[340 22.75 95 15], ...
	'String','d:\mydocuments\MatlabGuis\', ...
	'Style','edit', ...
	'Tag','edtxtY');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[322.5 41.25 14.25 15], ...
	'String','from', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[322.5 2.25 14.25 15], ...
	'String','from', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[322.5 59.25 14.25 15], ...
	'String','X', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[322.5 21.75 14.25 15], ...
	'String','Y', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[381 33 60 66.75], ...
	'String','Xfiles', ...
	'Style','popupmenu', ...
	'Tag','ListXfiles', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[406.5 157.5 30.75 20.25], ...
	'Tag','Pushbutton3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[320.25 102 60 53.25], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[380.25 69.75 59.25 84], ...
	'String',' ', ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'Value',1);
if nargout > 0, fig = h0; end