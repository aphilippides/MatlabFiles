function[C]=Pt3dSS(x,t_half)

k=-sqrt(log(2)/(3300*t_half));
C=(0.021./(4.*pi.*x.*3300)).*exp(k.*x);
