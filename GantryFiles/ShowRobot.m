function ShowRobot

dmat
cd ..\Gantry\VolSig1\Data\Test
fid=fopen('arena.dat');
a=fscanf(fid,'%f, \n')';
ht=a(3);
wid=a(2);
b=[0 0;a(2) 0;a(2) ht;0 ht;0 0];
plot(b(:,1),b(:,2));
hold on;
a=fscanf(fid,'%f, \n')';
plot(a(2:5),[ht ht+10 ht+10 ht])
a=fscanf(fid,'%f, \n')';
plot(a([2,4,3]),[ht ht+10 ht])
fclose(fid);
h=load('RobotPos.dat');
plot(h(:,2),h(:,3));
hold off
axis([-5 wid+5 -5 ht+15]);