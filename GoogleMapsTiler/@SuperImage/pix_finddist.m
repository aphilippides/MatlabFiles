function d = pix_finddist(obj,i1,j1,i2,j2)
[lat1,long1] = obj.pix2gps(i1,j1);
[lat2,long2] = obj.pix2gps(i2,j2);

d = gps_finddist(lat1,long1,lat2,long2);