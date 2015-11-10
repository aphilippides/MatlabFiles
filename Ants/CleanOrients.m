% function[newos] = CleanOrients(os,flip,t)
%
% this function goes through a set of orientations and checks whether the
% next angle should be flipped thru 180 degrees or not to deal with the
% ambiguity of not knowing which end of the ellipse is being captured
% the input parameters are os which hold the orientations and then there
% are 2 optional parameters. 
% flip is a binary variable with a default value of 0
% If it is 1, then we flip the 1st orientation thru 180 degrees. 
%
% t holds the threshold for the difference between consecutive orientations
% above which the angle is flipped. The default is pi/2 and this works
%
% The standard call will therfore be: newos=CleanOrients(os);

function[newos] = CleanOrients(os,flip,t)
if(nargin<3) t=pi/2; end;
if(nargin<2) flip=0; end;

newos=os;
% NB function could be optimised but this for clarity
% Also need a flip eg
if(flip)
    if(os(1)<0) newos(1) = os(1)+pi;
    else newos(1) = os(1)-pi;
    end
end

for j=2:length(os)
%     d=abs(os(j)-newos(j-1));
%     if(d>pi) 
%         d=2*pi - d; 
%     end;
    d=abs(AngularDifference(os(j),newos(j-1)));
    if(d>=t)
        if(os(j)<0) newos(j) = os(j)+pi;
        else newos(j) = os(j)-pi;
        end
    end
%     plot(os), hold on; plot(newos,'r'), hold off
end
