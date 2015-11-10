function [y,a] = Ang_iqr(x,med)
% Ang_IQR Interquartile range. 
%   Y = IQR(X) returns the interquartile range of the values in X.  For
%   vector input, Y is the difference between the 75th and 25th percentiles
%   of X.  For matrix input, Y is a row vector containing the interquartile
%   range of each column of X.  For N-D arrays, IQR operates along the
%   first non-singleton dimension.
%
%   The IQR is a robust estimate of the spread of the data, since changes
%   in the upper and lower 25% of the data do not affect it.
%
%   IQR(X,DIM) calculates the interquartile range along the dimension DIM
%   of X.
%
%   See also PRCTILE, STD, VAR.

%   Copyright A. Philippides, 29/03/2011. 

if nargin < 2
    med=circ_median(x);
end
a=Ang_prctile(x, med, [25; 75])
y = circ_dist(a(2),a(1));