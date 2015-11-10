function[tsh,ash]=AlignArcs(p,pa,pt,o,oa,ot,t)

tsh=0.2;
ash=MeanAngle(AngularDifference(o,p));
while(1)
    plot(t,o,'b',t+tsh,p+ash,'k',ot,oa,'r.',pt+tsh,pa+ash,'g.')
    legend('Body axis','Angular position','Location','Best')
    in=input('enter time adjustment, return to do angle; 0 to end\n');
    if(isempty(in))
       in=input('enter angle adjustment, return to do angle; 0 to end\n'); 
       ash=ash-in;
    elseif(in==0) break;
    else tsh=tsh-in;
    end
end