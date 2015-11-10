function d=gps_finddist(lat1,long1,lat2,long2)
% function d=gps_dist(lat1,long1,lat2,long2)
% 
% Returns distance between two points on Earth, in metres.
% Requires circular statistics toolbox.

r_earth = 6.371e6; % mean radius of Earth (m)

lat1=circ_ang2rad(lat1);   lat2=circ_ang2rad(lat2);
long1=circ_ang2rad(long1); long2=circ_ang2rad(long2);

a = sin(circ_dist(lat1,lat2)./2).^2 ...
       + cos(lat1).*cos(lat2).*sin(circ_dist(long1,long2)./2).^2;
d = 2.*r_earth.*atan2(sqrt(a),sqrt(1-a));
