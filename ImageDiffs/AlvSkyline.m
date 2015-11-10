function AlvSkyline(skylines)
load skylines
skylines=round(imresize(m,[66 360]));
skylines=round((skylines-min(skylines(:)))/10);
[ALVgoal]=getALVfromIM(skylines(35,:));
[GoalX,GoalY]=pol2cart(ALVgoal(1),ALVgoal(2));

for i=1:size(skylines,1)
i
   [ALVcurrent(i,:)]=getALVfromIM(skylines(i,:));
   [X,Y]=pol2cart(ALVcurrent(1),ALVcurrent(2));

       VectorDiff(i) = sqrt( ((X-GoalX)^2) + ((Y-GoalY)^2) );

       [dALV(1),dALV(2)]=cart2pol((X-GoalX),(Y-GoalY));
    Movement_angle(i)=dALV(1);
    Movement_r(i)=dALV(2);

end%i
keyboard
% figure;plot(VectorDiff)
% figure;plot(Movement_angle)
% figure;hold on;axis equal;
% quiver([1:1:66],ones(1,66),Movement_r.*cos(Movement_angle),Movement_r.*sin(Movement_angle));

%--------------------------------------------------
function [ALV]=getALVfromIM(elevation);
a1=2*pi/length(elevation);
angs=[1:length(elevation)]*a1;
lms=[];
for j=1:length(elevation)
       if elevation(j)>1;lms=[lms, ones(1,elevation(j))*j];end
end

[ALV(1),ALV(2)] = angular_mean(angs(lms));

%---------------------------------------------
   function [theta,r] = angular_mean(angles)
       x_array = cos(angles);
       y_array = sin(angles);
       x = mean(x_array);
       y = mean(y_array);
       %x=notzero(x);
       theta=cart2pol(x,y);
       r = sqrt(x^2+y^2);