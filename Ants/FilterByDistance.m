% this function filters the data by distance
% it takes DToNest - the distance to the nest (or any point of interest
% and dLim, a 2 element vector dLim which specifies the inner and outer 
% radii of a ring of distances from the nest/point of interest
%
% eg if dLim=[3 6] this function returns the data from the 1st time the bee
% is over 3 cm, then the first time it goes over 6 cm after that
%
% if dLim = [0 9] this gets all the data (for a learning flight) from
% leaving the nest (as *every* distance is greater than 0) to when it
% crosses 9cm
%
% to get all the data do eg dLim=[0 1000]
% 
% The main output is a vector of the indices of the data in this ring
%
% Note this does not return *all* the data that is within these spatial
% limits. It instead looks at the continuous trajectory from when the bee
% first crosses the first distance limit to when it exits the second. If
% you wanted to get all the data between distance limits you would do:
%
% is = find((DToNest>=dLim(1))&(DToNest<dLim(2)));
% TODO: Check this
%
% % NOT NEEDED FOR GENERAL PURPOSE
%
% it also takes t, the time, as I was using this function to get the time
% the bee was spending within each ring. Because of this the second element
% it returns is l, the length of time the bee spends in this ring. However,
% you don't need to use this part
% 
% TO DO: this only works for outward flights. I will reverse it for inward
% ones
function[is,l]=FilterByDistance(DToNest,dLim,t)
% set up dummy output variable
l=NaN;

if(isempty(dLim))
    is=1:length(DToNest);
    return;
else
% find the first index when the bee first goes over the 1st element of dLim  
i1=find(DToNest>=dLim(1),1);

if(isempty(i1))
    % if there is no data which crosses the first distance 
    % point return an empty vector
    is=[];
else
    % if there is some data which crosses the inner ring, find the first
    % point after that which crosses the outer ring
    i2=find(DToNest>dLim(2),1);
    if(isempty(i2))
        % if no point crosses the outer ring return all the remaining data
        is=i1:length(DToNest);
    else
        % otherwise return all the data up to the point before the crossing
        is=i1:(i2-1);
    end
end
end

% if a 3rd argument has been entered find the distance between
% this and a second one
if((nargin>2)&&(~isempty(is)))
    l=t(is(end))-t(is(1));
end
