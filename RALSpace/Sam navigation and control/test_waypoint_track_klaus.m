function test_waypoint_track_klaus

delete(instrfindall)
close all
clear all
fclose all
IG500E('open','COM28',115200)
%comport='COM28';
%s1=gps_open(comport,115200);
%comport='COM8';
%s1=gps_open(comport,38400);


control_robot=0
if (control_robot)
eth=open_robot_ethernet('192.168.0.100',7);
pause(2);
flushinput(eth);
for i=1:10
     pause(1)
    send_robot_steer_speed(-3,4,eth);
   
    
end
        
end

%start line near corner AEIC N=5848181.106545 easting:538470.003561
%wp_n=5848181.106545;
%wp_e=538470.003561;

%end due northwest in line with security cam || to carpark 5848206.981082 easting:538445.594849 
 wp_n=5848156.7
 wp_e=538495.094

%wp_n=5848206.981082;
%wp_e=538445.594849;
 
rotationgain=0.6; %was 0.8
maxsteeringangle=40;

endpointreached=0;
tic
fileID = fopen('waypoint_17-8-15 north gain 0-5.dat','w');
sample_t=0;
 

    endpointreached=0;
while (~endpointreached)

%[lt,ln,speed,c_b,gpcourse,dop]=read_gps_serial(s1);
%    ln=-ln;
x=IG500E('read');
    lt=x(4);
    ln=x(5);
    c_b=x(3)/pi*180;
    
    gprmccourse=0;
    time=0;
    dop=0;
    [c_e,c_n,zone]=deg2utm(lt,ln);

   dist=disttopoint(c_n,c_e,wp_n,wp_e);

%   aimbearing=bearing_to_point(c_n,c_e,wp_n,wp_e);
% 
  %   cl_bearing=closest_bearing_difference(c_b,aimbearing);
%     steeringangle=rotationgain*cl_bearing;
%      if (steeringangle>maxsteeringangle) steeringangle=maxsteeringangle;end
%     if (steeringangle<-maxsteeringangle) steeringangle=-maxsteeringangle;end
%     
  %  s=sprintf('current:northing:%f easting:%f bearing:%f, dist:%f, aimbearing:%f, closest_b:%f, steer ang:%f, zn:%s',c_n,c_e,c_b,dist,aimbearing,cl_bearing,steeringangle,zone)
    %Calculate steering angle from the heading
    [steeringangle,aimbearing]=calc_steering_aim(c_n,c_e,c_b,wp_n,wp_e,rotationgain,maxsteeringangle);

cl_bearing=0;
   % if (toc>0.5)
    s=sprintf('current:northing:%f easting:%f bearing:%f, dist:%f, aimbearing:%f, closest_b:%f, steer ang:%f, zn:%s',c_n,c_e,c_b,dist,aimbearing,cl_bearing,steeringangle,zone);
   
        if (control_robot)
            send_robot_steer_speed(steeringangle-3,7,eth);
            
           
        end
        fprintf(fileID,'%f,%f,%f,%f,%f,%f,%f,%f\n',sample_t,c_n,c_e,c_b,dist,aimbearing,cl_bearing,steeringangle);
        sample_t=sample_t+0.5;
        tic
 %   end


    %Calculate if the wp reached
    endpointreached=waypoint_reached(c_n,c_e,wp_n,wp_e);
   %end
    pause(0.5);
end

%Stop the robot
if (control_robot)
    send_robot_steer_speed(0,0,eth);
ss=sprintf('Stopping\n');
close_robot_ethernet(eth);
    end

IG500E('close')
%gps_close(s1);
fclose(fileID);
end


