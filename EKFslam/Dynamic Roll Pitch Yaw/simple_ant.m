function ant=simple_ant(world)

pos=world.home;

% FV = sphere_tri('ico',5,[],0);
% vert=FV.vertices;
load vertices;

ant=struct(...
    'dt',0.02,...
    'x',pos(1),...
    'y',pos(2),...
    'z',pos(3),...
    'roll',0,...
    'pitch',0,...
    'yaw',0,...
    'dx',5,...
    'dy',5,...
    'dz',5,...
    'droll',5,...
    'dpitch',5,...
    'dyaw',5,...
    'vert',vert);


