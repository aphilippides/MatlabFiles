function[s1Line,s1Low,s1LowT,s1Ex,s1High]=IfMin(j,s,len,s1Line,s1Low,s1LowT,s1Ex,s1High,d)
if(d(1)<d(2))
    if((s<=s1Low)&(s1High(2)~=-1e9))
        s1Low=s;
        s1LowT=j;
        gr=(s1Low-s1High(2))/(j-s1High(1));
        [s1Ex,s1ExT]=GetDiagonalPt(gr,len,s1Low,j);
        s1Line=[s1High;j,s1Low;s1ExT,s1Ex];
    end
elseif(s>=s1High(2))
    s1High=[j s];
end