% function[dat]=ProcessBeeFileName2015(f,endstr)
% 
% this function processes file names so that from the name you can tell the
% type of experiment, flight number bee etc. it retruns all the data in a
% structure dat
% 
% It takes a filename in f and an optional argument which is the bit at the
% end of the filename that will be ignored. Without this, it processes all
% the filename before the '.'
%
% This works well for the .avi files ie the movie names but not eg for the
% ...Prog.mat or ...All.mat files
%
% Typical USAGE:
%
% % Process all avi files in a folder
% 
% s=dir('*.avi');
% for i=1:length(s)
%     d(i)=ProcessBeeFileName2015(s(i).name);
% end
%
% % Process all All files in a folder
% 
% s=dir('*All.mat');
% for i=1:length(s)
%     d(i)=ProcessBeeFileName2015(s(i).name,'All.');
% end

function[dat]=ProcessBeeFileName2015(f,endstr)

% by default use the bit of the filename before the last '.'
if(nargin<2)
    endstr='.';
end
% last bit before the .avi or eg All.
ep=strfind(f,endstr);
lf=ep(end)-1;

% store the name
dat.name=f;

% positions of all underscores
unds=strfind(f,'_');

% get the date: 4/6 chars before last underscore
sp=unds(end)+1;
fbit=f(sp:lf);
[dat.date,ind]=ExtractNumbers(fbit);

% check for letters after the date
if((ind(2)+sp-1)==lf)
    tadd=0;
    dat.lafter=[];
else
    % this gets the letters before the . and turns them into a numerical
    % value. eg a=1, b=2 etc
    val=double(f((ind(2)+sp):lf))-96;
    
    % this bit then adds val/100 to the time stamp eg a=0.01, b=.2 etc and
    % stores the first letter
    tadd=val(1)/100;
    dat.lafter=f((ind(2)+sp));
    
    % this bit was written assuming the only letters before the '.' are to
    % denote timing (so aa would come after z). However, I'm now using tis 
    % file to process All.mat files so now only taking the 1st letter
%     lt=length(val)-1;
%     tadd=val(1)/100+lt*.26;
end

% this is a flag which says that, while this is a flight that was learnt with
% a small landmark, it was tested with a big landmark
bigsinglm=0;

% Get file type
if(isequal(f(1:3),'Cal')||isequal(f(1:3),'cal'))
    % Calibration File
    dat.bee='Cal';
    dat.fltnum=-1;
    dat.ftype=1;
    dat.lmw=-1;
    dat.nlm=-1;
    dat.time=0;
    dat.bnum=-1;
    if(ismember(exptype,[4 5]))
        dat.NestVec=[0,0];
    end
else
    % get bee identifier
    dat.bee=f(1:(unds(1)-1));
    
    % get the flight number
    s=unds(1)+1;
    % this is the section of the name between 1st and 2nd underscores
    fbit=f(s:(unds(2)-1));
    % get the first number as the flight number
    [flnums,inds]=ExtractNumbers(fbit);
    
    % This bit is a bit of a hack because the 3 LM flights have a 3 as the
    % number before the underscore. This is annoying as it would be better
    % if it were a letter. As a workaround I'll just take the first two
    % numbers as the bee flight number if there's a 3 after the flight
    % number (below) However, I could also do it here if needed to do it
    % for all flights
%     flnums=ExtractNumbers(fbit(inds(1):(inds(1)+1)));
    
    
    dat.fltnum=flnums(1);
    % ind holds the indices of the numbers. This is used to see if there
    % are any letters after the flight number
    ind=inds(1,:);
    % if it's an unknown bee make fltnum -1
    if(~isempty(strfind(fbit,'X')))
        dat.fltnum=-1;
    end
    
    % get type of flight from the letter after the 1st underscore
    % this may need to be re-written as both B and T used to indicate tests
    % may need to have different versions if we only want T R or L    
    % start with default experiment type of 3 LMS but then alter below
    if(isequal(f(s),'T'))
        % test with big LMs, no nest, 3 LMs       
        dat.ftype=6;
        dat.lmw=5;
        dat.nlm=3;
    elseif(isequal(f(s),'B'))
        % test with Big LMs, no nest, single LM         
        dat.ftype=5;
        dat.lmw=5;
        dat.nlm=1;
        bigsinglm=1;
    elseif(isequal(f(s),'S'))
        % test with small LMs, no nest, single LM       
        dat.ftype=4;
        dat.lmw=2.5;
        dat.nlm=1;
    elseif(isequal(f(s),'R'))
        % return flight, nest uncovered
        dat.ftype=3;
        dat.lmw=5;
        dat.nlm=3;
    elseif(isequal(f(s),'L'))
        % learning flight
        dat.ftype=2;
        dat.lmw=5;
        dat.nlm=3;
    end

    % this is the bit that should be customised to specify different
    % experiment types
    
    % s+ind(2) is the index of the end of the flight number in fbit
    % hence first check if there are any letters before the underscore
    if((s+ind(2))==unds(2))
        % if there's no letter after the flight number it's an experiment
        % with 3 or 1 LMs via the old system
        
        % if it has a 3 as the last number, then it could be that the
        % flight number should only be the first two numbers and not
        % include the 3. However, i don't know this for so will maybe also
        % test the length of inds
        if(isequal(fbit(end),'3'))
            % if there are 3 numbers
%             if((inds(end)-inds(1))>1)
%             end
            maxn=max(inds(2),inds(1)+1);
            flnums=ExtractNumbers(fbit(inds(1):(maxn-1)));
            exptype=5;
        else
            exptype=1;
        end
        % if it's an unknown bee make fltnum -1
        if(~isempty(strfind(fbit,'X')))
            dat.fltnum=-1;
        else
            dat.fltnum=flnums(1);
        end

    else     
        % if there's something after the number then see what it is and set
        % the type of the experiment and reset number of landmarks etc as
        % appropriate
        afternum=(s+ind(end,2):unds(2)-1);
        if(isequal(f(afternum),'S'))
            % this is a single landmark with small landmarks
            exptype=1;
            dat.nlm=1;
            if(bigsinglm==0)
                dat.lmw=2.5;
            end
        elseif(isequal(f(afternum),'B'))
            % this is a single landmark with a Big landmark
            dat.lmw=5;
            dat.nlm=1;
            exptype=1;
        elseif(isequal(f(afternum),'L'))
            % this is a single landmark with a Large (?) landmark
            dat.lmw=5;
            dat.nlm=1;
            exptype=1;        
        elseif(isequal(f(afternum),'C3'))
            % this is a 3 LMs, 12 or 22 cm north of the nest
            dat.lmw=5;
            dat.nlm=3;
            exptype=6;
        elseif(isequal(f(afternum),'X3'))
            % this is an unknown bee. This needs working out
            % this is a 3 LMs, 22 cm north of the nest
            dat.lmw=5;
            dat.nlm=3;
            exptype=5;
            dat.fltnum=-1;
        elseif(isequal(f(afternum),'AC3'))
            % this is a 3 LMs, 12 or 22 cm north of the nest
            dat.lmw=5;
            dat.nlm=3;
            exptype=6;
        elseif(isequal(f(afternum),'BC3'))
            % this is a 3 LMs, 12 or 22 cm north of the nest
            dat.lmw=5;
            dat.nlm=3;
            exptype=6;
        elseif(isequal(f(afternum),'PR'))
            % this is a 3 LMs, 12 or 22 cm north of the nest
            dat.lmw=5;
            dat.nlm=3;
            exptype=7;
        elseif(isequal(f(afternum:(afternum+1)),'R4'))
            % I'm assuming this is a board type experiment. In this case
            % one needs to have 2 landmarks and exptype as 3
            exptype =3;
            dat.nlm=2;
            % this is the width of the board (I think) but is not currently used
            dat.lmw=20;
        elseif(isequal(f(afternum:(afternum+1)),'R2'))
            % I'm assuming this is a board type experiment. In this case
            % one needs to have 2 landmarks and exptype as 3
            exptype =3;
            dat.nlm=2;
            % this is the width of the board (I think) but is not currently used
            dat.lmw=29;
        elseif(isequal(f(afternum:(afternum+2)),'LW3'))
            % I assume this is also a board type experiment. In this case
            % one needs to have 2 landmarks and exptype as 3
            exptype =3;
            dat.nlm=2;
            % this is the width of the board (I think) but is not currently used
            dat.lmw=20;
        end
    end    

    % if the experiment is with a board
    if(exptype==3)
        dat.nlm=2;
        dat.lmw=20;
    elseif(exptype==1)
        % single landmark
        dat.nlm=1;
    elseif(exptype==4)
        % not sure this should be necessary byt the filenam conventions are
        % all a bit screwy
        dat.nlm=1;
        dat.NestVec=[8,0];
    elseif(exptype==5)
        % not sure this should be necessary byt the filenam conventions are
        % all a bit screwy
        dat.nlm=3;
        dat.lmw=5;
        dat.NestVec=[-20,0];
    end
    
    % get the time of the flight
    fbit=f(unds(2)+1:(unds(3)-1));
    t=ExtractNumbers(fbit);  
    % add in a bit if there's any letters
    dat.time=t+tadd;
end
dat.bnum=ExtractNumbers(dat.bee);
dat.ordtime=OrdTime(dat.date,dat.time);
dat.exptype=exptype;


function[ot]=OrdTime(d,t)
xd=int2str(d);
vd=datenum(0,str2num(xd(end-1:end)),str2num(xd(1:end-2)))*1e5;
ot=vd+t;