function[out]=CheckAviNames2012(FList12,exptype)

out=1;
if(nargin<1)
    FList12=dir('*.avi');
end
exptype=0;
if(nargin<2)
    while(~ismember(exptype,1:3))
        disp(' ')
        disp('What file types? enter 1 for 1 LM,')
        exptype=input('2 for 3 LMs, 3 for board: ');
    end
end
disp(' ')
for j=1:length(FList12)
    try
        if(exist('d'))
            d(j).name='';
            d(j)=ProcessBeeFileName2012(FList12(j).name,exptype,d(j));
        else
            d(j)=ProcessBeeFileName2012(FList12(j).name,exptype);
        end
    catch
        disp(['File name ' FList12(j).name ' needs altering'])
        out=0;
    end
end
if(out==0)
    disp(' ')
    disp('please change filenames listed above before proceeding')
    disp('If you were running AvisToMats2012 or nestcoords2012')
    disp('you should re-run it')
end

