function Plot_ALV( fig1,fig2,fig3,fig4,FileName, ...
                   X,Y,obj,nest,fac_awidth,SideEffectWidth,NObj, ...
                   mx,my,Angle,NumSteps,trapx,trapy,Save_Figures)

%%%%%% 1st figure : plot nest, objects and homing vectors, draw the field 
% of view from the nest as a black circle
figure(fig1) ;
hold off ;
DrawEnvironment(obj,nest) ;
hold on ;
MyCircle(nest([1 2]),SideEffectWidth,'k') ;
axis tight ;
hold on ;
quiver(X,Y,mx,my)
%    contour(X,Y,Angle), colorbar ;
hold off ;

%%%%% 2nd figure : plot the environment, the homing vector accuracy and the
% contour of the number of objects seen
figure(fig2)
hold off ;
DrawEnvironment(obj, nest) ;
axis([X(1)  X(end)  Y(1)  Y(end)]) ;
hold on ;
pcolor(X,Y,Angle) ;
%    colorbar ;
shading interp;
%    hold on ;
%    [c h]=contour(X,Y,NObj./max(max(NObj)));
%    colorbar
%    axis tight
hold off

%%%%% 3rd figure : plot the number of objects seen with black circles
% which radius shows the area where this object can be seen
figure(fig3)
hold off ;
DrawEnvironment(obj,nest) ;
axis([X(1)  X(end)  Y(1)  Y(end)]) ;
hold on
pcolor(X,Y,NObj), colorbar, shading flat;
hold on
MyCircle(obj(:,[1 2]), obj(:,3)/sin(0.5*fac_awidth), 'k');
hold off

%%%%% 4th figure : plot the catchment area with colour varying according to
% the number of steps needed to reach the nest (8 connexity used)
figure(fig4)
hold off
DrawEnvironment(obj,nest) ;
axis([X(1)  X(end)  Y(1)  Y(end)]) ;
%    hold on
%    MyCircle(obj(:,[1 2]), obj(:,3)/sin(0.5*fac_awidth), 'k');
hold on
pcolor(X,Y,NumSteps) ;
%    colorbar ;
shading flat;
hold on
plot(Y(trapy,1),X(1,trapx),'Xk');
hold off

if ( Save_Figures )
    saveas(fig1, strcat(FileName,'_Fig_AlvArrows.fig') ) ;
    saveas(fig2, strcat(FileName,'_Fig_AlvAccur.fig') ) ;
    saveas(fig3, strcat(FileName,'_Fig_NumObjSeen.fig') ) ;
    saveas(fig4, strcat(FileName,'_Fig_AlvCatch.fig') ) ;
end