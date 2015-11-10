function theta=get_heading(world,ant,n)
% Only look for the desired landmark
world.landmarks=world.landmarks(n,:);

v0=view_world(world,ant);

% get average of left and right edges . 
% Occlusions should cancel out
[plus,minus]=find_edges(v0>0);

[dummy,ind_p]=find(plus'>0);
thetas_p=2*pi*(ind_p)/ant.n_rods;

[dummy,ind_m]=find(minus'>0);
thetas_m=2*pi*(ind_m)/ant.n_rods;

theta=atan2(sum(sin([thetas_p,thetas_m])),sum(cos([thetas_p,thetas_m])));
theta=theta+ant.theta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function V=view_world(world,ant,col)
n_rods=ant.n_rods;
V=zeros(1,n_rods);
%get the landmarks
L=world.landmarks;
if nargin==3
    temp=[];
    for i=1:size(L,1)
        if L(i,6)==col
            temp=[temp;L(i,:)];
        end
    end
    L=temp;
end

if length(L)==0
    return
end

H=(atan2(L(:,2)-ant.y,L(:,1)-ant.x));

% get tthe headings to the corners
H1=(atan2(L(:,2)+L(:,4)-ant.y,L(:,1)+L(:,3)-ant.x));
H2=(atan2(L(:,2)+L(:,4)-ant.y,L(:,1)-L(:,3)-ant.x));
H3=(atan2(L(:,2)-L(:,4)-ant.y,L(:,1)+L(:,3)-ant.x));
H4=(atan2(L(:,2)-L(:,4)-ant.y,L(:,1)-L(:,3)-ant.x));

% make sure all headings are in range [0,2*pi]
HH=[bring_to_range(H1),bring_to_range(H2),bring_to_range(H3),bring_to_range(H4)];

[Hmin,ind_min]=min((HH'));
[Hmax,ind_max]=max((HH'));

% for each landmark
for i=1:size(L,1)
        % get the index of min and max angle
        s1=ceil(n_rods*(HH(i,ind_min(i))/(2*pi)));
        s2=min(n_rods,max(1,ceil(n_rods*(HH(i,ind_max(i)))/(2*pi))));
        % get landmark height
        z=L(i,5);
        % and distance to landmark
        x=sqrt(dist2(L(i,1:2),[ant.x,ant.y]));
        % calculate number of facets occluded in the vertical
        atan2zx=ceil(n_rods*atan2(z,x))/n_rods;    
        % fill out output
        if s2>s1     
            if (s2-s1)<((n_rods+1)/2)
                V(s1:s2)=max(atan2zx,V(s1:s2));
            else
                V(1:s1)=max(atan2zx,V(1:s1)); 
                V(s2:end)=max(atan2zx,V(s2:end));
            end
        else
            if (s1-s2)<((n_rods+1)/2)
                V(s2:s1)=max(V(s2:s1),atan2zx);
            else
                V(1:s2)=max(atan2zx,V(1:s2)); 
                V(s1:end)=max(atan2zx,V(s1:end));
            end
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function H=bring_to_range(H)
for i=1:length(H)
    while(H(i)>2*pi)
        H(i)=H(i)-2*pi;
    end
    while(H(i)<0)
        H(i)=H(i)+2*pi;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [plus,minus]=find_edges(v0)
 mask=[1,-1];
c=conv([v0,v0,v0]',mask);
c=c(length(v0)+2:length(v0)*2+1);
plus=ones(size(c)).*logical(c>0);
minus=ones(size(c)).*logical(c<0);
if sum(plus)==sum(minus)
    return
else
    error('Arse')
end