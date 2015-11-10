function CheckModality(mu,k,n,ra)
% mu=3;k=1;n=1000;
s=vsamp(mu,k,n);
[y,x]=hist(s,50);
plot(x,2*pi*y/n,x,VonMises(x,mu,k),'r')
r=rand(1,2)*2*ra-ra;
[out,s] = mle(s,'pdf',@VonMises,'start',[mu,k]+r)

function s=vsamp(mu,k,n)
s=[];
while length(s)~=n
    % random number between 0 and 2*pi
    x=rand(1)*2*pi;
    % p=probability of accepting x
    p=VonMises(x, mu, k);
    if p>rand(1)
        s=[s,x];
    end
end
