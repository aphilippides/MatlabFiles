function gammaTable=GammaIdentity(windowPtrOrScreenNumber,bits)% gammaTable=GammaIdentity(windowPtrOrScreenNumber,[bits])%% Creates an identity gamma table with the specified precision.% The default value of "bits" is ScreenDacBits(windowPtrOrScreenNumber).% 7/21/98  dgp  Wrote it.% 8/26/98  dgp  Changed it to use same length as table obtained from driver.% 8/31/98  dgp  Fixed fatal bug introduced 8/26.% 6/13/02  dgp  Allow user to specify bits.if nargin<1 | nargin>2 | nargout>1	error('Usage:  gammaTable=GammaIdentity(windowPtrOrScreenNumber,[bits])');endif nargin<2	bits=ScreenDacBits(windowPtrOrScreenNumber);endgammaTable=[0:255]'*(2^bits-1)/255;