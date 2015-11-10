    
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
            DISTANCE(j)=d2(ind);
        end
        avedist(inds(i))=mean(DISTANCE(2:7));
    end