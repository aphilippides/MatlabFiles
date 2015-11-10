function NewTheta=GetTheta(OldTheta)

[x,y]=pol2cart(OldTheta,ones(size(OldTheta)));

[NewTheta, JunkR] = cart2pol(x,y);