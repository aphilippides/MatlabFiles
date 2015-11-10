% Function which calculates the concentration at a distance r from a
% ring of radius 'radius' source of NO at a time t after an instantaneous burst

function [concient] = InstRing(radius,r, t)

global RING_CONST;
global DIFF;
global LAM;
%GLOBE;

const1 = radius.*r./(2.*DIFF.*t);
concient=RING_CONST.*((exp(-(r.^2+radius.^2)./(4.*DIFF.*t) - LAM.*t)).*radius./t).*besseli(0,const1);




