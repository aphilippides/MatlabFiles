% Function used to draw a positivie elec link in a gas net
% Uses a parabola between the points governed by the last parameter

function ChemLink(x1,y1,x2,y2,off)

NumPts = 20; %number of points in the parabola
offset = 5;
xmid = (x1+x2)/2;
ymid = (y1+y2)/2;
if(abs(x1-x2)<0.001)
   Y=y1:(y2-y1)/NumPts:y2;
   X=ones(1,length(Y))*x1;
else
   m = (y2-y1)/(x2-x1);
   X=x1:(x2-x1)/NumPts:x2;
   c=y1-m*x1;
   Y=X*m+c;
end
plot(X,Y,'g--');  

% plot start symbols
%plot(X(offset),Y(offset),'gs')
plot(X(NumPts+2-offset),Y(NumPts+2-offset),'g>')
%plot(X(NumPts/2),Y(NumPts/2),'x')
