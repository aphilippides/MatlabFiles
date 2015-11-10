% N.B. Time in s, distance in microns

function GLOBES

global OLD_STRENGTH  % flag to say if square wave being used or not
OLD_STRENGTH = 1;

global SAT_TIME   % time to reach peak conc for point
SAT_TIME = 0.04;

global HALF_SAT_TIME   % half of SAT_TIME
HALF_SAT_TIME = 0.02;

global STEEPNESS     % power in smooth square wave
STEEPNESS = 3;

global STRE_DENOM   % denominator for smooth square wave
STRE_DENOM = (HALF_SAT_TIME.^STEEPNESS).*2;


global DIFF;
DIFF = 3300;   % Units: microns squared/sec

global LAM;  % N.B. LAM = ln(2)/half_life
LAM = 0.1386;

global STRENGTH_SEC;    % Strength/second is also implicitly /unit volume due 
			% to being a point source and thus integrated over a 
			% volume		     	
STRENGTH_SEC = 0.021;

global STRENGTH_VOLSEC  % Strength/vol/sec in microns: to be used in integrals
STRENGTH_VOLSEC = 0.04;

global RING_CONST;
RING_CONST = STRENGTH_VOLSEC./(2.*DIFF);

global L2D_CONST;
L2D_CONST = STRENGTH_SEC./(4.*DIFF.*pi);

global L1D_CONST;
L1D_CONST = STRENGTH_SEC./(2.*((DIFF.*pi).^0.5));

global PT_3D_CONST;
PT_3D_CONST = STRENGTH_SEC./(8.*((DIFF.*pi).^1.5));

global SPHERE_CONST;
SPHERE_CONST = STRENGTH_VOLSEC./(2.*((DIFF.*pi).^0.5));

global SPHERE_CONST2;
SPHERE_CONST2 = STRENGTH_VOLSEC.*sqrt((DIFF./pi));

global RISE;
global FALL;
global RISE_STEEP;
global FALL_STEEP;

RISE = 0.025;
FALL = 0.025;
RISE_STEEP = 3;
FALL_STEEP = 6;
