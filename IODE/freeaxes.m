function freeaxes
% function freeaxes
%
% $Id: freeaxes.m,v 1.10 2002-12-26 13:54:46-06 brinkman Exp $
% (c) 2002, Peter Brinkmann (brinkman@math.uiuc.edu)
%
% freeaxes: Clears the plot and enables autoscaling in a way
%		that works for both Octave and Matlab

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (http://www.gnu.org/copyleft/gpl.html).

	global ismatlab;
	global isoctave;

	if ismatlab
		hold off;
		cla;

		% The following lines are a hack around a labeling bug
		% of Matlab. The eval statements are necessary because
		% Octave 2.0.16 won't read this file without them.
		eval('a=get(gca,{''Title'',''XLabel'',''YLabel'',''ZLabel''});');
		eval('delete(a{:});');

		eval('axis auto;');
	elseif isoctave
		hold off;
		cla;
		axis;
	end

