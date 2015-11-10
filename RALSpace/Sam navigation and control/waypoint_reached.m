function endpointreached=waypoint_reached(c_n,c_e,wp_n,wp_e)
persistent checkbearingcurrent;
dist_point=disttopoint(c_n,c_e,wp_n,wp_e);
bearingtopoint=bearing_to_point(c_n,c_e,wp_n,wp_e);
endpointreached=0;
 if ((dist_point>3) && (dist_point<5)) 
        checkbearingcurrent=bearingtopoint ;
 end  
    if (dist_point<3)
        if abs(checkbearingcurrent-bearingtopoint)>100 
            endpointreached=1 ;
        end
    end
end

