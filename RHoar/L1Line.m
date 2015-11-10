function[l1linenew,Reset]=L1Line(l1,i,l1lineold,Reset,TLim)
if(nargin<5) TLim=0; end;
l1p1=l1lineold(1,:);
l1p2=l1lineold(2,:);
l1low=l1lineold(3,[1 2]);
l1p2low=l1lineold(4,[1 2]);
% not needed to read in: for reference l1ex=l1lineold(3,3);
% l1 line p1 to p2
if(l1>=l1p1(2)) % new high p1
    l1p1=[i l1 0];
    l1p2=[i l1 -1e9];
    l1low=[i l1];
    l1p2low=l1low;
    l1ex=-1e9;
    Reset=1;
else
    % new low after p1
    if(l1<=l1low(2)) l1low=[i l1]; end;
    td=i-l1p1(1);
    if(td>TLim)
        gr=(l1-l1p1(2))/(i-l1p1(1));
        % new low gradient
        if(gr>=l1p2(3))
            l1p2=[i l1 gr];
            l1p2low=l1low;
        end;
        % if past old low, update the gradient
        if(l1<=l1p2low(2))
            Reset=1;
            l1p1(3)=l1p2(3);
        end;
    end
    l1ex=l1p1(2)+l1p1(3)*td;
end
l1linenew=[l1p1;l1p2;l1low l1ex;l1p2low 0];