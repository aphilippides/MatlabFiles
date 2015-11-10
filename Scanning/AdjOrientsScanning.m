function[sOr,bads,Cents] = AdjOrientsScanning(sOr,Cents,FrameNum,fn,bads,len,alln)
% Get the correct frames from Framenum
% Look at the offending data 
% Flip any that are necessary via return to flip, 
% anything else to skip eg
if(nargin<5) bads=[]; end;
if(nargin<6) len=10*ones(size(sOr)); end;
TrL=5;
maxl=length(sOr);
while 1
    a=AngleWithoutFlip(sOr)*180/pi;
    plot(FrameNum,a,'b-',FrameNum(bads),a(bads),'ks')
    grid on;
    inp=input('enter frames to flip; -1 to end; -2 to run CleanOrients\n');
    if(~isempty(inp))
        if(inp==-1) break;
        elseif(inp==-2) sOr=CleanOrients(sOr);
        else
            for k=inp
                i=find(FrameNum==k);
                if(~isempty(i))
                    if(ismember(i,bads)) uns=1;
                    else uns=0;
                    end
                    tri=max(1,i-TrL):min(maxl,i+TrL);
                    if(length(tri)<2) tr=[]; 
                    else tr=Cents(tri,:);
                    end;
                    [sOr(i),Cents(i,:),len(i),b,u] = ...
                        AdjustOrientsScanning(sOr(i),Cents(i,:),len(i),FrameNum(i),fn,[],tr,uns);
                    if(~isempty(b)) bads=[bads i]; end;
                    if(~isempty(u)) bads=[bads i]; end;
                end
            end
        end
        unsure=bads;
        save(alln,'sOr','unsure','-append')
    end
end
bads=unique(bads);
