% l2line.p1 = [t, l2, buy] is highest value of current active line
% l2line.p2 = [t, l2] is p2 value of current active line
% l2line.high = [t, l2] is low value between current active line
% l2line.gr = [t, l2] is gradient of current active line
% l2line.**new is same as above but NOT yet activated
% l2line.currhigh = [t l2] is the current low point. Constantly updated

function[l2line,Reset]=L2LineNew(l2,i,l2line,TLim,buy)
Reset=0;
if(l2<=l2line.p1new(2)) % new high p1
    l2line.p1new=[i l2 buy];
    l2line.p2new=[i l2];
    l2line.highnew=[i l2];
    l2line.currhigh=[i l2];
    l2line.grnew=1e9;
else
    % update low pt if new low after p1new 
    if(l2>=l2line.currhigh(2)) 
        l2line.currhigh=[i l2]; 
    end;    
    % calc time difference since last p1
    td=i-l2line.p1new(1);
    if(td>TLim)
        gr=(l2-l2line.p1new(2))/td;
        % new low gradient
        if(gr<=l2line.grnew)
            l2line.p2new=[i l2];
            l2line.grnew=gr;
            l2line.highnew=l2line.currhigh;
        end;
        % Check if new p1p2 is activated
        if(l2>=l2line.highnew(2))
            l2line.p1=l2line.p1new;
            l2line.p2=l2line.p2new;
            l2line.high=l2line.highnew;
            l2line.gr=l2line.grnew;
            Reset=1;
        end;
    end
end