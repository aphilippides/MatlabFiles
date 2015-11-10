function[sphere_conc1] = test1(t,x,sp)

global DIFF;
global LAM;
global STRENGTH_VOLSEC;
const1=sqrt(4.*DIFF.*t);

sphere_conc1 = (STRENGTH_VOLSEC.*0.5.*(erf((x+sp)./const1)+erf((sp-x)./const1))).*exp(-LAM.*t);
