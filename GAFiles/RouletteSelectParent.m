% function to perform roulette wheel rank selection on a set of potential parents

function[Parent]=RouletteSelectParent(Scores)

ScTotal=sum(Scores);
CumSc=cumsum(Scores./ScTotal);
x=rand;
i=1;
while(CumSc(i)<x)
   i=i+1;
end
Parent=i;


