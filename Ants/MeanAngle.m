% function[mTh,mR] = MeanAngle(x,y)
% function which returns the mean angle of x (if y undefined) or of the
% vectors (x,y) if y is defined

% Second bit not working at the moment

function[mTh,mR] = MeanAngle(x,y)

if(nargin<2)
    y=sin(x);
    x=cos(x);
    [mTh,mR] = cart2pol(mean(mean(x)),mean(mean(y)));
end
