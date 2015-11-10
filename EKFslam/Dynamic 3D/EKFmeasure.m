function [X,P]=EKFmeasure(XYZ,X,P,R,n)

ind1=3*(n-1)+7;
ind2=3*(n-1)+9;
% Get the current estimate for landmark number n
L=X(ind1:ind2);

% Make a prediction of heading
[h, dhdX,dhdY]=Measurement_Model(X,L);

% Calculate innovation / predicted uncertainty
Pxx=P(1:6,1:6);
Pxy=P(1:6,ind1:ind2);
Pyx=P(ind1:ind2,1:6);   
Pyy=P(ind1:ind2,ind1:ind2);

S=dhdX*Pxx*dhdX' + dhdX*Pxy*dhdY' + dhdY*Pyx*dhdX' + dhdY*Pyy*dhdY'+ R;

% Calculate Kalman gain
W=P(:,1:6)*dhdX'*pinv(S) + P(:,ind1:ind2)*dhdY'*pinv(S);

% Update state and covariance 
% z is the actual measurement
X=X+W*(XYZ-h);
P=P-W*S*W';

