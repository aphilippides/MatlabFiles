function[aRms,Checked]=CheckNestData(aRms,Checked,Cents,EPt,elips,...
    FrameNum,WhichB,fn,vObj,dlim,nest,cmPerPix,fignum)

if(isempty(aRms))
    return;
end

% remove any that have already been checked
toch=[FrameNum(aRms);WhichB(aRms)]';
ism=ismember(toch,Checked(:,1:2),'rows');
% toch=toch(~ism,:);
aRms=aRms(~ism);
if(isempty(aRms))
    return;
end

% next step is to ensure that we don't remove bees over the nest

% get distance to the nest of all bees and find ones within dlim of nest
d2n=CartDist(Cents,nest)*cmPerPix;
rmnear=aRms(d2n(aRms)<dlim)';

% first show all of them and decide whether to check or not
if(~isempty(rmnear))
    % first find how many bees are in the frames of the ones to be removed
    NinFr=NumInFrame(FrameNum,FrameNum(rmnear));
    
    % plot the bees
    figure(fignum)
    nrm=length(rmnear);
    fr=floor(0.5*(FrameNum(rmnear(1))+1));
    f=MyAviRead(fn,fr,vObj);
    imagesc(f);
    % plot all of them in green
    plotb(rmnear,Cents,EPt,[],elips,'g')
    
    % over-plot the ones where there's only one bee in the frame in red
    plotb(rmnear(NinFr==1),Cents,EPt,[],elips,'r')

    hold on;
    MyCircle(nest(1),nest(2),dlim/cmPerPix,'r');
    hold off;
    title([int2str(nrm) ' excluded within ' num2str(dlim,2) 'cm of nest']);
    ylabel('REDS HAVE NO OTHER BEES IN THAT FRAME')
    xlabel('0: delete ALL; 1 keep ALL; 2 check all; 3 remove greens')
    while 1
        [x,y,b]=ginput(1);
        if(isequal(b,48))
            % 0 pressed: delete all
            Checked=[Checked;FrameNum(rmnear)' WhichB(rmnear)' zeros(nrm,1)];
            return;
        elseif(isequal(b,49))
            % 1 pressed: keep all
            aRms=setdiff(aRms,rmnear);
            Checked=[Checked;FrameNum(rmnear)' WhichB(rmnear)' ones(nrm,1)];
            return;
        elseif(isequal(b,50))
            % 2 pressed: check each nest one
            break
        elseif(isequal(b,51))
            % 3 pressed: get rid of single frame ones
            aRms=aRms(NinFr>1);
%             Checked=[Checked;FrameNum(rmnear)' WhichB(rmnear)' (NinFr>1)'];
            return
        end
    end
end

% now check each one that is within 3 cm of nest
% and not already checked
for ind=1:length(rmnear)
    i=rmnear(ind);
    
    % *** the idea with the commented if statement etc
    % below was that if there are other bees
    % at that point in time then they should be removed.
    % this could be added back in but would be best done
    % below where I've written HERE
    
    %     goods=setdiff(1:length(WhichB),aRms);
    %     if(~ismember(FrameNum(i),FrameNum(goods)))
    % show frame
    figure(fignum)
    fr=floor(0.5*(FrameNum(i)+1));
    f=MyAviRead(fn,fr,vObj);
    imagesc(f);
    plotb(i,Cents,EPt,[],elips,'g')
    hold on;
    MyCircle(nest(1),nest(2),dlim/cmPerPix,'r');
    hold off;
    title(['keep frame ' int2str(FrameNum(i)) '?'])
    if(NinFr(ind)>1)
        ylabel([int2str(NinFr(ind)-1) ' other bees in this frame'],'Color','k')
    else
        ylabel('NO OTHER BEES IN THIS FRAME','Color','r')
    end
    while 1
        xlabel('press y if this is a bee, n to remove');
        [x,y,b]=ginput(1);
        if(isequal(b,121))
            % if y is pressed; keep the frame
            % one could remove all other bees that are
            % at this time-frame at this point HERE
            aRms=setdiff(aRms,i);
            Checked=[Checked;FrameNum(i) WhichB(i) 1];
            break;
        elseif(isequal(b,110))
            % if n is pressed; remove the frame
            Checked=[Checked;FrameNum(i) WhichB(i) 0];
            break;
        end
    end
    %     else
    %         Checked=[Checked;FrameNum(i) WhichB(i) 0];
    %     end
end
end

function[NinFr]=NumInFrame(FrameNum,frtocheck)
for i=1:length(frtocheck)
    NinFr(i)=sum(FrameNum==frtocheck(i));
end
end

function plotb(is,c1,e1,e2,ell,col)
if(isempty(is))
    return;
end
bw=75;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=1:length(is)
    plot(ell(is(i)).elips(:,1),ell(is(i)).elips(:,2),col)
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])
hold off
end