function Vec=raytrace(ant,world,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns a vector specifying the direction of a landmark 
% RELATIVE TO THE AGENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the landmark coordinates
L=world.landmarks(n,:);

% set up some counters for X Y and Z components
% of raytrace direction vector for landmark n
X=0;
Y=0;
Z=0;

% Get the x y z coordinates of all of the facets
vert=ant.vert;
n_facets=length(vert);

% take into account yaw pitch and roll
% to bring vert into a world frame of reference
T=Transform(ant.yaw,ant.pitch,ant.roll);
vert=T*vert';
vert=vert';
x=vert(:,1);
y=vert(:,2);
z=vert(:,3);

% get the min and max relative positions of the landmark
minx=L(1)-L(4)-ant.x;
maxx=L(1)+L(4)-ant.x;
miny=L(2)-L(5)-ant.y;
maxy=L(2)+L(5)-ant.y;
minz=L(3)-L(6)-ant.z;
maxz=L(3)+L(6)-ant.z;

% clf
% hold on
% get direction of ray
for i=1:n_facets
    % make sure none of our vertices are exactly 0 since we need to divide by Dx Dy
    % and Dz
    Dx=x(i);
    Dy=y(i);
    Dz=z(i);
    
    if Dx==0
        Dx=0.0001;
    end
    if Dy==0
        Dy=0.0001;
    end
    if Dz==0
        Dz=0.0001;
    end
    
    % if we're inside the landmark
    if ((Dx < maxx) & (Dx > minx) & (Dy < maxy) & (Dy > miny) & (Dz < maxz) & (Dz > minz)) 
        %         V(i)=1;
        %                 plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'c.')
        X=X+ant.vert(i,1);
        Y=Y+ant.vert(i,2);
        Z=Z+ant.vert(i,3);
    else
        % if the distance of the centre is greater than the distance to the beginning its pointing away
        boxCentroidx = (maxx + minx)/2;
        boxCentroidy = (maxy + miny)/2;
        boxCentroidz = (maxz + minz)/2;
        distanceToCentroid = sqrt(boxCentroidx*boxCentroidx + boxCentroidy*boxCentroidy + boxCentroidz*boxCentroidz);
        vx = Dx * distanceToCentroid;
        vy = Dy * distanceToCentroid;
        vz = Dz * distanceToCentroid; % v = end point of ray when projected to box orbit
        distanceFromEnd=sqrt(((boxCentroidx - vx)*(boxCentroidx - vx)) + ...
            ((boxCentroidy - vy)*(boxCentroidy - vy)) +...
            ((boxCentroidz - vz)*(boxCentroidz - vz)));
        
        if (distanceFromEnd > distanceToCentroid) 
            %             V(i)=0; 
            %                         plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'r.')
        else
            % check each of the faces of the landmark for intersection
            
            if (((Dy * minx / Dx < maxy) & (Dy * minx / Dx > miny) & (Dz * minx / Dx < maxz) & (Dz * minx / Dx > minz)) |...
                    ((Dy * maxx / Dx < maxy) & (Dy * maxx / Dx > miny) & (Dz * maxx / Dx < maxz) & (Dz * maxx / Dx > minz)) |...
                    ((Dx * miny / Dy< maxx) & (Dx * miny / Dy> minx) & (Dz * miny / Dy< maxz) & (Dz * miny / Dy> minz)) |...
                    ((Dx * maxy / Dy< maxx) & (Dx * maxy / Dy> minx) & (Dz * maxy / Dy< maxz) & (Dz * maxy / Dy> minz)) |...
                    ((Dx * minz / Dz< maxx) & (Dx * minz / Dz> minx) & (Dy * minz / Dz< maxy) & (Dy * minz / Dz> miny)) |...
                    ((Dx * maxz / Dz< maxx) & (Dx * maxz / Dz> minx) & (Dy * maxz / Dz< maxy) & (Dy * maxz / Dz> miny)))
                %                 V(i)=1;
                %                                 plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'k.')
        X=X+ant.vert(i,1);
        Y=Y+ant.vert(i,2);
        Z=Z+ant.vert(i,3);
            else
                %                 V(i)=0;
                %                 plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'g.')
            end
        end
    end
end
% axis equal
% quiver3(ant.x,ant.y,ant.z,X,Y,Z)
% plot3(L(1),L(2),L(3),'r*')
% Normalise
N=sqrt(X^2+Y^2+Z^2);
if sum(X+Y+Z)~=0
    Vec=[X;Y;Z]/N;
else
    Vec=[0;0;0];
end
