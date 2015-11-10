function DrawAnalysisAlv

FileNameRoot = 'C:\Temp\Desmottes\Env_' ;

A_Catch_Env_Ratio_Alv = [] ;
A_Catch_Env_Ratio_AlvSE = [] ;
A_Bigest_Radius_Alv =[] ;
A_NestLocSiz= [];
A_Catch_Locale_Ratio_Alv = [] ;
A_MeanChangeNumObjSeen_Alv = [] ;
% % A_Num_Loc_Alv = [] ;
% A_Num_Loc_Alv_2 = [] ;
% A_Num_Loc_Catch_Alv = [] ;
A_Num_Loc_Catch_Alv_2 = [] ;
% A_Num_Trap_Alv = [] ;

Catch_over_SE=[];

A_Mean_AHC_Dist_Alv = [] ;
% % A_Mean_AHC_Loc_Alv = [] ;

X1=[];
X2=[];
X3=[];

for i = 15:5:50
    FileNameRoot2=strcat(strcat(FileNameRoot,sprintf('%d',i)),'Obj_');
    
    Mean_AHC_Dist_Alv = zeros(1,152);
    Mean_AHC_Dist_Alv_pond = zeros(1,152);
% %     Mean_AHC_Loc_Alv = zeros(1,80);
% %     Mean_AHC_Loc_Alv_pond = zeros(1,80);
    
    for j = 1:50
%         [i j]
        FileName=strcat(FileNameRoot2,sprintf('%d',j));

        %Analyse_Data(FileName,1,2);
        
        load(strcat(FileName,'_Analyse'))

        A_Catch_Env_Ratio_Alv = [A_Catch_Env_Ratio_Alv Catch_Env_Ratio_Alv] ;
        A_Catch_Env_Ratio_AlvSE = [A_Catch_Env_Ratio_AlvSE Catch_Env_Ratio_AlvSE] ;
        A_Bigest_Radius_Alv = [A_Bigest_Radius_Alv max(8,Bigest_Radius_Alv)] ;
        A_NestLocSiz= [A_NestLocSiz Visual_Locale_Size_Alv];
        A_Catch_Locale_Ratio_Alv = [A_Catch_Locale_Ratio_Alv Catch_Locale_Ratio_Alv] ;
        A_MeanChangeNumObjSeen_Alv = [A_MeanChangeNumObjSeen_Alv MeanChangeNumObjSeen_Alv] ;
% %         A_Num_Loc_Alv = [A_Num_Loc_Alv Num_Loc_Alv] ;
%         A_Num_Loc_Alv_2 = [A_Num_Loc_Alv_2 Num_Loc_Alv_2] ;
%         A_Num_Loc_Catch_Alv = [A_Num_Loc_Catch_Alv Num_Loc_Catch_Alv] ;
        A_Num_Loc_Catch_Alv_2 = [A_Num_Loc_Catch_Alv_2 Num_Loc_Catch_Alv_2] ;
%         A_Num_Trap_Alv = [A_Num_Trap_Alv Num_Trap_Alv] ;
        
        Mean_AHC_Dist_Alv(1:size(AHC_Dist_Alv,2))...
            =Mean_AHC_Dist_Alv(1:size(AHC_Dist_Alv,2))+AHC_Dist_Alv;
        Mean_AHC_Dist_Alv_pond(1:size(AHC_Dist_Alv,2))...
            = Mean_AHC_Dist_Alv_pond(1:size(AHC_Dist_Alv,2))+1;
% %         
% %         Mean_AHC_Loc_Alv(1:size(AHC_Loc_Alv,2))...
% %             =Mean_AHC_Loc_Alv(1:size(AHC_Loc_Alv,2))+AHC_Loc_Alv;
% %         Mean_AHC_Loc_Alv_pond(1:size(AHC_Loc_Alv,2))...
% %             = Mean_AHC_Loc_Alv_pond(1:size(AHC_Loc_Alv,2))+1;
             
    end
    
    Catch_over_SE...
        =[Catch_over_SE exp(mean(log(A_Catch_Env_Ratio_Alv(end-j+1:end))...
         -log(A_Catch_Env_Ratio_AlvSE(end-j+1:end))))];
           
    A_Mean_AHC_Dist_Alv = [A_Mean_AHC_Dist_Alv ; Mean_AHC_Dist_Alv./Mean_AHC_Dist_Alv_pond] ;       
% %     A_Mean_AHC_Loc_Alv = [A_Mean_AHC_Loc_Alv ; Mean_AHC_Loc_Alv./Mean_AHC_Loc_Alv_pond] ;       

    
    X1=[X1 [i-1+[0:1/j:1-1/j]]];
    X2=2+X1;
    X3=[X3 [i-1+[0:2/j:2-2/j]]];
end

figure(1)
clf ;
hold on ;
plot(X1,A_Catch_Env_Ratio_Alv,'r*')
plot(X2,A_Catch_Env_Ratio_AlvSE,'b*')
ylim([0 1])
xlim('auto')
hold off ;

tmpA=sparse(50,8);
tmpA(:)=A_Catch_Env_Ratio_Alv(:);
tmpB(:,1:2:16)=tmpA;
tmpA(:)=A_Catch_Env_Ratio_AlvSE(:);
tmpB(:,2:2:16)=tmpA;

figure(2)    
hold off ;
boxplot(tmpB,'notch','on');
xlabel('')
ylabel('Ratio Catchment over Environment')
title('Size of Catchment Area')
hold off;

for l=1:2:16
    [p13((l+1)/2),h13((l+1)/2)] = ranksum(tmpB(:,l),tmpB(:,l+1),0.00001)
end
[p13;h13]    

tmpA=sparse(50,8);
tmpA(:)=log(A_Catch_Env_Ratio_Alv)-log(A_Catch_Env_Ratio_AlvSE);

figure(3)
clf;
hold on ;
plot(X1+0.5,tmpA(:),'g.')
plot([X1(1) X1(end)],[0 0],'c')
ylim('auto')
xlim([13 52])
xlabel('Number of objects')
title('Comparison between No SE and SE Catchment Areas')
hold off ;
figure(4)    
clf;
hold on ;
plot([15:5:50],Catch_over_SE,'-or')
ylim([0 0.5])
xlim([13 52])
xlabel('Number of objects')
title('Comparison between No SE and SE Catchment Areas')
hold off ;

A_Catch_over_SE...
    =exp(mean(log(A_Catch_Env_Ratio_Alv)-log(A_Catch_Env_Ratio_AlvSE)));



figure(5)
clf ;
hold on ;
plot(X3,A_Bigest_Radius_Alv,'r*')
ylim('auto')
xlim('auto')
hold off;

tmp=sparse(50,8);
tmp(:)=A_Bigest_Radius_Alv(:);

figure(6)
clf ;
hold on ;
boxplot(tmp,'notch','on');
xlabel('')
ylabel('')
title('')
hold off;

figure(7)
clf ;
hold on ;
plot(X3,log((pi*A_Bigest_Radius_Alv.^2)./(A_Catch_Env_Ratio_Alv*1.8227e+005)),'.k')
xlabel('Number of objects')
ylabel('log(Ratio of areas)')
title('Comparison between Biggest Circle and Catchment Area')
ylim('auto')
xlim('auto')
hold off;

HighEccent=sum(tmp==8);
figure(8)
clf ;
hold on ;
bar(15:5:50,HighEccent,0.5)
xlabel('Number of objects')
ylabel({'Occurence of';'"Catchment area perimeter tangent to nest"'})
title('Catchment Area eccentricity')
ylim([0 50])
xlim([12 53])
hold off;



figure(9)
clf ;
hold on ;
plot(X3,A_Catch_Env_Ratio_Alv,'r*')
ylim('auto')
xlim([13 52])
hold off ;

tmp=sparse(50,8);
tmp(:)=A_Catch_Env_Ratio_Alv(:);

figure(10)
clf ;
hold on ;
boxplot(tmp,'notch','on');
ylim([0 0.4])
xlim('auto')
xlabel('Number of objects (from 15 to 50)')
ylabel('Ratio Catchment over Environment')
title('Size of Catchment Area')
hold off;



tmp=sparse(50,8);
tmp(:)=A_NestLocSiz(:);

figure(11)
clf ;
hold on ;
boxplot(tmp,'notch','on');
xlabel('Number of objects (from 15 to 50)')
ylabel('')
title('Size of the Nest Locale')
hold off;

figure(12)
clf ;
hold on ;
plot(X3,A_Catch_Locale_Ratio_Alv,'r*')
ylim('auto')
xlim('auto')
hold off;

tmp=sparse(50,8);
tmp(:)=log(A_Catch_Locale_Ratio_Alv(:));

figure(13)
clf ;
hold on ;
plot(X3,log(A_Catch_Locale_Ratio_Alv),'.k')
plot([15:5:50],(mean(tmp)),'-or')
xlabel('Number of objects')
ylabel('log(Ratio of areas)')
title('Comparison between Catchment Area and Visual Locale')
ylim('auto')
xlim('auto')
hold off;



figure(14)
clf ;
hold on ;
plot(X3,A_MeanChangeNumObjSeen_Alv,'r*')
ylim('auto')
xlim('auto')
hold off;

tmp=sparse(50,8);
tmp(:)=A_MeanChangeNumObjSeen_Alv(:);

figure(15)
clf ;
hold on ;
boxplot(tmp,'notch','on');
xlabel('Number of objects (from 15 to 50)')
ylabel('')
title('Number of edges crossed')
hold off;



figure(16)
clf ;
hold on ;
plot(X3,A_Num_Loc_Catch_Alv_2,'r*')
ylim('auto')
xlim('auto')
hold off;

tmp=sparse(50,8);
tmp(:)=A_Num_Loc_Catch_Alv_2(:);

figure(17)
clf ;
hold on ;
boxplot(tmp,'notch','on');
xlabel('Number of objects (from 15 to 50)')
ylabel('')
title('Number of Locales within the Catchment Area')
hold off;



% figure(18)
% clf ;
% hold on ;
% plot(X3,A_Num_Trap_Alv,'r*')
% ylim('auto')
% xlim('auto')
% hold off;
% 
% tmp=sparse(50,8);
% tmp(:)=A_Num_Trap_Alv(:);
% 
% figure(19)
% clf ;
% hold on ;
% boxplot(tmp,'notch','on');
% xlabel('Number of objects (from 15 to 50)')
% ylabel('')
% title('XXXX')
% hold off;



figure(20)
hold off;
plot(0:2:2*size(A_Mean_AHC_Dist_Alv,2)-1,A_Mean_AHC_Dist_Alv(1:8,:))
legend('15 objects','20 objects','25 objects','30 objects','35 objects','40 objects','45 objects','50 objects');
ylim([-0.1 1])
xlim([0 250])
xlabel('distance to nest');
ylabel('average homeward component');
title('Evolution of the accuracy of the homing vector in ALV')
hold off ;



% % figure(24)
% % hold off;
% % plot(0:2:2*size(A_Mean_AHC_Loc_Alv,2)-1,A_Mean_AHC_Loc_Alv)
% % hold on ;
% % ylim([0 1])
% % xlim('auto')
% % title('DIST')
% % hold off ;

