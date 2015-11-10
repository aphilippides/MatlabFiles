function Plot_RmsE( fig1,fig2,fig3,FileName, ...
                    X,Y,obj,nest,fac_awidth,SideEffectWidth, ...
                    mx,my,RmsE,NumSteps,trapx,trapy,Save_Figures)

%%%%% 1st figure  : plot the nest & objects, draw the field of view from 
% the nest as a black circle ; plot the direction pointed from each
% point of the grid
figure(fig1)
hold off ;
DrawEnvironment(obj,nest) ;
hold on ;
MyCircle(nest([1 2]),SideEffectWidth,'k') ;
axis tight ;
hold on ;
quiver(X,Y,mx,my)
hold off;

%%%%% 2nd figure : plot the average rms error at each point
figure(fig2)
hold off ;
DrawEnvironment(obj,nest) ;
axis([X(1)  X(end)  Y(1)  Y(end)]) ;
hold on ;
pcolor(X,Y,RmsE);
%    colorbar;
shading flat;
hold off

%%%%% 3rd figure : plot the catchment area with colour varying according to
% the number of steps needed to reach the nest (8 connexity used)
figure(fig3)
hold off
DrawEnvironment(obj,nest) ;
axis([X(1)  X(end)  Y(1)  Y(end)]) ;
hold on
pcolor(X,Y,NumSteps);
%    colorbar;
shading flat;
hold on
plot(Y(trapy,1),X(1,trapx),'Xk');
hold off

if ( Save_Figures )
    saveas(9, strcat(FileName,'_Fig_RmsEArrows.fig') ) ;
    saveas(10, strcat(FileName,'_Fig_RmsE.fig') ) ;
    saveas(11, strcat(FileName,'_Fig_RmsECatch.fig') ) ;
end