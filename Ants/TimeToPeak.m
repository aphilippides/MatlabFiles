function[ts]=TimeToPeak(tl,Arcs)
if(length(Arcs)<2) ts=[]
else
    ts=[];
    for i=1:length(tl)
        d=tl(i)-Arcs;
        [m,j]=min(abs(d));
        ts(i)=d(j);
    end
end