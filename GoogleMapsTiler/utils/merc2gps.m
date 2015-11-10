function [lat,long] = merc2gps(mlat,mlong)
lat = circ_rad2ang(2.*atan(exp(pi.*(1-2.*mlat))))-90;
if nargin == 2
    long = 360.*(mlong-0.5);
end