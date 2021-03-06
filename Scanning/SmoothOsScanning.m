function[os,cs,len,bads,unsure,ignore]=SmoothOsScanning(os,t,cs,len,fn,...
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
TrL=5;
maxl=length(os);

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
    if(isempty(NotDone)) break; end;
    
    dtravelled=CartDist(diff(cs([1 1:end],:)))./[1;diff(frames')];
    % find the index of the one most different from the smoothed value
    
    if(nx==0)
        e=dtravelled(NotDone);
        [m,ind]=max(e);
        TStr=['Dist ' num2str(m,3) '/' num2str(median(dtravelled),3)];
    elseif(nx==1)
        e=areas(NotDone);
        [m,ind]=max(e);
        TStr=['Area ' num2str(m,3) '/' num2str(median(areas),3)];
    elseif(nx==2)
        e=eccent(NotDone);
        [m,ind]=min(e);
        TStr=['Eccent ' num2str(m,3)];
    elseif(nx==3)
        e=areas(NotDone);
        [m,ind]=min(e);
        TStr=['Area ' num2str(m,3) '/' num2str(median(areas),3)];
    elseif(nx==4)
        e=abs(AngularDifference(o(NotDone),so(NotDone)));
        [m,ind]=max(e);
        TStr=['Error ' num2str(m*180/pi,3)];
    else break;
    end
    i=NotDone(ind);

    if(Printing)
        figure(1), 
        plot(t,o*180/pi,'r',t,AngleWithoutFlip(so)*180/pi,'b:',...
            t(ignore),o(ignore)*180/pi,'ko',t(unsure),o(unsure)*180/pi,'ro')
        hold on
        plot(t(i),o(i)*180/pi,'gs','MarkerFaceColor','g')
        hold off 
        axis tight
        if(opt)
            figure(3);
            plot(cs(:,1),cs(:,2),'b.-',cs(ind,1),cs(ind,2),'go'),
            axis equal
            set(gca,'YDir','reverse');
        end            
        figure(2); 
        plot(t(NotDone),e,t(i),e(ind),'go'),
    end
    
    tri=max(1,i-TrL):min(maxl,i+TrL);
    if(length(tri)<2) tr=[];
    else tr=cs(tri,:);
    end;

    [os(i),cs(i,:),len(i),b,u] = ...
        AdjustOrientsScanning(so(i),cs(i,:),len(i),frames(i),fn,TStr,tr);
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