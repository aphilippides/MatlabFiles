
FileName='C:\Temp\Desmottes\Env_15Obj_1';

load(FileName);
%   EnvSize    SideEffectWidth    fac_awidth    nest   obj            

DataFileName = strcat(FileName, '_Monitor') ;
load(DataFileName);
%   X_Alv       Y_Alv       NObj    mx_Alv   my_Alv   HomewardComp   AlvNumSteps
%   trapx_Alv   trapy_Alv 

%   ObjSE           NObjSE         mx_Alv_SE       my_Alv_SE   HomewardCompSE
%   AlvNumStepsSE   trapx_Alv_SE   trapy_Alv_SE  

%   X_RmsE          Y_RmsE        RmsE          mx_RmsE   my_RmsE   
%   RmsENumSteps    trapx_RmsE    trapy_RmsE



Plot_ALV( 21,22,23,24,'tmp',X_Alv,Y_Alv, ...
                  obj,nest,fac_awidth,SideEffectWidth,NObj,mx_Alv,my_Alv, ...
                  HomewardComp,AlvNumSteps,trapx_Alv,trapy_Alv,0)           
Plot_ALV( 25,26,27,28,'tmp', X_Alv,Y_Alv,ObjSE,nest, ...
                  fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
                  HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)
Plot_RmsE( 31,32,33,'tmp', ...
                    X_RmsE,Y_RmsE,obj,nest,fac_awidth,SideEffectWidth, ...
                    mx_RmsE,my_RmsE,RmsE,RmsENumSteps,trapx_RmsE,trapy_RmsE,0)
;

%### for l=1:8
%###     [h19(l),p19(l),c] = ttest(tmpA(:,l),0,0.00001)
%### end
%### [p19;h19]
%###
%### for l=1:2:16
%###     [p14((l+1)/2),h14((l+1)/2)] = ranksum(tmpB(:,l),tmpB(:,l+1),0.05);
%### end
%### [p14;h14] 
%###
%### for l=1:8
%###     [h20(l),p20(l),c] = ttest(tmpA(:,l),0,0.05);
%### end
%### [p20;h20]








% % alpha = 0;
% % while alpha<Ons(1,1)& Ons(2,1)==1
% %     X=[0 300];
% %     X=X*sign(cos(alpha));
% %     Y=[0 tan(alpha)*X(2)];
% %     plot(X+300,Y+300)
% %     alpha = alpha+0.1;
% % end    
% % for j=1:size(Ons,2)-1
% %     alpha = Ons(1,j);
% %     X=[0 300];
% %     X=X*sign(cos(alpha));
% %     Y=[0 tan(alpha)*X(2)];
% %     plot(X+300,Y+300)
% %     while alpha<Ons(1,j+1)&Ons(2,j)==0
% %         X=[0 300];
% %         X=X*sign(cos(alpha));
% %         Y=[0 tan(alpha)*X(2)];
% %         plot(X+300,Y+300)
% %         alpha = alpha+0.1;
% %     end
% % end
% % j=size(Ons,2);
% % alpha = Ons(1,j);
% % X=[0 300];
% % X=X*sign(cos(alpha));
% % Y=[0 tan(alpha)*X(2)];
% % plot(X+300,Y+300)
% % while alpha<2*pi & Ons(2,j)==0
% %     X=[0 300];
% %     X=X*sign(cos(alpha));
% %     Y=[0 tan(alpha)*X(2)];
% %     plot(X+300,Y+300)
% %     alpha = alpha+0.1;
% % end



% File_Monitor=strcat(FileName,'_Edge_Monitor.mat');
% mx_Edge=mx_Alv;
% my_Edge=my_Alv;
% HomewardComp_Edge=HomewardComp;
% EdgeNumSteps=AlvNumSteps;
% save( File_Monitor,'mx_Edge','my_Edge', ...
%           'HomewardComp_Edge','EdgeNumSteps');



% % function[AverageHomewardComp,AHC_Dist]...
% %     =Data_Within_Catch_RmsE(nest,nest_grid,X,Y,mx,my,HomewardComp)
% % 
% % [I,J]=meshgrid(1:size(X)) ;
% % I=I-nest_grid(1)*ones(size(X)) ;
% % J=J-nest_grid(2)*ones(size(X)) ;
% % Grid_Distance=round(sqrt(I.^2+J.^2)) ;
% % 
% % % Initializations
% % NumSteps=NaN(size(X)) ;
% % AverageHomewardComp=NaN(size(X)) ;
% % AHC_Dist=[]; % ### WARNING ### box number i => dist = i-1 
% % AHC_Dist_pond=[] ;
% % 
% % % Initialize Fifo with each grid point within the nest area and the
% % % invariance area (ALV==0)
% % Fifo = [];
% % StartFifo = [nest_grid(2) nest_grid(1)] ;
% % 
% % while size(StartFifo,1) > 0
% %     Local = StartFifo(1,:) ; 
% %     for i=-1:1
% %         for j=-1:1
% %            Neighbour = Local + [i j] ;
% %            if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
% %                -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
% %                & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
% %                % ### WARNING ### vector (i,j) is expected to be the
% %                % vector from the Local box to the neighbour but since 
% %                % the data organisation is different between the array 
% %                % and the image (NE-SW symetry)
% %                % i and j have thus been switched to cope with this problem                   
% %                if ( mx(Neighbour(1),Neighbour(2))==0 & my(Neighbour(1),Neighbour(2))==0 )
% %                    Fifo = [Fifo ; Neighbour] ;
% %                    StartFifo = [StartFifo ; Neighbour] ;
% %                    NumSteps(Neighbour(1),Neighbour(2))=0;
% %                    AverageHomewardComp(Neighbour(1),Neighbour(2))=0;
% %                end
% %            end
% %         end 
% %     end
% %     StartFifo(1,:) = [] ;
% % end
% % 
% % % Initialize the catchment area to the area covered by the nest
% % % Radius of the nest expressed as a number of grid interval
% % r = round(nest(3)/(Y(2)-Y(1)));
% % for i=-r:r
% %     for j=-r:r
% %          if( (X(1,nest_grid(1)+i)-nest(1))^2 + ...
% %              (Y(nest_grid(2)+j,1)-nest(2))^2 <= nest(3)^2  )
% %             % ### WARNING ### See comment below
% %             Fifo = [Fifo ; [nest_grid(2)+j nest_grid(1)+i] ] ;
% %             NumSteps(nest_grid(2)+j,nest_grid(1)+i)=0;
% %             AverageHomewardComp(nest_grid(2)+j,nest_grid(1)+i)=0;
% %          end
% %     end
% % end
% % 
% % while size(Fifo,1) > 0
% %     Local = Fifo(1,:) ; 
% %     for i=-1:1
% %         for j=-1:1
% %            Neighbour = Local + [i j] ;
% %            if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
% %                -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
% %                & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
% %                % ### WARNING ### vector (i,j) is expected to be the
% %                % vector from the Local box to the neighbour but since 
% %                % the data organisation is different between the array 
% %                % and the image (NE-SW symetry)
% %                % i and j have thus been switched to cope with this problem                   
% %                if (   mx(Neighbour(1),Neighbour(2))~=0 ... 
% %                     | my(Neighbour(1),Neighbour(2))~=0 )
% %                    if ( (mx(Neighbour(1),Neighbour(2))*j+my(Neighbour(1),Neighbour(2))*i)/ ... 
% %                         (sqrt(mx(Neighbour(1),Neighbour(2))^2+my(Neighbour(1),Neighbour(2))^2) ...
% %                         *sqrt(i^2+j^2))<=(-cos(pi/8)+10^(-15)))
% %                        %need to add 10^-15 to solve some strange
% %                        %approximation problems
% %                        
% %                        AverageHomewardComp(Neighbour(1),Neighbour(2)) = AverageHomewardComp(Local(1),Local(2)) + HomewardComp(Neighbour(1),Neighbour(2));
% %                        
% %                        NumSteps(Neighbour(1),Neighbour(2)) = NumSteps(Local(1),Local(2)) + 1 ;
% %                        Fifo = [Fifo;Neighbour];
% %                    end
% %                end
% %            end
% %         end 
% %     end
% %     
% %     tmp=Grid_Distance(Local(1),Local(2))+1;
% %     if( size(AHC_Dist,2) < tmp )
% %         AHC_Dist( tmp ) = HomewardComp(Local(1),Local(2)) ;
% %         AHC_Dist_pond( tmp ) = 0 ;
% %     else
% %         if ( isnan(HomewardComp(Local(1),Local(2))) )
% %             AHC_Dist(tmp)=AHC_Dist(tmp)+1 ;
% %         else
% %             AHC_Dist(tmp)=AHC_Dist(tmp)+HomewardComp(Local(1),Local(2));
% %         end
% %         AHC_Dist_pond(tmp)=AHC_Dist_pond(tmp)+1 ;
% %     end
% %         
% %     AverageHomewardComp(Local(1),Local(2))=AverageHomewardComp(Local(1),Local(2))/(NumSteps(Local(1),Local(2))+1);
% %     Fifo(1,:) = [] ;
% % end
% % 
% % AHC_Dist = AHC_Dist./( AHC_Dist_pond+1 ) ;



% figure(11)
% hold on
% plot(X(find(Trap==1)),Y(find(Trap==1)),'Xk')
% figure(10)
% title('Summed Squared Errors')
% axis([420 580 425 585 ])
% figure(11) 
% title('Catchment Area')
% axis([420 580 425 585 ])


% % figure(44)
% % hold off ;
% % DrawEnvironment(obj, nest) ;
% % axis([X_RmsE(1)  X_RmsE(end)  Y_RmsE(1)  Y_RmsE(end)]) ;
% % hold on ;
% % pcolor(X_RmsE,Y_RmsE,HomewardComp_RmsE) ;
% % %    colorbar ;
% % shading interp;
% % hold off          


% figure(40)
% hold off ;
% DrawEnvironment(obj, nest) ;
% plot([X_RmsE(1) X_RmsE(end) X_RmsE(end) X_RmsE(1) X_RmsE(1)], [Y_RmsE(1) Y_RmsE(1) Y_RmsE(end) Y_RmsE(end) Y_RmsE(1)],'--k')
% axis([0 1000 0 1000 ])
% hold on ;
% pcolor(X_RmsE,Y_RmsE,MapObj) ;
% shading flat;
% hold off
% 
% axis([280 720 280 720 ])
% 
% figure(41)
% hold on ;
% MyCircle([426.7052 573.9557],15,'k') ;
% plot(426.7052 , 573.9557,'rX')
% hold off


% % MapObj=zeros(size(X_Alv));
% % r = ceil(SideEffectWidth/(X_Alv(1,2)-X_Alv(1,1))) ;
% % for k=1:size(obj,1)
% %     for i=-r:r
% %         for j=-r:r
% %             y=i*2+obj(k,1);
% %             x=j*2+obj(k,2);
% %             if (x>=(X_Alv(1)-1) & y>=(Y_Alv(1)-1) & x<=(X_Alv(end)+1) & y<=(Y_Alv(end)+1))
% %                 Grid_Pos=Find_Nest_Grid(X_Alv,Y_Alv,[x y]);
% %                 if( (X_Alv(Grid_Pos(1),Grid_Pos(2))-obj(k,1))^2 ...
% %                         + (Y_Alv(Grid_Pos(1),Grid_Pos(2))-obj(k,2))^2 ...
% %                         <= SideEffectWidth^2 )
% %                     MapObj(Grid_Pos(1),Grid_Pos(2))=MapObj(Grid_Pos(1),Grid_Pos(2))+1;
% %                 end
% %                 if( (X_Alv(Grid_Pos(1),Grid_Pos(2))-obj(k,1))^2 ...
% %                         + (Y_Alv(Grid_Pos(1),Grid_Pos(2))-obj(k,2))^2 ...
% %                         <= obj(k,3)^2 )
% %                     MapObj(Grid_Pos(1),Grid_Pos(2))=NaN;
% %                 end
% %             end
% %         end
% %     end
% % end
% % MapObj(find(isnan(MapObj)))=-1;
% % figure(50)
% % hold off ;
% % DrawEnvironment(obj, nest) ;
% % axis([0 1000 0 1000 ])
% % hold on ;
% % pcolor(X_Alv,Y_Alv,MapObj) ;
% % shading flat;
% % hold off
% % figure(50)
% % axis([280 720 280 720 ])
% % figure(33)
% % axis([280 720 280 720 ])


% obj=[ 610 630 10;630 610 10; 550 400 10 ];

% FileNameRoot2=strcat(strcat(FileNameRoot,'15'),'Obj_');
% FileName=strcat(FileNameRoot2,sprintf('%d',j));
% load(FileName);
% DataFileName = strcat(FileName, '_Monitor') ;
% load(DataFileName);
% 
% figure(30)
% hold off ;
% DrawEnvironment(obj,nest) ;
% axis([0  1000  0  1000]) ;
% hold on
% pcolor(X_Alv,Y_Alv,NObj), shading flat;
% hold on
% title('Number of objects seen, 15 objects in the Environment')
% 
% t = (1/64:1/32:1)'*2*pi;
% x = 10*sin(t);
% y = 10*cos(t);
% a=x*ones(1,15)
% a=a+(obj(:,1)*ones(1,32))'
% b=y*ones(1,15)
% b=b+(obj(:,2)*ones(1,32))'
% fill(a,b,[0 0 0.6])
% hold off


% figure(4)
% title('Eccentricity of Catchment Area')


% % FileNameRoot = 'C:\Temp\Desmottes\Env_' ;
% % j=23;
% % FileNameRoot2=strcat(strcat(FileNameRoot,'25'),'Obj_');
% % FileName=strcat(FileNameRoot2,sprintf('%d',j));
% % load(FileName);
% % DataFileName = strcat(FileName, '_Monitor') ;
% % load(DataFileName);
% % f1=56;f2=57;f3=58;f4=59;
% % figure(f1)
% % clf;
% % DrawEnvironment(obj, nest) ;
% % axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% % hold on ;
% % pcolor(X_Alv,Y_Alv,(HomewardComp)*20) ;
% % colorbar, shading flat;
% % [c h]=contour(X_Alv,Y_Alv,NObj,[1:25],'k');
% % title('20*Cosinus(homeward vector error) & discontinuities in vision')
% % hold off
% % figure(f2)
% % hold off ;
% % DrawEnvironment(obj,nest) ;
% % axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% % hold on
% % pcolor(X_Alv,Y_Alv,NObj), colorbar, shading flat;
% % hold off
% % figure(f3)
% % hold off
% % DrawEnvironment(obj,nest) ;
% % axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% % hold on
% % pcolor(X_Alv,Y_Alv,AlvNumSteps);
% % shading flat;
% % plot(Y_Alv(trapy_Alv,1),X_Alv(1,trapx_Alv),'Xk');
% % contour(X_Alv,Y_Alv,NObj,[1:25],'k');
% % title('Catchment Area & discontinuities in vision')
% % hold off
% % figure(f4)
% % clf;
% % DrawEnvironment(obj, nest) ;
% % axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% % hold on ;
% % pcolor(X_Alv,Y_Alv,(HomewardComp)*20) ;
% % colorbar, shading flat;
% % hold off


% FileName=strcat(strcat(FileNameRoot,'50'),'Obj_32');
% load(FileName);
% DataFileName = strcat(FileName, '_Monitor') ;
% load(DataFileName);
% Plot_ALV( 35,36,37,38,'tmp',X_Alv,Y_Alv, ...
%                   ObjSE,nest,fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
%                   HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)
% 
% figure(37)
% %axis([200  800  200  800]) ;
% 
% figure(36)
% title('Cosinus of homeward vector error')
% saveas(36, '\\profiles\jd205\WindowsProfile\My Documents\PPL\Im_Rapp\SurroundnessAngle') ;
% 
% figure(37)
% DrawEnvironment(obj,nest) ;
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on
% pcolor(X_Alv,Y_Alv,NObjSE), colorbar, shading flat;
% title('Number of objects seen')
% saveas(37, '\\profiles\jd205\WindowsProfile\My Documents\PPL\Im_Rapp\SurroundnessNObj') ;
% 
% figure(38)
% title('Catchment Area (Number of steps)')
% saveas(38, '\\profiles\jd205\WindowsProfile\My Documents\PPL\Im_Rapp\SurroundnessCatch') ;
 

% % Trap(find(~Trap))=NaN;
% % figure(35)
% % hold on
% % pcolor(X,Y,Trap), shading flat;
% % 
% % nest = [500 500 8];
% % nest_grid=Find_Nest_Grid(X,Y,nest);
% % NumSteps=NaN(size(X)) ;
% % StartFifo = [nest_grid(2) nest_grid(1)] ;
% % while size(StartFifo,1) > 0
% %     Local = StartFifo(1,:) ; 
% %     for i=-1:1
% %         for j=-1:1
% %            Neighbour = Local + [i j] ;
% %            if ( Neighbour(1)*Neighbour(2)*(size(X,1)+1 ...
% %                -Neighbour(1))*(size(X,2)+1-Neighbour(2))~=0 ... 
% %                & isnan(NumSteps(Neighbour(1),Neighbour(2))) )
% %                if ( mx(Neighbour(1),Neighbour(2))==0 & my(Neighbour(1),Neighbour(2))==0 )
% %                    StartFifo = [StartFifo ; Neighbour] ;
% %                    NumSteps(Neighbour(1),Neighbour(2))=0;
% %                end
% %            end
% %         end 
% %     end
% %     StartFifo(1,:) = [] ;
% % end
% % r = round(nest(3)/(Y(2)-Y(1)));
% % for i=-r:r
% %     for j=-r:r
% %          if( (X(1,nest_grid(1)+i)-nest(1))^2 + ...
% %              (Y(nest_grid(2)+j,1)-nest(2))^2 <= nest(3)^2  )
% %             NumSteps(nest_grid(2)+j,nest_grid(1)+i)=0;
% %          end
% %     end
% % end
% % NumSteps=NumSteps+2;
% % NumSteps(1)=-3;
% % NumSteps(2)=5;
% % figure(35)
% % hold on;
% % pcolor(X,Y,NumSteps), shading flat;


% figure(7)
% xlabel('Number of objects seen')
% title('Configuration')


% % FileNameRoot2=strcat(strcat(FileNameRoot,'45'),'Obj_');
% % FileName=strcat(FileNameRoot2,sprintf('%d',j));
% % load(FileName);
% % DataFileName = strcat(FileName, '_Monitor') ;
% % load(DataFileName);
% % Plot_ALV( 31,32,33,34,'tmp', X_Alv,Y_Alv,ObjSE,nest, ...
% %                       fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
% %                       HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)
% % FileNameRoot2=strcat(strcat(FileNameRoot,'50'),'Obj_');
% % FileName=strcat(FileNameRoot2,sprintf('%d',j));
% % load(FileName);
% % DataFileName = strcat(FileName, '_Monitor') ;
% % load(DataFileName);
% % Plot_ALV( 35,36,37,38,'tmp', X_Alv,Y_Alv,ObjSE,nest, ...
% %                       fac_awidth,SideEffectWidth,NObjSE,mx_Alv_SE,my_Alv_SE, ...
% %                       HomewardCompSE,AlvNumStepsSE,trapx_Alv_SE,trapy_Alv_SE,0)


% figure(5)
% hold off
% plot(Y_Alv(trapy_Alv,1),X_Alv(1,trapx_Alv),'b.');
% axis([X_Alv(1)  X_Alv(end)  Y_Alv(1)  Y_Alv(end)]) ;
% hold on
% DrawEnvironment(obj,nest) ;
% title('Invariance area')
% hold off             


% % saveas(7, '\\profiles\jd205\WindowsProfile\My Documents\PPL\Im_Rapp\') ;


% figure(25)
% clf ;
% hold on ;
% plot(X1,A_NestLocSiz,'r*')
% plot(X2,A_NestLocSizSE,'b*')
% ylim('auto')
% xlim('auto')
% hold off ;
% 
% % % tmpA=sparse(50,8);
% % % tmpA(:)=A_NestLocSiz(:);
% % % tmpB(:,1:2:16)=tmpA;
% % % tmpA(:)=A_NestLocSizSE(:);
% % % tmpB(:,2:2:16)=tmpA;
% % % 
% % % figure(25)    
% % % hold off ;
% % % boxplot(tmpB,'notch','on');
% % % hold off;
% % % 
% % % % % figure(25)
% % % % % clf;
% % % % % hold on;
% % % % % plot([15:5:50],NestLocSiz,'-or')
% % % % % plot([15:5:50],NestLocSizSE,'-ob')
% % % % % ylim('auto')
% % % % % xlim('auto')
% % % % % hold off ;

% % FileName='figtest';
% %     saveas(1, strcat(FileName,'1CatchsRatio'),'jpg' ) ;
% %     saveas(2, strcat(FileName,'2CatchLocRatio'),'jpg'  ) ;
% %     saveas(3, strcat(FileName,'3MeanChNumOb'),'jpg'  ) ;
% %     saveas(4, strcat(FileName,'4NumLocCatch'),'jpg'  ) ;
% %     saveas(5, strcat(FileName,'5NumTrap'),'jpg'  ) ;
% %     saveas(6, strcat(FileName,'6Radius'),'jpg'  ) ;
% %     saveas(7, strcat(FileName,'7CatchsRatio'),'jpg'  ) ;
% %     saveas(8, strcat(FileName,'8CatchLocRatio'),'jpg'  ) ;
% %     saveas(9, strcat(FileName,'9MeanChNumOb'),'jpg'  ) ;
% %     saveas(10, strcat(FileName,'10NumLocCatch'),'jpg'  ) ;
% %     saveas(11, strcat(FileName,'11NumTrap'),'jpg'  ) ;
% %     saveas(12, strcat(FileName,'12Radius'),'jpg'  ) ;
% %     saveas(13, strcat(FileName,'13CatchsRatio'),'jpg'  ) ;
% %     saveas(14, strcat(FileName,'14CatchLocRatio'),'jpg'  ) ;
% %     saveas(19, strcat(FileName,'19CatchsRatio') ,'jpg' ) ;
% %     saveas(20, strcat(FileName,'20CatchLocRatio'),'jpg'  ) ;


% figure(29) ;
% hold off ;
% DrawEnvironment(obj,nest) ;
% hold on ;
% MyCircle(nest([1 2]),SideEffectWidth,'k') ;
% plot([X_Alv(1) X_Alv(end) X_Alv(end) X_Alv(1) X_Alv(1)], [Y_Alv(1) Y_Alv(1) Y_Alv(end) Y_Alv(end) Y_Alv(1)],'--k')
% xlim([0 EnvSize])
% ylim([0 EnvSize])
% title('No Side Effect')
% hold off ;
% 
% figure(30) ;
% hold off ;
% DrawEnvironment(ObjSE,nest) ;
% hold on ;
% MyCircle(nest([1 2]),SideEffectWidth,'k') ;
% plot([X_Alv(1) X_Alv(end) X_Alv(end) X_Alv(1) X_Alv(1)], [Y_Alv(1) Y_Alv(1) Y_Alv(end) Y_Alv(end) Y_Alv(1)],'--k')
% xlim([0 EnvSize])
% ylim([0 EnvSize])
% title('Side Effect')
% hold off ;