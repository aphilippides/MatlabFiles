function [X,P]=EKFmeasure(z,X,P,R,n)

ind1=2*(n-1)+4;
ind2=2*(n-1)+5;
% Get the current estimate for landmark number n
L=X(ind1:ind2);

% Make a prediction of heading
[h, dhdX,dhdY]=Measurement_Model(X,L);

% Calculate innovation / predicted uncertainty
Pxx=P(1:3,1:3);
Pxy=P(1:3,ind1:ind2);
Pyx=P(ind1:ind2,1:3);   
Pyy=P(ind1:ind2,ind1:ind2);

S=dhdX*Pxx*dhdX' + dhdX*Pxy*dhdY' + dhdY*Pyx*dhdX' + dhdY*Pyy*dhdY'+ R;

% Calculate Kalman gain
W=P(:,1:3)*dhdX'*pinv(S) + P(:,ind1:ind2)*dhdY'*pinv(S);

% Update state and covariance 
% z is the actual measurement
X=X+W*(atan(tan(z-h)));
P=P-W*S*W';

