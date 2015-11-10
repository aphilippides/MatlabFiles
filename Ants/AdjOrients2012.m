function[ang_e,unsure,Cents,len_e,bads]=AdjOrients2012(ang_e,Cents,FrameNum,fn,...
    unsure,len_e,vObj,bads,so,AllN)
% Get the correct frames from Framenum
% Look at the offending data
% Flip any that are necessary via return to flip,
% anything else to skip eg
if(nargin<5);    unsure=[]; end;
if(nargin<6); len_e=10*ones(size(ang_e)); end;
TrL=2;
maxl=length(ang_e);
so=AngleWithoutFlip(so)*180/pi;
while 1
    a=AngleWithoutFlip(ang_e)*180/pi;
    figure(1)
    plot(FrameNum,a,'b',FrameNum(unsure),a(unsure),'ro',FrameNum(bads),a(bads),'k*')
    axis tight
    grid on;
    inp_s=input('enter frames to flip; -1 to end; -2 run CleanOrients: ','s');
    inp=str2num(inp_s);
    if(isequal(inp,-1))
        break;
    elseif(inp==-2)
        ang_e=CleanOrients(ang_e);
    else
        for k=inp
            i=find(FrameNum==k);
            if(~isempty(i))
                u=ismember(i,unsure);
                b=ismember(i,bads);
                tri=max(1,i-TrL):min(maxl,i+TrL);
                mp=find(tri==i);
                if(length(tri)<2) 
                    tr=[];
                else
                    tr=Cents(tri,:);
                end;
                figure(1)
                plot(FrameNum,a,'b',FrameNum(unsure),a(unsure),'ro',...
                    FrameNum(bads),a(bads),'k*',FrameNum,so,'r:')
                axis tight
                grid on;
                figure(2)
                [ang_e(i),Cents(i,:),len_e(i),s,b,u]=AdjustOrientsExpt2(ang_e(i),...
                    Cents(i,:),len_e(i),FrameNum(i),fn,vObj,[],tr,u,mp,b);
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
            end
        end
        save(AllN,'ang_e','Cents','len_e','bads','unsure','-append')
    end
end