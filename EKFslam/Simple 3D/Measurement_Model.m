function [h, dhdX,dhdY]=Measurement_Model(X,Y)

dhdX=zeros(3);
dhdY=zeros(3);

% estimated agent position
Xa=X(1);
Ya=X(2);
Za=X(3);

% estimated landmark position
Xl=Y(1);
Yl=Y(2);
Zl=Y(3);
N1=(Xl-Xa)^2+(Yl-Ya)^2+(Zl-Za)^2;
if sum(N1)~=0
h=[Xl-Xa;Yl-Ya;Zl-Za]/sqrt(N1);
else
    h=[0;0;0];
    return
end
% jacobian calculations
if nargout>1
    dhdX(1,1) = [-1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Xl+2*Xa);
    dhdX(1,2) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Yl+2*Ya);
    dhdX(1,3)= [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Zl+2*Za);
    dhdX(2,1) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Xl+2*Xa);
    dhdX(2,2) = [-1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Yl+2*Ya);
    dhdX(2,3) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Zl+2*Za);
    dhdX(3,1) =  [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Xl+2*Xa);
    dhdX(3,2)  = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Yl+2*Ya);
    dhdX(3,3) = [-1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(-2*Zl+2*Za);
    
    dhdY(1,1)  = [1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Xl-2*Xa);
    dhdY(1,2) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Yl-2*Ya);
    dhdY(1,3) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Xl-Xa]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Zl-2*Za);
    dhdY(2,1)  = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Xl-2*Xa);
    dhdY(2,2)=  [1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Yl-2*Ya);
    dhdY(2,3) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Yl-Ya]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Zl-2*Za);
    dhdY(3,1) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Xl-2*Xa);
    dhdY(3,2) = [0]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Yl-2*Ya);
    dhdY(3,3) = [1]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)-1/2*[Zl-Za]/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(3/2)*(2*Zl-2*Za);
end



%     dhdX(1,1) = -1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Xl+2*Xa);
%     dhdX(1,2) = 2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Yl+2*Ya);
%     dhdX(1,3)= 2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Zl+2*Za);
%     dhdX(2,1) = 2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Xl+2*Xa);
%     dhdX(2,2) = -1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Yl+2*Ya);
%     dhdX(2,3) = 2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Zl+2*Za);
%     dhdX(3,1) =  2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Xl+2*Xa);
%     dhdX(3,2)  = 2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Yl+2*Ya);
%     dhdX(3,3) = -1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(-2*Zl+2*Za);
%     
%     dhdY(1,1)  = 1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Xl-2*Xa);
%     dhdY(1,2) = 2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Yl-2*Ya);
%     dhdY(1,3) = 2*(Xl-Xa)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Zl-2*Za);
%     dhdY(2,1)  = 2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Xl-2*Xa);
%     dhdY(2,2)= 1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Yl-2*Ya);
%     dhdY(2,3) = 2*(Yl-Ya)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Zl-2*Za);
%     dhdY(3,1) = 2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Xl-2*Xa);
%     dhdY(3,2) = 2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Yl-2*Ya);
%     dhdY(3,3) = 1/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)+1/2*(Zl-Za)/(Xl^2-2*Xl*Xa+Xa^2+Yl^2-2*Yl*Ya+Ya^2+Zl^2-2*Zl*Za+Za^2)^(1/2)*(2*Zl-2*Za);
