function T=Transform(yaw,pitch,roll)
T=[cos(yaw)*cos(pitch),cos(yaw)*sin(pitch)*sin(roll)-sin(yaw)*cos(roll),cos(yaw)*sin(pitch)*cos(roll)+sin(yaw)*sin(roll);...
        sin(yaw)*cos(pitch),sin(yaw)*sin(pitch)*sin(roll)+cos(yaw)*cos(roll),sin(yaw)*sin(pitch)*cos(roll)-cos(yaw)*sin(roll);...
        -sin(pitch),cos(pitch)*sin(roll),cos(pitch)*cos(roll)];

% a=yaw;
% b=pitch;
% g=roll;
% 
% T=[cos(a)*cos(g)-sin(a)*cos(b)*sin(g), -sin(a)*cos(g)-cos(a)*cos(b)*sin(g), sin(b)*sin(g);...
%         cos(a)*sin(g)+sin(a)*cos(b)*cos(g), -sin(a)*sin(g)+cos(a)*cos(b)*cos(g), -sin(b)*cos(g);...
%         sin(a)*sin(b), cos(a)*sin(b), cos(b)];