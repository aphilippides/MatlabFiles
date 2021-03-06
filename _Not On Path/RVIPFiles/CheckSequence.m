function[MaxS,counts,bad] = CheckSequence(a)

old=-1;
count=1;
for i=1:length(a)
    new=OddEven(a(i));
    if(new==0)
        count=1;
    elseif(new==old)
        count=count+1;
    else
        count=1;
    end
    counts(i)=count;
    old=new;
end
bad=0;
for i=2:length(a)
    if(a(i)==a(i-1)) 
        bad=bad+1;
    end
end

MaxS=max(counts);