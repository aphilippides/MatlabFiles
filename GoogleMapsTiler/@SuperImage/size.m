function sz=size(obj,wh)
if obj.Grayscale
    sz = obj.pix;
else
    sz = [obj.pix 3];
end
if nargin == 2
    if wh <= length(sz)
        sz = sz(wh);
    else
        sz = 1;
    end
end