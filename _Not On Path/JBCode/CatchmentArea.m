%%%%%%  This function builds or loads an environment and examines how the ALV model
%manages in the whole area, giving the possibility to plot the homing
%vector for each point of the grid and the real catchment area ( places from
%which the model ant manages to reach the nest).
%  This model tries to free ourselves from the side effects usually caused
%by the absence of landmark appearance at the edge of the area. To compare
%this method with the simple one, just set Check at the value 1


function CatchmentArea( FileName, Save_Figures, Load_Environment_Only,...
                        Load_Env_And_Computed_Parameters,...
                        Save_Env_And_Computed_Parameters, Monitor,...
                        Display_Figures, do_alv, AlvMeshPitch,...
                        Check_Side_Effect, Alv_NumAverage, Alv_Norm, do_rmse,...
                        RmsMeshPitch, nest, EnvSize, Num_obj, Obj_size )

if(nargin<18) 
    %%%%%% Parameters
    FileName = 'C:\Temp\Desmottes\Env_35Obj_5' ; %ALV_and_RMSE\Test26

    Save_Figures = 0 ;
    Load_Environment_Only = 0 ;
    Load_Env_And_Computed_Parameters = 1 ;
    Save_Env_And_Computed_Parameters = 0 ;
    Monitor = 0 ;
    Display_Figures = 1 ;

    do_alv = 1;
    AlvMeshPitch = 2 ;
    Check_Side_Effect = 0 ;
    Alv_NumAverage = 0 ;
    Alv_Norm = 0; %### WARNING ###% (see Do_ALV)

    do_rmse = 0 ;
    RmsMeshPitch = 5 ;
    
    nest = [500 500 8];
    Num_obj = 50 ;
    EnvSize = 1000 ;
    Obj_size = 10 ;  
end

% close all ;
%%%%% Load or create the environment, and save it if asked to.
[obj,nest,EnvSize,fac_awidth,SideEffectWidth]=Create_And_Save_Env( ...
    FileName, ...
    Load_Environment_Only, ... 
    Load_Env_And_Computed_Parameters, ... 
    Save_Env_And_Computed_Parameters | Monitor, ...
    nest, EnvSize, Num_obj, Obj_size );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALV model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses figures 1 to 8
if (do_alv)
    
    [X_Alv,Y_Alv]=meshgrid([SideEffectWidth:AlvMeshPitch:EnvSize-SideEffectWidth]);
    
    %%%%% Compute the nest ALV vector and ALV vector and number of
    % objects seen from each point of the grid.
    [NObj,mx_Alv,my_Alv,HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv]= ...
        Do_ALV(X_Alv,Y_Alv,obj,nest,Alv_NumAverage,Alv_Norm);

    %%%%% Plot data
    if ( Save_Figures | Display_Figures )
        Plot_ALV( 1,2,3,4,strcat(FileName,'_NoSE'), X_Alv,Y_Alv, ...
                  obj,nest,fac_awidth,SideEffectWidth,NObj,mx_Alv,my_Alv, ...
                  HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv,Save_Figures) 
    end

    if(Monitor)

% %%%% Patch used to save the data from other model of vision (Edge, Facet
% or Perfect) instead of the next 9 lines %%%%
%                     File_Monitor=strcat(FileName,'_Perfect_Monitor.mat');
%                     NObj_Perfect=NObj;
%                     mx_Perfect=mx_Alv;
%                     my_Perfect=my_Alv;
%                     HomewardComp_Perfect=HomewardComp;
%                     PerfectNumSteps=AlvNumSteps;
%                     trapx_Perfect=trapx_Alv;
%                     trapy_Perfect=trapy_Alv;
%                     save( File_Monitor,'NObj_Perfect',...
%                                        'mx_Perfect',...
%                                        'my_Perfect', ...
%                                        'HomewardComp_Perfect',...
%                                        'PerfectNumSteps',...
%                                        'trapx_Perfect',...
%                                        'trapy_Perfect');
 
        File_Monitor=strcat(FileName,'_Monitor.mat');
        if (exist(File_Monitor))
%#######%probably no need of trapx & trapy which are only the positions
%where homing vector is null, and thus do not take into account other kinds
%of false minima
            save( File_Monitor,'X_Alv','Y_Alv','NObj','mx_Alv','my_Alv', ...
                  'HomewardComp','AlvNumSteps','trapx_Alv','trapy_Alv','-append');
        else
            save( File_Monitor,'X_Alv','Y_Alv','NObj','mx_Alv','my_Alv', ...
                  'HomewardComp','AlvNumSteps','trapx_Alv','trapy_Alv');
        end
    end
    
    %%%%% Check without removing side effects if == 1 ; plot and save
    % the same figures but in other windows
    if(Check_Side_Effect)
        
        %%%%% Withdraw objects outside the "no-side-effect" area
        ObjSE=obj;
        ObjSE(find(ObjSE(:,1)<SideEffectWidth),:)=[];
        ObjSE(find(ObjSE(:,2)<SideEffectWidth),:)=[];
        ObjSE(find(ObjSE(:,1)>EnvSize-SideEffectWidth),:)=[];
        ObjSE(find(ObjSE(:,2)>EnvSize-SideEffectWidth),:)=[];

        %%%%% Compute the nest ALV vector and ALV vector and number of
        % objects seen from each point of the grid.
        [NObjSE,mx_Alv_SE,my_Alv_SE,HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE]= ...
            Do_ALV(X_Alv,Y_Alv,ObjSE,nest,Alv_NumAverage,Alv_Norm);
        
        if ( Save_Figures | Display_Figures )
            %%%%% Plot data
            Plot_ALV( 5,6,7,8,strcat(FileName,'_SE'), X_Alv,Y_Alv,ObjSE,nest, ...
                      fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
                      HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,Save_Figures) 
        end
        
        if(Monitor)
            File_Monitor=strcat(FileName,'_Monitor.mat');
            if (exist(File_Monitor))
%#######%probably no need of trapx & trapy which are only the positions
%where homing vector is null, and thus do not take into account other kinds
%of false minima
                save( File_Monitor,'X_Alv','Y_Alv','ObjSE','NObjSE', ...
                      'mx_Alv_SE','my_Alv_SE','HomewardCompSE','AlvNumStepsSE', ...
                      'trapx_Alv_SE','trapy_Alv_SE','-append');
            else
                save( File_Monitor,'X_Alv','Y_Alv','ObjSE','NObjSE', ...
                      'mx_Alv_SE','my_Alv_SE','HomewardCompSE','AlvNumStepsSE', ...
                      'trapx_Alv_SE','trapy_Alv_SE');
            end
        end
        
    end
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALV model END %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rms error model %%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses figures 9 to 11
if (do_rmse)
   
    [X_RmsE,Y_RmsE]=meshgrid([SideEffectWidth:RmsMeshPitch:EnvSize-SideEffectWidth]);
    
    %%%%% Compute the rms error at each point of the grid and compute
    % the homing vectors. The rms error is localy averaged with the eight
    % neighbours
    [RmsE,mx_RmsE,my_RmsE,RmsENumSteps,trapx_RmsE,trapy_RmsE]=...
        Do_RmsE(X_RmsE,Y_RmsE,obj,nest);
    
    %%%%% Plot data
    if ( Save_Figures | Display_Figures )
        Plot_RmsE( 9,10,11,FileName, X_RmsE,Y_RmsE,obj,nest,fac_awidth, ... 
                   SideEffectWidth,mx_RmsE,my_RmsE, RmsE,RmsENumSteps, ...
                   trapx_RmsE,trapy_RmsE,Save_Figures) 
    end
    
    if(Monitor)
        File_Monitor=strcat(FileName,'_Monitor.mat');
        if (exist(File_Monitor))
%#######%probably no need of trapx & trapy which are only the positions
%where homing vector is null, and thus do not take into account other kinds
%of false minima
            save( File_Monitor,'X_RmsE','Y_RmsE','RmsE','mx_RmsE', ...
                  'my_RmsE', 'RmsENumSteps','trapx_RmsE','trapy_RmsE','-append');
        else
            save( File_Monitor,'X_RmsE','Y_RmsE','RmsE','mx_RmsE', ...
                  'my_RmsE', 'RmsENumSteps','trapx_RmsE','trapy_RmsE');
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rms error model END %%%%%%%%%%%%%%%%%%%%%%%%%%