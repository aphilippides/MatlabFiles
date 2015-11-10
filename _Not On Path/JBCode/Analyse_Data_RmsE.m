function[       Catch_Env_Ratio_RmsE ,...
                Bigest_Radius_RmsE ,...
                AHC_Dist_RmsE,...
                Num_Trap_RmsE]...
        =Analyse_Data_RmsE(FileName,fig_AHC_Dist,fig_AHC_Loc)

if(nargin<3)
    FileName = 'C:\Temp\Desmottes\Env_30Obj_2' ;
    fig_AHC_Dist=20 ;
    fig_AHC_Loc=21 ;
end
    
load(FileName);
% LOADED :
%   EnvSize    SideEffectWidth    fac_awidth    nest   obj            

DataFileName = strcat(FileName, '_Monitor') ;
load(DataFileName);
% LOADED :
%...
%   X_RmsE          Y_RmsE        RmsE          mx_RmsE   my_RmsE   
%   RmsENumSteps    trapx_RmsE    trapy_RmsE

if (~exist('HomewardComp_RmsE'))
    HomewardComp_RmsE = ( (mx_RmsE.*(nest(1)-X_RmsE) + my_RmsE.*(nest(2)-Y_RmsE) )./ ...
        (sqrt((mx_RmsE.^2 + my_RmsE.^2).*( (X_RmsE-nest(1)).^2 +(Y_RmsE-nest(2)).^2)) ));
    save(DataFileName,'HomewardComp_RmsE','-append');
end

% Plot_RmsE( 41,42,43,'tmp',X_RmsE,Y_RmsE, ...
%                   obj,nest,fac_awidth,SideEffectWidth,mx_RmsE,my_RmsE, ...
%                   RmsE,RmsENumSteps,trapx_RmsE,trapy_RmsE,0) 
% figure(44)
% hold off
% pcolor(X_RmsE,Y_RmsE,HomewardComp_RmsE), shading flat;

% Find the position of the nest in the mesh grid
Nest_Grid_RmsE=Find_Nest_Grid(X_RmsE,Y_RmsE,nest);

AHC_Dist_RmsE...
    =Get_AHC_Dist(Nest_Grid_RmsE,X_RmsE,Y_RmsE,HomewardComp_RmsE) ;

Catch_Size_RmsE = Get_Catch_Size(RmsENumSteps,X_RmsE(1,2)-X_RmsE(1,1),Y_RmsE(2,1)-Y_RmsE(1,1));
Catch_Env_Ratio_RmsE=Catch_Size_RmsE/(EnvSize - 2*SideEffectWidth)^2 ;

% Radius of the bigest circle included in the catchment area
Bigest_Radius_RmsE=Get_Bigest_Radius(RmsENumSteps,X_RmsE,Y_RmsE,nest);

if (~exist('MapObj'))
    Pitch=X_RmsE(1,2)-X_RmsE(1,1);
    MapObj=zeros(size(X_RmsE));
    r = ceil(SideEffectWidth/Pitch) ;
    for k=1:size(obj,1)
        for i=-r:r
            for j=-r:r
                y=i*Pitch+obj(k,1);
                x=j*Pitch+obj(k,2);
                if (x>=X_RmsE(1)-Pitch/2 & y>=Y_RmsE(1)-Pitch/2 & x<=X_RmsE(end)+Pitch/2 & y<=Y_RmsE(end)+Pitch/2)
                    Grid_Pos=Find_Nest_Grid(X_RmsE,Y_RmsE,[x y]);
                    if( (X_RmsE(Grid_Pos(1),Grid_Pos(2))-obj(k,1))^2 ...
                            + (Y_RmsE(Grid_Pos(1),Grid_Pos(2))-obj(k,2))^2 ...
                            <= SideEffectWidth^2 )
                        MapObj(Grid_Pos(1),Grid_Pos(2))=MapObj(Grid_Pos(1),Grid_Pos(2))+1;
                    end
                    if( (X_RmsE(Grid_Pos(1),Grid_Pos(2))-obj(k,1))^2 ...
                            + (Y_RmsE(Grid_Pos(1),Grid_Pos(2))-obj(k,2))^2 ...
                            <= (obj(k,3))^2 )
                        MapObj(Grid_Pos(1),Grid_Pos(2))=NaN;
                    end
                end
            end
        end
    end
    tmp= bwmorph(isnan(MapObj),'dilate');
    MapObj(find(tmp))=-1;
    save(DataFileName,'MapObj','-append');
end
%##### What to do with Trap_Area ?? #####
[Trap_Area_RmsE,Num_Trap_RmsE]=Get_Trap(RmsENumSteps(2:end-1,2:end-1),X_RmsE(2:end-1,2:end-1),Y_RmsE(2:end-1,2:end-1),MapObj(2:end-1,2:end-1),mx_RmsE(2:end-1,2:end-1),my_RmsE(2:end-1,2:end-1)) ;

% figure(fig_AHC_Dist)
% %hold off;
% plot(0:5:5*size(AHC_Dist_RmsE,2)-1,AHC_Dist_RmsE)
% hold on ;
% ylim('auto')
% xlim([0 SideEffectWidth])
% title('DIST')
% %hold off ;

File_Analysis=strcat(FileName,'_Analyse.mat');
if (exist(File_Analysis))
    save( File_Analysis,...
                'Catch_Env_Ratio_RmsE' ,...
                'AHC_Dist_RmsE',...
                'Bigest_Radius_RmsE' ,...
                'Num_Trap_RmsE' ,...
           '-append');
else
    save( File_Analysis,...
                'Catch_Env_Ratio_RmsE' ,...
                'AHC_Dist_RmsE',...
                'Bigest_Radius_RmsE' ,...
                'Num_Trap_RmsE');
end


function[Size]=Get_Catch_Size(NumSteps,X_Step,Y_Step)
Bin_Catch_Area=1*~isnan(NumSteps);
Size=X_Step*Y_Step*sum(sum(Bin_Catch_Area));
  

% Find the position of the nest in the mesh grid
function[Nest_Grid]=Find_Nest_Grid(X,Y,nest)
Nest_Grid(1)= find( abs(X(1,:)-nest(1))<= (X(1,2)-X(1,1))/2) ;
Nest_Grid(2)= find( abs(Y(:,1)-nest(2))<= (Y(2,1)-Y(1,1))/2) ;
 

function AHC_Dist...
    =Get_AHC_Dist(nest_grid,X,Y,HomewardComp)

[I,J]=meshgrid(1:size(X)) ;
I=I-nest_grid(1)*ones(size(X)) ;
J=J-nest_grid(2)*ones(size(X)) ;
Grid_Distance=round(sqrt(I.^2+J.^2))+1 ;
Dist_Max=max(max(Grid_Distance));

% Initializations
AHC_Dist=zeros(1,Dist_Max); % ### WARNING ### box number i => dist = i-1 
AHC_Dist_pond=zeros(1,Dist_Max) ;

for i=1:size(X,1)
    for j=1:size(X,2)
        Dist=Grid_Distance(i,j);
        if (~isnan(HomewardComp(i,j)))
            AHC_Dist(Dist)=AHC_Dist(Dist)+HomewardComp(i,j);
            AHC_Dist_pond(Dist)=AHC_Dist_pond(Dist)+1;
        end
    end
end
AHC_Dist = AHC_Dist./AHC_Dist_pond ;


% Identify false minima
% ### WARNING ### A parameter must be changed according to the use of ALV or RmsE
function[Trap_Area,Num_Trap]=Get_Trap(NumSteps,X,Y,NumObj,mx,my)
NonCatch=1*isnan(NumSteps) ;
Count=2;
for i=1:size(X,1)
    flag=1;
    for j=1:length(X)
        if ( NonCatch(i,j)==1 & NumObj(i,j)>0 )
            Local_x = i ;
            Local_y = j ;
            go_on = 1;
            while go_on
                if (isnan(mx(Local_x,Local_y)))
                    Aim_x=0;
                else
                    Aim_x=(abs(mx(Local_x,Local_y)/sqrt(mx(Local_x,Local_y)^2+my(Local_x,Local_y)^2))>cos(3*pi/8))*sign(mx(Local_x,Local_y)) ;
                end
                if (isnan(my(Local_x,Local_y)))
                    Aim_y=0;
                else
                    Aim_y=(abs(my(Local_x,Local_y)/sqrt(mx(Local_x,Local_y)^2+my(Local_x,Local_y)^2))>sin(pi/8))*sign(my(Local_x,Local_y)) ;
                end
                Next_x = Local_x + Aim_y ;
                Next_y = Local_y + Aim_x ;
                
                if( Next_x*Next_y*(size(X,1)+1-Next_x)*(length(X)+1-Next_y) )
                    if (NonCatch(Next_x,Next_y)==1)
                        if ( NumObj(Next_x,Next_y)<=0 )
                            NonCatch(Local_x,Local_y)=-2;
                            go_on = 0 ;
                        else
                            NonCatch(Local_x,Local_y)=Count;
                            Local_x = Next_x ;
                            Local_y = Next_y ;
                        end
                    elseif (NonCatch(Next_x,Next_y)==-2)
                        if (NonCatch(Local_x,Local_y)<0)
                            NonCatch(Local_x,Local_y)=-2;
                            go_on = 0 ;
                        else
                            NonCatch(Local_x,Local_y)=Count;
                            go_on = 0 ;
                        end
                    elseif (NonCatch(Next_x,Next_y)==Count)
                        NonCatch(Local_x,Local_y)=-1;
                        Local_x = Next_x ;
                        Local_y = Next_y ;
                    elseif (NonCatch(Next_x,Next_y)==-1)
                        NonCatch(Local_x,Local_y)=-2;
                        Local_x = Next_x ;
                        Local_y = Next_y ;
                    else
                        NonCatch(Local_x,Local_y)=Count;
                        go_on = 0 ;
                    end  
                else
                    NonCatch(Local_x,Local_y)=-2;
                    go_on = 0 ;
                end
            end
            Count=Count+1;
        end
    end
end
Trap=1*(NonCatch==-2);

% figure(35)
% hold on
% plot(X(find(Trap==1)),Y(find(Trap==1)),'Xk')

Trap_Area_Grid=sum(sum(Trap));
Trap_Area=Trap_Area_Grid*(X(1,2)-X(1,1))*(Y(2,1)-Y(1,1));
% ### WARNING ### dilate once for RmsE, 4 time for the ALV
tmp = bwmorph(Trap,'dilate',1);

% pcolor(X,Y,1*tmp), shading flat ;

[A,Num_Trap] = bwlabel(tmp,8) ;


% Radius of the bigest circle included in the catchment area
function[Dist]=Get_Bigest_Radius(NumSteps,X,Y,nest)
Bin_Catch=~isnan(NumSteps);
Perim = bwperim(Bin_Catch,8);
[I,J]=find(Perim);
A=Y(J,1) ;
B=X(1,I)' ;
DistSq=(A-nest(2)).^2+(B-nest(1)).^2 ;
Dist=sqrt(min(DistSq)) ;