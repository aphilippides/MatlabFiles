function[newos,cs,os,oldcs,len,bads,unsure,ignore]=SmoothOsScanningHandSkip(os,t,cs,len,fn,...
    sm_len,eccent,areas,frames,opt)%o_thresh,ReplaceWithMean)
flip=0;
if(nargin<6) sm_len=0.1; end;
if(nargin<10) opt=0; end;
% if(nargin<7) o_thresh=0.175; end;
% if(nargin<8) ReplaceWithMean=0; end;
if(size(os,1)>size(os,2)) os =os'; end;
Printing=1;
ignore=[];
setvals=[];
unsure=[];
bads=[];
if(opt==1) 
    nx=0;
else
    nx=1;
end

% # of points to smooth backwards
TrL=5;
% # of points to smooth forwards
TrH=5;
maxl=length(os);

sk=3;
newos=os;
angd=0;
% while(i<=maxl)
smo=TimeSmooth(AngleWithoutFlip(os),t,sm_len);
oldcs=cs;
for i=1:sk:maxl
    
    % set index of first value
    oldi=max(1,i-1);
    
    % Smooth the orientation values
    goodis=setdiff(1:sk:length(os),bads);
    o=AngleWithoutFlip([newos(1:i-1) os(i:end)+angd]);
    so=o;
    so(goodis)=TimeSmooth(o(goodis),t(goodis),sm_len);
    
%     cc=[cs(:,1)+dv(1) cs(:,2)+dv(2)];
%     cc(1:i-1,:)=newcs(1:i-1,:);
    sc(:,1)=TimeSmooth(cs(:,1),t,sm_len)';
    sc(:,2)=TimeSmooth(cs(:,2),t,sm_len)';
    
%     % set the smoothed values to sure ones already adjusted
%     % NB this is currently from old stuff and so unused
%     so(ignore)=setvals;

    % set the indices to get predicted movement from
    tri=max(1,i-TrL):min(maxl,i+TrH);
    % remove bad ones (currently not used)
    tri=setdiff(tri,bads);
%     
%     if(length(tri)>=3)
%         % robust fit a line to the trace
%         ctr=cs(tri,:);
%         brob = robustfit(ctr(:,1),ctr(:,2));
%         % get (rough) start/end positions on line + vector between them
%         xtr=ctr([1 end],1);
%         ytr=brob(1)+brob(2)*xtr;
%         s=diff([xtr ytr]);
%     elseif(length(tri)==2)
%         % if only 2 values just get vector between them 
%         s=diff(cs(tri,:));
%     end
%     % if enough values get a predicted movement which is the vector
%     % between the projection of the current and previous centroids 
%     % onto the fitted line 
%     if(length(tri)>=2)
%         newp=(cs(i,:)*s'/(s*s'))*s;
%         oldp=(cs(oldi,:)*s'/(s*s'))*s;
%         predm=newp-oldp;
%         
%         % predict the new position
%         newcs(i,:)=newcs(oldi,:)+predm;
%     end
    
    % get time between points either side
%     n1=max(1,i-1);
%     n2=min(maxl,i+1);
%     ta=t(n2)-t(n1);
%     td=t(i)-t(n1);
%     xd=cs(n1,1)+vec*td/ta

    if(length(tri)<2) tr=[];
    else tr=cs(tri,:);
    end;

    TStr=['Frame ' int2str(i) '/' int2str(length(os))];
    
    [newos(i),cs(i,:),len(i),b,u] = ...
        AdjustOrientsScanning(so(i),sc(i,:),len(i),frames(i),fn,TStr,tr);

    % get the change in data bet current/previous centroids/orientations
    % and update the old auto-generated ones
    angd=AngularDifference(newos(i),smo(i));
    % fill in any gaps
    if(i>1)
        inds=i-sk+1:i-1;
        of=AngleWithoutFlip(newos([i-sk i]));
        newos(inds)=mod(interp1(t([i-sk i]),of,t(inds)),2*pi);
    end
    if(~isempty(b))
        if(b<0) nx=nx+1;
            %                 else bads=[bads i];
        else unsure=[unsure i];
        end
    else
        if(~isempty(u)) unsure=[unsure i];
        else
            setvals=[setvals os(i)];
            ignore=[ignore i];
        end;
    end
end
o=AngleWithoutFlip([newos(1:i) os(i+1:end)+angd]);
so=TimeSmooth(o,t,sm_len);
newos(i+1:end)=so(i+1:end);