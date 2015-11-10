function [X,P]=EKFmeasure(z,X,P,R,n)

% Get the current estimate for landmark number n
L=X(2*(n-1)+3:2*(n-1)+4);

% Make a prediction of heading
[h, dhdX,dhdY]=Measurement_Model(X,L);

% Calculate innovation / predicted uncertainty
Pxx=P(1:2,1:2);
Pxy=P(1:2,2*(n-1)+3:2*(n-1)+4);
Pyx=P(2*(n-1)+3:2*(n-1)+4,1:2);   
Pyy=P(2*(n-1)+3:2*(n-1)+4,2*(n-1)+3:2*(n-1)+4);

S=dhdX*Pxx*dhdX' + dhdX*Pxy*dhdY' + dhdY*Pyx*dhdX' + dhdY*Pyy*dhdY'+ R;

% Calculate Kalman gain
W=P(:,1:2)*dhdX'*pinv(S) + P(:,2*(n-1)+3:2*(n-1)+4)*dhdY'*pinv(S);

% Update state and covariance 
% z is the actual measurement
X=X+W*(atan(tan(z-h)));
P=P-W*S*W';

