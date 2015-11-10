% Function used to draw a positivie elec link in a gas net
% Uses a parabola between the points governed by the last parameter

function PosLink(x1,y1,x2,y2,off)

NumPts = 20; %number of points in the parabola
offset =4;
%off=0.2*sqrt((x1-x2)^2+(y1-y2)^2)
X=0:1/NumPts:1;
Y=polyval([1 -1 0],X)*-4*off; 	%generates a quadratic bet 0 and 1, max: off
if(abs(y1-y2)<0.001)			% if y's are equal
   U=X*(x2-x1)+x1;
   Y=Y+y1;
   plot(U,Y);
   plot(U(NumPts+2-offset),Y(NumPts+2-offset),'>') % plot end symbols   
elseif(abs(x1-x2)<0.001)		%if x's are equal
   U=Y+x1;
   Y=X*(y2-y1)+y1;
   plot(U,Y);
   plot(U(NumPts+2-offset),Y(NumPts+2-offset),'>')  % plot end symbols
else
   Yx=y1:(y2-y1)/NumPts:y2;
   U=X*(x2-x1)+x1;
   Y=Y+Yx;
   plot(U,Y);
  	plot(U(NumPts+2-offset),Y(NumPts+2-offset),'>') % plot end symbols
end
