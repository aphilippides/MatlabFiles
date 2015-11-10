function[s]=TimeSecs(t)
if(ischar(t(1)))
    for i=1:size(t,1) 
        Ts(i,:)=sscanf(t(i,:),'%d:%d:%d')'; 
    end
    t=Ts;
end
s=t*[3600 60 1]';