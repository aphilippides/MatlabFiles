function[integ] = my_ptint(t2,r)

global L2D_CONST;
global DIFF;
global LAM;

GLOBE;

integ = 0.5.*(1+exp(-LAM.*t2)).*L2D_CONST.*(erfc(r./(2.*sqrt(DIFF.*t2))))./r;

