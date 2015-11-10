function [mlat,mlong] = pix2merc(obj,i,j)
[mtoplat,mleftlong] = gps2merc(obj.TopLatitude,obj.LeftLongitude);
mercperpix = 1.25*2^(1-obj.Zoom)/640;

mlat  = mtoplat   + i*mercperpix;
mlong = mleftlong + j*mercperpix;