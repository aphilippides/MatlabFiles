function send_robot_steer_speed(steer,speed,eth)
       
 persistent steer_val
 inc=10;
       if (isempty(steer_val)) steer_val=0;end
       if (steer>steer_val) 
           if ((steer-steer_val)>inc) steer_val=steer_val+inc;else steer_val=steer;end 
       end
       if (steer<steer_val) 
           if ((steer_val-steer)>inc) steer_val=steer_val-inc;else steer_val=steer;end 
       end
       str= sprintf('$SAFAR:STEER:%.2f:SPEED:%.2f\r',steer_val,speed);


       
       fprintf(eth,str);
       ss=sprintf('%s',str)
    end