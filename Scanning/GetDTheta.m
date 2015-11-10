function d_thet=GetDTheta(theta);
d_thet(1)=0;
for i=1:(length(theta)-1)
	d_thet(i+1) = ang_diff(theta(i+1),theta(i));
	
	
end
%-------------------
function diff=ang_diff(th1,th2)
diff=abs(th1-th2);
if (diff>pi);
    diff=abs(diff-(2*pi));
end