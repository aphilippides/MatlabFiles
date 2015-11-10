% SelectFlightSections
%
% run this to pick out flight sections 
% first picks out sections then lets you review them

function SelectFlightSections(fn)

% Get Data file
if(nargin<1) fn=['']; end;
fs=dir('*Data.mat');
WriteFileOnScreen(fs,1);
Picked=input('select output file; return to enter new one:  ');
if(isempty(Picked))
    fst=input('Enter new filename start *Data.mat:  ','s');
    OutFn=[fst 'Data.mat'];
    fltsec=[];
    if((isempty(fn))|(ischar(fn)))
        s=dir(['*' fn '*All.mat']);
        WriteFileOnScreen(s,1);
        Picked=input('select file numbers:  ');
        if(isempty(Picked)) flist=s;
        else flist=s(Picked);
        end
    else
        s=dir(['*All.mat']);
        flist=s(fn);
    end
else
    OutFn=fs(Picked).name;
    load(OutFn)
    if(~isfield(fltsec,'cs')) fltsec(1).cs=[]; end
end

curr=1;
nc=length(flist);
while 1
    if((length(fltsec)>=curr)&(~isempty(fltsec(curr).lm)))
        j=length(fltsec(curr).fsec);
        figure(1)
        PlotNestAndLMs(fltsec(curr).lm,fltsec(curr).lmw,[0 0]);
        hold on;
        for k=1:j
            ccs=fltsec(curr).fsec(k).cs;
            plot(ccs(:,1),ccs(:,2),'k- .')
            text(ccs(1,1),ccs(1,2),'S')
            text(ccs(end,1),ccs(end,2),'E','Color','r')
        end
        axis equal
        title(['file ' int2str(curr) '/' int2str(nc) ': ' fltsec(curr).fn]);
        hold off
        
        if(~isempty(fltsec(curr).cs))
            figure(2)
            PlotNestAndLMs(fltsec(curr).lm,fltsec(curr).lmw,[0 0]);
            hold on;
            plot(fltsec(curr).cs(:,1),fltsec(curr).cs(:,2),'r:')
            for k=1:(j-1)
                ccs=fltsec(curr).fsec(k).cs;
                plot(ccs(:,1),ccs(:,2),'k- .')
                text(ccs(1,1),ccs(1,2),'S')
                text(ccs(end,1),ccs(end,2),'E','Color','r')
            end
            axis equal
            title(['file ' int2str(curr) '/' int2str(nc) ': ' fltsec(curr).fn]);
            hold off
        end

        disp(' ')
        disp('Enter 1 to select sections; r to remove sections; ');
        disp('p to review sections one-by-one; ');
        inp=input('return continue; u = up 1 file; c break:  ','s');
        if(isequal(inp,'u')) curr=curr-1;
        elseif(isequal(inp,'c')) break;
        elseif(isempty(inp)) curr=curr+1;
        elseif(isequal(inp,'1')) 
            fltsec=GetFlightSec(fltsec,curr,OutFn,flist);
        elseif(isequal(inp,'r')) 
            fltsec(curr).fsec=ReviewSections(fltsec(curr));
            save(OutFn,'fltsec','flist');
        elseif(isequal(inp,'p')) 
            fltsec(curr).fsec=ReviewSectionsSingly(fltsec(curr));
            save(OutFn,'fltsec','flist');
        end
    else
        fltsec(curr).fn=flist(curr).name;
        fltsec(curr).fsec=[];
        fltsec=GetFlightSec(fltsec,curr,OutFn,flist);
    end
    curr=mod(curr,nc);
    if(curr==0) curr=nc; end;
    
end

function[newfsec]=ReviewSectionsSingly(fltsec)

newfsec=fltsec.fsec;
nc=length(newfsec);
rem=ones(1,nc);
if(nc==0)
    disp('NO FLIGHTS TO REMOVE')
    return;
end

% allcs=[];
% for k=1:nc allcs=[allcs;newfsec(k).cs]; end;

load(fltsec.fn);

k=1;
while 1
    figure(1)
    PlotNestAndLMs(fltsec.lm,fltsec.lmw,[0 0]);
    hold on;
    plot(fltsec.cs(:,1),fltsec.cs(:,2),'r:')
    for i=k%1:nc
        ccs=newfsec(i).cs;
        plot(ccs(:,1),ccs(:,2),'k- .')
%         if(i==k)
%             if(rem(i)) plot(ccs(:,1),ccs(:,2),'k-*')
%             else plot(ccs(:,1),ccs(:,2),'r-*')
%             end
%         elseif(rem(i)) plot(ccs(:,1),ccs(:,2),'k- .')
%         else plot(ccs(:,1),ccs(:,2),'r- *')
%         end
        text(ccs(1,1),ccs(1,2),['S'])
        text(ccs(end,1),ccs(end,2),['E'],'Color','r')
    end
    axis equal
    hold off
    xlabel('black is staying, red is to be removed; stars is current')
    title(['file ' fltsec.fn '; section ' int2str(k) ' out of ' int2str(nc)]);
    figure(2)
    PlotNestAndLMs(fltsec.lm,fltsec.lmw,[0 0]);
    hold on;
    ccs=newfsec(k).cs;
    if(rem(k)) plot(ccs(:,1),ccs(:,2),'k- .')
    else plot(ccs(:,1),ccs(:,2),'r- .')
    end
    text(ccs(1,1),ccs(1,2),['S'])
    text(ccs(end,1),ccs(end,2),['E'],'Color','r')
    axis equal
    hold off
    st=t(newfsec(k).is(1));
    et=t(newfsec(k).is(end));
    xlabel('black is staying, red is to be removed')
    title(['section ' int2str(k) ' out of ' int2str(nc) '; Time ' num2str(st) ' to ' num2str(et)]);
    disp(' ')
    inp=input('r to remove/deremove; else to continue, c to end:  ','s');
    if(isequal(inp,'c'))
        newfsec=newfsec(find(rem));
        return;
    elseif(isequal(inp,'r'))
        rem(k)=mod(rem(k)+1,2);
    else k=k+1;
    end
    k=mod(k,nc);
    if(k==0) k=nc; end;
end


function[newfsec]=ReviewSections(fltsec)

newfsec=fltsec.fsec;
j=length(newfsec);
rem=ones(1,j);
if(j==0)
    disp('MO FLIGHTS TO REMOVE')
    return;
end

allcs=[];
for k=1:j allcs=[allcs;newfsec(k).cs]; end;

while 1
    figure(1)
    PlotNestAndLMs(fltsec.lm,fltsec.lmw,[0 0]);
    hold on;
    for k=1:j
        ccs=newfsec(k).cs;
        if(rem(k)) plot(ccs(:,1),ccs(:,2),'k- .')
        else plot(ccs(:,1),ccs(:,2),'r- .')
        end
        text(ccs(1,1),ccs(1,2),['S:' int2str(k)])
        text(ccs(end,1),ccs(end,2),['E:' int2str(k)],'Color','r')
    end
    axis equal
    hold off
    xlabel('black is staying, red is to be removed')
    [ind1,b]=GetNearestClickedPt(allcs,'click to select/deselect a section, return when done');
    if(isempty(b))
        while 1
            disp(' ')
            disp(['Type 0 if ok; r to continue;'])
            inp=input('n to enter section numbers to select/deselect:  ','s');
            if(isequal(inp,'0'))
                newfsec=newfsec(find(rem));
                return;
            elseif(isequal(inp,'r'))
                break;
            elseif(isequal(inp,'n'))
                disp(' ')
                disp(['currently selected ' int2str(find(~rem))])
                v=input('enter section numbers to select/deselect as a vector:  ')
                rem(v)=mod(rem(v)+1,2);
                break;
            end
        end
    else
        pic=allcs(ind1,:);
        for k=1:j
            ccs=newfsec(k).cs;
            if(ismember(pic,newfsec(k).cs,'rows'))
                rem(k)=mod(rem(k)+1,2);
                break;
            end
        end
    end
end


function[fltsec]=GetFlightSec(fltsec,curr,OutFn,flist)
compassDir=4.9393;
fn=fltsec(curr).fn;
load(fn);
lmo=LMOrder(LM);
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end
fltsec(curr).lm=LM;
fltsec(curr).lmw=LMWid;
fltsec(curr).cs=Cents;

tInc=0.5;
tgap=5;
ils=1;
lent=length(t);
ilen=max(ils+1,GetTimes(t,t(1)+tgap));
iall=[];
j=length(fltsec(curr).fsec);
chosen=[];
for k=1:j 
    chosen=union(chosen,fltsec(curr).fsec(k).is); 
end

while 1

    ils=min(max(ils,1),lent-1);
    ilen=max(ils+1,min(ilen,lent));
    ileft=ils:ilen;
    j=length(fltsec(curr).fsec)+1;

    % Plot stuff
    figure(2)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    plot(Cents(:,1),Cents(:,2),'r:')
    for k=1:(j-1)
        ccs=fltsec(curr).fsec(k).cs;
        plot(ccs(:,1),ccs(:,2),'k- .')
        text(ccs(1,1),ccs(1,2),'S')
        text(ccs(end,1),ccs(end,2),'E','Color','r')
    end
    axis equal
    title(fn);
    hold off

    figure(1)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    plot(Cents(ileft,1),Cents(ileft,2),'k- .')
    plot(Cents(iall,1),Cents(iall,2),'r- .')
    plot(Cents(intersect(ileft,chosen),1),Cents(intersect(ileft,chosen),2),'gs')
    text(Cents(ils,1),Cents(ils,2),'S')
    text(Cents(ilen,1),Cents(ilen,2),'E','Color','r')
    axis equal
    title(['Time ' num2str(t(ils)) ' to ' num2str(t(ilen))])
    hold off

    xlabel('Cursor arrows moves available points. t to change the time increment');
    [ind1,b]=GetNearestClickedPt(Cents(ileft,:),'click start pt; return to stop'); %right click or b if bad;
    if(isempty(b))
        fla=FlushResponse;
        
        if(fla==2)
            ils=1;
            ilen=max(ils+1,GetTimes(t,t(1)+tgap));
            iall=[];
            chosen=[];
            j=1;
            zz=InitZigZag(fn);
        elseif(fla<3)
            % if some points have been chosen
            if(length(iall)>1)
                fltsec(curr).fsec(j).is=iall;
                fltsec(curr).fsec(j).fn=fn;
                fltsec(curr).fsec(j).cs=Cents(iall,:);
                fltsec(curr).fsec(j).so=sOr(iall);
                fltsec(curr).fsec(j).ep=EndPt(iall,:);
                fltsec(curr).fsec(j).co=Cent_Os(iall);
                save(OutFn,'fltsec','flist');
                chosen=union(chosen,iall);
            end
            % do next file
            if(fla==0) break;
            % do another bit of the same file    
            elseif(length(iall)>1)
%                 ils=iall(end)+1;
%                 ilen=max(ils+1,GetTimes(t,t(ils)+2));
                iall=[];
            end
        elseif(fla==4) break;
        end
    elseif(b==28) ils=max(ils+1,GetTimes(t,t(ils)+tInc));
    elseif(b==29) ils=min(ils-1,GetTimes(t,t(ils)-tInc));
    elseif(b==30) ilen=min(ilen-1,GetTimes(t,t(ilen)-tInc));
    elseif(b==31) ilen=max(ilen+1,GetTimes(t,t(ilen)+tInc));
    elseif(isequal(b,t))
        while 1
            newt=input(['Enter new increment, currently ' num2str(tInc) ':  ']);
            if(newt>0)
                tInc=newt;
                break;
            end
        end
    else
        ind1=ileft(ind1);
        while 1
            [ind2,b]=GetNearestClickedPt(Cents(ileft,:),'click end pt');
            if(ind2>0)
                ind2=ileft(ind2);
                break;
            end
        end
        if(ind1>ind2)
            tmp=ind1;
            ind1=ind2;
            ind2=tmp;
        end
        iall=ind1:ind2;
    end;
end

function[fla]=FlushResponse
while 1
    disp(' ');
    disp('0: next file; 1: do another bit; 2: next file without this bit');
    inp=input('r: redo whole file; z, go back:  ','s');
    if(isequal(inp,'0'))
        fla=0;
        break;
    elseif(isequal(inp,'1'))
        fla=1;
        break;
    elseif(isequal(inp,'r'))
        fla=2;
        break;
    elseif(isequal(inp,'z'))
        fla=3;
        break;
    elseif(isequal(inp,'2'))
        fla=4;
        break;
    end
end
