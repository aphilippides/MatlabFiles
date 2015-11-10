function Fin2InfPicsV2

FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 15]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.575 0.375 0.375])
FinInfOverZ([100],0,[0.5,1,2])
hold on
FinInfOverZ(49,0,[0.5,1,2])
hold off
subplot('Position',[0.6 0.575 0.375 0.375])
FinInfOverX(250,0,[2]*1000)
hold on
FinInfOverX(100,0,[0.5,1,2]*1000)
hold off
h=legend('2s, 500\mum','0.5s, 200\mum','1s, 200\mum','2s, 200\mum',4);

subplot('Position',[0.1 0.075 0.375 0.375])
FinInfOverZ([100],1,[0.5,1,2])
hold on
FinInfOverZ([100],2,[0.5,1,2])
hold off

subplot('Position',[0.6 0.075 0.375 0.375])
FinInfOverZ([49],1,[0.5,1,2])
hold on
FinInfOverZ([49],2,[0.5,1,2])
hold off

function FinInfOverSl(X,Z,T)
Ss=2;Sq=1;Sp=5;
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
dthesisdat
for i=1:length(T)
    fn=['MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'AllSlZ'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T(i)) 'NumOver.mat'];
    load(fn)
    if(sum(NumOver3dMin)==0) NumOver3dMin=NumOver3dMax;end;
    MMEst=0.5*(NumOver3dMax+NumOver3dMin);
%    plot(Sl(1:3),MMEst(1:3).*100./MMEst(1),Cols(i,:))
    plot(Sl(1:3),100.*sqrt(MMEst(1:3)./MMEst(1)),Cols(i,:))
    hold on;
    MMErrs=100*(NumOver3dMax-MMEst)./NumOver3dMax
end
hold off
Setbox
ylabel('Area over threshold (% of infinite)');
xlabel('Slice Number (\mum)')
h=legend('0.5s','1s','2s',1);

function FinInfOverZ(X,Sl,T)
Ss=2;Sq=1;Sp=5;
Cols=['b- .';'r: x';'g--s';'k-.d';'b- +';'k: *'];
dthesisdat
for i=1:length(T)
    fn=['MeshSSt'x2str(Ss) 'Gr300X'x2str(X(1)) 'AllZSq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(i)*1000) 'NumOver.mat'];
    load(fn)
    plot(Z*2,sqrt(NumOver3dMax.*1e4./NumOver2dM),Cols(i,:))
    hold on;
    MMErrs=50*(NumOver3dMax-NumOver3dMin)./NumOver3dMax
end
hold off
Setbox
ylabel('Area over threshold (% of infinite)');
xlabel('Fibre length (\mum)')
%h=legend('0.5s, N=100','1s, N=100','2s, N=100','0.5s, N=49','1s, N=49','2s, N=49',4);
h=legend('0.5s','1s','2s',4);

function FinInfOverX(Z,Sl,T)
Ss=2;Sq=1;Sp=5;
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
dthesisdat
for i=1:length(T)
    fn=['MeshSSt'x2str(Ss) 'Gr300AllXZ'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(i)) 'NumOver.mat'];
    load(fn)
%    plot(sqrt(X),NumOver3dMax.*100./NumOver2dM,Cols(i,:))
    plot(sqrt(X),sqrt(NumOver3dMax.*1e4./NumOver2dM),Cols(i,:))
    hold on;
    MMErrs=50*(NumOver3dMax-NumOver3dMin)./NumOver3dMax
end
hold off
Setbox
ylabel('Area over threshold (% of infinite)');
xlabel('Number of sources')
h=legend('0.5s','1s','2s',4);
