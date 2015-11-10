function[s,f] = SmoothVision(o)

f(1,:)=o(1,:);
for i=2:size(o,1) 
    f(i,:)=FillHoles(f(i-1,:),o(i,:));
end
s(1,:)=DeNoiseRow1(f(1,:));
for i=2:size(o,1) 
    s(i,:)=DeNoise(s(i-1,:),f(i,:));
end

function[o]=DeNoiseRow1(os)
o=os;
os=[os(end) os os(1)];
for i=2:length(os)-1
    if((os(i-1)==0)&(os(i+1)==0))
        o(i-1)=0; 
    end
end

function[o]=DeNoise(out,os)
o=os;
os=[os(end) os os(1)];
out=[out(end) out out(1)];
for i=2:length(os)-1
    if((os(i-1)==0)&(os(i+1)==0))
        if(out(i)==0) 
        o(i-1)=0; 
        end
    end
end

function[new] = CheckConnected(out,actual,k,n)
if(k<=n) 
    new=zeros(size(out));
    return;
end
is=find(out~=actual(k,:));
new=actual(k,:);
for i=is
    if(actual(k,i))
        if(~isequal(actual(k-n:k-1,i),ones(n,1))) 
            new(i)=0;
        end
    else
        if(~isequal(actual(k-n:k-1,i),zeros(n,1))) 
            new(i)=1;
        end
    end
end

function[o]=FillHoles(out,os)
is=find((out~=os)&(os==0))+1;
o=os;
os=[os(end) os os(1)];
for i=is
    if(os(i-1)&os(i+1)) o(i-1)=1; end
end


function[o]=FillHolesAndClean(os)
os=[os(end) os os(1)];
for i=2:length(os)-1
%     if(os(i-1)==os(i+1)) o(i-1)=os(i); end;
    if(os(i-1)==os(i+1)) os(i)=os(i-1); end;
end
o=os(2:end-1);