function[sphere_conc] = InstSolSphere(t,x)

global DIFF;
global LAM;
global SPHERE_CONST2;
global SPHE_OUT;
global STRENGTH_VOLSEC;

const2 = 4.*DIFF.*t;
const1=sqrt(const2);

if x<0.0001
    sphere_conc =(STRENGTH_VOLSEC.*0.5.*(erf((x+SPHE_OUT)./const1)+erf((SPHE_OUT-x)./const1) - SPHERE_CONST2.*exp(-1.*(x.^2)./const2).* exp(-1.*(SPHE_OUT.^2)./const2).*SPHE_OUT./(DIFF.*sqrt(t)))).*exp(-LAM.*t);
else
sphere_conc = (STRENGTH_VOLSEC.*0.5.*(erf((x+SPHE_OUT)./const1)+erf((SPHE_OUT-x)./const1)) + SPHERE_CONST2.*(sqrt(t)./x).*(exp(-1.*((x+SPHE_OUT).^2)./const2) - exp(-1.*((SPHE_OUT-x).^2)./const2))).*exp(-LAM.*t);
end
