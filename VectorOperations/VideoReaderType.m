% function[vO,vObj]=VideoReaderType(fn,vO)
%
% this function checks to see which VideoReader to use
% vO=1 means use videoReader, vO=0 = use mmread (slow)
% vObj returns the video object from VideoReader or [] 
% if VideoReader throws an error
%
% if you're still gettin odd errors and want the program to just use mmread
% by default then uncomment lines (currently) 24 and 25 ie:
%
% % vO=0;
% % return;
%
% USAGE:
% [vO,vObj]=VideoReaderType(fn,vO) % gets vObj if vO=1
% [vO,vObj]=VideoReaderType(fn) % gets vObj and vO
% [vO,vObj]=VideoReaderType % gets vO and sets vObj=[]

function[vO,vObj]=VideoReaderType(fn,vO)
vObj=[];

% % ** if you want it to force the program to always use mmread uncomment the
% % ** 2 lines below this one
% vO=0;
% return;

if(~exist(fn,'file'))
    disp(' ');
    disp(['*** CANNOT FIND FILE ' fn ' ***']);
    disp('*** Check you are in the right directory ***');
    disp(' ');
    vO=0;
    return
end

% this checks if the function VideoReader exists
if(nargin<2)
    if exist('VideoReader')
        vO=1;
    else
        vO=0;
    end
end

% this chceks if VideoReader throws an error
if(vO)
    try 
        vObj=VideoReader(fn);
    catch 
        vObj=[];
        vO=0;
    end
    % this checks if read throws an error
    if(vO)
        try
            read(vObj,1);
        catch
            vObj=[];
            vO=0;
        end
    end
end
if(~vO)
    disp(' ')
    disp(['*** VideoReader doesnt work for ' fn ' ***'])
    disp(' ')
end