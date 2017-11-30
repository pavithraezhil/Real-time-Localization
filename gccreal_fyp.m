function varargout = gccreal(varargin)
% GCCREAL MATLAB code for gccreal.fig
%      GCCREAL, by itself, creates a new GCCREAL or raises the existing
%      singleton*.
%
%      H = GCCREAL returns the handle to a new GCCREAL or the handle to
%      the existing singleton*.
%
%      GCCREAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GCCREAL.M with the given input arguments.
%
%      GCCREAL('Property','Value',...) creates a new GCCREAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gccreal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gccreal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gccreal

% Last Modified by GUIDE v2.5 05-Mar-2015 11:41:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gccreal_OpeningFcn, ...
                   'gui_OutputFcn',  @gccreal_OutputFcn, ...
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


% --- Executes just before gccreal is made visible.
function gccreal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gccreal (see VARARGIN)

% Choose default command line output for gccreal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gccreal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gccreal_OutputFcn(hObject, eventdata, handles) 
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

clc;

for o=1:10
recobj = audiorecorder(16000,8,2);
disp('start')
recordblocking(recobj,1);
disp('end')
play(recobj);
myrecording= getaudiodata(recobj);
q1= length(myrecording)

p1= myrecording(:,1)
p2= myrecording(:,2)


axes(handles.axes1)
plot(p1);

axes(handles.axes3)
plot(p2);

%figure(1);
%subplot(3,1,1);


fs= 16000;
%ts=1/fs;
%p1= 0.5*fs;

u=1600;
for i=0:9
    for g=(i*u):(((i+1)*u)-1)
%select a small window
    signal1(g-(i*u)+1)= p1(g+1);
end
%subplot(3,1,2);
%plot(signal1);



%subplot(3,1,3);
%plot(p2);
 for j=(i*u):(((i+1)*u)-1)
%select a small window
    signal2(j-(i*u)+1)= p2(j+1);
end
%figure(2);
%subplot(3,1,1);
%plot(signal1);
%pad zeros for linear convolution
N1= length(signal1)
N2= length(signal2)
N=N1+N2-1
s1= horzcat(signal1,zeros(1,N-N1));
s2= horzcat(signal2,zeros(1,N-N2));
f1= fft(s1);
f2= fft(s2);
%figure(2);
%subplot(2,1,1);
%plot(s1);
%subplot(2,1,2);
%plot(s2);
%perform GCC-PHAT
fx2= conj(f2);
numerator= f1.*fx2;
denominator= abs(numerator);
Gphat= numerator./denominator;
ifft1= ifft(Gphat);
%figure(3);
%subplot(3,1,1);
%plot(signal2);
%figure(4);
%plot(ifft1);

j= 1;
w=0;e=0;
for i=1:N
    if(i<=4) %max(d1,d2)
        b(i)= ifft1(i);
       % e=e+1
    elseif(i>=N-4) %max(d1,d2)
        b(N-i+j)= ifft1(i);
        j= j+2;
        %w=w+1
    else
        ifft1(i)= ifft1(i);
    end
end
L= length(b)
p= (L-1)/2;
q= (L+1)/2;
for g=-p:p
    a(g+q)= g;
end
for h=1:L
    if(h<q)
        c(h)= b(h+q);
    else
        c(h)= b(h-p);
    end
end
    
o1= max(b)
ctr1=0;ctr2=0;
for o2= 1:9
    if (b(o2)==o1)
        if(o2>5)
            ctr1=ctr1+1;
        elseif(o2<5)
           ctr2=ctr2+1;
        end
    end
end

%figure(5);
%subplot(3,1,1);
%plot(b);
%subplot(3,1,2);
%plot(c);
%subplot(3,1,3);
axes(handles.axes2)
plot(a,c)
xlabel('TDOA')
%ylabel()
end

if(ctr1>ctr2)
    axes(handles.axes4)
    imshow('left.jpg')
else
    axes(handles.axes4)
    imshow('right.jpg')
end

end
