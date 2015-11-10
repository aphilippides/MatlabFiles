% function[is]=GetTimes(t,Ts)
%
% function which returns indices of the time in t that are between the
% elements of each row of Ts. If Ts is a column vector, it returns the
% indices of the times which most closely match each element
 
function[is]=GetTimes(t,Ts)
is=[];
if(size(Ts,2)==2)
    for i=1:size(Ts,1)
        si=find(t>=Ts(i,1),1);
        ei=find(t<Ts(i,2),1,'last');
%         [m,si]=min(abs(t-Ts(i,1)));
%         [m,ei]=min(abs(t-Ts(i,2)));
        if(isempty(si)|isempty(ei)) is=[];
        else is=[is si(1):ei(end)];
        end
    end
else
    for i=1:size(Ts,1)
        [m,si]=min(abs(t-Ts(i)));
        is=[is si];
    end
end