function[   Catch_Env_Ratio_Alv ,...
            Catch_Locale_Ratio_Alv ,...
            MeanChangeNumObjSeen_Alv ,...
            Num_Loc_Alv ,...
            Num_Loc_Catch_Alv ,... 
            Num_Trap_Alv,...
            Bigest_Radius_Alv,...
            ...
            Catch_Env_Ratio_AlvSE ,...
            Catch_Locale_Ratio_AlvSE ,...
            MeanChangeNumObjSeen_AlvSE ,...
            Num_Loc_AlvSE ,...
            Num_Loc_Catch_AlvSE ,... 
            Num_Trap_AlvSE,...
            Bigest_Radius_AlvSE]...
        =Analyse_Data_Old(FileName,fig_AHC_Dist,fig_AHC_Loc)

if(nargin<3)
    FileName = 'C:\Temp\Desmottes\Env_15Obj_1' ;
    fig_AHC_Dist=20 ;
    fig_AHC_Loc=21 ;
end
    
load(FileName);
%   EnvSize    SideEffectWidth    fac_awidth    nest   obj            

DataFileName = strcat(FileName, '_Monitor') ;
load(DataFileName);
%   X_Alv       Y_Alv       NObj    mx_Alv   my_Alv   HomewardComp   AlvNumSteps
%   trapx_Alv   trapy_Alv 

%   ObjSE           NObjSE         mx_Alv_SE       my_Alv_SE   HomewardCompSE
%   AlvNumStepsSE   trapx_Alv_SE   trapy_Alv_SE  

%   X_RmsE          Y_RmsE        RmsE          mx_RmsE   my_RmsE   
%   RmsENumSteps    trapx_RmsE    trapy_RmsE

% Plot_ALV( 1,2,3,4,'tmp',X_Alv,Y_Alv, ...
%                   obj,nest,fac_awidth,SideEffectWidth,NObj,mx_Alv,my_Alv, ...
%                   HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv,0) 

% Find the position of the nest in the mesh grid
Nest_Grid_Alv=Find_Nest_Grid(X_Alv,Y_Alv,nest);


Catch_Size_Alv = Get_Catch_Size(AlvNumSteps,X_Alv(1,2)-X_Alv(1,1),Y_Alv(2,1)-Y_Alv(1,1));
Catch_Env_Ratio_Alv=Catch_Size_Alv/(EnvSize - 2*SideEffectWidth)^2 ;

Visual_Locale_Size_Alv = Get_Vis_Loc_Siz(NObj,Nest_Grid_Alv,X_Alv(1,2)-X_Alv(1,1),Y_Alv(2,1)-Y_Alv(1,1)) ;
Catch_Locale_Ratio_Alv=Catch_Size_Alv/Visual_Locale_Size_Alv ;

%##### What to do with AverageHomewardComp_Alv ?? #####
[MeanChangeNumObjSeen_Alv,AverageHomewardComp_Alv,AHC_Dist_Alv,AHC_Loc_Alv]...
    =Data_Within_Catch(nest,Nest_Grid_Alv,X_Alv,Y_Alv,mx_Alv,my_Alv,NObj,HomewardComp) ;

% nombre de locale, en tt et ds catch area
%###### attention fonction foireuse
Num_Loc_Alv=Get_Num_Loc(obj,NObj);
% Num_Loc_Alv_2=Get_Num_Loc_2(obj,NObj);

Num_Loc_Catch_Alv=Get_Num_Loc(obj,NObj.*(1-isnan(AlvNumSteps)))-1;
% Num_Loc_Catch_Alv_2=Get_Num_Loc_2(obj,NObj.*(1-isnan(AlvNumSteps)))-1;

%##### What to do with Trap_Area ?? #####
[Trap_Area_Alv,Num_Trap_Alv]=Get_Trap(AlvNumSteps,X_Alv,Y_Alv,NObj,mx_Alv,my_Alv) ;

% Radius of the bigest circle included in the catchment area
Bigest_Radius_Alv=Get_Bigest_Radius(AlvNumSteps,X_Alv,Y_Alv,nest);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%  Plot_ALV( 5,6,7,8,'tmp', X_Alv,Y_Alv,ObjSE,nest, ...
%                       fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
%                       HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)

Catch_Size_AlvSE = Get_Catch_Size(AlvNumStepsSE,X_Alv(1,2)-X_Alv(1,1),Y_Alv(2,1)-Y_Alv(1,1));
Catch_Env_Ratio_AlvSE=Catch_Size_AlvSE/(EnvSize - 2*SideEffectWidth)^2 ;

Visual_Locale_Size_AlvSE = Get_Vis_Loc_Siz(NObjSE,Nest_Grid_Alv,X_Alv(1,2)-X_Alv(1,1),Y_Alv(2,1)-Y_Alv(1,1)) ;
Catch_Locale_Ratio_AlvSE=Catch_Size_AlvSE/Visual_Locale_Size_AlvSE ;

%##### What to do with AverageHomewardComp_Alv ?? #####
[MeanChangeNumObjSeen_AlvSE,AverageHomewardComp_AlvSE,AHC_Dist_AlvSE,AHC_Loc_AlvSE]...
    =Data_Within_Catch(nest,Nest_Grid_Alv,X_Alv,Y_Alv,mx_Alv_SE,my_Alv_SE,NObjSE,HomewardCompSE) ;

% nombre de locale, en tt et ds catch area
%###### attention fonction foireuse
Num_Loc_AlvSE=Get_Num_Loc(ObjSE,NObjSE);
% Num_Loc_AlvSE_2=Get_Num_Loc_2(ObjSE,NObjSE);

Num_Loc_Catch_AlvSE=Get_Num_Loc(ObjSE,NObjSE.*(1-isnan(AlvNumStepsSE)))-1;
% Num_Loc_Catch_AlvSE_2=Get_Num_Loc_2(ObjSE,NObjSE.*(1-isnan(AlvNumStepsSE)))-1;

%##### What to do with Trap_Area ?? #####
[Trap_Area_AlvSE,Num_Trap_AlvSE]=Get_Trap(AlvNumStepsSE,X_Alv,Y_Alv,NObjSE,mx_Alv_SE,my_Alv_SE) ;

% Radius of the bigest circle included in the catchment area
Bigest_Radius_AlvSE=Get_Bigest_Radius(AlvNumStepsSE,X_Alv,Y_Alv,nest);


% figure(fig_AHC_Dist)
% %hold off;
% plot(0:2:2*size(AHC_Dist_Alv,2)-1,AHC_Dist_Alv,'r')
% hold on;
% plot(0:2:2*size(AHC_Dist_AlvSE,2)-1,AHC_Dist_AlvSE,'g')
% ylim([0 1])
% xlim('auto')
% %hold off ;
% 
% figure(fig_AHC_Loc)
% %hold off ;
% plot(0:size(AHC_Loc_Alv,2)-1,AHC_Loc_Alv,'rh')
% hold on ;
% plot(0:size(AHC_Loc_AlvSE,2)-1,AHC_Loc_AlvSE,'gh')
% ylim([0 1])
% xlim('auto')
% %hold off ;


% File_Analysis=strcat(FileName,'_Analyse.mat');
% save( File_Analysis,...
%        'Catch_Locale_Ratio_Alv',...
%        'Catch_Locale_Ratio_AlvSE' ,...
%        '-append');

%             'Num_Loc_Alv_2' ,...
%             'Num_Loc_Catch_Alv_2' ,...
%             'Num_Loc_AlvSE_2' ,...
%             'Num_Loc_Catch_AlvSE_2' ,...

%             'AHC_Dist_Alv',...
%             'AHC_Loc_Alv',...
%             'AHC_Dist_AlvSE',...
%             'AHC_Loc_AlvSE',...

% File_Analysis=strcat(FileName,'_Analyse.mat');
% % if (exist(File_Analysis))
% %     save( File_Analysis,...
% %                 'Catch_Env_Ratio_Alv' ,...
% %                 'Catch_Locale_Ratio_Alv' ,...
% %                 'MeanChangeNumObjSeen_Alv' ,...
% %                 'Num_Loc_Alv' ,...
% %                 'Num_Loc_Catch_Alv' ,... 
% %                 'Num_Trap_Alv' ,...
% %                 'Bigest_Radius_Alv' ,...
% %                     'Trap_Area_Alv',...
% %                 'Catch_Env_Ratio_AlvSE' ,...
% %                 'Catch_Locale_Ratio_AlvSE' ,...
% %                 'MeanChangeNumObjSeen_AlvSE' ,...
% %                 'Num_Loc_AlvSE' ,...
% %                 'Num_Loc_Catch_AlvSE' ,... 
% %                 'Num_Trap_AlvSE' ,...
% %                 'Bigest_Radius_AlvSE' ,...
% %                     'Trap_Area_AlvSE',...
% %            '-append');
% % else
%     save( File_Analysis,...
%                 'Catch_Env_Ratio_Alv' ,...
%                 'Catch_Locale_Ratio_Alv' ,...
%                 'MeanChangeNumObjSeen_Alv' ,...
%                 'Num_Loc_Alv' ,...
%                 'Num_Loc_Catch_Alv' ,... 
%                 'Num_Trap_Alv' ,...
%                 'Bigest_Radius_Alv' ,...
%                     'Trap_Area_Alv',...
%                 'Catch_Env_Ratio_AlvSE' ,...
%                 'Catch_Locale_Ratio_AlvSE' ,...
%                 'MeanChangeNumObjSeen_AlvSE' ,...
%                 'Num_Loc_AlvSE' ,...
%                 'Num_Loc_Catch_AlvSE' ,... 
%                 'Num_Trap_AlvSE' ,...
%                 'Bigest_Radius_AlvSE' ,...
%                     'Trap_Area_AlvSE' );
% % end


% log(Catch_Locale_Ratio_Alv)-log(Catch_Locale_Ratio_AlvSE)
% Visual_Locale_Size_Alv
% Visual_Locale_Size_AlvSE
% 
% Plot_ALV( 21,22,23,24,'tmp',X_Alv,Y_Alv, ...
%                   obj,nest,fac_awidth,SideEffectWidth,NObj,mx_Alv,my_Alv, ...
%                   HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv,0) 
% figure(24)
% axis([400  600  400  600]) ;
% Plot_ALV( 25,26,27,28,'tmp', X_Alv,Y_Alv,ObjSE,nest, ...
%                   fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
%                   HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)
% figure(28)
% axis([400  600  400  600]) ;
% 
% figure(23)
% axis([400  600  400  600]) ;
% figure(27)
% axis([400  600  400  600]) ;
% 
% a=1;


function[Size]=Get_Catch_Size(NumSteps,X_Step,Y_Step)
Bin_Catch_Area=1*~isnan(NumSteps);
Size=X_Step*Y_Step*sum(sum(Bin_Catch_Area));
  

% Find the position of the nest in the mesh grid
function[Nest_Grid]=Find_Nest_Grid(X,Y,nest)
Nest_Grid(1)= find( abs(X(1,:)-nest(1))<= (X(1,2)-X(1,1))/2) ;
Nest_Grid(2)= find( abs(Y(:,1)-nest(2))<= (Y(2,1)-Y(1,1))/2) ;
 

function[Size]=Get_Vis_Loc_Siz(NObj,Nest_Grid,X_Step,Y_Step)  
Nest_NObj=NObj(Nest_Grid(2),Nest_Grid(1));
same_numb = bwmorph(NObj==Nest_NObj,'erode');
same_numb(Nest_Grid(1),Nest_Grid(2))=1 ;
Visual_Locale_size=1* bwmorph( bwselect(same_numb,Nest_Grid(2),Nest_Grid(1),8),'dilate') ;
Size=X_Step*Y_Step*sum(sum(Visual_Locale_size)); 


% Calcul du nbr de locales
% tte foireuse...
function[NumLoc]=Get_Num_Loc(obj,NumObj)
NumLoc=0;
for Num=0:size(obj,1)
    KindOfLocale=(NumObj==Num);
    [Labels,NumThisKind] = bwlabel(KindOfLocale,8);
    NumLoc=NumLoc+NumThisKind ;
end

function[NumLoc]=Get_Num_Loc_2(obj,NumObj)
ThinEdges=edge(NumObj,'roberts',0.1);
ThickEdges = ~bwmorph(ThinEdges,'dilate');
[Labels,NumLoc] = bwlabel(ThickEdges,8);

% load('C:\Temp\Desmottes\Env_15Obj_1_Monitor', 'X_Alv', 'Y_Alv')
% figure(30)
% hold off ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on ;
% pcolor(X_Alv,Y_Alv,NumObj) ;
% shading flat;
% hold off
% 
% figure(31)
% hold off ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on ;
% pcolor(X_Alv,Y_Alv,1*ThinEdges) ;
% shading flat;
% hold off
% 
% figure(32)
% hold off ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on ;
% pcolor(X_Alv,Y_Alv,1*ThickEdges) ;
% shading flat;
% hold off


function[MeanChangeNumObjSeen,AverageHomewardComp,AHC_Dist,AHC_Loc]...
    =Data_Within_Catch(nest,nest_grid,X,Y,mx,my,NumObj,HomewardComp)

[I,J]=meshgrid(1:size(X)) ;
I=I-nest_grid(1)*ones(size(X)) ;
J=J-nest_grid(2)*ones(size(X)) ;
Grid_Distance=round(sqrt(I.^2+J.^2)) ;
%####*(X_Alv(1,2)-X_Alv(1,1)) ;

% Initializations
NumSteps=NaN(size(X)) ;
ChangeNumObjSeen=NaN(size(X)) ;
AverageHomewardComp=NaN(size(X)) ;
AHC_Dist=[]; %%attention 1ere case => dist = 0 
AHC_Dist_pond=[] ;
AHC_Loc=[] ; %%attention 1ere case => locale inchangee = 0
AHC_Loc_pond=[] ;

% Initialize Fifo with each grid point within the nest area
Fifo = [];

% Initialize the catchment area to the area covered by the nest
% Radius of the nest expressed as a number of grid interval
r = round(nest(3)/(Y(2)-Y(1)));
for i=-r:r
    for j=-r:r
         if( (X(1,nest_grid(1)+i)-nest(1))^2 + ...
             (Y(nest_grid(2)+j,1)-nest(2))^2 <= nest(3)^2  )
            % ### WARNING ### See comment below
            Fifo = [Fifo ; [nest_grid(2)+j nest_grid(1)+i] ] ;
            NumSteps(nest_grid(2)+j,nest_grid(1)+i)=0;
            ChangeNumObjSeen(nest_grid(2)+j,nest_grid(1)+i)=0;
            AverageHomewardComp(nest_grid(2)+j,nest_grid(1)+i)=0;
         end
    end
end

while size(Fifo,1) > 0
    Local = Fifo(1,:) ; 
    for i=-1:1
        for j=-1:1
           Neighbour = Local + [i j] ;
           if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
               -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
               & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
               % ### WARNING ### vector (i,j) is expected to be the
               % vector from the Local box to the neighbour but since 
               % the data organisation is different between the array 
               % and the image (NE-SW symetry)
               % i and j have thus been switched to cope with this problem                   
               if (   mx(Neighbour(1),Neighbour(2))~=0 ... 
                    | my(Neighbour(1),Neighbour(2))~=0 )
                   if ( (mx(Neighbour(1),Neighbour(2))*j+my(Neighbour(1),Neighbour(2))*i)/ ... 
                        (sqrt(mx(Neighbour(1),Neighbour(2))^2+my(Neighbour(1),Neighbour(2))^2) ...
                        *sqrt(i^2+j^2))<=(-cos(pi/8)+10^(-15)))
                       %need to add 10^-15 to solve some strange
                       %approximation problems
                       
                       ObjSeenChanges = NumObj(Local(1),Local(2))-NumObj(Neighbour(1),Neighbour(2))~=0 ;
                       ChangeNumObjSeen(Neighbour(1),Neighbour(2)) = ChangeNumObjSeen(Local(1),Local(2)) + ObjSeenChanges ;
                       
                       AverageHomewardComp(Neighbour(1),Neighbour(2)) = AverageHomewardComp(Local(1),Local(2)) + HomewardComp(Neighbour(1),Neighbour(2));
                       
                       NumSteps(Neighbour(1),Neighbour(2)) = NumSteps(Local(1),Local(2)) + 1 ;
                       Fifo = [Fifo;Neighbour];
                   end
               end
           end
        end 
    end
  
    tmp=Grid_Distance(Local(1),Local(2))+1;
    if( size(AHC_Dist,2) < tmp )
        AHC_Dist( tmp ) = HomewardComp(Local(1),Local(2)) ;
        AHC_Dist_pond( tmp ) = 0 ;
    else
        if ( isnan(HomewardComp(Local(1),Local(2))) )
            AHC_Dist(tmp)=AHC_Dist(tmp)+1 ;
        else
            AHC_Dist(tmp)=AHC_Dist(tmp)+HomewardComp(Local(1),Local(2));
        end
        AHC_Dist_pond(tmp)=AHC_Dist_pond(tmp)+1 ;
    end
    tmp=ChangeNumObjSeen( Local(1),Local(2) ) + 1;
    if( size(AHC_Loc,2) < tmp )
        AHC_Loc( tmp ) = HomewardComp(Local(1),Local(2)) ;
        AHC_Loc_pond( tmp ) = 0 ;
    else
        if ( isnan(HomewardComp(Local(1),Local(2))) )
            AHC_Loc(tmp)=AHC_Loc(tmp)+1 ;
        else
            AHC_Loc(tmp)=AHC_Loc(tmp)+HomewardComp(Local(1),Local(2));
        end
        AHC_Loc_pond(tmp)=AHC_Loc_pond(tmp)+1 ;
    end
    
    AverageHomewardComp(Local(1),Local(2))=AverageHomewardComp(Local(1),Local(2))/(NumSteps(Local(1),Local(2))+1);
    Fifo(1,:) = [] ;
end

AHC_Dist = AHC_Dist./( AHC_Dist_pond+1 ) ;
AHC_Loc  = AHC_Loc./( AHC_Loc_pond+1 );

MeanChangeNumObjSeen=sum(nansum(ChangeNumObjSeen))/sum(sum(~isnan(ChangeNumObjSeen))) ;


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
                Aim_x=(abs(mx(Local_x,Local_y)/sqrt(mx(Local_x,Local_y)^2+my(Local_x,Local_y)^2))>cos(3*pi/8))*sign(mx(Local_x,Local_y)) ;
                Aim_y=(abs(my(Local_x,Local_y)/sqrt(mx(Local_x,Local_y)^2+my(Local_x,Local_y)^2))>sin(pi/8))*sign(my(Local_x,Local_y)) ;
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
Trap_Area_Grid=sum(sum(Trap));
Trap_Area=Trap_Area_Grid*(X(1,2)-X(1,1))*(Y(2,1)-Y(1,1));

tmp = bwmorph(Trap,'dilate',4);
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