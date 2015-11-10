%%%%%% Function computing the catchment area with colour varying according
% to the number of steps needed to reach the nest.
% The 8-connexity is used (8 neighbours per box)
% The algorithm strategy is based on a Fifo list
function[NumSteps]=StartFromEachPos(X,Y,mx,my,nest)

% Initialization of the catchment area
NumSteps=NaN(size(X)) ;

% Find the position of the nest in the mesh grid
nest_grid(1)= find( abs(X(1,:)-nest(1))<= (Y(2)-Y(1))/2) ;
nest_grid(2)= find( abs(Y(:,1)-nest(2))<= (Y(2)-Y(1))/2) ;

% Initialize Fifo with each grid point within the nest area
Fifo = [];

StartFifo = [nest_grid(2) nest_grid(1)] ;
while size(StartFifo,1) > 0
    Local = StartFifo(1,:) ; 
    for i=-1:1
        for j=-1:1
           Neighbour = Local + [i j] ;
           if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
               -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
               & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
               % ### WARNING ### vector (i,j) is expected to be the
               % vector from the Local box to the neighbour but since 
               % the data organisation is different between the array 
               % and the image (NE-SW symetry)
               % i and j have thus been switched to cope with this problem                   
               if ( mx(Neighbour(1),Neighbour(2))==0 & my(Neighbour(1),Neighbour(2))==0 )
                   Fifo = [Fifo ; Neighbour] ;
                   StartFifo = [StartFifo ; Neighbour] ;
                   NumSteps(Neighbour(1),Neighbour(2))=0;
                   ChangeNumObjSeen(Neighbour(1),Neighbour(2)) = 0 ;
                   AverageHomewardComp(Neighbour(1),Neighbour(2))=0;
               end
           end
        end 
    end
    StartFifo(1,:) = [] ;
end

% Initialize the catchment area to the area covered by the nest
% Radius of the nest expressed as a number of grid interval
r = round(nest(3)/(Y(2)-Y(1)));
for i=-r:r
    for j=-r:r
         if( (X(1,nest_grid(1)+i)-nest(1))^2 + ...
             (Y(nest_grid(2)+j,1)-nest(2))^2 <= nest(3)^2  )
            % ### WARNING ### See comment below
            Fifo = [Fifo ; [nest_grid(2)+j nest_grid(1)+i] ] ;
            NumSteps(nest_grid(2)+j,nest_grid(1)+i)=0;
        end
    end
end

while size(Fifo,1) > 0
    Local = Fifo(1,:) ; 
    for i=-1:1
        for j=-1:1
           Neighbour = Local + [i j] ;
           if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
               -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
               & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
               % ### WARNING ### vector (i,j) is expected to be the
               % vector from the Local box to the neighbour but since 
               % the data organisation is different between the array 
               % and the image (NE-SW symetry)
               % i and j have thus been switched to cope with this problem                   
               if (   mx(Neighbour(1),Neighbour(2))~=0 ... 
                    | my(Neighbour(1),Neighbour(2))~=0 )
                   if ( (mx(Neighbour(1),Neighbour(2))*j+my(Neighbour(1),Neighbour(2))*i)/ ... 
                        (sqrt(mx(Neighbour(1),Neighbour(2))^2+my(Neighbour(1),Neighbour(2))^2) ...
                        *sqrt(i^2+j^2))<=(-cos(pi/8)+10^(-15)))
                       %need to add 10^-15 to solve some strange
                       %approximation problems
                       NumSteps(Neighbour(1),Neighbour(2)) = NumSteps(Local(1),Local(2)) + 1 ;
                       Fifo = [Fifo;Neighbour];
                   end
               end
           end
        end 
    end
    Fifo(1,:) = [] ;
end