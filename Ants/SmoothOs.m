function[os,t,so,bads]=SmoothOs(os,t,ReplaceWithMean,cs,fn,sm_len,o_thresh)
flip=0;
if(nargin<6) sm_len=5; end;
if(nargin<7) o_thresh=0.175; end;
% if(nargin<7) o_thresh=0.35; end;
if(nargin<3) ReplaceWithMean=0; end;
if(size(os,1)>size(os,2)) os =os'; end;
Printing=1;
ignore=[];
setvals=[];
bads=[];
origt=t;
while(1)
    %os=CleanOrients(os,flip);
    goodis=setdiff(1:length(os),bads);
    o=AngleWithoutFlip(os);
    so=os;
%    so(bads)=0;
%    so=SmoothVec(o,sm_len,'replicate');
    so(goodis)=TimeSmooth(o(goodis),t(goodis),sm_len);
    so(ignore)=setvals;
    NotDone=setdiff(1:length(os),[ignore bads]);
    e=abs(AngularDifference(o(NotDone),so(NotDone)));
    [m,ind]=max(e);
    i=NotDone(ind);
    if(Printing)
    figure(1), plot(t,o,'r-x',t(i),o(i),'go',t,AngleWithoutFlip(so),t(ignore),o(ignore),'ks',t(bads),o(bads),'c*')
    figure(2); plot(t(NotDone),e,t(i),e(ind),'go')
    end
    if(m>=o_thresh)
        if(ReplaceWithMean) 
            [os(i),badf,badpt] = AdjustOrients(os(i),cs(i,:),round(t(i)/0.02),fn);
            if(isempty(badpt))
                ignore=[ignore i];
                setvals=[setvals os(i)];
            else bads=[bads i];
%                  os(i)=so(i);
%                 is=[1:i-1, i+1:length(os)];
%                 os=os(is);
%                 t=t(is);
%                 cs=cs(is,:);
            end
        else
            os(i)=so(i);
%            is=[is i];
%             is=[1:i-1, i+1:length(os)];
%             os=os(is);
%             t=t(is);
        end
    else break;
    end
end
goodis=setdiff(1:length(os),bads);
so=so(goodis);