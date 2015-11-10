function[mv] = GetMovement(old_mv,alv,wpt,dx,DoSmooth)

mv = (alv-wpt);
l=norm(mv);
if (l==0)
    disp('grr');
    mv=old_mv(end,:);
    return;
end
mv=2*mv/l; %%%Pas terrible si vect egaux. effet d'echantillonage ?

if(DoSmooth)
    t1=cart2pol(mv(1),mv(2));
    t2=cart2pol(old_mv(end,1),old_mv(end,2));
    d=min(1,abs(AngularDifference(t1,t2)/(0.5*pi)));
    mv=(1-d)*mv + d*old_mv(end,:);
%     mv=0.5*(mv+old_mv(end,:));
end
% dx=max(l,dx);
% mv = dx*m/l;