function [newlat,newlong] = rad2gps(lat,long)
newlat = mod(circ_rad2ang(lat),360);
newlat(newlat>180) = newlat(newlat>180)-180;
newlat(newlat>90) = newlat(newlat>90)-180;

newlong = mod(circ_rad2ang(long),360);
newlong(newlong>180) = newlong(newlong>180)-360;
