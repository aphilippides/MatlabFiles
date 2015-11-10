function f=hat(x,a,b)
% function f=hat(x,a,b)
%
% $Id: hat.m,v 1.3 2002-12-21 17:38:39-06 brinkman Exp $
% (c) 2001, Peter Brinkmann (brinkman@math.uiuc.edu)
%
% hat: returns 1 for a<x<b, 0 otherwise
%
% Note: This only makes sense for a<b, but hat does _not_ check this.

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (http://www.gnu.org/copyleft/gpl.html).

	f=(x>a).*(x<b);
