function[expa , b]=GetConcVsDiamRelationship(DFromSurf,B)
if(DFromSurf==-1)
    load CentTubeConcsB1T1;
    Conc=CentConc;
    diams=Diams(1:105);
elseif(DFromSurf==0)
    load TubeSurfaceConcDiam0_1_10B1;
    Conc=SurfaceTubeConc;
    diams=Diams;
else
    fn=['ConcsD' x2str(DFromSurf) 'FromSurfB' x2str(B) 'T' x2str(B) 'DiffDiams.mat'];
    load(fn)
end
ld=log(diams);
lc=log(Conc);
md=mean(ld);mc=mean(lc);
b=regress(lc'-mc,ld'-md);
a=mc-b*md;

subplot(2,1,1)
plot(ld,lc,'rx',ld,b*ld+a,'b')
title(['log(C) vs log(diam) with linear regression'])
h=xlabel('log(Diameters)');MoveXYZ(h,-0.1,0.02,0) 
ylabel('log(Concentration)')

subplot(2,1,2)
plot(diams,Conc,'rx',diams,exp(a)*(diams.^b),'b')
h=title(['plot of C = ' num2str(exp(a),2) ' d\^(' num2str(b,3) ')']);
MoveXYZ(h,0.1,-0.02,0); 
xlabel('Diameters');ylabel('Concentration')
expa=exp(a);