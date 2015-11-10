function[obj,nest,EnvSize,fac_awidth,SideEffectWidth]=Create_And_Save_Env( ...
    FileName, ...
    Load_Environment_Only, ...
    Load_Env_And_Computed_Parameters, ...
    Save_Env_And_Computed_Parameters, ...
    nest, EnvSize, Num_obj, Obj_size )

if ( Load_Environment_Only | Load_Env_And_Computed_Parameters )
    load(FileName) ;
else
    %%%%%% Maybe useless, reset the random seed
    rand('state',sum(100*clock));

    obj = RndEnvironment(Num_obj,[1 EnvSize],Obj_size,nest,1);

    if(obj(1,3)<0)
        disp('too many objects***\n');
    end
end

if ( ~Load_Env_And_Computed_Parameters )
    %%%%%% Determine the part of the environment where there will be no
    % side effect
    BigestObject = max(obj(:,3)) ;

    % Poorly implemented, for if this value is changed in LincVision.m, it
    % will need to be changed here too
    fac_awidth = 2*pi/90;
    SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;

    % return and display an error message whenever the "no-side-effect"
    % area is empty
    if  (EnvSize< 2*SideEffectWidth)
        disp('Environment too small or objects too wide\n');
        return;
    end

    if ( Save_Env_And_Computed_Parameters )
        save(FileName,'obj','nest','EnvSize','fac_awidth','SideEffectWidth') ;
    end
end