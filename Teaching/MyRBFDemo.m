function MyRBFDemo(s)

x=[0 0;0 1;1 0;1 1];
a=sqrt(2);
O=[0 1 1 a; 1 0 a 1; 1 a 0 1;a 1 1 0];
d=[ 0 1 1 0]';
w=(O^-1)*d;
%[X,Y] = meshgrid(0:0.1:1, 0:0.1:1);
X=[0:0.1:1];
for i=1:length(X)
    for j=1:length(X)
        Z(i,j)=VecNorm(x,[X(i) X(j)])'*w;  %CHANGED VecNorm so this won't work!!!!!
    end
end   

O2=MyGauss(O,s)
w2=(O2^-1)*d;
for i=1:length(X)
    for j=1:length(X)
        Z2(i,j)=MyGauss(VecNorm(x,[X(i) X(j)]),s)'*w2;
    end
end   
axis tight;
subplot(2,2,1), surf(Z);axis tight;
title('Outputs from Linear Rbf Net')
subplot(2,2,2), surf(Z2);axis tight;
title('Outputs from Gaussian Rbf Net')
D=Z2-Z;
subplot(2,2,3), surf(D);axis tight;
xlabel({'Difference in Activations between';'Linear and Gaussian Nets'})
l=floor(length(D)/2);
Y=MyGauss(X,s);
subplot(2,2,4), 
plot(X,X,'r:x',X,invert(Y),'b',X,invert(X),'r:x',X,Y);axis tight;
legend('linear','gaussian')
xlabel('Profile of rbfs')

function[o]= MyGauss(x,s)

o=exp(-0.5.*((x./s).^2));