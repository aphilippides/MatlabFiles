function [X,P]=EKFmeasure(XYZ,X,P,R,n)

Xdim=6;
ind1=3*(n-1)+Xdim+1;
ind2=3*(n-1)+Xdim+3;
% Get the current estimate for landmark number n
L=X(ind1:ind2);

% Make a prediction of heading
[h, dhdX,dhdY]=Measurement_Model(X,L);

% Calculate innovation / predicted uncertainty
Pxx=P(1:Xdim,1:Xdim);
Pxy=P(1:Xdim,ind1:ind2);
Pyx=P(ind1:ind2,1:Xdim);   
Pyy=P(ind1:ind2,ind1:ind2);

S=dhdX*Pxx*dhdX' + dhdX*Pxy*dhdY' + dhdY*Pyx*dhdX' + dhdY*Pyy*dhdY'+ R;

% Calculate Kalman gain
W=P(:,1:Xdim)*dhdX'*pinv(S) + P(:,ind1:ind2)*dhdY'*pinv(S);

% Update state and covariance 
% XYZ is the actual measurement
X=X+W*(XYZ-h);
P=P-W*S*W';

