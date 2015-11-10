function OptimisationEG(d)

Landscape(d)
%ezmesh(@Landscape2,[-5 5],[-5 5])



function Landscape(d)

f = ['4*(1-x)^2*exp(-(x^2) - (y+1)^2)' ... 
         '- 15*(x/5 - x^3 - y^5)*exp(-x^2-y^2)' ... 
         '- 1/3*exp(-(x+1)^2 - y^2)' ...
        '-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2)'   ];

ezmesh(f,[-3,7])

function[f]=LandscapeFunc(x,y)

f=4*(1-x)^2*exp(-(x^2)-(y+1)^2)- 10*(x/5 - x^3 - y^5)*exp(-x^2-y^2)- 1/3*exp(-(x+1)^2 - y^2)'-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2);

