function ant=simple_ant(world)
n_rods=121;
scale=world.size;
pos=world.home;

ant=struct(...
    'food_found',0,...
    'hungry',1,...
    'with_food',0,...
    'dt',0.02,...
    'x',pos(1),...
    'y',pos(2),...
    'z',0.1,...
    'dx',0,...
    'dy',0,...
    'r',0,...
    'theta',0,...
    'dr',0,...
    'dtheta',0,...
    'heading',0,...
    'cnt',0,....
    'v',0.5,...
    'n_rods',n_rods,...
    'view_angle',pi);


