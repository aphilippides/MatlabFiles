function M=haykthresh(A,ll,ul)

% M=haykthresh(A,ll,ul)
%
%  this used to be called thresh but that interfered with my programs so I
%  renamed it haykthresh
%
%  a little routine that thresholds a matrix or vector with 
%  a lower limit (ll) and an upper limit (ul)
%
%  Hugh Pasika 1996

M = (A<ll)*ll + (A>ul)*ul + (A>=ll & A<=ul).*A;


