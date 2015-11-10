% Function which calculates the concentration at time t and distance d from a
% point source of NO in a 3D volume after an instantaneous burst 

function [concient2] = inst_3d(t,d)

global PT_3D_CONST;
global DIFF;
global LAM;
global OLD_STRENGTH
global HALF_SAT_TIME;
global SAT_TIME;
global STEEPNESS;
global STRE_DENOM;

if (OLD_STRENGTH==0)
	if (t>=SAT_TIME)
	concient2=PT_3D_CONST.*(exp(-(d.^2./(4.*DIFF*t)) - LAM.*t))./(t.^1.5);
	elseif (t>HALF_SAT_TIME)
	concient2=PT_3D_CONST.*(exp(-(d.^2./(4.*DIFF*t)) - LAM.*t)).*(1 - ((2-t./HALF_SAT_TIME).^STEEPNESS)./2)./(t.^1.5);
	else
	concient2=PT_3D_CONST.*(exp(-(d.^2./(4.*DIFF*t)) - LAM.*t)).*(t.^(STEEPNESS-1.5))./STRE_DENOM;
	end
else
concient2=PT_3D_CONST.*(exp(-(d.^2./(4.*DIFF*t)) - LAM.*t))./(t.^1.5);
end
