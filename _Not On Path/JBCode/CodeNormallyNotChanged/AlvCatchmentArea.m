%%%%%%  This function builds or loads an environment and examines how the ALV model
%manages in the whole area, giving the possibility to plot the homing
%vector for each point of the grid and the real catchment area ( places from
%which the model ant manages to reach the nest).
%  This model tries to free ourselves from the side effects usually caused
%by the absence of landmark appearance at the edge of the area. To compare
%this method with the simple one, just set Check at the value 1


function AlvCatchmentArea

%%%%%% Maybe useless, reset the random seed
rand('state',sum(100*clock));


%%%%%% Generate/load environment
nest = [500 500 5];
EnvSize = 1000 ;
obj = RndEnvironment(10,[1 EnvSize],10,nest,1);
if(obj(1,3)<0) 
    disp('too many objects***\n');
end

FileName = 'TestSideEffects/Test13' ;
%save(FileName,'obj','nest') ;
load(FileName);


%%%%%% Determine the part of the environment where there will be no side
% effect
BigestObject = max(obj(:,3)) ;

% Poorly implemented, for if this value is changed in LincVision.m, it will
% need to be changed here too
fac_awidth = 2*pi/90;
SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;

% return and display an error message whenever the "no-side-effect" area is
% empty
if  (EnvSize< 2*SideEffectWidth)
    disp('Environment too small or objects too wide\n');
    return;
end
[X,Y]=meshgrid([SideEffectWidth:5:EnvSize-SideEffectWidth]);

%%%%%% Figure 1 : plot the nest & objects, draw the field of view from the
% nest as a black circle
figure(1) ;
hold off ;
DrawEnvironment(obj,nest) ;
hold on ;
MyCircle(nest([1 2]),SideEffectWidth,'k') ;
axis tight ;
hold off ;



[Rms,Rmx,Rmy]=RMSsForEnvironment(X,Y,obj,nest);

figure(8)
hold off ;
DrawEnvironment(obj,nest) ;
axis tight
hold on ;
pcolor(X,Y,Rms(2:end-1,2:end-1)), colorbar, shading interp;
hold off 

figure(9)
hold off ;
DrawEnvironment(obj,nest) ;
hold on ;
MyCircle(nest([1 2]),SideEffectWidth,'k') ;
axis tight ;
hold on ;
quiver(X,Y,Rmx,Rmy)
hold off;

%%%%% Compute the catchment area
RmNumSteps=StartFromEachPos(X,Y,Rmx,Rmy,nest) ;

figure(10)
hold off
DrawEnvironment(obj,nest) ;
axis tight ;
hold on
MyCircle(obj(:,[1 2]), obj(:,3)/sin(0.5*fac_awidth), 'k');
hold on
pcolor(X,Y,RmNumSteps), colorbar, shading flat;
hold off

% %%%%% Compute the ALV vector from each point of the grid and plot the
% % homing vectors if the last argument is set to 1
% % ####### WARNING !! ####### plotting seems to change the output for
% % mx and my are no longer the ALV vectors but the homing vectors
% % Figure 1 : plot the homing vectors
% % Figure 2 : plot the environment, the homing vector accuracy (cosinus
% % between  the homing vector and the true homing vector) and the contour of
% % the number of objects seen
% [NObj,mx,my]=ALVsForEnvironment(X,Y,obj,5,nest,1);
% save(FileName,'NObj','mx','my','-append');
    
%%%%%% Compute the catchment area
% NumSteps=StartFromEachPos(X,Y,mx,my,nest) ;

%%%%%% Figure 3 : plot the number of objects seen with black circles which
%% radius shows the area where this object can be seen
% figure(3)
% hold off ;
% DrawEnvironment(obj,nest) ;
% axis tight ;
% hold on
% pcolor(X,Y,NObj), colorbar, shading flat;
% hold on
% MyCircle(obj(:,[1 2]), obj(:,3)/sin(0.5*fac_awidth), 'k');
% hold off

%%%%%% Save figures
% saveas(1, strcat(FileName,'_Wide_Vectors.fig'));
% saveas(2, strcat(FileName,'_Wide_Accur.fig'));
% saveas(3, strcat(FileName,'_Wide_View.fig'));

%%%%%% Figure 7 : plot the catchment area with colour varying according to
%% the number of steps needed to reach the nest (8 connexity used)
% figure(7)
% hold off
% DrawEnvironment(obj,nest) ;
% axis tight ;
% hold on
% MyCircle(obj(:,[1 2]), obj(:,3)/sin(0.5*fac_awidth), 'k');
% hold on
% pcolor(X,Y,NumSteps), colorbar, shading flat;
% hold off

%%%%%% Check without removing side effects if == 1 ; plot and save the same
%% figures but in other windows due to the last argument of 
%% ALVsForEnvironment wich is 2
Check = 0 ;

if(Check)
    obj(find(obj(:,1)<SideEffectWidth),:)=[];
    obj(find(obj(:,2)<SideEffectWidth),:)=[];
    obj(find(obj(:,1)>EnvSize-SideEffectWidth),:)=[];
    obj(find(obj(:,2)>EnvSize-SideEffectWidth),:)=[];

    figure(4);
    hold off ;
    DrawEnvironment(obj,nest)
    %axis tight ;
    hold off ;
    
    [NObj,mx,my]=ALVsForEnvironment(X,Y,obj,5,nest,2);

    figure(6) ;
    hold off
    DrawEnvironment(obj,nest) ;
    hold on
    pcolor(X,Y,NObj), colorbar, shading flat;
    hold off
    
    saveas(4, strcat(FileName,'_SEffect_Vectors.fig'));
    saveas(5, strcat(FileName,'_SEffect_Accur.fig'));
    saveas(6, strcat(FileName,'_SEffect_View.fig'));
end


%%%%%% Function computing the catchment area with colour varying according
% to the number of steps needed to reach the nest.
% The 8-connexity is used (8 neighbours per box)
% The algorithm strategy is based on a Fifo list
function[NumSteps]=StartFromEachPos(X,Y,mx,my,nest)

% Initialization of the catchment area
NumSteps=NaN(size(X)) ;

% Find the position of the nest in the mesh grid
nest_grid(1)= find( abs(X(1,:)-nest(1))<= (Y(2)-Y(1))/2) ;
nest_grid(2)= find( abs(Y(:,1)-nest(2))<= (Y(2)-Y(1))/2) ;

% Initialize Fifo with each grid point within the nest area
NewFifo = [];
% Radius of the nest expressed as a number of grid interval
r = 3*floor(nest(3)/(Y(2)-Y(1)));  
for i=-r:r
    for j=-r:r
        if( (X(1,nest_grid(1)+i)-nest(1))^2 + (Y(nest_grid(2)+j,1)-nest(2))^2 <= (3*nest(3))^2  )
            NewFifo = [NewFifo ; [nest_grid]+[i j] ] ;
            NumSteps(nest_grid(1)+i,nest_grid(2)+j)=0;
        end
    end
end

step = 1 ;
% The end condition is an empty list
while size(NewFifo,1) > 0
    OldFifo = NewFifo ;
    NewFifo = [];
    
    while size(OldFifo,1) > 0
        Local = OldFifo(1,:) ;
        for i=-1:1
            for j=-1:1
               Neighbour = OldFifo(1,:) + [i j] ; 
               if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1-Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
                   % ### WARNING ### vector (i,j) is expected to be the
                   % vector from the Local box to the neighbour but since 
                   % the data organisation is different between the array 
                   % and the image (NE-SW symetry)
                   % i and j have thus been switched to cope with this problem                   
                   if ( (mx(Neighbour(1),Neighbour(2))*j+my(Neighbour(1),Neighbour(2))*i)/(sqrt(mx(Neighbour(1),Neighbour(2))^2+my(Neighbour(1),Neighbour(2))^2)*sqrt(i^2+j^2))<-cos(pi/8))
                       NumSteps(Neighbour(1),Neighbour(2)) = step ;
                       NewFifo = [NewFifo;Neighbour];
                   end
               end
           end
        end
        OldFifo(1,:) = [] ;
    end

    step=step+1 ;
end





