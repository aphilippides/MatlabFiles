function fixaxes(ax)
% function fixaxes(ax)
%
% $Id: fixaxes.m,v 1.20 2003-01-05 14:43:15-06 brinkman Exp $
% (c) 2002, Peter Brinkmann (brinkman@math.uiuc.edu)
%
% fixaxes: Clears the plot window and initializes it in such a way
%	that both Octave and Matlab treat axes in the same way
%
% Parameters:
%	ax: Parameter for 'axis' function; see 'help axis'
%
% fixaxes does the following:
%	- it clears the plot window
%	- it issues the 'hold on' command, and
%	- it calls 'axis' with the desired parameters and makes sure
%		that Matlab obeys
%
% Many thanks to Ben Langhals for solving the labeling problem!

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (http://www.gnu.org/copyleft/gpl.html).

	global ismatlab;
	global isoctave;

	if isoctave
		cla;
		axis(ax);
		hold on;
	elseif ismatlab
		cla;

		% The following lines are a hack around a labeling bug
		% of Matlab. The eval statements are necessary because
		% Octave 2.0.16 won't read this file without them.
		eval('a=get(gca,{''Title'',''XLabel'',''YLabel'',''ZLabel''});');
		eval('delete(a{:});');

		axis(ax);
		hold on;
	end

