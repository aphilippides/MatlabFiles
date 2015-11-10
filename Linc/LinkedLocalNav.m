function LinkedLocalNav

% Generate/load environment
nest = [100 100 5];
food = [500 300 5];%[IRnd(500,1,2) 5];
obj = RndEnvironment(4,[1 500],20,[nest;food],1);
if(obj(1,3)<0) 
    disp('too many objects***\n');
end
% save tempEnv obj food nest
load tempEnv
obj(4,2)=150;
food = [400 280 5];%[IRnd(500,1,2) 5];

Agent=[food([1 2]) 5];
AgentAndIR=Agent+[0 0 4.09];
% Learning 
[NR,WPts,LPath,ObjHit] = LearnRoute(obj,AgentAndIR,nest);

DrawEnvironment(obj,[nest;food])
hold on
[X,Y]=meshgrid([1:10:500]);
% [NObj,mx,my]=ALVsForEnvironment(X,Y,obj);
% save tempEnv NObj mx my -append  
[c h]=contour(X,Y,NObj,[-1:max(max(NObj))]);
plot(LPath(:,1),LPath(:,2),'r')
plot(WPts(:,4),WPts(:,5),'cs')
hold off

% Navigation
if(NR==1)
    [GotHome,NPath,OHit] = LLNavigate(obj,AgentAndIR,nest,WPts(:,[1 2]));
end

function[NestReached,Path,ObjHit] = LLNavigate(Objects,agent,Nest,WPts,dx,msteps)
if(nargin<6) msteps=500; end;
if(nargin<5) dx=1; end;

ne=Nest([1 2]); dNestThresh=agent(3);%Nest(3)+agent(3)
ObjHit=[];mv=[];

% set current waypoint and start position
wpt=1; goalv=WPts(1,:); GoalVs=[1 1 goalv];
Pos(1,:)= agent([1,2]);
DoSmooth=0;
for i=1:msteps

    % Calculate dist to nest and ALV from vision; 
    [DToN(i),VToN]=CartDist(ne,Pos(i,:));
    [obc,obw]=LincVision(Objects,Pos(i,:));
    [NumObs(i),alvs(i,:)]=GetALVs(obc,obw);

    % if home, stop; if inside object, stop
    % if < 2 objects stop; 
    % if boundary detected, move to next waypoint, 
    if(DToN(i)<dNestThresh)
        Path=[Pos alvs DToN' NumObs'];
        NestReached=1;
        return;
    elseif(NumObs(i)==-1) 
        Path=[Pos alvs DToN' NumObs'];
        NestReached=-2;
        return;
    elseif(NumObs(i)<2) 
        Path=[Pos alvs DToN' NumObs'];
        NestReached=-1;
        return;
    elseif(BoundaryCrossed(NumObs,alvs)) 
        wpt=wpt+1;
        if(wpt>size(WPts,1)) 
            Path=[Pos(1:end,:) alvs DToN' NumObs'];
            NestReached=-3;
            return
        end

        goalv=WPts(wpt,:);
        GoalVs=[GoalVs;i wpt goalv];
        DoSmooth=0;
    end
    
    % Calculate movement from vision
    mv(i,:) = GetMovement(mv,alvs(i,:),goalv,dx,DoSmooth);
%     DoSmooth=1;
    % Check for obstacles and avoid if necessary
    % ** NO OBSTACLE AVOIDANCE AT THE MOMENT ***
%     [inObj,Overlaps,V2Nearest,MinDist,MinInd]=InsideObject(Objects,[Pos(i,:) agent(3)]);
%     if(inObj) 
%         ObjHit=[ObjHit;i MinInd];
%         mv=mv-V2Nearest/MinDist; 
%     end;
    Pos(i+1,:)=Pos(i,:)+mv(i,:);    
end
Path=[Pos(1:end-1,:) alvs DToN' NumObs'];
NestReached=0;

function[NestReached,WayPoints,Path,ObjHit] = LearnRoute(Objects,agent,Nest,dx,msteps)
if(nargin<6) msteps=500; end;
if(nargin<5) dx=1; end;

dNestThresh=agent(3);%Nest(3)+agent(3)
ne=Nest([1 2]);
WayPoints=[];
ObjHit=[];
Pos(1,:)= agent([1,2]);
for i=1:msteps

    % Calculate dist to nest and ALV from vision; 
    [DToN(i),VToN]=CartDist(ne,Pos(i,:));
    [obc,obw]=LincVision(Objects,Pos(i,:));
    [NumObs(i),alvs(i,:)]=GetALVs(obc,obw);

    % if home, stop; if inside object, stop
    % if < 2 objects stop; 
    % if boundary detected, set waypoint, 
    if(DToN(i)<dNestThresh)
        Path=[Pos alvs DToN' NumObs'];
        NestReached=1;
        return;
    elseif(NumObs(i)==-1) 
        Path=[Pos alvs DToN' NumObs'];
        NestReached=-2;
        return;
    elseif(NumObs(i)<2) 
        Path=[Pos alvs DToN' NumObs'];
        NestReached=-1;
        return;
    elseif(BoundaryCrossed(NumObs,alvs))
        WayPoints=[WayPoints;[alvs(i-1,:) i-1 Pos(i-1,:)]];
    end
    
    % Move via PI, Check for obstacles and avoid if necessary
    mv=VToN*dx/DToN(i);
    [inObj,Overlaps,V2Nearest,MinDist,MinInd]=InsideObject(Objects,[Pos(i,:) agent(3)]);
    if(inObj) 
        ObjHit=[ObjHit;i MinInd];
        mv=mv-V2Nearest/MinDist; 
    end;
    Pos(i+1,:)=Pos(i,:)+mv;    
end
Path=[Pos(1:end-1,:) alvs DToN' NumObs'];
NestReached=0;