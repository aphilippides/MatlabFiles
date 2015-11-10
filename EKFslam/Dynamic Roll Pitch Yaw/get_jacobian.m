function [dhdX,dhdY]=get_jacobian(X,Y)
h=M_Model(X,Y);
dx=0.0001*ones(1,12);
for i=1:12
    X(i)=X(i)+dx(i);
    hplus=M_Model(X,Y);
    X(i)=X(i)-2*dx(i);
    hminus=M_Model(X,Y);
    dhdX(:,i)=(hplus-hminus)/(2*dx(i));
     X(i)=X(i)+dx(i);
end

for i=1:3
    Y(i)=Y(i)+dx(i);
    hplus=M_Model(X,Y);
    Y(i)=Y(i)-2*dx(i);
    hminus=M_Model(X,Y);
    dhdY(:,i)=(hplus-hminus)/(2*dx(i));
     Y(i)=Y(i)+dx(i);
end