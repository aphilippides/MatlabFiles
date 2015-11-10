function varargout = viewer_gui(varargin)
% VIEWER_GUI M-file for viewer_gui.fig
%      VIEWER_GUI, by itself, creates a new VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = VIEWER_GUI returns the handle to a new VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER_GUI.M with the given input arguments.
%
%      VIEWER_GUI('Property','Value',...) creates a new VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewer_gui

% Last Modified by GUIDE v2.5 30-Jul-2008 14:10:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @viewer_gui_OpeningFcn, ...
    'gui_OutputFcn',  @viewer_gui_OutputFcn, ...
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

% --- Executes just before viewer_gui is made visible.
function viewer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewer_gui (see VARARGIN)

% Choose default command line output for viewer_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using viewer_gui.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes viewer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewer_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

val1=get(handles.slider1, 'Value');
minval1=get(handles.slider1,'Min');
maxval1=get(handles.slider1,'Max');

spacing=25*(val1-minval1)/(maxval1-minval1)+5;

val2=get(handles.slider2, 'Value');
minval2=get(handles.slider2,'Min');
maxval2=get(handles.slider2,'Max');
thresh=(pi/2)*(val2-minval2)/(maxval2-minval2)+0.000001;

contents = get(handles.listbox1,'String');
fn=contents{get(handles.listbox1,'Value')};
load(fn);

findStraightSections(Cents,spacing,thresh);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val1=get(handles.slider1, 'Value');
minval1=get(handles.slider1,'Min');
maxval1=get(handles.slider1,'Max');

spacing=25*(val1-minval1)/(maxval1-minval1)+5;

val2=get(handles.slider2, 'Value');
minval2=get(handles.slider2,'Min');
maxval2=get(handles.slider2,'Max');
thresh=(pi/2)*(val2-minval2)/(maxval2-minval2)+0.000001;

set(handles.edit1,'String',num2str(spacing));

contents = get(handles.listbox1,'String');
fn=contents{get(handles.listbox1,'Value')};
load(fn);

findStraightSections(Cents,spacing,thresh);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val1=get(handles.slider1, 'Value');
minval1=get(handles.slider1,'Min');
maxval1=get(handles.slider1,'Max');
spacing=25*(val1-minval1)/(maxval1-minval1)+5;

val2=get(handles.slider2, 'Value');
minval2=get(handles.slider2,'Min');
maxval2=get(handles.slider2,'Max');
thresh=(pi/2)*(val2-minval2)/(maxval2-minval2)+0.000001;

set(handles.edit2,'String',num2str(thresh));

contents = get(handles.listbox1,'String');
fn=contents{get(handles.listbox1,'Value')};
load(fn);

findStraightSections(Cents,spacing,thresh);
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function [sections,normalisedSections]=findStraightSections(Cents,spacing,thresh)
% spacing - distance between sample points
% thresh - angle in radians that indicates deviation from straight

% resample data at higher sampling rate
dt=0.01;
t=1:length(Cents);
sCents(:,1)=spline(t,Cents(:,1),t(1):dt:t(end));
sCents(:,2)=spline(t,Cents(:,2),t(1):dt:t(end));

% resample at equal distances rather than equal time steps
svx=gradient(sCents(:,1));
svy=gradient(sCents(:,2));
[sth,sr]=cart2pol(svx,svy);
d=0;
cnt=0;
Cx=[];
Cy=[];
for i=1:length(sr)
    d=d+sr(i);
    if d>spacing
        cnt=cnt+1;
        d=0;
        Cx(cnt)=sCents(i,1);
        Cy(cnt)=sCents(i,2);
    end
end

% iterate through resampled data finding straight sections
% figure(gca)
cla
cellcnt=1;
pts=[];
for i=2:length(Cx)-1
    p1=[Cx(i-1),Cy(i-1)];
    p2=[Cx(i),Cy(i)];
    p3=[Cx(i+1),Cy(i+1)];

    [th13,len13]=cart2pol([p1(1)-p3(1)],[p1(2)-p3(2)]);
    [th23,len23]=cart2pol([p2(1)-p3(1)],[p2(2)-p3(2)]);
    [th12,len12]=cart2pol([p1(1)-p2(1)],[p1(2)-p2(2)]);

    u=[p1(1)-p2(1),p1(2)-p2(2)];
    v=[p2(1)-p3(1),p2(2)-p3(2)];
    th=acos((dot(u,v)/abs(len12*len23)));

    if th<thresh
        hold on
        plot([p1(1),p2(1),p3(1)],[p1(2),p2(2),p3(2)],'k-')
        plot([p1(1),p2(1),p3(1)],[p1(2),p2(2),p3(2)],'k.')
        pts=[pts;p2];
    else

        if numel(pts)>8
            sections{cellcnt}=pts;
            nS=[pts(:,1)-mean(pts(:,1)),pts(:,2)-mean(pts(:,2))];
            d=sqrt(dist2(pts(1,:),pts(end,:)));
            nS=nS/d;
            normalisedSections{cellcnt}=nS;
            cellcnt=cellcnt+1;
        end
        pts=[];
        plot(p2(1),p2(2),'r.')
    end

end
axis equal
hold off


% figure(2)
% for i=1:length(normalisedSections)
%     pts=normalisedSections{i};
%     plot(pts(:,1),pts(:,2),'k.');
%     hold on
% %     plot(pts(:,1),pts(:,2),'k-');
% end
% axis equal
% hold off


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
val1=get(handles.slider1, 'Value');
minval1=get(handles.slider1,'Min');
maxval1=get(handles.slider1,'Max');

spacing=25*(val1-minval1)/(maxval1-minval1)+5;

val2=get(handles.slider2, 'Value');
minval2=get(handles.slider2,'Min');
maxval2=get(handles.slider2,'Max');
thresh=(pi/2)*(val2-minval2)/(maxval2-minval2)+0.000001;


contents = get(handles.listbox1,'String');
fn=contents{get(handles.listbox1,'Value')};
load(fn);

findStraightSections(Cents,spacing,thresh);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

dd=dir('*.mat');
for i=1:length(dd)
    fnames{i}=dd(i).name;
end
set(hObject,'String',fnames);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


