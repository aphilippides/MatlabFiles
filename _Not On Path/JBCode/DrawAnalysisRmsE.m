function DrawAnalysisRmsE

FileNameRoot = 'C:\Temp\Desmottes\Env_' ;

A_Catch_Env_Ratio_Alv = [] ;
A_Bigest_Radius_Alv =[] ;
A_Num_Trap_Alv = [] ;

A_Catch_Env_Ratio_RmsE = [] ;
A_Bigest_Radius_RmsE =[] ;
A_Num_Trap_RmsE = [] ;

Biggest_Circle_Alv_over_RmsE=[];

A_Mean_AHC_Dist_RmsE = [] ;

X1=[];
X2=[];
X3=[];

for i = 15:5:50
    FileNameRoot2=strcat(strcat(FileNameRoot,sprintf('%d',i)),'Obj_');
    
    Mean_AHC_Dist_RmsE = zeros(1,152);
    Mean_AHC_Dist_RmsE_pond = zeros(1,152);
    
    for j = 1:50
%         [i j]
        FileName=strcat(FileNameRoot2,sprintf('%d',j));

        %Analyse_Data(FileName,1,2);
        
        load(strcat(FileName,'_Analyse'))

        A_Catch_Env_Ratio_Alv = [A_Catch_Env_Ratio_Alv Catch_Env_Ratio_Alv] ;
        A_Bigest_Radius_Alv = [A_Bigest_Radius_Alv max(8,Bigest_Radius_Alv)] ;
        A_Num_Trap_Alv = [A_Num_Trap_Alv Num_Trap_Alv] ;
        
        A_Catch_Env_Ratio_RmsE = [A_Catch_Env_Ratio_RmsE Catch_Env_Ratio_RmsE] ;
        A_Bigest_Radius_RmsE = [A_Bigest_Radius_RmsE max(8,Bigest_Radius_RmsE)] ;
        A_Num_Trap_RmsE = [A_Num_Trap_RmsE Num_Trap_RmsE] ;
        
        Mean_AHC_Dist_RmsE(1:size(AHC_Dist_RmsE,2))...
            =Mean_AHC_Dist_RmsE(1:size(AHC_Dist_RmsE,2))+AHC_Dist_RmsE;
        Mean_AHC_Dist_RmsE_pond(1:size(AHC_Dist_RmsE,2))...
            = Mean_AHC_Dist_RmsE_pond(1:size(AHC_Dist_RmsE,2))+1;
    end
      
    Biggest_Circle_Alv_over_RmsE...
        =[Biggest_Circle_Alv_over_RmsE exp(mean(log((A_Bigest_Radius_Alv.^2)./(A_Bigest_Radius_RmsE.^2))))];

    A_Mean_AHC_Dist_RmsE = [A_Mean_AHC_Dist_RmsE ; Mean_AHC_Dist_RmsE./Mean_AHC_Dist_RmsE_pond] ;       
    
    X1=[X1 [i-1+[0:1/j:1-1/j]]];
    X2=2+X1;
    X3=[X3 [i-1+[0:2/j:2-2/j]]];
end

% figure(61)
% clf ;
% hold on ;
% plot(X3,A_Catch_Env_Ratio_RmsE,'r*')
% ylim([0 1])
% xlim('auto')
% hold off ;
% 
% tmp=sparse(50,8);
% tmp(:)=A_Catch_Env_Ratio_RmsE(:);
% 
% figure(62)    
% hold off ;
% boxplot(tmp,'notch','on');
% ylim([0 0.2])
% xlabel('Number of objects (from 15 to 50)')
% ylabel('Ratio Catchment over Environment')
% title('Size of Catchment Area')
% hold off;
% 
% tmpA=sparse(50,8);
% tmpA(:)=A_Catch_Env_Ratio_Alv(:);
% tmpB(:,1:2:16)=tmpA;
% tmpA(:)=A_Catch_Env_Ratio_RmsE(:);
% tmpB(:,2:2:16)=tmpA;
% 
% figure(63)    
% hold off ;
% boxplot(tmpB,'notch','on');
% ylim([0 0.2])
% xlabel('')
% ylabel('Ratio Catchment over Environment')
% title('Size of Catchment Area')
% hold off;
% 
% 
% 
% tmp=sparse(50,8);
% tmp(:)=A_Bigest_Radius_Alv(:);
% 
% figure(7)
% clf ;
% hold on ;
% plot(X3,log((pi*A_Bigest_Radius_Alv.^2)./(A_Catch_Env_Ratio_Alv*1.8227e+005)),'.k')
% xlabel('Number of objects')
% ylabel('log(Ratio of areas)')
% title('Comparison between Biggest Circle and Catchment Area')
% ylim('auto')
% xlim('auto')
% hold off;
% 
% HighEccent_Alv=sum(tmp==8);
% 
% figure(8)
% clf ;
% hold on ;
% bar(15:5:50,HighEccent_Alv,0.5)
% xlabel('Number of objects')
% ylabel({'Occurence of';'"Catchment area perimeter tangent to nest"'})
% title('Catchment Area eccentricity')
% ylim([0 50])
% xlim([12 53])
% hold off;
% 
% figure(64)
% clf ;
% hold on ;
% plot(X3,A_Bigest_Radius_RmsE,'r*')
% ylim('auto')
% xlim('auto')
% hold off;
% 
% tmp=sparse(50,8);
% tmp(:)=A_Bigest_Radius_RmsE(:);
% 
% figure(65)
% clf ;
% hold on ;
% plot(X3,log((pi*A_Bigest_Radius_RmsE.^2)./(A_Catch_Env_Ratio_RmsE*1.8227e+005)),'.k')
% xlabel('Number of objects')
% ylabel('log(Ratio of areas)')
% title('Comparison between Biggest Circle and Catchment Area')
% ylim('auto')
% xlim('auto')
% hold off;
% 
% figure(66)
% clf ;
% hold on ;
% plot(X3,log((A_Bigest_Radius_Alv.^2)./(A_Bigest_Radius_RmsE.^2)),'.k')
% plot([X1(1) X1(end)],[0 0],'c')
% xlabel('Number of objects')
% ylabel('log( Ratio of areas )')
% title('Comparison of Biggest Circle between the two models')
% ylim('auto')
% xlim('auto')
% hold off;
% 
% figure(67)    
% clf;
% hold on ;
% plot([15:5:50],Biggest_Circle_Alv_over_RmsE,'-or')
% ylim([0 0.8])
% xlim([13 52])
% ylabel('exp( mean( log( Ratio ) ) )')
% xlabel('Number of objects')
% title('Comparison of Biggest Circle between the two models')
% hold off ;
% 
% HighEccent_RmsE=sum(tmp==8);
% 
% figure(68)
% clf ;
% hold on ;
% bar(15:5:50,[HighEccent_Alv' HighEccent_RmsE'],1)
% xlabel('Number of objects')
% ylabel({'Occurence of';'"Catchment area perimeter tangent to nest"'})
% title('Catchment Area eccentricity')
% ylim([0 50])
% xlim([12 53])
% hold off;
% 
% 
% 
% figure(18)
% clf ;
% hold on ;
% plot(X3,A_Num_Trap_Alv,'r*')
% plot(X3,A_Num_Trap_RmsE,'b*')
% ylim('auto')
% xlim([13 52])
% xlabel('Number of objects')
% ylabel('Number of false local minima')
% legend('ALV','SSE');
% hold off;
% 
% 
% % tmp=sparse(50,8);
% % tmp(:)=A_Num_Trap_Alv(:);
% % 
% % figure(19)
% % clf ;
% % hold on ;
% % boxplot(tmp,'notch','on');
% % ylim([0 90])
% % xlabel('Number of objects (from 15 to 50)')
% % ylabel('')
% % title('Number of false local minima')
% % hold off;
% 
% % tmp=sparse(50,8);
% % tmp(:)=A_Num_Trap_RmsE(:);
% % 
% % figure(69)
% % clf ;
% % hold on ;
% % boxplot(tmp,'notch','on');
% % ylim([0 90])
% % xlabel('Number of objects (from 15 to 50)')
% % ylabel('')
% % title('Number of false local minima')
% % hold off;
% 
% 
% 
% figure(70)
% hold off;
% plot(0:5:5*size(A_Mean_AHC_Dist_RmsE,2)-1,A_Mean_AHC_Dist_RmsE(1:8,:))
% legend('15 objects','20 objects','25 objects','30 objects','35 objects','40 objects','45 objects','50 objects');
% ylim([-0.1 1])
% xlim([0 250])
% xlabel('distance to nest');
% ylabel('average homeward component');
% title('Evolution of the accuracy of the homing vector in SSE')
% hold off ;

