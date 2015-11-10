function [mlat,mlong] = gps2merc(lat,long)
mlat = 0.5-log(tan(pi/4+circ_ang2rad(lat)/2))/(2*pi);
if nargin == 2
    mlong = 0.5+long./360;
end