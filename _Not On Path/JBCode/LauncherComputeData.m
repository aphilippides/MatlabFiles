function LauncherComputeData

FileNameRoot = 'C:\Temp\Desmottes\Env_' ;

Save_Figures = 0 ;
Load_Environment_Only = 0 ;
Load_Env_And_Computed_Parameters = 1 ;
Save_Env_And_Computed_Parameters = 0 ;
Monitor = 1 ;
Display_Figures = 0 ;

do_alv = 1;
AlvMeshPitch = 2 ;
Check_Side_Effect = 0 ;
Alv_NumAverage = 0 ;
Alv_Norm = 0;

do_rmse = 0 ;
RmsMeshPitch = 5 ;

nest = [500 500 8];
EnvSize = 1000 ;
Obj_size = 10 ;

for i = 15:5:50
    FileNameRoot2=strcat(strcat(FileNameRoot,sprintf('%d',i)),'Obj_');
    Num_obj = i ;
    
    for j = 2:7:50
        [i j]
        FileName=strcat(FileNameRoot2,sprintf('%d',j));

%         CatchmentArea( FileName, Save_Figures, Load_Environment_Only,...
%                Load_Env_And_Computed_Parameters,...
%                Save_Env_And_Computed_Parameters, Monitor,...
%                Display_Figures, do_alv, AlvMeshPitch,...
%                Check_Side_Effect, Alv_NumAverage, Alv_Norm, do_rmse,...
%                RmsMeshPitch, nest, EnvSize, Num_obj, Obj_size );
        
%         Analyse_Data_Old(FileName,20,21);

%         Analyse_Data_Alv(FileName,20,21);

%         Analyse_Data_Rms(FileName,20,21);

%         Analyse_Data_Edge(FileName);

%         Analyse_Data_Facet(FileName);

%         Analyse_Data_Perfect(FileName);

    end
end