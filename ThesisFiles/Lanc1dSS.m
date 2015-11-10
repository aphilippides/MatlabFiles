function[C]=Lanc1dSS(x,t_half)

k1=-log(2)/sqrt(6600*t_half);
C=(exp(k1.*x));
