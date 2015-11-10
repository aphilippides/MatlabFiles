function varargout = VidEditor(varargin)
% VIDEDITOR M-file for VidEditor.fig
%      VIDEDITOR, by itself, creates a new VIDEDITOR or raises the existing
%      singleton*.
%
%      H = VIDEDITOR returns the handle to a new VIDEDITOR or the handle to
%      the existing singleton*.
%
%      VIDEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEDITOR.M with the given input arguments.
%
%      VIDEDITOR('Property','Value',...) creates a new VIDEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VidEditor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VidEditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VidEditor

% Last Modified by GUIDE v2.5 22-Jul-2005 15:02:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VidEditor_OpeningFcn, ...
    'gui_OutputFcn',  @VidEditor_OutputFcn, ...
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


% --- Executes just before VidEditor is made visible.
function VidEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VidEditor (see VARARGIN)

% Choose default command line output for VidEditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VidEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VidEditor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

maxnum=get(handles.infile,'UserData');
f=get(handles.infile,'String');
n=get(handles.infile,'Value');
fn=char(f(n));
ns=[150:170];
[refim,noiserange]=GetReferenceImage([150:170],fn);
refim=aviread(fn,1);
imagesc(refim);
set(hObject,'UserData',refim);
% set(handles.play,'UserData',noiserange);
colormap gray

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'UserData',1);
set(handles.rewind,'UserData',0);
st=get(handles.framenum,'UserData');
maxnum=get(handles.infile,'UserData');
f=get(handles.infile,'String');
n=get(handles.infile,'Value');
fn=char(f(n));
axes(handles.mainfig);
gap=get(handles.fps,'UserData');
go=1;
refim=get(handles.start,'UserData');
maxnum=get(handles.infile,'UserData');

fold=refim;
while((st<=maxnum)&(go))
    t(st)=GetSecs;
    f=aviread(fn,st);
    imagesc(f.cdata);
    go=get(hObject,'UserData');
    set(handles.framenum,'String',int2str(st),'UserData',st);
    st=st+1;
    pause(gap)
    %      k=(rgb2gray(f.cdata)-uint8(fold));
    %      imagesc(k);
    %     colormap gray
    %     fold=rgb2gray(f.cdata);
end

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.play,'UserData',0);
set(handles.rewind,'UserData',0);

% --- Executes on button press in rewind.
function rewind_Callback(hObject, eventdata, handles)
% hObject    handle to rewind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'UserData',1);
set(handles.play,'UserData',0);
st=get(handles.framenum,'UserData');
f=get(handles.infile,'String');
n=get(handles.infile,'Value');
fn=char(f(n));
axes(handles.mainfig);
gap=get(handles.fps,'UserData');
go=1;

while((st>=1)&(go))
    t(st)=GetSecs;
    f=aviread(fn,st);
    imagesc(f.cdata);
    go=get(hObject,'UserData');
    set(handles.framenum,'String',int2str(st),'UserData',st);
    st=st-1;
    pause(gap)
end


% --- Executes on button press in Bwd1.
function Bwd1_Callback(hObject, eventdata, handles)
% hObject    handle to Bwd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f=get(handles.infile,'String');
n=get(handles.infile,'Value');
fn=char(f(n));
num=get(handles.framenum,'UserData')-1;
if(num>=1)
    set(handles.framenum,'UserData',num,'String',int2str(num))
    f=aviread(fn,num);
    axes(handles.mainfig)
    % imagesc(f.cdata);
    imshow(f.cdata);
end

% --- Executes on button press in Fwd1.
function Fwd1_Callback(hObject, eventdata, handles)
% hObject    handle to Fwd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f=get(handles.infile,'String');
n=get(handles.infile,'Value');
fn=char(f(n));
num=get(handles.framenum,'UserData')+1;
MaxNum=get(handles.infile,'UserData');
refim=aviread(fn,1);
if(num<=MaxNum)
    set(handles.framenum,'UserData',num,'String',int2str(num))
    f=aviread(fn,num);
    axes(handles.mainfig);
    [a,c,o,im,s,e,NumBee,Bounds]=FindBee(imsubtract(refim.cdata,f.cdata),0);
    %     Areas=[Areas a];
    %     Cents=[Cents c];
    %     Orients=[Orients o];
    %     %BlurIm=BlurIm+im;
    %     Stripes=[Stripes s];
    imagesc(f.cdata);
    hold on;
    for i=1:NumBee
    l(i)=30*(1-s(i));
        [e1,e2]=pol2cart(o(i),l(i));
    e2=c(i,2)-e2;
    e1=e1+c(i,1);
    plot(c(i,1),c(i,2),'g.')
    plot([c(i,1) e1]',[c(i,2) e2]','g')
    end

%     for i=1:length(Bounds)
%         b=Bounds{i};
%         plot(b(:,2), b(:,1), 'r');
%     end
    hold off
end


function fps_Callback(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fps as text
%        str2double(get(hObject,'String')) returns contents of fps as a
% double
n=1/str2double(get(hObject,'String'));
set(hObject,'UserData',n);


% --- Executes during object creation, after setting all properties.
function fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
n=1/str2double(get(hObject,'String'));
set(hObject,'UserData',n);


function framenum_Callback(hObject, eventdata, handles)
% hObject    handle to framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framenum as text
%        str2double(get(hObject,'String')) returns contents of framenum as a double

MaxFrames=get(handles.infile,'UserData');
n=str2double(get(hObject,'String'));
n=max(1,n);
n=min(n,MaxFrames);
set(hObject,'UserData',n,'String',int2str(n));
f=get(handles.infile,'String');
n2=get(handles.infile,'Value');
fn=char(f(n2));
p=aviread(fn,n);
axes(handles.mainfig)
imagesc(p.cdata);

% --- Executes during object creation, after setting all properties.
function framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',1,'String','1');

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
    a=aviinfo(s);
    set(hObject,'UserData',a.NumFrames);
    n=a.FramesPerSecond;
    set(handles.fps,'UserData',1/n,'String',int2str(n));
    set(handles.mainfig,'Units','Pixels');
    X=get(handles.mainfig,'Position');
    set(handles.mainfig,'Position',[X(1) X(2) a.Width a.Height]);
    set(gca,'Position',[X(1) X(2) a.Width a.Height]);
    set(handles.framenum,'String','1','UserData',1);
    f=aviread(s,1);
    axes(handles.mainfig)
    imagesc(f.cdata);
end

% --- Executes during object creation, after setting all properties.
function infile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
dwork;
cd GantryProj\Bees
c=dir('*.avi');
if(~isempty(c))
    set(hObject,'String',{c.name},'Value',1);
    s=c(1).name;
    if(isfile(s))
        a=aviinfo(s);
        set(hObject,'UserData',a.NumFrames);
    end
else
    set(hObject,'String',{'change directory'},'Value',1);
end
