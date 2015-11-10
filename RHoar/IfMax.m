function[s2Line,s2Low,s2Ex,s2High,s2HighT]=IfMax(j,s,len,s2Line,s2Low,s2Ex,s2High,s2HighT,d)
if(d(1)>=d(2))
    if((s>=s2High)&(s2Low(2)~=1e9))
        s2High=s;
        s2HighT=j;
        gr=(s2High-s2Low(2))/(j-s2Low(1));
        [s2Ex,s2ExT]=GetDiagonalPt(gr,len,s2High,j);
        s2Line=[s2Low;j,s2High;s2ExT,s2Ex];
    end
elseif(s<=s2Low(2))
    s2Low=[j s];
end;