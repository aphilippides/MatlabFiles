function h=M_Model(X,Y)

dhdX=zeros(3,6);
dhdY=zeros(3);

% estimated agent position
Xa=X(1);
Ya=X(2);
Za=X(3);
yaw=X(4);
pitch=X(5);
roll=X(6);
% estimated landmark position
Xl=Y(1);
Yl=Y(2);
Zl=Y(3);

N1=(Xl-Xa)^2+(Yl-Ya)^2+(Zl-Za)^2;

if sum(N1)~=0
    % take into account yaw pitch and roll
    T=Transform(yaw,pitch,roll);
    Tinv=T';
    h=Tinv*[Xl-Xa;Yl-Ya;Zl-Za];
    h=h/sqrt(h'*h);
else
    h=[0;0;0];
    return
end