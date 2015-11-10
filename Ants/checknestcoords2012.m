function checknestcoords2012(exptype)
if(nargin<1)
    exptype=2;
end
% dwork;
% cd Bees\bees12\

% vO=1 means use videoReader, 0 = use mmread (slow)
vO=0;

% specify the type of calibration
if(nargin<1)
    exptype=0;
end
while(~ismember(exptype,1:3))
    disp('')
    disp('What file types? enter 1 for 1 LM,')
    exptype=input('2 for 3 LMs, 3 for board: ');
end

UseAvi=1;
if(UseAvi)
    FList12=dir('*.avi');
    disp('**** using avis not FileList ****')
else
    load FileList.mat;
end

is=1:length(FList12);
for j=is
    if(exist('d'))
        d(j).name='';
        d(j)=ProcessBeeFileName2012(FList12(j).name,exptype,d(j));
    else
        d(j)=ProcessBeeFileName2012(FList12(j).name,exptype);
    end
end
% order the files by date and time
[s,ks]=sort([d.ordtime]);
d=d(ks);
% process all calibration files
CalList=d([d.ftype]==1);

% calibcoords(CalList,vO);
% disp('***UNCOMMENT***')
% process all other files
d=d([d.ftype]~=1);
for j=1:length(d)
    f=d(j).name(1:end-4);
    j
    dat=d(j).date;
    if 1%(d(j).ftype~=1)
        GetNestAndLMData2012(f,d(j),d(1:j-1),CalList,vO,exptype,1);
    end
end