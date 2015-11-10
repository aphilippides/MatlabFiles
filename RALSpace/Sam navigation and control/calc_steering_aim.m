function [steeringangle,aimbearing]=calc_steering_aim(currentnorthing,currenteasting,currentbearing,endnorthing,endeasting,rotationgain,maxsteeringangle)    
    aimbearing=bearing_to_point(currentnorthing,currenteasting,endnorthing,endeasting);
    steeringangle=rotationgain*closest_bearing_difference(currentbearing,aimbearing);
     if (steeringangle>maxsteeringangle) steeringangle=maxsteeringangle;end
    if (steeringangle<-maxsteeringangle) steeringangle=-maxsteeringangle;end
end