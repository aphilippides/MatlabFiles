function[spa] = ExtractSpikes(a,as,da)
% spa=a<(as-da);  % crude version with all spikes
if(isempty(a))
    spa=[];
    return;
end
    
d=as-da;
ov=a>d;
s=diff(ov);
spa=find(s==-1)';
if(isempty(spa))
    spa=[];
else
    spa=spa+1;
end