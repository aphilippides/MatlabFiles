function Vec=FastRaytrace(ant,world,n)

% Make a prediction of heading
Xant=[ant.x;ant.y;ant.z];
L=world.landmarks(n,:);

h=Measurement_Model(Xant,L);

X=0;
Y=0;
Z=0;

% get facets we're interested in
min_dist_to_heading = 0.5;
Err=sum((ant.vert-ones(size(ant.vert,1),1)*h').^2,2);
ind=find(Err<=min_dist_to_heading);

x=ant.vert(ind,1);
y=ant.vert(ind,2);
z=ant.vert(ind,3);

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
for i=1:length(x(:))
    % make sure none of our vertices are exactly 0
    Dx=x(i);
    if Dx==0
        Dx=0.0001;
    end
    Dy=y(i);
    if Dy==0
        Dy=0.0001;
    end
    Dz=z(i);
    if Dz==0
        Dz=0.0001;
    end
    
    % if we're inside the landmark
    if ((Dx < maxx) & (Dx > minx) & (Dy < maxy) & (Dy > miny) & (Dz < maxz) & (Dz > minz)) 
        %         V(i)=1;
%                 plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'c.')
        X=X+Dx;
        Y=Y+Dy;
        Z=Z+Dz;
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
%                         plot3(ant.x+Dx,ant.y+Dy,ant.z+Dz,'g.')
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
                X=X+Dx;
                Y=Y+Dy;
                Z=Z+Dz;
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