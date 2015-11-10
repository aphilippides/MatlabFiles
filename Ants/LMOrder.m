function[lmo]=LMOrder(LMs)
nlm=size(LMs,1);
if(nlm==1) lmo=1;
elseif(nlm==2)
    if(LMs(1,2)<LMs(2,2)) lmo=[1 2];
    else lmo=[2 1];
    end
else
    m=mean(LMs);
    th=cart2pol(LMs(:,1)-m(1),LMs(:,2)-m(2))*180/pi;
    [d is]=sort(th);
    lmo=is;
%     for i=1:4 lmo(i)=find(is==i); end;
end