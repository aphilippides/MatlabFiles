function cal = SetGamma(cal,gammaMode,precision)% cal = SetGamma(cal,gammaMode,[precision])%% Old name for SetGammaMethod.%% 3/12/98  dhb  Wrote it.if (nargin == 2)	cal = SetGammaMethod(cal,gammaMode);else	cal = SetGammaMethod(cal,gammaMode,precision);end