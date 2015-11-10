% l1line.p1 = [t, l1, sell] is highest value of current active line
% l1line.p2 = [t, l1] is p2 value of current active line
% l1line.low = [t, l1] is low value between current active line
% l1line.gr = [t, l1] is gradient of current active line
% l1line.**new is same as above but NOT yet activated
% l1line.currlow = [t l1] is the current low point. Constantly updated

function[l1line,Reset]=L1Line(l1,i,l1line,TLim,sell)
Reset=0;
if(l1>=l1line.p1new(2)) % new high p1
    l1line.p1new=[i l1 sell];
    l1line.p2new=[i l1];
    l1line.lownew=[i l1];
    l1line.currlow=[i l1];
    l1line.grnew=-1e9;
else
    % update low pt if new low after p1new 
    if(l1<=l1line.currlow(2)) 
        l1line.currlow=[i l1]; 
    end;    
    % calc time difference since last p1
    td=i-l1line.p1new(1);
    if(td>TLim)
        gr=(l1-l1line.p1new(2))/td;
        % new low gradient
        if(gr>=l1line.grnew)
            l1line.p2new=[i l1];
            l1line.grnew=gr;
            l1line.lownew=l1line.currlow;
        end;
        % Check if new p1p2 is activated
        if(l1<=l1line.lownew(2))
            l1line.p1=l1line.p1new;
            l1line.p2=l1line.p2new;
            l1line.low=l1line.lownew;
            l1line.gr=l1line.grnew;
            Reset=1;
        end;
    end
end