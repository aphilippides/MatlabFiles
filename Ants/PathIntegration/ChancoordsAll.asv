function ChancoordsAll(exptype)
% dwork;
% cd Bees\bees12\

% vO=1 means use videoReader, 0 = use mmread (slow)
% vO=0;
% now doing auto setting of type of videoreader but if this doesn't work
% set it manually as above
s=dir('*.avi');
% vO=VideoReaderType(s(1).name);

% specify the type of calibration
if(nargin<1)
    exptype=0;
end
% while(~ismember(exptype,1:3))
%     disp('')
%     disp('What file types? enter 1 for 1 LM,')
%     exptype=input('2 for 3 LMs, 3 for board: ');
% end


is=[1:length(s)];
if(isempty(is))
    disp('no avi files in this folder');
    return;
end
% for j=is
%         d(j)=ProcessAntName2012(s(j).name,exptype,d(j));
%     else
%         d(j)=ProcessAntName2012(FList12(j).name,exptype);
%     end
% end
% % order the files by date and time
% [dum,ks]=sort([d.ordtime]);
% d=d(ks);

% % process all calibration files
% CalList=d([d.ftype]==1);
% 
% calibcoords(CalList);%,vO);
% % disp('***UNCOMMENT***')
% % process all other files
% d=d([d.ftype]~=1);
for j=is
    f=s(j).name(1:end-4);
    initlist=dir('*NestLMData.mat');
%     dat=d(j).date;
    GetChannelData(f,initlist,0);
end