function [lat,long] = pix2gps(obj,i,j)
[mlat,mlong] = obj.pix2merc(i,j);
[lat,long] = merc2gps(mlat,mlong);