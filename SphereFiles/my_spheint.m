% Function to do integral of problematic bit ofsolid sphere i.e from 0 to t

function[sphein] = my_spheint(t,r,a)


global DIFF;
global LAM;
global STRENGTH_VOLSEC;
 
GLOBE;

b1 = ((r-a).^2)./(4.*DIFF);
b2 = ((r+a).^2)./(4.*DIFF);

erf_bit = quad8('test1',eps*1e-30,t,[],[],r, a);

sphein=erf_bit-0.5.*(1+exp(-LAM.*t)).*(int_roote(t,b1,r)-int_roote(t,b2,r));

% function which gives the integral from 0 to eta of 
% (Conc_0/r)*sqrt(Dt/PI)*exp(-b/t) with respect to t
function[integ] = int_roote(eta,b,r)

global DIFF;
global STRENGTH_VOLSEC

if(r==0) r=eps; end;
integ = (STRENGTH_VOLSEC.*2.*sqrt(DIFF./pi)./(3.*r)).*((exp(-b./eta).*(eta-2.*b).*sqrt(eta)) + 2.*erfc((sqrt(b./eta))).*(sqrt(pi.*(b.^3))));

