function [lat,long] = gps_adddist(lat,long,dnorth,deast)
r_earth = 6.371e6;
[lat,long] = gps2rad(lat,long);
lat = lat + dnorth / r_earth;

[lat,long] = rad2gps(lat, long + deast./(r_earth.*cos(lat)));