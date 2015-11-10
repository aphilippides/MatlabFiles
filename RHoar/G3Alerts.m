function G3Alerts(l3,p1p2,s1s2,e1e2,c1c2,d1d2,m1m2,a1a2,chanBS,retBS,mids,boxes)
for k=1:size(p1p2,1)
    ind=p1p2(k,1);
    if(p1p2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'LineWidth',2);
    elseif(p1p2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r','LineWidth',2);
    elseif(p1p2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'k-s');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'g-s');
    end
end
for k=1:size(e1e2,1)
    ind=e1e2(k,1);
    if(e1e2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-o','MarkerFaceColor','b','LineWidth',1);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-o','MarkerFaceColor','r','LineWidth',1);
    end
end
for k=1:size(s1s2,1)
    ind=s1s2(k,1);
    if(s1s2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:o');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:o');
    end
end
for k=1:size(c1c2,1)
    ind=c1c2(k,1);
    if(c1c2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:v');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:v');
    end
end
for k=1:size(d1d2,1)
    ind=d1d2(k,1);
    if(d1d2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--*','LineWidth',2);
    elseif(d1d2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--*','LineWidth',2);
    elseif(d1d2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--s','MarkerFaceColor','b','LineWidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--s','MarkerFaceColor','r','LineWidth',2);
    end
end
for k=1:size(m1m2,1)
    ind=m1m2(k,1);
    if(m1m2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:','LineWidth',2);
    elseif(m1m2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:','LineWidth',2);
    elseif(m1m2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:s','MarkerFaceColor','b','LineWidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:s','MarkerFaceColor','r','LineWidth',2);
    end
end
for k=1:size(a1a2,1)
    ind=a1a2(k,1);
    if(a1a2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:d','LineWidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:d','LineWidth',2);
    end
end
for k=1:size(chanBS,1)
    ind=chanBS(k,1);
    if(chanBS(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:+');
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:+');
    end
end
for k=1:size(retBS,1)
    ind=retBS(k,1);
    if(retBS(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-x');
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-x');
    end
end
% for k=1:size(mids,1)
%     ind=mids(k,1);
%     if(mids(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--h','LineWidth',2);
%     else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--h','LineWidth',2);
%     end
% end
for k=1:size(boxes,1)
    ind=boxes(k,1);
    if(boxes(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-->','LineWidth',2);
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-->','LineWidth',2);
    end
end