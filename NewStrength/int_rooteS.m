% function which gives the integral from 0 to eta of 
% (Conc_0/r)*sqrt(Dt/PI)*exp(-b/t) with respect to t

function[integ] = int_rooteS(eta,b,r)

global DIFF;
global STRENGTH_VOLSEC



integ = (STRENGTH_VOLSEC.*2.*sqrt(DIFF./pi)./(3.*r)).*((exp(-b./eta).*(eta-2.*b).*sqrt(eta)) + 2.*erfc((sqrt(b./eta))).*(sqrt(pi.*(b.^3))));
