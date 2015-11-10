function[sphere_conc1] = sp_erfS(t,x,sp,meas_t,B)

global DIFF;
global LAM;
global SPHERE_CONST2;
global SPHE_INN;
global SPHE_OUT
global STRENGTH_VOLSEC;

const2 = 4.*DIFF.*t;
const1=sqrt(const2);

sphere_conc1 = (STRENGTH_VOLSEC.*0.5.*(erf((x+sp)./const1)+erf((sp-x)./const1))).*exp(-LAM.*t).*strengthlots((meas_t-t),B);

