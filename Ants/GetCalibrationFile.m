function[CalFile]=GetCalibrationFile(cal,dat)
CalFile=-1;

ds=find([cal.date]==dat.date);
dstr=dat.name;
if(length(dstr)==3)
    dstr=['0' dstr];
end
if(isempty(cal))
    disp(['No calibration files in folder']);
elseif(isempty(ds))
    disp(['No calib file for ' dstr]);
    WriteFileOnScreen(cal,1)
    pic=input(['Pick calib file for ' dstr '; return quit: ']);
    disp(' ')
    if(isempty(pic))
        disp(['No calibration file picked'])
        return;
    else
        CalFile=[cal(pic).name(1:end-4) 'CalData.mat'];
        disp(['using calib file: ' CalFile]);
%         dum=input(['using calibration file: ' CalFile  ...
%         '; press return to continue']);
    end
else
    if(length(ds)==1)
        CalFile=[cal(ds).name(1:end-4) 'CalData.mat'];
        disp(['using calib file: ' CalFile]);
    else
        WriteFileOnScreen(cal(ds),1)
        pic=input(['Pick calib file for ' dstr '; return quit: ']);
        disp(' ')
        if(isempty(pic))
            disp(['No calibration file picked'])
            return;
        else
            CalFile=[cal(ds(pic)).name(1:end-4) 'CalData.mat'];
            disp(['using calib file: ' CalFile]);
%             dum=input(['using calibration file: ' CalFile  ...
%                 '; press return to continue']);
        end
    end
end