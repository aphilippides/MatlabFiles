function f=cosef(ww,x,i)
% function f=cosef(ww,x,i)
%
% $Id: cosef.m,v 1.14 2003-06-22 01:02:05-05 brinkman Exp $
% (c) 2002, Peter Brinkmann (brinkman@math.uiuc.edu)
%
% cosef: an implementation of the interface for eigenfunctions suitable
%	for use with coeff.m
%
% Note that these eigenfunctions do _not_ need to be normalized because
% the module coeff.m takes care of this.
%
% Usage: ef=cosef(2,linspace(0,pi,30),3);
%
% Parameters:
%   ww: square root of eigenvalue or column vector of roots of eigenvalues
%   x: scalar, or row vector or matrix of x-values
%   i: index or column vector of indices indicating the location of the
%		entry or entries of ww in the list of all eigenvalues
%
% In order to conform to the interface for eigenfunctions, a function must
% return a meaningful value whenever the product ww*x is defined. This is
% the case
%	- if ww is a scalar and x is anything, or
%	- if x is a scalar and ww is anything, or
%	- if both ww and x are vectors.
% Note that in the third case, the product ww*x is the outer product of two
% vectors. When writing rather basic eigenfunctions that only depend on the
% product ww*x, this will not concern you. However, when writing a
% sophisticated function whose result doesn't just depend on ww*n but on
% the index i as well, then you need to make sure that the outer product
% case is handled correctly. See the file periodicef.m for an example of
% how to deal with outer products.
%
% Return values:
%   f: cos(ww*x)

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (http://www.gnu.org/copyleft/gpl.html).

	f=cos(ww*x);
