function [dhdX,dhdY]=getJac(X,Y)
if size(Y,1)==1
    Y=Y';
end
x0=[X;Y];
warning off Optimization:fsolve:NonSquareSystem
options=optimset('Jacobian','off');
[x,F,exitflag,output,JAC] = fsolve(@M_Model2,x0,options);
dhdX=JAC(:,1:6);
dhdY=JAC(:,7:9);