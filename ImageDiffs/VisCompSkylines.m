% function[e1,e2,em1,em2,ks]=VisCompSkylines(s,goal)
function[em1,ks,e1,dd]=VisCompSkylines(s,goal,mf)
if(nargin<3) 
    mf=3; 
end;

m=medfilt1(s,mf);
ig=s(goal,:);
igm=m(goal,:);
len=size(s,1);
for i=1:len 
   [mini(i),rim,imin,mind(i),dd(i,:)]=VisualCompass(ig,s(i,:));  
   [m1(i),rim,imin,mind(i),d(i,:)]=VisualCompass(igm,m(i,:));  
%      [mini2(i),rim2,imin2,mind2(i),dd2(i,:)]=VisualCompass(s(i,:),s((min(len,i+1)),:));
%      [m2(i),rim2,imin2,mind2(i),d2(i,:)]=VisualCompass(m(i,:),m((min(len,i+1)),:));
end; 
[e1,ns]=min([mini-1;361-mini]);
is=find(ns==2);
e1(is)=e1(is)*-1;
[em1,ns]=min([m1-1;361-m1]);is=find(ns==2);
em1(is)=em1(is)*-1;
% inds=[181:360 1:180];
% [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(dd(22,inds),-179:180,1e3,5,1)
% [e2,ns]=min([mini2-1;361-mini2]);
% is=find(ns==2);
% e2(is)=e2(is)*-1;
% [em2,ns]=min([m2-1;361-m2]);is=find(ns==2);
% em2(is)=em2(is)*-1;
% keyboard
ks=1:len;
% plot(ks,e1,'b:',ks,em1,'b')
% plot(ks,e1,'b:',ks,e2,'r:',ks,em1,'b',ks,em2,'r')

