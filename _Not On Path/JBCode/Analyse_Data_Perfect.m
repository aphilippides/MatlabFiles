function Analyse_Data_Perfect(FileName)

if(nargin<1)
    FileName = 'C:\Temp\Desmottes\Env_15Obj_5' ;
end
    
load(FileName);
% LOADED :
%   EnvSize    SideEffectWidth    fac_awidth    nest   obj            

DataFileName = strcat(FileName, '_Monitor') ;
load(DataFileName);
% LOADED :
%   X_Alv       Y_Alv       NObj    mx_Alv   my_Alv   HomewardComp   AlvNumSteps
%   trapx_Alv   trapy_Alv 

%   ObjSE           NObjSE         mx_Alv_SE       my_Alv_SE   HomewardCompSE
%   AlvNumStepsSE   trapx_Alv_SE   trapy_Alv_SE  
%...

DataFileName2 = strcat(FileName, '_Perfect_Monitor') ;
load(DataFileName2);
% LOADED :
%   mx_Perfect     my_Perfect     HomewardComp_Perfect      PerfectNumSteps


% Plot_ALV( 31,32,33,34,'tmp',X_Alv,Y_Alv, ...
%                   obj,nest,fac_awidth,SideEffectWidth,NObj,mx_Alv,my_Alv, ...
%                   HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv,0) 
% Plot_ALV( 35,36,37,38,'tmp',X_Alv,Y_Alv, ...
%                   obj,nest,fac_awidth,SideEffectWidth,NObj_Perfect,mx_Perfect,my_Perfect, ...
%                   HomewardComp_Perfect,PerfectNumSteps,trapx_Perfect,trapy_Perfect,0) 
% ;
% 
% figure(34)
% hold off
% DrawEnvironment(obj,nest) ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on
% pcolor(X_Alv,Y_Alv,AlvNumSteps) ;
% shading flat;
% hold on
% plot(Y_Alv(trapy_Alv,1),X_Alv(1,trapx_Alv),'Xk');
% hold off
% 
% figure(38)
% hold off
% DrawEnvironment(obj,nest) ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on
% pcolor(X_Alv,Y_Alv,PerfectNumSteps) ;
% shading flat;
% hold off
% 
% tmp=~isnan(AlvNumSteps)-~isnan(PerfectNumSteps);
% tmp(1)=1;
% tmp(2)=-1;
% 
% figure(39)
% hold off
% DrawEnvironment(obj,nest) ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on
% pcolor(X_Alv,Y_Alv,tmp) ;
% shading flat;
% hold off



% Find the position of the nest in the mesh grid
Nest_Grid_Alv=Find_Nest_Grid(X_Alv,Y_Alv,nest);
 
Catch_Size_Perfect = Get_Catch_Size(PerfectNumSteps,X_Alv(1,2)-X_Alv(1,1),Y_Alv(2,1)-Y_Alv(1,1));
Catch_Env_Ratio_Perfect=Catch_Size_Perfect/(EnvSize - 2*SideEffectWidth)^2 ;

File_Analysis=strcat(FileName,'_Perfect_Analyse.mat');
if (exist(File_Analysis))
    save( File_Analysis,...
                'Catch_Env_Ratio_Perfect' ,...
           '-append');
else
    save( File_Analysis,...
                'Catch_Env_Ratio_Perfect');
end


function[Size]=Get_Catch_Size(NumSteps,X_Step,Y_Step)
Bin_Catch_Area=1*~isnan(NumSteps);
Size=X_Step*Y_Step*sum(sum(Bin_Catch_Area));
  

% Find the position of the nest in the mesh grid
function[Nest_Grid]=Find_Nest_Grid(X,Y,nest)
Nest_Grid(1)= find( abs(X(1,:)-nest(1))<= (X(1,2)-X(1,1))/2) ;
Nest_Grid(2)= find( abs(Y(:,1)-nest(2))<= (Y(2,1)-Y(1,1))/2) ;