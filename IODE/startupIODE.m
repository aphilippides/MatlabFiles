% $Id: startup.m,v 1.18 2003-02-04 09:16:51-06 brinkman Exp $
% startup.m: init file for matlab and iode

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (http://www.gnu.org/copyleft/gpl.html).

global isoctave;
global ismatlab;
global numtol;

numtol=10^-12;	% numerical tolerance; values less than numtol will be
				% treated as zero

isoctave=0;
ismatlab=1;

warning off;

try
	eval('rehash toolboxcache');	% avoid trouble with toolbox cache
									% in heterogenous networks
end
