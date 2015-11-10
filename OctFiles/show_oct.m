function show_oct()

starty=0.0;
wid=15;
hwid=wid/2.0;
startx=-hwid;
length=39.0;
NUM_LEGS = 1;
LEG_PARAMS = 5;
filename =['octpos.dat'];
eval(['load ' filename ' -ascii;'])
[ITERS,PARAMS]=size(octpos);
side1=starty:(length)/(NUM_LEGS/2-1):length+starty
side2=length+starty:(-length)/(NUM_LEGS/2-1):starty
base=ones(1,4)*hwid;
pivot=[[-base base];[side2 side1]]';
centre_x=octpos(:,1);
centre_y=octpos(:,2);
centre_height=octpos(:,3);
clf
for i=1:NUM_LEGS
   eval(['leg' int2str(i) ' =[];']);
   for j=1:LEG_PARAMS
      3+LEG_PARAMS*(i-1)+j;
      temp = octpos(:,3+LEG_PARAMS*(i-1)+j);
      eval(['leg' int2str(i) ' =[[leg' int2str(i) '],[temp]];']);
   end
end
hold off;
R=10;
   j=100;

while((R~=0)&(j<=ITERS))
   % draw body
   line([-7.5 -7.5 7.5 7.5 -7.5],[starty starty+length starty+length starty starty]) 	
      for i=1:NUM_LEGS
   	eval(['x=leg' int2str(i) '(:,1);']);
   	eval(['y=leg' int2str(i) '(:,2);']);
%   plot(x,y)
	%	keyboard
X=[pivot(i,1),x(j)];
Y=[pivot(i,2),y(j)];      
plot(X,Y,'-*')
     hold on;
end
axis([-15 15 -5 45])
hold off
   j=j+1;
   R=input('0 to quit \n');
end
hold off;

%plot(centre_x,centre_y,'-x');

for j=1:80
   for i=1:NUM_LEGS
   	eval(['x=leg' int2str(i) '(:,1);']);
   	eval(['y=leg' int2str(i) '(:,2);']);
%   plot(x,y)
%  hold on;
%keyboard
	      %lsline([pivot(i,1),x(j)],[pivot(i,2),y(j)]);      
 %     plot(x(j),y(j),'*')
%      hold on;
   end
   %plot(centre_x(i),centre_y(i),'x');
   %axis([-30 30 -30 30]);
   %pause(.25);
end

