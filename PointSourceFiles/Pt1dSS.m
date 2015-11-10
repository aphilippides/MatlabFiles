function[C]=Pt1dSS(x,t_half)

k=-sqrt(log(2)/(3300*t_half));
C=(exp(k.*x));
