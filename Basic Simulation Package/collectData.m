function collectData(world,route,filename)
% this needs filenames of world and route, with variables as below
% and outputs data into filename
load(world); % X Y Z
load(route); % x y th
fh=figure(33);
clf
fill(X',Y','k')
hold on
set(fh,'Position',[1296,119,560,420]);
plot(x,y,'k.','MarkerSize',0.5)
axis equal
axis(10*[-1 1 -1 1])
D=zeros(length(x),17*90);
c=0;
% for each route step
for i=1:length(x)
    
    % get the view from that position
    v=getView(x(i),y(i),0,th(i),X,Y,Z);
    % check that it's not a bad file
    if sum(v(:))~=0
        c=c+1;
        % store each view as a vector in D
        D(c,:)=double(v(:)');
    end
end
% remove any empty entries in D
D=D(1:c,:);

save(filename,'D','x','y','th')

