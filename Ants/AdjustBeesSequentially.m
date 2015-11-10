function varargout = AdjustBeesSequentially(varargin)
% ADJUSTBEESSEQUENTIALLY MATLAB code for AdjustBeesSequentially.fig
%      ADJUSTBEESSEQUENTIALLY, by itself, creates a new ADJUSTBEESSEQUENTIALLY or raises the existing
%      singleton*.
%
%      H = ADJUSTBEESSEQUENTIALLY returns the handle to a new ADJUSTBEESSEQUENTIALLY or the handle to
%      the existing singleton*.
%
%      ADJUSTBEESSEQUENTIALLY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADJUSTBEESSEQUENTIALLY.M with the given input arguments.
%
%      ADJUSTBEESSEQUENTIALLY('Property','Value',...) creates a new ADJUSTBEESSEQUENTIALLY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AdjustBeesSequentially_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AdjustBeesSequentially_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AdjustBeesSequentially

% Last Modified by GUIDE v2.5 09-Nov-2015 22:31:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AdjustBeesSequentially_OpeningFcn, ...
                   'gui_OutputFcn',  @AdjustBeesSequentially_OutputFcn, ...
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





% --- Executes just before AdjustBeesSequentially is made visible.
function AdjustBeesSequentially_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AdjustBeesSequentially (see VARARGIN)

% Choose default command line output for AdjustBeesSequentially
handles.output = hObject;

handles.smlen=0.1;
% handles.tlev=4;
% set(handles.title,'String',['Thresh=' num2str(handles.tlev)]);

handles.addFr=1;
handles.npl=3;

fns=dir('*Prog.mat');
if(isempty(fns))
    set(handles.popupmenu1,'String','no data in this directory')
else
    set(handles.popupmenu1,'String',{fns.name})
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AdjustBeesSequentially wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function LoadData(hObject,handles,fn)

set(handles.loadtext,'String','loading')
drawnow;
load(fn)
handles.t=t;
handles.fn=fn;
handles.outfn=[fn(1:end-9) 'All.mat'];
if(exist(handles.outfn,'file'))
    set(handles.instruction,'String',[handles.spfn ' exists; move or delete']);
else
    set(handles.instruction,'String','');
end

% TODO
% load it or move it; stick in a while loop

% if(exist('tlev','var'))
%     handles.tlev=tlev;
%     set(handles.title,'String',['Thresh=' num2str(handles.tlev)]);
% end
% 
% for i=1:(handles.npl)
%     eval(['handles.chan(i).hdl=handles.axes' int2str(i) ';'])
%     handles.chan(i).a=zeros(size(t));
%     handles.chan(i).va=1;
%     handles.chan(i).as=zeros(size(t));
%     axChange([0 300 -150 50],1,handles.chan(i).hdl)
% end

% set initial stuff
handles.MinFr=1;
handles.MaxFr=length(NumBees);

% find the first frame with a bee
handles.currFr=find(NumBees==1,1);

guidata(hObject, handles);
set(handles.loadtext,'String',['loaded: ' fn])
UpdatePlots(handles)

function[sv]=SmoothVec(x,n,option)
if(length(n)==1)
    [r,c]=size(x);
    if((c==1)&&(r>1)) 
        x=x'; 
    end;
    if(length(x)<n) 
        n=length(x); 
    end;
    h=fspecial('average',[1,n]);
else
    h=fspecial('average',n);
end
if (nargin < 3) 
    sv=imfilter(x,h); 
else
    sv=imfilter(x,h,option);
end

% --- Outputs from this function are returned to the command line.
function varargout = AdjustBeesSequentially_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Fup.
function Fup_Callback(hObject, eventdata, handles)
% hObject    handle to Fup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currFr=min(handles.currFr+handles.addFr,handles.MaxFr);
set(handles.title,'String',['Frame = ' int2str(handles.currFr)]);
guidata(hObject, handles);
UpdatePlots(handles)

% ExtractAllSpikes(hObject,handles,vals)


% --- Executes on button press in FBack.
function FBack_Callback(hObject, eventdata, handles)
% hObject    handle to FBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.currFr=max(handles.currFr+handles.addFr,handles.MinFr);
set(handles.title,'String',['Frame = ' num2str(handles.currFr)]);
guidata(hObject, handles);
UpdatePlots(handles)


function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double
n=str2double(get(hObject,'String'));
for i=1:handles.npl
    axChange(n,1,handles.chan(i).hdl)
end

function axChange(n,ind,ax)
if(nargin<3)
    ax=gca;
end
if(length(n)==4)
    axis(ax,n);
elseif(ind>2)
    y=ylim(ax);
    y(ind-2)=n;
    if(y(2)>y(1))
        xlim(ax,y);
    end
else
    y=xlim(ax);
    y(ind)=n;
    if(y(2)>y(1))
        xlim(ax,y);
    end
end
% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double
n=str2double(get(hObject,'String'));
for i=1:handles.npl
    axChange(n,2,handles.chan(i).hdl)
end

% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double
n=str2double(get(hObject,'String'));
for i=1:handles.npl
    axChange(n,4,handles.chan(i).hdl)
end

% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double
n=str2double(get(hObject,'String'));
for i=1:handles.npl
    axChange(n,3,handles.chan(i).hdl)
end

% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fradd_Callback(hObject, eventdata, handles)
% hObject    handle to Fradd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fradd as text
%        str2double(get(hObject,'String')) returns contents of Fradd as a double
handles.addFr=ceil(str2double(get(hObject,'String')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Fradd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fradd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sm_len_Callback(hObject, eventdata, handles)
% hObject    handle to sm_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sm_len as text
%        str2double(get(hObject,'String')) returns contents of sm_len as a double
handles.smlen=round(str2double(get(hObject,'String')));

% Update handles structure
guidata(hObject, handles);
SmoothAndPlot(hObject,handles,1:3,0);

% --- Executes during object creation, after setting all properties.
function sm_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sm_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch1_Callback(hObject, eventdata, handles)
% hObject    handle to ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1 as text
%        str2double(get(hObject,'String')) returns contents of ch1 as a double
val=round(str2num(get(hObject,'String')));
ch=handles.ChanNum;
if(ValidChannel(val,ch))
    UpdateChan(hObject,handles,1,ch(val))
end

% --- Executes during object creation, after setting all properties.
function ch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch2_Callback(hObject, eventdata, handles)
% hObject    handle to ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2 as text
%        str2double(get(hObject,'String')) returns contents of ch2 as a double
val=round(str2num(get(hObject,'String')));
ch=handles.ChanNum;
if(ValidChannel(val,ch))
    UpdateChan(hObject,handles,2,ch(val))
end

% --- Executes during object creation, after setting all properties.
function ch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateChan(hObject,handles,val,vnum)
is=1:length(handles.t);
handles.chan(val).a=handles.dat(is,vnum);
guidata(hObject, handles);
SmoothAndPlot(hObject,handles,val,1)

function SmoothAndPlot(hObject,handles,vals,np)
for val=vals
    a=handles.chan(val).a;
    as=SmoothVec(a,handles.smlen)';
    handles.chan(val).as=as;
    handles.chan(val).va=iqr(a-as);
    handles.chan(val).da=handles.chan(val).va*handles.tlev;
    handles.chan(val).spa=ExtractSpikes(a,as,handles.chan(val).da);
end
guidata(hObject, handles);
UpdatePlots(handles,vals,np)

function UpdatePlots(handles)
t=handles.t(done);
a=handles.ang_e(handles.done)*180/pi;
axes(handles.taxis)
plot(t,a);%,t,a_adj,'o')
% axis 
axes(handles.taxis)
plot(t,handles.NumBees)


function PlotStuff(t,a,as,spa,da,ax_num,np)
axes(ax_num)
ax=axis;
plot(t,a,t,as,'g',t,as-da,'k',t(spa),a(spa),'r.')
if(np)
    axis tight;
else
    axis(ax);
end


function ch3_Callback(hObject, eventdata, handles)
% hObject    handle to ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3 as text
%        str2double(get(hObject,'String')) returns contents of ch3 as a double
val=round(str2num(get(hObject,'String')));
ch=handles.ChanNum;
if(ValidChannel(val,ch))
    UpdateChan(hObject,handles,3,ch(val))
end

function[out]=ValidChannel(val,ch)
out=0;
if((val>0)&&(val<=length(ch)))
    out=ch(val)>0;
end

% --- Executes during object creation, after setting all properties.
function ch3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
% contents = cellstr(get(hObject,'String'));
contents = cellstr(get(hObject,'String'));
fn=char(contents{get(hObject,'Value')});
LoadData(hObject,handles,fn);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExtractSpikes.
function ExtractSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fn=handles.spfn;
if(~exist(fn,'file'))
    tlev=handles.tlev;
    smlen=handles.smlen;
    save(handles.fn,'tlev','smlen','-append');
    GetSpikes1(handles);
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function taxis_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to taxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function title_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
