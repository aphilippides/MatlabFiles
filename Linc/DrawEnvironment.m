function DrawEnvironment(NewObj,Objects)
for i=1:size(NewObj,1)
    MyCircle(NewObj(i,[1 2]),NewObj(i,3),'g')
    hold on;
end
for i=1:size(Objects,1)
    MyCircle(Objects(i,[1 2]),Objects(i,3),'r')
end
hold off
