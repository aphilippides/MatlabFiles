function[f]=VonMises(phi,modalC,vari)
denom=2*pi*besseli(0,vari);
f = exp(vari*cos(phi-modalC))/denom;