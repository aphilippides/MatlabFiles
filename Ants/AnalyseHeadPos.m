function[bads] = AnalyseHeadPos(fn)
dwork;
cd GantryProj\Bees\Head
% fn=dir(['*' int2str(s) 'Hand*.mat'])
load(fn);
% load HeadPosData20HandData_1197_1500_HM.mat

t=1:length(isClicked);%(isClicked-isClicked(1))*0.004;
% Get indices of frames clicked for comparison with auto-data 
for i=1:length(isClicked) 
    isAuto(i)=find(FrameNum==isClicked(i)); 
end;

% Get orientation of line between antennae base, then tips, then legs
oAntBase=GetAngs(AntennaeBase);
oAntTips=GetAngs(AntennaeTips);
oLegs=GetAngs(Legs);

% Get vectors and orientations of neck to head and tail to neck
vHead=HeadsHand-NecksHand;
vBody=NecksHand-TailsHand;
oBody=CleanOrients(cart2pol(vBody(:,1),vBody(:,2)));
oHead=CleanOrients(cart2pol(vHead(:,1),vHead(:,2)));

figure(1)
e=CompareAngs(oBody,oHead,t);title('Body vs Head')
body_head=[mean(e), std(e) mean(abs(e)), std(abs(e))]*180/pi
figure(2)
e=CompareAngs(oBody-pi/2,oAntBase,t);title('Body vs Antennae base')
body_base=[mean(e), std(e) mean(abs(e)), std(abs(e))]*180/pi

figure(1)
e=CompareAngs(oAntBase,oHead-pi/2,t);title('Antennae base vs Head')
base_head=[mean(e), std(e) mean(abs(e)), std(abs(e))]*180/pi
figure(2)
e=CompareAngs(oAntBase,oAntTips,t);title('Antennae base vs antennae ends')
base_tips=[mean(e), std(e) mean(abs(e)), std(abs(e))]*180/pi
e=CompareAngs(oBody-pi/2,oAntTips,t);title('Body vs antennae ends')
body_tips=[mean(e), std(e) mean(abs(e)), std(abs(e))]*180/pi

o=CleanOrients(Orients)';
e=CompareAngs(o(isAuto),oBody,t)

function ComparePos(a,b)
ers=a-b;
ds=sqrt(sum(ers.^2,2));
subplot(2,1,1)
plot(ds)
subplot(2,1,2)
plot(a(:,1),a(:,2),'r-x')
plot(b(:,1),b(:,2),'b-s')

function[ers]= CompareAngs(a,b,t)
e1=AngularDifference(a,b);
e2=AngularDifference(a,CleanOrients(b,1));
if(mean(abs(e1))<mean(abs(e2))) ers=e1;
else 
    ers=e2; 
    b=CleanOrients(b,1);
end
subplot(2,1,1)
plot(t,ers*180/pi)
subplot(2,1,2)
plot(t,AngleWithoutFlip(a)*180/pi,'r',t,AngleWithoutFlip(b)*180/pi,'b-');

function[o]=GetAngs(as)
v1=as(1:2:end-1,:);
v2=as(2:2:end,:);
vs=v1-v2;
o=CleanOrients(cart2pol(vs(:,1),vs(:,2)));