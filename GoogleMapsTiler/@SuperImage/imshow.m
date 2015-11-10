function imshow(obj)
set(0,'units','pixels');
res = get(0,'ScreenSize');
maxsize = round(0.8 * res(3:4)); % 80% of screen
if any(obj.pix > maxsize)
    disp('Resizing superimage...')
    newsize = [NaN NaN];
    if obj.pix(1)-maxsize(1) > obj.pix(2)-maxsize(2)
        newsize(1) = maxsize(1);
    else
        newsize(2) = maxsize(2);
    end
    im = imresize(obj,newsize);
else
    im = obj.getimpart(1:obj.pix(1),1:obj.pix(2));
end

imshow(im);