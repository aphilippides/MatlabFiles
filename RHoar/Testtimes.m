% function Testtimes
% load temp
p=1000;
t=zeros(1,p);
x=ones(1,1000);
% plot(x,x)
% hold on
for i=1:p
%     [a,b]=PredictPoints(1:500,1:500,20,0.1);
    n=i+1000;
    x(n)=i;
    is=i:n;
    plot(x(is),x(is));
%     ylim([i i+500])
%     plot(x(n-1:n),x(n-1:n));
    axis([i n i i+500])
    drawnow
    t(i)=GetSecs;
end
hold off
plot(diff(t(1:p)))
% keyboard