function DoCluster


traitCount = 4;
for genNum=0:5
filename=['sim_run_2/generation_' int2str(genNum*100) '.txt']; 
Data=load(filename,'-ascii');
for i=1:traitCount
	x{i} = Data(:,i+1);
end

X = x{1};
for i=2:traitCount
  X = cat(2,X,x{i});
end

Y = pdist(X);
%YSquare = squareform(Y)
Z = linkage(Y, 'single');
%W = inconsistent(Z)
% [H, T] = dendrogram(Z);
%cophenet (Z, Y)
T = cluster(Z,0.983)
%find(T==15)
centres=[];
for i=1:max(T)
    is=find(T==i);
    if(length(is)>0) centres=[centres; mean(Data(is,2:5),1)]; 
    end
end
while(size(centres,1)>1)
    y=squareform(pdist(centres,'euclidean'));
    is=find(y(1,:)<3);
    if(length(is)<=1) break; end;
    newcentres=mean(centres(is,:),1);
    NewC=centres(setdiff(1:size(centres,1),is)',:);
    NewC=[NewC;newcentres];
    centres=NewC;
end
plot3(genNum*ones(size(centres(:,1))),centres(:,1),centres(:,2),'o')
hold on
end
hold off