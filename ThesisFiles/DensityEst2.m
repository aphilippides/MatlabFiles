function DensityEst2(t,X)
dsmall
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
DrawDensities(50,[5:1:25]);
%SetXTicks(gca,5,1,3)
subplot('Position',[0.6 0.15 0.375 0.8])
DrawDensities(100,[5:5:100]);

figure;
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 10 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.15 0.15 0.8 0.8])
DrawOvers([10,25,75],100,1);

function DrawDensities(X,N)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
t=[0.5,1,2];
Width=0.5*(N*10-8);%.^2;
for i=1:length(t)
    [y,x]=DensityEst1(t(i),X,N);
    plot(N,y./X^2,Cols(i,:));
    %plot(N,sqrt(y./pi),Cols(i,:));
    hold on
end
hold off
Setbox
ylabel('Area over threshold (\mum^2)');
ylabel({'Area over threshold (synthesising region)'});
%h=ylabel({'Threshold distance (\mum)'});
h=xlabel('Density (Vol. of source/synth. vol.)')
moveXYZ(h,0,-0.015,0)
if(X==50) SetXTicks(gca,1,1,3,[5:5:25],x([1:5:21]))
else SetXTicks(gca,1,1,3,N([1,5:5:20]),x([1,5:5:20]))
end
SetYTicks(gca,5)
h=legend('0.5s','1s','2s',2);

function[Over, Ds]=DensityEst1(t,X,N)
Ds=N.*4./X^2;
for i=1:length(N)
    dn=['Density'int2str(X) '/Mesh2dSSt1MaxGr1000X'int2str(N(i)) 'Sq*.dat'];
    [a,fn]=isfile(dn);
    if(a==1)
        M=load(['Density'int2str(X) '/'fn]);
        ind=find(M(:,1)==t);
        Over(i)=M(1,3)^2-M(ind,4);
    else
        Over(i)=0;
    end
end

function DrawOvers(N,X,B)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
for i=1:length(N)
    dn=['Density'int2str(X) '/Mesh2dSSt1MaxGr1000X'int2str(N(i)) 'Sq*.dat'];
    [a,fn]=isfile(dn);
    M=load(['Density'int2str(X) '/'fn]);
    T=M(2:end,1);
    Over=1e6-M(2:end,4);
%    plot(T,Over,Cols(i,:));
    plot(T,sqrt(Over./pi),Cols(i,:));
    hold on
end
hold off
Setbox
ylabel({'Area over threshold';'(synthesising region)'});
h=ylabel({'Threshold distance (\mum)'});
xlabel('Time (s)')
Ds=N.*4./X^2;
h=legend(num2str(Ds'),2);


