function []=MullerWehnerTestInfomax(W,sig,trial_index,filter,world,runName0,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
% W - optional input containing pretrained weights of the Infomax network
% sig - SD of noise to add to chosen direction of movement (try 0.1) for
%       starters. sig = 0 gives noise free performance
% n - number of trials.
% world - normally contains all the data specifying the 3D model of the
%       environment needed by get View
% runName0 - contains the training data
% filename - name of file used to save figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getView function will need this
load(world);%  

% load the training data
load(runName0); % x y th D runName
% mat file containing the following data 
% x - [1 x number of training points] vector
% y - [1 x number of training points] vector
% th - [1 x number of training points] vector
% D - [number of training points x num pixels in image] training views made into a vector and stacked up

% distance to move at each step 10cm at moment
stepsize=1;
% height - probably won't need to change ever
z0=0;
% scan stepsize - again won't need to change 
rotation_stepsize=1;


fh=figure(1);
clf
% this code normally plots the environment so isn't useful for you
set(fh,'Position',[646    -3   560   420]);
fill(X',Y','k')

% plot the training route
hold on
view(0,90)
plot([x(1),x(end)],[y(1),y(end)],'k*');
plot(x,y,'k.','MarkerSize',0.5,'Color',0.75*[1,1,1])

% set the goal location here - hard coded to x=0 y=6 at the moment
[xgoal,ygoal]=deal(0,0);

% Initialise variables
l_edges=[];r_edges=[];
overall_edge_data=[];
colour=[0 0 1
        0 1 0
        0 1 1
        1 0 0
        1 0 1
        1 1 0
        1 1 1
        0 0 1
        0 1 0
        0 1 1
        1 0 0
        1 0 1
        1 1 0
        1 1 1
        0 0 1
        0 1 0
        0 1 1
        1 0 0
        1 0 1
        1 1 0
        1 1 1
        0 0 1
        0 1 0
        0 1 1
        1 0 0
        1 0 1
        1 1 0
        1 1 1];
    
start_positions=[0 -100];

search_co_ords=[];
% perform n trials
for j=1:1,%n
    % set the starting position hard coded as x=0 y=-6 at the moment
    [x0,y0]=deal(start_positions(1,1),start_positions(1,2));
    search_co_ords=search_co_ords;[x0,y0];
    %[x0,y0]=deal(x(1),y(1));
    % scan range set to -90 degrees to +90 degrees relative to current
    % heading
    scan_range=linspace(-pi/6,pi/6,90/rotation_stepsize);
    % set the starting orientation - pointing North at the moment
    th0=pi/2;
    % this is how many steps each test will run
    for i=1:1000
        [xx,yy]=deal(x0,y0);
        % to allow a simple way to rotate the images with a step less than
        % 1 pixel we start with 2 images 1/2 a pixel apart
        % we start 90 degrees from the current heading and step through
        % taking the last column of the image and adding to the start
        [im,im1,ed_im,ed_im1]=WehnergetView(x0,y0,z0,th0-pi/2,X,Y,Z);
        [imA,im1A,ed_imA,ed_im1A]=WehnergetView(x0,y0,z0,th0-pi/2+(0.5/360*2*pi),X,Y,Z);
            
        % For later steps Bart used im and im1
        if strcmp(filter,'edge'),
            im=ed_im;
            imA=ed_imA;
        end
        
        
        % empty the record of familiarity scores E
        E=zeros(1,90);
        cnt=0;
        for k=1:45
            % get the familiarity of current view
            % im(:) turns the matrix into a vector
            cnt=cnt+1;
            dec=infomax_decision(W,im(:));
            E(cnt)=dec;
            % take the last column off an add to start to gradually rotate
            % the image
            im=[im(:,end),im(:,1:end-1)];
            
            % do the same with the other image that is roatated 1/2 pixel
            % from the first
            cnt=cnt+1;          
            dec1=infomax_decision(W,imA(:));
            E(cnt)=dec1;
            % take the last column off an add to start to gradually rotate
            % the image
            imA=[imA(:,end),imA(:,1:end-1)];
        end
        % find the minimum across all 90 views
        [dummy,ind]=min(E);
        % determine the direction of the minimum and add some random noise
        th0=pi2pi(th0+scan_range(ind)+sig*randn(1));
        
        % plot progress
        figure(fh)
        plot([xx,xx+stepsize*cos(th0)],[yy,yy+stepsize*sin(th0)],...
            '-','Color',1*colour(j,:));
        axis equal
        drawnow
        
        % update new positions
        [x0,y0]=deal(xx+stepsize*cos(th0),yy+stepsize*sin(th0));
        
        search_co_ords=[search_co_ords;[x0,y0]];
        
        
        % stop if at goal
        if sqrt(dist2([x0,y0],[xgoal,ygoal]))<2 || x0<-200 || x0>200 || y0<-200 || y0>200
            break
        end    
    end
    save ( strcat(filename,'_R',num2str(trial_index)) ,'search_co_ords');
    clear search_co_ords
    search_co_ords=[];
end
% save the resulting figure
saveas(fh,strcat(filename,'_Paths.fig'))

% fh1=figure(2);
% clf
% % Plot the environment then overlay the search data - currently a scatter
% % plot but want a surfc
% set(fh1,'Position',[646    -3   560   420]);
% fill(X',Y','k')
% scatter(search_co_ords(:,1),search_co_ords(:,2),1,'b')
% % save the resulting figure
% saveas(fh1,strcat(filename,'_Search_As_Scatter.fig'))
%save(strcat(filename,'_Search_co_ords'),'search_co_ords');



% % Need to bin the path data so that I can plot in a heat map or a surf.
% topEdge=50;
% botEdge=-50;
% numBins=20;
% binEdges = linspace(botEdge, topEdge, numBins+1)
% % Plot the surf plot of the overall search distribution.
% figure;surfc(X,Y,Z);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INFOMAX FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function w = infomax_init2(V,H)
% function w = infomax_init(N)
%
% Initialises the weights of a familiarity discrimination network.
%
% Input:
%  N - size of the network
% Output:
%  w - the matrix of weights: each row corresponds to the weights of a single novelty neuron

w = randn(V,H) - 0.5;

% weight normalization to ensure mean = 0 and std = 1
w = w - repmat (mean(w,2), 1, H);
w = w ./ repmat (std(w,1,2), 1, H);

function weights = infomax_learn2(weights,patts,vars,lrate)
% Infomax "extended algorithm"
if nargin < 4
    str = 'A learning rate is required';
    id = 'LearningRule:noLrateError';
    fd_error(str, id);
end
[N, P] = size(patts);
[H,V] = size(weights);
% fd_disp('Presenting familiar patterns ...','filename');
for i=1:P
    u=weights*patts(:,i);
    y=tanh(u);
    weights = weights + lrate/N * (eye(H)-(y+u)*u') * weights;
    if any(any(isnan(weights)))
        str='Weights blew up';
        id='LearningRule:WeightBlowUpError';
%         fd_error(str, id);
    end
end

function decs = infomax_decision(weights,patts)
% Infomax decision function, using the sum of the absolute values of
% membrane potentials

result = weights*patts;
decs = sum(abs(result));

% function for bringing angles in to range -pi to pi
function x=pi2pi(x)
x=mod(x,2*pi);
x=x-(x>pi)*2*pi;

function n2 = dist2(x, c)
%DIST2	Calculates squared distance between two sets of points.
%
%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.
%
%	See also
%	GMMACTIV, KMEANS, RBFFWD
%

%	Copyright (c) Ian T Nabney (1996-2001)

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end