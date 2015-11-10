function[d,c1,cf,CentStruct] = ArcCentre(fn,arcs)

load(fn);
x=(nest(1)-200):10:(nest(1)+200);
y=(nest(2)-150):10:(nest(2)+150);
[X,Y]=meshgrid(x,y);

% is=1:length(sOr);
% [d,mi1,c1]=TestDiffs(X,Y,Cents(is),sOr(is));c1=c1-nest
% is=round(length(sOr)/2);
% [d2,mi2,c2]=TestDiffs(X,Y,Cents(is),sOr(is));c2=c2-nest
% [mi3,i,j]=minM(d-d2);c3=[X(i,j) Y(i,j)]-nest

for i=1:(length(arcs)-1)
    is=arcs(i):arcs(i+1);
    [da1,df(i),cf(i,:)]=TestDiffsFix(X,Y,Cents(is,:),sOr(is));
    [da,angvar(i),c1(i,:),d(i)]=TestDiffs(X,Y,Cents(is,:),sOr(is));
    figure(3),pcolor(x,y,da1*180/pi),colorbar,hold on,
    title(['Time ' num2str(t(is(1))) ' to ' num2str(t(is(end))) '; Min diff ' num2str(df(i)*180/pi)])
    plot(nest(1),nest(2),'wo',LM(1),LM(2),'ws',cf(i,1),cf(i,2),'wx'), hold off;
%     title(['Time ' num2str(t(is(1))) ' to ' num2str(t(is(end))) '; Mean angle ' int2str(round(d(i)*180/pi))])
%     plot(nest(1),nest(2),'wo',LM(1),LM(2),'ws',c1(i,1),c1(i,2),'wx'), hold off;
    c1(i,:)=c1(i,:)-nest;
    cf(i,:)=cf(i,:)-nest;
end
CentStruct.arcpt=c1;
CentStruct.fixpt=cf;
CentStruct.absdiff=df;
CentStruct.fixa=d;
CentStruct.angvar=angvar;
CentStruct.fn=fn;
CentStruct.NoArcs=0;

function[d,mi,mipos,i,j]=TestDiffsFix(X,Y,Cents,sOr)
for i=1:size(Y,1)
    for j=1:size(X,2)
        newo=cart2pol(X(i,j)-Cents(:,1),Y(i,j)-Cents(:,2));
        do=AngularDifference(newo,sOr);
        d(i,j)=sum(abs(do))/length(do);
    end
end
[mi,i,j]=minM(d); 
mipos=[X(i,j) Y(i,j)];
newo=cart2pol(X(i,j)-Cents(:,1),Y(i,j)-Cents(:,2));
do=AngularDifference(newo,sOr);
figure(4),plot(do*180/pi,'b-x'),title(['min var = ' num2str(mi*180/pi)])

function[d,mi,mipos,i,j]=TestDiffs(X,Y,Cents,sOr)
for i=1:size(Y,1)
    for j=1:size(X,2)
        newo=cart2pol(X(i,j)-Cents(:,1),Y(i,j)-Cents(:,2));
        do=AngularDifference(newo,sOr);
        [mang(i,j), d(i,j)] = AngularStats(do);
%         [t,r]=cart2pol(mean(cos(do)),mean(sin(do)));
%         =(1-r);
%         mang(i,j)=t;
    end
end
[mi,i,j]=minM(d);
mipos=[X(i,j) Y(i,j)];
newo=cart2pol(X(i,j)-Cents(:,1),Y(i,j)-Cents(:,2));
do=AngularDifference(newo,sOr);
i=mang(i,j);
% figure(4),plot(do*180/pi,'b-x'),title(['min var = ' num2str(mi*180/pi)])