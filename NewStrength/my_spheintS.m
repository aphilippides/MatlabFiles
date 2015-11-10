% Function to do integral of problematic bit of solid sphere i.e from 0 to t

function[sphein] = my_spheintS(t,r,a,tim,B)


global DIFF;
global LAM;
global STRENGTH_VOLSEC;
global RISE; 
GLOBES;

b1 = ((r-a).^2)./(4.*DIFF);
b2 = ((r+a).^2)./(4.*DIFF);

erf_bit = quad8('sp_erfS',eps*1e-30,t,[],[],r, a,tim,B);

maxi = strengthlots(tim,B);	
mini = strengthlots((tim-t),B);


sphein=erf_bit-0.5.*(1.*maxi+exp(-LAM.*t).*mini).*(int_rooteS(t,b1,r)-int_rooteS(t,b2,r));

%sphein=erf_bit-0.5.*0.34.*(1+exp(-LAM.*t)).*(int_rooteS(t,b1,r)-int_rooteS(t,b2,r));
