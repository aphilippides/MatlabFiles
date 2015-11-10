function[y,x]=AngHist(t,c,NoWrap,plotting)
if((nargin<2)|isempty(c)) c=0:10:360; end
if(nargin<4) plotting=1; end;
[y,x]=hist(mod(t,360),c);
if((x(1)==0)&(x(end)==360))
    y(1)=y(1)+y(end);
    y=y(1:end-1);    
    x=x(1:end-1);
end
if((nargin<3)||isempty(NoWrap)||(~NoWrap))
    es=find(x>180);
    x(es)=x(es)-360;
    [x,is]=sort(x);
    y=y(is);
end
if(plotting)
    bar(x,y);
    axis tight
end