function[dat]=ProcessBeeFileName2012(f,exptype,dat)

if(nargin<2)
    exptype=2;
end
dat.name=f;
% positions of all underscores
unds=strfind(f,'_');
% last bit before the .avi
lf=length(f)-4;
% get the date: 4/6 chars before last underscore
sp=unds(end)+1;
fbit=f(sp:lf);
[dat.date,ind]=ExtractNumbers(fbit);

% check for letters after the date
if((ind(2)+sp-1)==lf)
    tadd=0;
else
    val=double(f((ind(2)+sp):lf))-96;
    lt=length(val)-1;
    tadd=val(1)/100 +lt*.26;
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
        % with 3 or 1 LMs via the old system so don't do anything
    elseif(exptype==5)
        % just to make sure it skips the past bit
        
    else     
        % if there's something after the number then see what it is and set
        % the type of the experiment and reset number of landmarks etc as
        % appropriate
        afternum=s+ind(2);
        if(isequal(f(afternum),'S'))
            % this is a single landmark with small landmarks
%             exptype=1;
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
        elseif(isequal(f(afternum:(afternum+1)),'R4'))
            % I'm assuming this is a board type experiment. In this case
            % one needs to have 2 landmarks and exptype as 3
            exptype =3;
            dat.nlm=2;
            % this is the width of the board (I think) but is not currently used
            dat.lmw=20;
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