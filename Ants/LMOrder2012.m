function[lmo,LMs]=LMOrder2012(LMs)
nlm=size(LMs,1);
if(nlm==1) 
    lmo=1;
elseif(nlm==2)
    % sort the LMs so that the first one is at the top
    if(LMs(1,2)<LMs(2,2)) 
        lmo=[1 2];
    else 
        lmo=[2 1];
    end
else
    % old version based on compass directions
    %     m=mean(LMs);
%     th=cart2pol(LMs(:,1)-m(1),LMs(:,2)-m(2))*180/pi;
%     [d is]=sort(th);

    % sort the LMs so that the first one is at the top
    [d,lmo]=sort(LMs(:,2));
end
LMs=LMs(lmo,:);