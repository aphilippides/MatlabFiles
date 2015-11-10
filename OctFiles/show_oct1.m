function show_oct1(a,b)

START_ITER=140;
starty=0.0;
wid=15;
hwid=wid/2.0;
startx=hwid;
length=39.0;
NUM_LEGS = 1;
LEG_PARAMS = 6;
filename =['octpos.dat'];
eval(['load ' filename ' -ascii;'])
[ITERS,PARAMS]=size(octpos);
side1=starty:(length)/(NUM_LEGS/2-1):length+starty
%side2=length+starty:(-length)/(NUM_LEGS/2-1):starty
%base=ones(1,4)*hwid;
%pivot=[[-base base];[side2 side1]]';
pivot=[0;0]
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
j= START_ITER; % when to start watching

while((R~=0)&(j<=ITERS-START_ITER))  
   subplot(1,2,1)
   % draw body
   line([(hwid+centre_x(j)) (hwid+centre_x(j))],[centre_y(j)-15 centre_y(j)+15]) 
   hold on;
   plot(centre_x(j), centre_y(j),'ro');
   i=1;			% leg number
   eval(['x=leg' int2str(i) '(:,1);']);
   eval(['y=leg' int2str(i) '(:,2);']);
   eval(['ud=leg' int2str(i) '(:,3);']);
   eval(['bf=leg' int2str(i) '(:,4);']);
eval(['ht=6-leg' int2str(i) '(:,5);']);
eval(['up=leg' int2str(i) '(:,6);']);
%   plot(x,y)
	%	keyboard
X=[pivot(1)+centre_x(j)+hwid,x(j)+centre_x(j)+hwid];
Y=[pivot(2)+centre_y(j),y(j)+centre_y(j)];      
plot(X,Y,'-')
if(up(j))
   plot(x(j)+centre_x(j)+hwid,y(j)+centre_y(j),'g>');
else
   plot(x(j)+centre_x(j)+hwid,y(j)+centre_y(j),'ro');   
end
%axis([centre_x(j)-1 centre_x(j)+20  centre_y(j)-20 centre_y(j)+20])
if(centre_x(START_ITER)<centre_x(START_ITER+20))
   a1=centre_x(START_ITER);
   b1=centre_x(START_ITER)+40;
else
   b1=centre_x(START_ITER);
   a1=centre_x(START_ITER)-40;
end
y1=centre_y(START_ITER)-10;
y2=y1+200;
axis([a1 b1 y1 y2])
hold off
   j=j+1;
   subplot(1,2,2)
   plot([0 1],[6 ht(j-1)]);
   axis([0 1.1 0 7])
   R=input('0 to quit \n');   
end
hold off;
time =1:1:ITERS;
figure,
subplot(3,1,1),h1=plot(time,ht),ylabel('ht'),grid;
axis([a b 0 6])
%subplot(5,1,2),h2=plot(time,up),ylabel('down'),grid;
axis([a b 0 1])
subplot(3,1,2),h3=plot(time,ud),ylabel('ud'),grid;
axis([a b -60 20])
subplot(3,1,3),h4=plot(time,bf),ylabel('bf'),grid;
axis([a b -95 95])
%subplot(5,1,5),h5=plot(time,y),ylabel('y'),grid;
%axis([a b -95 95])
%subplot(4,1,4),plot(time,bf),ylabel('bf'),grid;
%axis([a b -10 10])

%plot(centre_x,centre_y,'-x');
R=input('enter number you want to see closer[1-8]or quit (0)');
while (R~=0)
   figure;
	axes
   eval(['copyobj(h' int2str(R) ',gca);']);
   R=input('enter number you want to see closer[1-8]or quit (0)');
end

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

