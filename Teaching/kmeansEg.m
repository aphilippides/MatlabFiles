% kmeansEg(k,n,bad)
%
% demo program showing on-line kmeans in action
% generates data from 3 normal distributions and runs on-line k-means for 100 iterations
%
% k is number of centers fitted (default 3)
% n is number of points in each distributin (default 10)
% set 'bad' to 1 (default 0) to start with a bad choice of centres (1st 2 
% out of range of data so you get 'empty' centres
%
% USAGE:
% kmeansEg                % 3 centres and 10 points in each distribution
% kmeansEg(5)             % 5 centres and 10 points in each distribution
% kmeansEg(2,15)          % 2 centres and 15 points in each distribution
% kmeansEg(4,15,1)        % 4 centres and 15 points, 2 centres initialised badly 

function kmeansEg(k,n,bad)

if(nargin<1) k=3; end
if(nargin<2) n=10; end
if(nargin<3) bad=0; end

x1=MyMvnrnd([0 0],[1 0;0 1],n);
x2=MyMvnrnd([0 5],[1 0;0 0.1],n);
x3=MyMvnrnd([5 3],[1 0.5;0.5 1],n);

X=[x1;x2;x3];
plot(X(:,1),X(:,2),'go')
OnLineKMeans(k,X,0.1,bad)


function OnLineKMeans(k,X,lr,bad)
NData=size(X,1);
rp=randperm(NData);
centres=X(rp(1:k),:);
if bad
    centres(1:3,:)=[-3,6;-2,6;1,3 ];
end
plot(X(:,1),X(:,2),'go',centres(:,1),centres(:,2),'rx','LineWidth',2,'MarkerSize',12)

Mov=1;
Tol=0.1;

title('initial data: press any key to continue')
disp('initial data: press any key to continue')
pause;

trails =[];
drawingtrails=1;
count=0
figure(1)
while((Mov>Tol)&(count<100))
    Mov=0;
    count=count+1
    OldC=centres;
    for i=randperm(NData)
        x=X(i,:);
        xmin=centres -ones(length(centres),1)*x;
        [dmin,mind]=min(sum(xmin.^2,2));
        centres(mind,:)=centres(mind,:)-lr*xmin(mind,:);
        Mov=Mov+dmin;
        trails=[trails;centres];
        if(drawingtrails)
            plot(X(:,1),X(:,2),'go',x(1),x(2),'bs','LineWidth',2,'MarkerSize',12)
            hold on;
            for i=1:length(centres)
                cols=['r', 'k','b','c','y','g'];
                cstr=[cols(i) '-x'];
                plot(trails(i:length(centres):end,1),trails(i:length(centres):end,2),cstr,'LineWidth',2,'MarkerSize',12)
            end
            title('data and centres; current point is blue square')
            hold off;
                r=input('enter c to skip to end','s');
            if(r=='c') drawingtrails=0;            end
        end
    end
    Mov=sum(sqrt(sum((centres-OldC).^2,2)))
end
figure(2)
plot(X(:,1),X(:,2),'go','LineWidth',2,'MarkerSize',12)
hold on;
for i=1:length(centres)
    cols=['r', 'k','b','c','y','g'];
    cstr=[cols(i) '-x'];
    plot(trails(i:length(centres):end,1),trails(i:length(centres):end,2),cstr,'LineWidth',2,'MarkerSize',12)
end
hold off;
figure(3)
for i=1:length(centres)
    cols=['r', 'k','b','c','y','g'];
    cstr=[cols(i) 'x'];
    plot(centres(i,1),centres(i,2),cstr,'LineWidth',2,'MarkerSize',12)
    hold on
end
for i=1:NData
    cols=['r', 'k','b','c','y','g'];
    x=X(i,:);
    xmin=centres -ones(length(centres),1)*x;
    [dmin,mind]=min(sum(xmin.^2,2));
    cstr=[cols(mind) 'o'];
    plot(X(i,1),X(i,2),cstr,'LineWidth',2,'MarkerSize',12)
end
hold off

function r = MyMvnrnd(mu,sigma,cases);
%MVNRND Random matrices from the multivariate normal distribution.
%   R = MVNRND(MU,SIGMA,CASES) returns a matrix of random numbers chosen   
%   from the multivariate normal distribution with mean vector, MU, and 
%   covariance matrix, SIGMA. CASES is the number of rows in R.
%
%   SIGMA is a symmetric positive definite matrix with size equal to the 
%   length of MU

%   B.A. Jones 6-30-94
%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:51 $


[m1 n1] = size(mu);
c = max([m1 n1]);
if m1 .* n1 ~= c
   error('Mu must be a vector.');
end

[m n] = size(sigma);
if m ~= n
   error('Sigma must be square');
end

if m ~= c
   error('The length of mu must equal the number of rows in sigma.');
end

[T p] = chol(sigma);
if p ~= 0
  error('Sigma must be a positive definite matrix.');
end


if m1 == c
  mu = mu';
end

mu = mu(ones(cases,1),:);

r = randn(cases,c) * T + mu;
