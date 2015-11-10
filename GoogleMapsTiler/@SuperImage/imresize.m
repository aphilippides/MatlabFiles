function bigim = imresize(obj,scale)
if length(scale)==1
    scale = scale * obj.pix;
else
    if isnan(scale(1))
        scale(1) = round(scale(2)*obj.pix(1)/obj.pix(2));
    end
    if isnan(scale(2))
        scale(2) = round(scale(1)*obj.pix(2)/obj.pix(1));
    end
end
imscale = round(obj.ImPix .* scale ./ obj.pix);
imendscale = round(mod(obj.pix,obj.ImPix) .* scale ./obj.pix);
if imendscale(1)==0
    imendscale(1) = imscale(1);
end
if imendscale(2)==0
    imendscale(2) = imscale(2);
end
scale = imscale .* (obj.Units-1) + imendscale;

bigim = zeros([scale 3-2*obj.Grayscale],'uint8');
dd = gm_datadir;
imsize = [imscale(1) NaN];
for i = 1:obj.Units(1)
    if i==obj.Units(1)
        imsize(1) = imendscale(1);
    end
    starti = (i-1)*imscale(1);
    ind1 = (starti+1):(starti+imsize(1));
    
    imsize(2) = imscale(2);
    for j = 1:obj.Units(2)
        if j==obj.Units(2)
            imsize(2) = imendscale(2);
        end
        startj = (j-1)*imscale(2);
        ind2 = (startj+1):(startj+imsize(2));
        
        fname = sprintf('%s/%s_%04d,%04d',dd,obj.DataLabel,i,j);
        %fprintf('Loading from %s...\n',fname);
        load(fname,'im');
        bigim(ind1,ind2,:) = imresize(im,imsize);
    end
end