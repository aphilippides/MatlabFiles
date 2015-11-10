function world=new_world(n_lm,n_mL,n_bigL)
%make some landmarks
if nargin==0
    n_lm=10;
    n_mL=10;
    n_bigL=1;
end
world_sz=10;
error_bound=0.5;

cols=[1,2,3];
if n_bigL>0
    for j=1:n_bigL
        x=100*rand(1);
        if rand(1)>0.5
            x=-x;
        end
        y=sqrt(100^2-x^2)+randn(1)*20;
        if rand(1)>0.5
            y=-y;
        end    
        z=rand(1)*50;
        L(j,:)=[x,y,z,25,20,20,1];
    end
else
    j=0;
end

if n_mL>0
    
    for k=1:n_mL
        x=20*rand(1);
        if rand(1)>0.5
            x=-x;
        end
        y=sqrt(30^2-x^2)+randn(1)*10;
        z=rand(1)*50;
        if rand(1)>0.5
            y=-y;
        end
        %         L(j+k,:)=[x,y,1,1,rand(1)*50,2];
        L(j+k,:)=[x,y,z,5,5,5,2];     
    end
else
    k=j;
end

if n_lm>0
    for i=1:n_lm
        L(i+j+k,:)=[(2*world_sz*(rand(1,3)-0.5)),0.1,0.1,0.1,3];
    end
else
    i=k;
end

world=struct(...
    'size',world_sz,...
    'grid_sz',[-world_sz,world_sz,-world_sz,world_sz,0,2*world_sz/10],...
    'home',[-3,-3,0],...
    'landmarks',L,...
    'goal',[5,5,0],...
    'error_bound',error_bound);

