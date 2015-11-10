function nestcoords2012(exptype)
% dwork;
% cd Bees\bees12\

% vO=1 means use videoReader, 0 = use mmread (slow)
% vO=0;
% now doing auto setting of type of videoreader but if this doesn't work
% set it manually as above
s=dir('*.avi');
vO=VideoReaderType(s(1).name);

% specify the type of calibration
if(nargin<1)
    exptype=0;
end
while(~ismember(exptype,1:5))
    disp('')
    disp('1 for single 5cm LM 20cm away,')
    disp('2 for 3x5cm LMs, 20 cm around a nest,')
    disp('3 for board')
    disp('4 for single 2.5cm LM 8cm away,')
    disp('5 for 3x5cm LM, 20cm  a feeder')
    exptype=input('Pick which experiment type: ');
end

disp(' ')
UseAvi=ForceNumericInput('enter 1 to generate file-list from avis in folder, 0 not: ',[],[],[0 1]);

if(UseAvi)
    FList12=dir('*.avi');
    disp('**** using avis not FileList ****')
else
    if(isfile('FileList.mat'))
        load FileList.mat;
    elseif(vO==1)
        FList12=dir('*.avi')
        save('FileList.mat','FList12')
    else
        disp('need to re-run AvisToMats2012. Enter AvisToMats2012 at the command line')
        disp('if still problems, check you are in the right folder')
        return
    end
end
% check all the file names are ok
ch_out=CheckAviNames2012(FList12,exptype);
if(ch_out==0)
    return;
end
inp=0;
if(vO==0)
    while(~isequal(inp,1))
        inp=input('using mmread; enter 1 to continue');
    end
    if(~UseAvi)
        [ok,newflist]=CheckFileList2012;
        if(~ok)
            disp('need to re-run AvisToMats2012');
            return
        end
    end
elseif(vO==1)
%     while(~isequal(inp,1))
%         inp=input('using mmread; enter 1 to continue');
%     end
else
    disp('specify type of video reader at line 6')
    return;
end

is=[1:length(FList12)];

if(isempty(is))
    disp('no avi files in this folder');
    return;
end
for j=is
    if(exist('d'))
        d(j).name='';
        d(j)=ProcessBeeFileName2012(FList12(j).name,exptype,d(j));
    else
        d(j)=ProcessBeeFileName2012(FList12(j).name,exptype);
    end
end
% order the files by date and time
[dum,ks]=sort([d.ordtime]);
d=d(ks);

% process all calibration files
CalList=d([d.ftype]==1);

calibcoords(CalList);%,vO);
% disp('***UNCOMMENT***')
% process all other files
d=d([d.ftype]~=1);
for j=1:length(d)
    f=d(j).name(1:end-4);
%     dat=d(j).date;
    GetNestAndLMData2012(f,d(j),d(1:j-1),CalList,vO,exptype);
end