function [i,j] = gps2pix(obj,lat,long)
[mlat,mlong] = gps2merc(lat,long);
[i,j] = obj.merc2pix(mlat,mlong);