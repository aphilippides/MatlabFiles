function [x,y,z,t]=checkcoords(x,y,z,t,k,k1)
i=3;
while i<=length(x)
    
    if abs(x(i)-x(i-1))>k*(t(i)-t(i-1))
        flag1=0;
        for j=1:1:min(k1,length(x)-i)
          if abs(x(i+j)-x(i-1+j))>k*(t(i+j)-t(i+j-1)) 
          flag1=1; koord=i+j;
          end;
        end;
        
        if flag1==0 x(i)=[];y(i)=[];z(i)=[];t(i)=[];i=i;end;
        if flag1==1 x(i:koord)=[];y(i:koord)=[];z(i:koord)=[];t(i:koord)=[];i=i;end;         
    else i=i+1;
    end;    
end;