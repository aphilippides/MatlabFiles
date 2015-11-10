function CheckAccFig1(Bursts)

%Bursts=[0.1 1 5 10];
CheckRadErrLims(Bursts)
CheckCLimErrs(Bursts)
figure
CheckRadErrs(Bursts)
%AmendLimits(Bursts)
%CheckSurfaceConcErrs(Bursts)

function CheckCLimErrs(Bursts)

for j=1:length(Bursts)
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) '.mat']);
   load(filename)
   IOver=find(RThresh>Rads);
   Under=setdiff(Rads,Rads(IOver))
   ODiffs=abs(2.5e-7-CheckConc(IOver)*0.00331)./2.5e-7;
   subplot(3,1,1)
   plot(Rads(IOver),ODiffs*100,Colour(j))
   hold on,axis tight
   title('% diff at RLim from Thresh')
   subplot(3,1,2),axis tight
   plot(Rads,LimitCheckConc,Colour(j))
   hold on,axis tight
   title('Limit for Conc at RLim (<25)')
   subplot(3,1,3),axis tight
   plot(Rads,LimConc,Colour(j))
   hold on,axis tight
   title('Conc Limit from CheckLim (<20)')
   IBad=(ODiffs*100>0.5);
   RBad=Rads(IBad)
   DiffBads=ODiffs(IBad)
   BadThresh=RThresh(IBad)
end
subplot(3,1,1)
plot([Rads(IOver(1)) Rads(IOver(end))], [0.5 0.5],'r:')


% function to generate confidence intervals around solutions
function CheckRadErrs(Bursts)

for j=1:length(Bursts)
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) '.mat']);
   load(filename)
   subplot(length(Bursts),1,j)
   for i=1:length(Rads)
      i
      X1=RThresh(i);
      if(CheckConc(i)*.00331<2.5e-7)
         if (RThresh(i)==0)
            Timee=Bursts(j);
         else
            Timee=TThresh(i);
         end
         X2(i)=abs(RThresh(i)-0.05);
         [Y2(i) ErrY2(i) LimY2(i)]=Tube(abs(RThresh(i)-0.05),Timee,Rads(i),Bursts(j),1e-3,25);
      else
         X2(i)=RThresh(i)+0.05;
         [Y2(i) ErrY2(i) LimY2(i)]=Tube(RThresh(i)+0.05,Timee,Rads(i),Bursts(j),1e-3,25);
      end
      X=[X1 X2(i)];
      Y=[CheckConc(i) Y2(i)]*.00331;
      line(X,Y)
      filename=(['Fig1CheckRadsErrB' x2str(Bursts(j)) 'Early.mat']);
      %save(filename,'Rads','Y2','LimY2','ErrY2','X2')
   end
   BadR=Rads(find(LimY2<0))
   BadR2=Rads(find(LimY2>24))
   BadErr=ErrY2(find((ErrY2./Y2)>0.005))
   hold on
   plot([RThresh(1) RThresh(end)],[2.5e-7 2.5e-7],'r:')
   hold off
   axis tight
end


function CheckRadErrLims(Bursts)
%Bursts=10;
aff=2.5e-7;
mult=.00331;
for j=1:length(Bursts)
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) '.mat']);
   load(filename)
   filename=(['Fig1CheckRads1_25ErrB' x2str(Bursts(j)) '.mat']);
   load(filename)
   Conc=CheckConc*mult;
   Y=Y2*mult;
   plot(Rads,Conc,'b-x',Rads,Y,'r:o',[Rads(1) Rads(end)],[aff aff],'k')
   ConcDiff=abs(aff-Conc);
   YDiff=abs(Y-aff);
   figure
   plot(Rads,ConcDiff,'b-x',Rads,YDiff,'r:o',[Rads(1) Rads(end)],[aff aff]*.005,'k')
   NotOver=find((RThresh-Rads)<-0.05)
   IBadC=setdiff(find(ConcDiff>aff*.005),NotOver)	
   IBadY=setdiff(find(YDiff>aff*.005),NotOver)
   RadBadC=Rads(IBadC)
   RadBadY=Rads(IBadY)
   RBadC=RThresh(IBadC)
   RBadY=X2(IBadY)
   BadC=Conc(IBadC)
   BadY=Y(IBadY) 
   find(LimY2>20)
   find(LimY2<0)
end

function AmendLimits(Bursts)

aff=2.5e-7;
mult=.00331;
for j=1:length(Bursts)
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) '.mat']);
   load(filename)
   filename=(['Fig1CheckRads1_25ErrB' x2str(Bursts(j)) '.mat']);
   load(filename)
   IOver=find(RThresh>Rads)
   Conc=CheckConc(IOver)*mult;
   Y=Y2(IOver)*mult;
   CDiff=abs(aff-Conc);
   YDiff=abs(aff-Y);
   Change=find(YDiff<CDiff)
   CheckConc(Change)=Y2(Change);
   RThresh(Change)=X2(Change);
   LimitCheckConc(Change)=LimY2(Change);
   ErrorCheckConc(Change)=ErrY2(Change);
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) 'Am.mat']);
  % save(filename,'RThresh', 'TThresh' ,'Err', 'Rads' ,'ErrConc', 'LimConc',...
  %    'LimitCheckConc','CheckConc','ErrorCheckConc');
   Conc=CheckConc(IOver)*mult;
   CDiff=abs(aff-Conc);
   maxCerr=max(CDiff.*100./aff)
   maxErr=max(ErrorCheckConc./CheckConc)
   subplot(2,1,1),plot(Rads,RThresh)
   subplot(2,1,2),plot(Rads,ErrorCheckConc.*100./CheckConc)
end

function CheckSurfaceConcErrs(Bursts)

for j=1:length(Bursts)
	filename=(['MeshPaper/Fig1Data/TubeSurfaceConcDiam0_1_10B'x2str(Bursts(j)) '.mat']);
   load(filename)
   subplot(2,1,1)
   plot(Diams,Err.*100./SurfaceTubeConc,Colour(j))
   maxErr=max(Err.*100./SurfaceTubeConc)
   meanErr=mean(Err.*100./SurfaceTubeConc)
   SrdErr=std(Err.*100./SurfaceTubeConc)
   hold on,axis tight
	subplot(2,1,2)
   plot(Diams,Limit,Colour(j))
   MaxLim=max(Limit)
   hold on,axis tight
end
subplot(2,1,1)
plot([Diams(1) Diams(end)],[0.5 0.5],'r:')
hold off
subplot(2,1,2)
hold off

