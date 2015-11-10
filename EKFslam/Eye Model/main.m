%cover a unit sphere with some regularly spaced vertices
FV = sphere_tri('ico',4,[],0);
FVOLD=FV;
vertices=FV.vertices;
%show sphere
facecolor = [.7 .7 .7];
figure
Hp = patch('faces',FV.faces,'vertices',FV.vertices,...
    'facecolor',facecolor,'facealpha',0.8,'edgecolor',[.8 .8 .8]); 
camlight('headlight','infinite'); daspect([1 1 1]); axis vis3d; axis off
material dull; rotate3d


% sphere_project - project point X,Y,Z to the surface of sphere radius r
r=1;%sphere radius
c=[0,0,0];% cente
v=[1,1,1]% direction
V = sphere_project(v,r,c);



%loop
for p=1:1000
    % set desired size == distance from [1,0,0]
    % work out current desired size
    d=sqrt(dist2(vertices,[1,0,0]));
    desired_width=0.0+(d/2)*0.1;a
    SDV=[];
    inds=randperm(length(vertices));
    % Relaxation algorithm
    for i=1:length(vertices)
        % pick a random vertex
        v=vertices(inds(i),:);
        
        % find six nearest neighbours
        d2=sqrt(dist2(vertices,v));
        temp=d2;
        for j=1:7
            [m,ind]=min(temp);
            % lose smallest
            temp(ind)=1000;
            %save indices
            IND(j)=ind;
            VERT(j,:)=vertices(ind,:);
            DES(j)=desired_width(ind);
            DISTANCE(j)=d2(ind);
        end
        
        % calculate resultant force
        H=1;
        F=H*(DISTANCE-DES);
        %difference in vectors
        DV=VERT-ones(7,1)*v;
        SDV=[SDV,sum(F)];
        v=v+F*DV;
        v = sphere_project(v,r,c);
        vertices(inds(i),:)=v;
    end
    %     plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.')
    %     view(90,0)
    %     drawnow
    %     figure(2)
    %     hist(SDV,20)
    %     drawnow
    %     figure(1)
end
plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.')
view(90,0)
drawnow
figure(2)
hist(SDV,20)
drawnow
figure(1)
FV.vertices=vertices;