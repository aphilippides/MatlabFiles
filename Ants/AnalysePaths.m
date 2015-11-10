function varargout = AnalysePaths(varargin)
% ANALYSEPATHS M-file for AnalysePaths.fig
%      ANALYSEPATHS, by itself, creates a new ANALYSEPATHS or raises the existing
%      singleton*.
%
%      H = ANALYSEPATHS returns the handle to a new ANALYSEPATHS or the handle to
%      the existing singleton*.
%
%      ANALYSEPATHS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSEPATHS.M with the given input arguments.
%
%      ANALYSEPATHS('Property','Value',...) creates a new ANALYSEPATHS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AnalysePaths_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnalysePaths_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help AnalysePaths

% Last Modified by GUIDE v2.5 02-Jun-2006 12:31:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AnalysePaths_OpeningFcn, ...
    'gui_OutputFcn',  @AnalysePaths_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AnalysePaths is made visible.
function AnalysePaths_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnalysePaths (see VARARGIN)

% Choose default command line output for AnalysePaths
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnalysePaths wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnalysePaths_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in flip.
function flip_Callback(hObject, eventdata, handles)
% hObject    handle to flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flip
fl=get(hObject,'Value');
o=get(hObject,'UserData');
os=CleanOrients(o,fl);
set(handles.orients,'UserData',os);
c=get(handles.plotpath,'UserData');
Cents=c(:,[1 2]);

[EndPt(:,1) EndPt(:,2)]=pol2cart(os,10);
EndPt=EndPt+Cents;
set(handles.plotpath,'UserData',[Cents EndPt])

OToNest=get(handles.otonest,'UserData');
OToLM=get(handles.otolm,'UserData');

NestOnRetina=AngularDifference(OToNest,os');
LMOnRetina=AngularDifference(OToLM,os');

set(handles.nestonret,'UserData',NestOnRetina);
set(handles.lmonret,'UserData',LMOnRetina);

t=get(handles.toplot,'UserData');
a=get(handles.lmornest,'Value');
if(a)
    d=get(handles.dtolm,'UserData');
    PlotAll(t,Cents,EndPt,LMOnRetina,d,OToLM,handles);
else
    d=get(handles.dtonest,'UserData');
    PlotAll(t,Cents,EndPt,NestOnRetina,d,OToNest,handles);
end

f=get(handles.infile,'String');
n=get(handles.infile,'Value');
s=char(f(n));
i=strfind(s,'Prog');
ff=s(1:i-1);
save([ff 'All.mat'],'os','NestOnRetina','LMOnRetina','-append')

function MaxT_Callback(hObject, eventdata, handles)
% hObject    handle to MaxT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxT as text
%        str2double(get(hObject,'String')) returns contents of MaxT as a double
t1=str2double(get(hObject,'String'));
t=get(handles.toplot,'UserData');
[m,i]=min(abs(t-t1));
set(hObject,'UserData',[t1 i]);

T=get(handles.axes2,'XLim');
set(handles.axes2,'XLim',[T(1) t1]);
set(handles.axes3,'XLim',[T(1) t1]);
set(handles.axes4,'XLim',[T(1) t1]);

m=get(handles.MinT,'UserData');
axes(handles.axes5);
x=get(handles.plotrose,'UserData');
rose(x(m(2):i),40)

c=get(handles.plotpath,'UserData');
axes(handles.axes1);
PlotPath(c(:,[1 2]),c(:,[3 4]),handles)

% --- Executes during object creation, after setting all properties.
function MaxT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function MinT_Callback(hObject, eventdata, handles)
% hObject    handle to MinT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinT as text
%        str2double(get(hObject,'String')) returns contents of MinT as a double
t1=str2double(get(hObject,'String'));
t=get(handles.toplot,'UserData');
[m,i]=min(abs(t-t1));
set(hObject,'UserData',[t1 i]);

T=get(handles.axes2,'XLim');
set(handles.axes2,'XLim',[t1 T(2)]);
set(handles.axes3,'XLim',[t1 T(2)]);
set(handles.axes4,'XLim',[t1 T(2)]);

m=get(handles.MaxT,'UserData');
axes(handles.axes5);
x=get(handles.plotrose,'UserData');
rose(x(i:m(2)),40)

c=get(handles.plotpath,'UserData');
axes(handles.axes1);
PlotPath(c(:,[1 2]),c(:,[3 4]),handles)

% --- Executes during object creation, after setting all properties.
function MinT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in infile.
function infile_Callback(hObject, eventdata, handles)
% hObject    handle to infile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns infile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from infile

f=get(hObject,'String');
n=get(hObject,'Value');
s=char(f(n));

if(isfile(s))
    load(s);
    i=strfind(s,'Prog');
    ff=s(1:i-1);
    fn=[ff 'NestLMData.mat'];
%     if(~isfile(fn)) GetNestAndLMData(s(1:i-1)); end;
    load(fn)
    set(handles.lmornest,'UserData',[nest LM LMWid]);
    set(handles.flip,'UserData',Orients)
    os=CleanOrients(Orients);

    [EndPt(:,1) EndPt(:,2)]=pol2cart(os,10);
    EndPt=EndPt+Cents;
    set(handles.plotpath,'UserData',[Cents EndPt])

    VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
    DToNest=sqrt(sum(VToNest.^2,2));
    OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
    NestOnRetina=AngularDifference(OToNest,os');

    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,os');

    t=FrameNum*0.02;
    vel=diff(Cents)./[diff(t') diff(t')];
    speed = sqrt(sum(vel.^2,2));
    speed = [speed(1); speed];
    

    %    set(handles.vtonest,'UserData',VToNest);
    set(handles.dtonest,'UserData',DToNest);
    set(handles.otonest,'UserData',OToNest);
    set(handles.nestonret,'UserData',NestOnRetina);

    set(handles.dtolm,'UserData',DToLM);
    set(handles.otolm,'UserData',OToLM);
    set(handles.lmonret,'UserData',LMOnRetina);

    set(handles.speed,'UserData',speed);
    set(handles.orients,'UserData',os);
    set(handles.toplot,'UserData',t);
    set(handles.MaxT,'UserData',[t(end) length(t)],'String',num2str(t(end)));
    set(handles.MinT,'UserData',[t(1) 1],'String',num2str(t(1)));

    PlotAll(t,Cents,EndPt,NestOnRetina,DToNest,OToNest,handles);
end
clear i n s handles hObject f fn eventdata s
save([ff 'All.mat'])

function PlotAll(t,Cents,EndPt,NestOnRetina,DToNest,OToNest,handles);
axes(handles.axes5);
d=get(handles.MinT,'UserData');
i1=d(2);
d=get(handles.MaxT,'UserData');
i2=d(2);
set(handles.plotrose,'UserData',NestOnRetina);
rose(NestOnRetina(i1:i2),40)
axes(handles.axes1);
PlotPath(Cents,EndPt,handles);
axes(handles.axes2);
PlotLine(t,(AngleWithoutFlip(NestOnRetina)*180/pi),handles)
axes(handles.axes3);
PlotLine(t,DToNest,handles)
axes(handles.axes4);
PlotLine(t,(AngleWithoutFlip(OToNest)*180/pi),handles)

% --- Executes during object creation, after setting all properties.
function infile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

dwork;
cd GantryProj\Bees\21
% cd  E:\bum'blebee flights\'
c=dir('*Prog*.mat');
if(~isempty(c))
    set(hObject,'String',{c.name},'Value',1);
else
    set(hObject,'String',{'change directory'},'Value',1);
end

function PlotLine(t,x,handles)
t1=get(handles.MinT,'UserData');
t2=get(handles.MaxT,'UserData');
sty='b';
plot(t,x);
axis tight;
xlim([t1(1) t2(1)]);
set(gca,'UserData',x);
grid on;

function PlotPath(Cents,EndPt,handles)
t1=get(handles.MinT,'UserData');
t2=get(handles.MaxT,'UserData');
sk=str2num(get(handles.skip,'String'));
nestlm = get(handles.lmornest,'UserData');
is=t1(2):sk:t2(2);

plot(nestlm(1),nestlm(2),'gs')
hold on;
MyCircle([nestlm(3),nestlm(4)],nestlm(5));
plot(EndPt(is,1),EndPt(is,2),'r.')
plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','r')
hold off;

function skip_Callback(hObject, eventdata, handles)
% hObject    handle to skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skip as text
%        str2double(get(hObject,'String')) returns contents of skip as a double


% --- Executes during object creation, after setting all properties.
function skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in pushbutton1.
function plotrose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes5);
s=get(handles.toplot,'SelectedObject');
x=get(s,'UserData');
set(hObject,'UserData',x);
d=get(handles.MinT,'UserData');
i1=d(2);
d=get(handles.MaxT,'UserData');
i2=d(2);
rose(x(i1:i2),40)

% --- Executes on button press in plotpath.
function plotpath_Callback(hObject, eventdata, handles)
% hObject    handle to plotpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=get(hObject,'UserData');
axes(handles.axes1);
PlotPath(c(:,[1 2]),c(:,[3 4]),handles)

% --- Executes on button press in plotline.
function plotline_Callback(hObject, eventdata, handles)
% hObject    handle to plotline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% t=get(hObject,'UserData');
% PlotLine(t,x,handles)

function whichaxis_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% selection = get(hObject,'SelectedObject');
switch get(hObject,'Tag')
    case 'axis1'
        axes(handles.axes1);
    case 'axis2'
        axes(handles.axes2);
    case 'axis3'
        axes(handles.axes3);
    case 'axis4'
        axes(handles.axes4);
    case 'axis5'
        axes(handles.axes5);
    case 'axis6'
        axes(handles.axes6);
end

function toplot_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%selection = get(hObject,'SelectedObject');
t=get(handles.toplot,'UserData');
x=get(hObject,'UserData');
tag=get(hObject,'Tag');
NotAngles={'speed';'dtolm';'dtonest'};
if(sum(strcmp(tag,NotAngles))) PlotLine(t,x,handles);
else PlotLine(t,(AngleWithoutFlip(x)*180/pi),handles);
end

% --- Executes on button press in lmornest.
function lmornest_Callback(hObject, eventdata, handles)
% hObject    handle to lmornest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lmornest
a=get(hObject,'Value');
t=get(handles.toplot,'UserData');
c=get(handles.plotpath,'UserData');
Cents=c(:,[1 2]);
EndPt=c(:,[3 4]);
if(a)
    d=get(handles.dtolm,'UserData');
    o=get(handles.otolm,'UserData');
    n=get(handles.lmonret,'UserData');
else
    d=get(handles.dtonest,'UserData');
    o=get(handles.otonest,'UserData');
    n=get(handles.nestonret,'UserData');
end
PlotAll(t,Cents,EndPt,n,d,o,handles);


% --- Executes on button press in kboard.
function kboard_Callback(hObject, eventdata, handles)
% hObject    handle to kboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard

% --- Executes on button press in holdax2.
function holdax2_Callback(hObject, eventdata, handles)
% hObject    handle to holdax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=get(hObject,'Value');
axes(handles.axes2);
if(h) hold on;
else hold off;
end

% --- Executes on button press in holdax3.
function holdax3_Callback(hObject, eventdata, handles)
% hObject    handle to holdax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=get(hObject,'Value');
axes(handles.axes3);
if(h) hold on;
else hold off;
end

% --- Executes on button press in holdax4.
function holdax4_Callback(hObject, eventdata, handles)
% hObject    handle to holdax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=get(hObject,'Value');
axes(handles.axes4);
if(h) hold on;
else hold off;
end

% --- Executes on button press in flip2.
function flip2_Callback(hObject, eventdata, handles)
% hObject    handle to flip2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flip2
h=get(hObject,'Value');
x=get(handles.axes2,'UserData');
t=get(handle.plotline,'UserData');

% --- Executes on button press in flip3.
function flip3_Callback(hObject, eventdata, handles)
% hObject    handle to flip3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flip3


% --- Executes on button press in flip4.
function flip4_Callback(hObject, eventdata, handles)
% hObject    handle to flip4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flip4


