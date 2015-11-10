function OctDists()

pi_180=0.0175;
ph=-60:1:20;
thet=35;
fem=7;tib=4;
ht=6-5*sin(pi_180*(ph+60));
plot(ph,ht)
upang=(asin(0.3)/pi_180)-60
upang=-43;
ph=-60:0.1:-43;
len = (fem+tib*(sin(pi_180*(ph+60))))*sin(pi_180*(thet));
fitness=5*40*2*(len+(6-5*sin(pi_180*(ph+60)))*0.1)/1.7169;
plot(ph,fitness),figure

len = (fem+tib*(sin(pi_180*(17))))*sin(pi_180*(thet))
maxfitness=5*40*2*(len+(6-5*sin(pi_180*(17)))*0.1)
fitness2=5*16*5*(thet+6)
fitness2=5*16*5*(thet)
fitness2=5*16*5*(thet+(6-5*sin(pi_180*(ph+60)))*1)/16.4;
plot(ph,fitness2)

