function im = getumwelt(obj,i,j,myrot)
if nargin < 3
    myrot = 0;
end

uws = (obj.UmweltSize-1)/2;
im = obj.getimpart((i-uws(1)+1):(i+uws(1)),(j-uws(2)+1):(j+uws(2)));
if myrot ~= 0
    im = imrotate(im,-myrot,'crop');
end
im = imagetocirc(im);