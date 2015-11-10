function[os,cs,len,bads,unsure,ignore,setvals,nx]=SmoothOsExpt2(os,t,cs,...
    len,fn,sm_len,eccent,areas,vObj,fr,lflag,unsure,bads)%o_thresh,ReplaceWithMean)

AllN=[fn(1:end-4) 'All.mat'];
flip=0;
if(nargin<6) 
    sm_len=0.1; 
end;
% if(nargin<7) o_thresh=0.175; end;
% if(nargin<8) ReplaceWithMean=0; end;
if(size(os,1)>size(os,2)) 
    os =os'; 
end;
Printing=0;
if(nargin<12)
    unsure=[];
end
if(nargin<13)
    bads=[];
end
ignore=[];
setvals=[];
nx=1;
if((nargin>10)&&(lflag==1))
    fn_str=load(AllN,'ignore','setvals','bads','unsure','nx'); 
    if(isfield(fn_str,'nx'))
        unsure=fn_str.unsure;
        nx=fn_str.nx;   
        ignore=fn_str.ignore;
        setvals=fn_str.setvals;
        
        % this check shouldn't be necessary any more but there was a bug
        % which meant that bad frames that were removed, weren't removed
        % from ignore and setvals for a few files. To fix that
        % one needs to find out which frame was removed (by checking with
        % the Check File (or something.... 
        % one can then change the ignores so they are no longer too high
        % one should be able to also do soething with setvals as it should
        % be mainly equal to os but that doesn't work always on the os...
        
        if((nx<5)&&(isfield(fn_str,'bads')))        
            bads=fn_str.bads;
        else
            finp=0;
            if(finp~=1)
                finp=ForceNumericInput('File has been processed. 1 reprocess; 0 skip: ',1);
            end
            if(finp==0)
                return;
            else
                ignore=[];
                setvals=[];
                nx=1;
            end
        end
    end
end
TrL=2;
maxl=length(os);
count=1;
while(1)
    % Smooth the values
    goodis=setdiff(1:length(os),bads);
    o=AngleWithoutFlip(os);
    so=o;
    so(goodis)=TimeSmooth(o(goodis),t(goodis),sm_len);
    % Re-do the smooth without unsure ones
    is=setdiff(goodis,unsure);
    so(is)=TimeSmooth(o(is),t(is),sm_len);
    % set the smoothed values to sure ones already adjusted
    so(ignore)=setvals;
    % find those not looked at
    NotDone=setdiff(1:length(os),[ignore unsure bads]);
    if(isempty(NotDone)) 
        break; 
    end;
    % find the index of the one most different from the smoothed value
    if(nx==1)
        e=areas(NotDone);
        [m,ind]=nanmax(e);
        TStr=['Area ' num2str(m,3) '/' num2str(nanmedian(areas),3)];
    elseif(nx==2)
        e=eccent(NotDone);
        [m,ind]=nanmin(e);
        TStr=['Eccent ' num2str(m,3)];
    elseif(nx==3)
        e=areas(NotDone);
        [m,ind]=nanmin(e);
        TStr=['Area ' num2str(m,3) '/' num2str(nanmedian(areas),3)];
    elseif(nx==4)
        e=abs(AngularDifference(o(NotDone),so(NotDone)));
        [m,ind]=nanmax(e);
        TStr=['Error ' num2str(m*180/pi,3)];
    else
        break;
    end
    i=NotDone(ind);

    if(Printing)
        figure(1), 
        plot(t,o*180/pi,'r',t,AngleWithoutFlip(so)*180/pi,'b:',...
            t(ignore),o(ignore)*180/pi,'k.',t(unsure),o(unsure)*180/pi,'ro'...
            ,t(bads),o(bads)*180/pi,'k*')
        hold on, 
        plot(t(i),o(i)*180/pi,'gs','MarkerFaceColor','g'),
        hold off
%         figure(2); plot(t(NotDone),e,t(i),e(ind),'go'),
    end
    
    tri=max(1,i-TrL):min(maxl,i+TrL);
    mp=find(tri==i);
    if(length(tri)<2) 
        tr=[];
    else
        tr=cs(tri,:);
    end

    % find whether the frame is deemed bad or unsure
    uns=ismember(i,unsure);
    bad=ismember(i,bads);

    % adjust the orientation etc
    figure(2)
    [os(i),cs(i,:),len(i),sk,b,u] = AdjustOrientsExpt2(so(i),cs(i,:),...
        len(i),fr(i),fn,vObj,TStr,tr,uns,mp,bad);
   
    % change the bads set which will be removed depending on whther b=1/0
    if(b==1)
        bads=union(bads,i);
    else
        bads=setdiff(bads,i);
    end
    % change the unsure set depending on whther u=1/0
    if(u==1)
        unsure=union(unsure,i);
    else
        unsure=setdiff(unsure,i);
    end
    % if sk=1 is picked go on to the next criterion
    if(sk==1)
        nx=nx+1;
    else
        if((b==0)&&(u==0))
            ignore=[ignore i];
            setvals=[setvals os(i)];
        end
    end
    
    % save stuff every 5 clicks in case of crashes
    if(mod(count,5)==0)
        ang_e=os;
        Cents=cs;
        len_e=len;
        save(AllN,'ang_e','Cents','len_e','bads','unsure',...
            'ignore','setvals','nx','-append')
    end
    count=count+1;
end
nx=5;