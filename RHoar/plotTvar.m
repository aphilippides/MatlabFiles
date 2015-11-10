function plotTvar(tvar,TU,TO,mi,nPt)
i=length(tvar);
% js=nPt:i;
% plot(js,tvar(js),'y','LineWidth',2);
for j=1:size(TU,1)
    if(TU(j,2)==0) TU(j,2)=i; end;
    if(TU(j,2)>=mi) 
        is=TU(j,1):TU(j,2);
        plot(is,tvar(is),'y','LineWidth',2);
    end; 
end;
for j=1:size(TO,1)
    if(TO(j,2)==0) TO(j,2)=i; end;
    if(TO(j,2)>=mi) 
        is=TO(j,1):TO(j,2);
        plot(is,tvar(is),'y','LineWidth',2); 
    end;
end;   