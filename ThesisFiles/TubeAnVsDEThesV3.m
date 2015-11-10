function[TubeConcAn,TubeDEConc,Differ,RelDiff,DistVec]= TubeAnVsDEThesV3(Ds,t)

if(nargin<2) t=2; end
if(nargin<1) Ds=[1,5]; end

[h1,h2]=Subplot2(gcf);
DataNeeded=0;
if (DataNeeded)
    [TubeConcAn1,TubeConcDE1,Differ1,RelDiff1,DistVec1]=TubeAnVsDEData(1,t);
    [TubeConcAn2,TubeConcDE2,Differ2,RelDiff2,DistVec2]=TubeAnVsDEData(2,t);
    [TubeConcAn3,TubeConcDE3,Differ3,RelDiff3,DistVec3]=TubeAnVsDEData(3,t);
    [TubeConcAn4,TubeConcDE4,Differ4,RelDiff4,DistVec4]=TubeAnVsDEData(4,t);
    [TubeConcAn5,TubeConcDE5,Differ5,RelDiff5,DistVec5]=TubeAnVsDEData(5,t);
    dthesisdat
save TubeAnVsDEThesData.mat TubeConcAn1 TubeConcDE1 Differ1 RelDiff1 DistVec1 TubeConcAn2 TubeConcDE2 Differ2 RelDiff2 DistVec2 TubeConcAn5 TubeConcDE5 Differ5 RelDiff5 DistVec5 TubeConcAn4 TubeConcDE4 Differ4 RelDiff4 DistVec4 TubeConcAn3 TubeConcDE3 Differ3 RelDiff3 DistVec3
end
dthesisdat
load TubeAnVsDEThesData;
subplot(h1)
plot(DistVec5,TubeConcAn5,'b',DistVec5,TubeConcDE5,ThCols(2),DistVec2,TubeConcAn2,'b',DistVec2,TubeConcDE2,ThCols(2))
%plot(DistVec1,TubeConcAn1,'b',DistVec1,TubeConcDE1,ThCols(2),DistVec5,TubeConcAn5,'b',DistVec5,TubeConcDE5,ThCols(2))
xlabel('Distance (\mum)');
ylabel('Concentration (\muM)');
Setbox;
%legend('2\mum analytic','2\mum DE','5\mum analytic','5\mum DE',0)
legend('Analytic','DE',0)
SetYTicks(gca,6,1,1e6)

dthesisdat;
fn=['TubeDiams1_5B' int2str(t*1000) 'AnVsDEDiffData.mat'];   
load(fn)
subplot(h2)
for i=1:5
   % eval(['[m,ind]=max(abs(RelDiff' int2str(i) '))'])
   % eval(['MaxRel(i)=RelDiff' int2str(i) '(ind)'])
end
%plot(Diam,MaxRel,ThCols(2));
keyboard
hold on;
AvgRel(1)=mean(RelDiff1);
StdRel(1)=std(RelDiff1);
errorbar(Diam,AvgRel,StdRel,'b');
hold off;
legend('Maximum','Mean',0)
xlabel('Diameter (\mum)');
ylabel('Relative difference (%)');
Setbox;

h=figure;
SingPlot(h);
plot(DistVec2,RelDiff2*100,ThCols(2));axis tight;
hold on;
plot(DistVec5,RelDiff5*100,ThCols(1));
hold off;
legend('2\mum','5\mum',0)
xlabel('Distance (\mum)');
ylabel('Relative difference (%)');
Setbox;

return
dthesisdat;
fn=['TubeDiams1_5B' int2str(t*1000) 'AnVsDEDiffData.mat'];   
load(fn)
subplot(h3)
for i=1:5
    eval(['[m,ind]=max(abs(RelDiff' int2str(i) '))'])
    eval(['MaxRel(i)=RelDiff' int2str(i) '(ind)'])
end

plot(Diam,MaxRel,ThCols(2));
hold on;
AvgRel(1)=mean(RelDiff1);
StdRel(1)=std(RelDiff1);
errorbar(Diam,AvgRel,StdRel,'b');
hold off;
legend('Maximum','Mean',0)
xlabel('Diameter (\mum)');
ylabel('Relative difference (%)');
Setbox;
return
subplot(h4)
for i=1:5
    eval(['NumBad(i)=length(find(abs(RelDiff' int2str(i) '>0.005)))'])
end
    plot(Diam,NumBad,'b');

%legend('Maximum','Mean',0)
xlabel('Diameter (\mum)');
ylabel('Number of points where difference > 0.5 %');
Setbox;
