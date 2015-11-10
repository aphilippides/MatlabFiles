function[l2linenew,Reset]=L2Line(l2,i,l2lineold,Reset,TLim)
if(nargin<5) TLim=0; end;
l2p1=l2lineold(1,:);
l2p2=l2lineold(2,:);
l2high=l2lineold(3,[1 2]);
l2p2high=l2lineold(4,[1 2]);
% not needed to read in: for reference l2ex12=l2lineold(3,3);
% l2 line p1 to p2
if(l2<=l2p1(2)) % new low p1
    l2p1=[i l2 0];
    l2p2=[i l2 1e9];
    l2high=[i l2];
    l2p2high=l2high;
    l2ex12=-1e9;
    Reset=1;
else
    % new high after p1
    if(l2>=l2high(2)) l2high=[i l2]; end;
    td=i-l2p1(1);
    if(td>TLim)
        grp12=(l2-l2p1(2))/(i-l2p1(1));
        % new low gradient
        if(grp12<=l2p2(3))
            l2p2=[i l2 grp12];
            l2p2high=l2high;
        end;
        % if past old high, update the gradient
        if(l2>=l2p2high(2))
            Reset=1;
            l2p1(3)=l2p2(3);
        end;
    end
    l2ex12=l2p1(2)+l2p1(3)*td;
end
l2linenew=[l2p1;l2p2;l2high l2ex12;l2p2high 0];