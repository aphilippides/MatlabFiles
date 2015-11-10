function DensityEst(t,X)
dsmall
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 15]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.575 0.375 0.375])
DrawDensities(25,[2:2:60]);
subplot('Position',[0.6 0.575 0.375 0.375])
DrawDensities(100,[2:2:70]);
subplot('Position',[0.1 0.075 0.375 0.375])
DrawOvers([2,40,50],100,2);
subplot('Position',[0.6 0.075 0.375 0.375])
DrawOvers([25,36,42,45],100,1);

function DrawDensities(X,Sp)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
t=[0.5,1,2];
hold off
for i=1:length(t)
    [y,x]=DensityEst1(t(i),X,Sp);
    plot(x,y./(X*4),Cols(i,:));
    hold on
end
hold off
Setbox
ylabel('Area over threshold (\mum^2)');
ylabel('Area over threshold (fibre x-area)');
xlabel('Spacing (\mum)')
h=legend('0.5s','1s','2s',2);
axis tight

function[Over, Sp]=DensityEst1(t,X,Sp)
Sq=2;
Ds=(X./((X-1).*Sp+Sq)).^2;
Ds=Sp;
for i=1:length(Sp)
    fn=['Density/Mesh2dSSt1MaxGr1000X'int2str(X) 'Sq2Sp' int2str(Sp(i)) '.dat'];
    M=load(fn);
    ind=find(M(:,1)==t);
    Over(i)=M(1,3)^2-M(ind,4);
end

function DrawOvers(Sp,X,B)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
hold off
for i=1:length(Sp)
    if(B==1)
        fn=['Density/Mesh2dSSt1B1MaxGr1000X'int2str(X) 'Sq2Sp' int2str(Sp(i)) '.dat'];
    else
        fn=['Density/Mesh2dSSt1MaxGr1000X'int2str(X) 'Sq2Sp' int2str(Sp(i)) '.dat'];
    end
    M=load(fn);
    T=M(2:end,1);
    Over=1e6-M(2:end,4);
    %plot(T,Over./(X*4),Cols(i,:));
    plot(T,Over,Cols(i,:));
    hold on
end
hold off
Setbox
ylabel('Area over threshold (\mum^2)');
%ylabel('Area over threshold (area of source)');
xlabel('Time (s)')
ind=find(Sp==2);
Sp(ind)=0;
h=legend(int2str(Sp'),2);