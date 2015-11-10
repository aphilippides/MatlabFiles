function HollowTubePics
[h1,h2]=SubPlot2(gcf);
subplot(h1);
[C,t]=HTube(eps,10,20,400,0.1,0,1,0)
[C1,t1]=HTube(60,10,20,100,0.1,0,2,0)
a=max(C);
a*0.00331
b=max(C1);
b*0.00331
C=C*100./a;
C1=C1*100./b;
plot(t,C,'b-',t1,C1,'r:')
Setbox;
xlabel('Time (s)')
ylabel('Concentration (% of max concentration)');
SetXLim(gca,0,0.75)
SetYTicks(gca,5);
legend('0\mum','60\mum');
subplot(h2);

[C,t]=HTubeT(0.1,10,20,50,0.1,0,50,0)
[C1,t1]=HTubeT(0.025,10,20,50,0.1,0,50,0)
[C2,t2]=HTubeT(0.25,10,20,50,0.1,0,50,0)
plot(t1,C1,'r:',t,C,'b-',t2,C2,'g -- x')
Setbox;
xlabel('Time (s)')
ylabel('Concentration (\muM)');
SetYTicks(gca,4,1e6);
legend('25ms','100ms','250ms');
b*0.00331


function[HTubeConc,t]=HTube(r,in,out,NumPts,Burst,MinT,MaxT,DataNeeded)
fn=['HollowTubePicsD' (int2str(r)) 'Data.mat'];
if (DataNeeded)
   [HTubeConc,t]=TestTubeDist(r,out,NumPts,Burst,MinT,MaxT);
   [temp,t]=TestTubeDist(r,in,NumPts,Burst,MinT,MaxT);
   HTubeConc=HTubeConc-temp;
   dthesisdat
   save(fn,'HTubeConc', 't','in','out','Burst','r');
end
load(fn)

function[HTubeConc,r]=HTubeT(t,in,out,NumPts,Burst,MinR,MaxR,DataNeeded)
fn=['HollowTubePicsT' (int2str(t*1000)) 'Data.mat'];
if (DataNeeded)
   [HTubeConc,r]=TestTubeTime(t,out,Burst,MinR,MaxR,NumPts);
   [temp,r]=TestTubeTime(t,in,Burst,MinR,MaxR,NumPts);
   HTubeConc=(HTubeConc-temp)*0.00331;
   dthesisdat
   r=MirrorvecMinus(r);
   HTubeConc=Mirrorvec(HTubeConc);
   save(fn,'HTubeConc', 't','in','out','Burst','r');
end
load(fn)
