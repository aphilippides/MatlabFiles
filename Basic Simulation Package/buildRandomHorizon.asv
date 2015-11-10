function [X,Y,Z]=buildRandomHorizon(X,Y,Z)
%CREATE RANDOM HORIZON OF TREES AND BUSHES
% inputs are the already built other objects
% generates flat objects whihc are oriented to be maximally visible 
% ie oriented along a tangent to the circumference of circle around cnetre
% of world
if nargin==0
    [X,Y,Z]=deal([],[],[]);
end
% this sets the potential places that bush/tree could be set
th=linspace(0,2*pi,100);
th=th(1:end-1);

% d=25; % distance of objects

for i=1:length(th)
    % distance of objects
    d=25+rand(1)*35;
    
    % decide whether to place an object
    if rand(1)>0.5                                     %% change this to get more/less objects
        %decide what sort of object
        if rand(1)>0.3                                 %% change this to get more/less trees/bushes
            %bush
            [Xt,Yt,Zt]=randomBush(rand(1)/5+0.8);
            % randomly scale
            [Xt,Yt,Zt]=deal(2*Xt,2*Yt*rand(1),2*Zt*rand(1));
        else
            %tree
            [Xt,Yt,Zt]=randomTree(rand(1)/2+0.5,1.5+rand(1));
            % randomly scale
            [Xt,Yt,Zt]=deal(Xt,Yt*(1+rand(1)),Zt*3*rand(1));
        end
        
        % rotate
        [Xt,Yt,Zt]=rotZ(Xt,Yt,Zt,th(i)+pi/2);
        % place at distance
        [Xt,Yt]=deal([Xt+d*sin(th(i))],[Yt+d*cos(th(i))]);
        [X,Y,Z]=deal([X;Xt],[Y;Yt],[Z;Zt]);
    end
end

close(75)
% Plot out some example views
% v0=getView(0,-10,0,0,X,Y,Z);
% v1=getView(0,0,0,0,X,Y,Z);
% v2=getView(0,10,0,0,X,Y,Z);
%
% figure(2)
% subplot(311)
% myim(v0)
% subplot(312)
% myim(v1)
% subplot(313)
% myim(v2)

% helper functions
function [X,Y,Z]=randomTree(sig,h)
figure(75)
clf
n=randperm(4);
load(strcat('Objects\t',num2str(n(1)),'.mat'));% X Y Z
% randomly flip
if rand(1)>0.5
    [X,Y,Z]=rotZ(X,Y,Z,pi);
end
load('Objects\leaves2.mat'); %Xl Yl Zl
fill3(X',Y',Z','k')

hold on
inds=rand(1,size(Xl,1))>sig;
fill3(Xl(inds,:)',Yl(inds,:)',Zl(inds,:)'+h,'k');
view(90,0)
axis equal
axis tight
[X,Y,Z]=deal([X;Xl(inds,:)],[Y;Yl(inds,:)],[Z;Zl(inds,:)+h]);

function [X,Y,Z]=randomBush(sig)
figure(75)
clf
% load('FlatTrees\t1.mat');% X Y Z
load('Objects\leaves2.mat'); %Xl Yl Zl
% fill3(X',Y',Z','k')

hold on
inds=rand(1,size(Xl,1))>sig;
fill3(Xl(inds,:)',Yl(inds,:)',Zl(inds,:)','k');
view(90,0)
axis equal
axis tight
[X,Y,Z]=deal(Xl(inds,:),Yl(inds,:),Zl(inds,:));
