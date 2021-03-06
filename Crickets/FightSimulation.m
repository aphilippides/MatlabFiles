function FightSimulation

rand('seed',sum(100*clock));

Crick1.Pos=[0,0];
Crick1.Face=0;
Crick1.Flee=0;
Crick1.Size=max(0,randn)+0.5;
Crick1.WinLoss=[];
Crick1.FightThresh=0.5;
Crick1.FleeThresh=0.5;

Crick2.Pos=[2,0];
Crick2.Face=pi;
Crick2.Size=max(0,randn)+0.5;
Crick2.Flee=0;
Crick2.WinLoss=[];
Crick1.FightThresh=0.5;
Crick1.FleeThresh=0.5;

for i=1:100
    [Crick1,Crick2]=FightStatic(Crick1,Crick2);
end

function[Crick1,Crick2]=FightStatic(Crick1,Crick2)
MaxSteps = 100;
DistLim=5;
for t=1:MaxSteps
    PlotCrickets(Crick1,Crick2);
    drawnow;
    pause(0.2)
    % if criskets are close then fight else move around
    if(CartDist(Crick1.Pos,Crick2.Pos)<DistLim)
        [Crick1,Crick2]=FightCrickets(Crick1,Crick2);
    else
        [Crick1,Crick2]=MoveCrickets(Crick1,Crick2);
    end
end
hold off

function[Crick1,Crick2]=FightCrickets(Crick1,Crick2)
Crick2.Flee=DoesFlee(Crick2,Crick1);
if(DoesFlee(Crick1,Crick2))
    Crick1.Flee=1;
    Crick1.Face=Crick1.Face+pi;
    Crick1.WinLoss=[Crick1.WinLoss 0];
end
if(DoesFlee(Crick2,Crick1))
    Crick1.Flee=1;
    Crick1.Face=Crick1.Face+pi;
    Crick1.WinLoss=[Crick1.WinLoss 0];
end

if((Crick1.Flee)&&(Crick2.Flee))
    FleeFlag=1;
elseif((Crick1.Flee)&&(~Crick2.Flee))
    Crick1.WinLoss=[Crick1.WinLoss 0];
    Crick2.WinLoss=[Crick2.WinLoss 1];
elseif((Crick2.Flee)&&(~Crick1.Flee))
    Crick2.WinLoss=[Crick2.WinLoss 0];
    Crick1.WinLoss=[Crick1.WinLoss 1];
elseif((Crick1.Flee*Crick2.Flee)==0)
    Crick1.FleeThresh=CalcDamage(Crick1,Crick2);
    Crick2.FleeThresh=CalcDamage(Crick2,Crick1);
end


function[NewPos,NewHeading]=MoveAntCorr(OldPos,OldHeading)

new_ang=2*(rand-0.5);
NewHeading=OldHeading+new_ang;
[randx,randy]=pol2cart(NewHeading,0.5);
rand_step=[randx,randy];
NewPos=OldPos+rand_step;

function[NewPos]=MoveAntRandom(OldPos,S)

% rand_step=rand(1,2)-0.5;
[randx,randy]=pol2cart(rand*2*pi,0.5);
rand_step=[randx,randy];
NewPos=OldPos+rand_step;
