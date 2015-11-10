function DrawAnalysisPerfect

FileNameRoot = 'C:\_MyDocuments\Current\JeanBaptiste\Environments&data\Env_' ;

A_Catch_Env_Ratio_Alv = [] ;
A_Catch_Env_Ratio_Perfect = [] ;

Catch_Centre_over_Perfect=[];

X1=[];
X2=[];
X3=[];

for i = 15:5:50
    FileNameRoot2=strcat(strcat(FileNameRoot,sprintf('%d',i)),'Obj_');
    
    for j = 1:50
%         [i j]
        FileName=strcat(FileNameRoot2,sprintf('%d',j));

        load(strcat(FileName,'_Analyse'))
        load(strcat(FileName,'_Perfect_Analyse'))

        A_Catch_Env_Ratio_Alv = [A_Catch_Env_Ratio_Alv Catch_Env_Ratio_Alv] ;
        A_Catch_Env_Ratio_Perfect = [A_Catch_Env_Ratio_Perfect Catch_Env_Ratio_Perfect] ;           
    end
    
    Catch_Centre_over_Perfect...
        =[Catch_Centre_over_Perfect exp(mean(log(A_Catch_Env_Ratio_Alv(end-j+1:end))...
         -log(A_Catch_Env_Ratio_Perfect(end-j+1:end))))];
             
    X1=[X1 [i-1+[0:1/j:1-1/j]]];
    X2=2+X1;
    X3=[X3 [i-1+[0:2/j:2-2/j]]];
end

figure(81)
clf ;
hold on ;
plot(X1,A_Catch_Env_Ratio_Alv,'r*')
plot(X2,A_Catch_Env_Ratio_Perfect,'b*')
ylim([0 1])
xlim('auto')
hold off ;

tmpA=sparse(50,8);
tmpA(:)=A_Catch_Env_Ratio_Alv(:);
tmpB(:,1:2:16)=tmpA;
tmpA(:)=A_Catch_Env_Ratio_Perfect(:);
tmpB(:,2:2:16)=tmpA;

figure(82)    
hold off ;
boxplot(tmpB,'notch','on');
xlabel('')
ylabel('Ratio Catchment over Environment')
title('Size of Catchment Area')
hold off;

tmpA=sparse(50,8);
tmpA(:)=log(A_Catch_Env_Ratio_Alv)-log(A_Catch_Env_Ratio_Perfect);

figure(83)
clf;
hold on ;
plot(X3,tmpA(:),'g.')
plot([X3(1) X3(end)],[0 0],'c')
ylim('auto')
xlim([13 52])
xlabel('Number of objects')
ylabel('log( Ratio )')
title('Pointing the centre of an object vs enhanced vision')
hold off ;
figure(84)    
clf;
hold on ;
plot([15:5:50],Catch_Centre_over_Perfect,'-or')
plot([X1(1) X1(end)],[1 1],'m')
ylim([0 2])
xlim([13 52])
xlabel('Number of objects')
ylabel('exp( mean( log( Ratio ) ) )')
title('Pointing the centre of an object vs enhanced vision')
hold off ;