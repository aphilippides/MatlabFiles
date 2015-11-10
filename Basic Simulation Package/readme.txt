% main functions for constructing model environments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X,Y,Z]=basicTussockWorld(world_sz,n);

>> [X,Y,Z]=basicTussockWorld([10 10],50);

Will create a 10m x 10m world with 50 random tussocks in it

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X,Y,Z]=buildRandomHorizon(X,Y,Z);

>> [X,Y,Z]=buildRandomHorizon;

Will create an empty world with randomly generated trees and bushes on the horizon

>> [X,Y,Z]=buildRandomHorizon(X,Y,Z);

Will append randomly generated trees etc to existing model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

showWorld(X,Y,Z);

Will display the model stored in X, Y and Z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v=getView(x,y,z,th,X,Y,Z);

Main function for getting views from model

>> v=getView(-1,-2,0,pi/3,X,Y,Z);

Will get the low resolution view at position x=-1 y=-2 z=0 facing in direction pi/3 and will return
it in a 17x90 matrix use

>> myim(v) 

to view the matrix.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,y,th]=buildRoute(dx,world_sz)

Function for manually specifying routes using a gui

>> [x,y,th]=buildRoute(0.05,[5,5]);

Will open a figure with axis [-5 5 -5 5]. Click on points to specify waypoints and hit return to output
the x,y and th points that pass through the waypoints sampled every 0.05 units.

>> [x,y,th]=buildRoute; 

Uses default values dx=0.01 and axis([-1,1,-1,1])

Use 

>> arrowplot(x,y,th,0.01,'k')

to view the path as a set of black arrows 0.01 long 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Save data as .mat files for subsequent use

>> save world1 X Y Z

>> save route1 x y th

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

collectData(world,route,filename)

Function for automatically collecting views from a route.

>> collectData('world1.mat','route1.mat','savedViews.mat')

Will sample views along route1 in world1 and save the data in a file called savedViews.mat

You can also include full paths to make things a bit tidier so if you save all of your worlds
in a folder called worlds and all of your routes in Routes and all of your saved data in Results
you can use the function in the following way

>> collectData('Worlds/world1','Routes/route1','Results/world1_route1_run1')

The data is stored in a variable called D that is [numsamples X numpixels] so to look at the 
data you will need to get individual samples and reshape them

To view all of the data in a run as a sort of movie would therefore be done like this

for i=1:size(D,1)
    myim(reshape(D(i,:),17,90));
    drawnow
end

