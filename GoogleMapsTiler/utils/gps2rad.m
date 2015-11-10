function [lat,long] = gps2rad(lat,long)
lat = circ_ang2rad(lat);
long = circ_ang2rad(long);