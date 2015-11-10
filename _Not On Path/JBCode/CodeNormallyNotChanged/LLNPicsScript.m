function LLNPicsScript

% Vision figure
dwork
cd ../Current/Linc/results/
% h=dlmread('longrun/longrun_1_alv_nav.txt');m=50
% h=dlmread('occlusion/occlusion_2_alv_nav.txt');m=size(h,1);
h=dlmread('occlusion/occlusion_2_nav.txt');m=size(h,1);
figure(1)
colormap gray
% raw image
pcolor(-h(m:-1:1,16:105)), shading flat,axis off
% excitation
pcolor(-h(m:-1:1,106:195)), shading flat,axis off
% inhibition
pcolor(-h(m:-1:1,196:285)), shading flat,axis off
% plot of ALV
figure(2)
% feather(h(1:m,3),h(1:m,4),'b')
% feather(-h(1:m,4),h(1:m,3),'b')
% figure(3)
% Object Plots
vis=h(1:m,196:285);
for i=1:size(vis,1) 
    a=ObjectsFromFacets(vis(i,:))*pi/45;
    cs(i).cents=a;
    cs(i).xs=cos(a);
    cs(i).ys=sin(a);
%     plot(a,ones(size(a))*m-i,'.')
    plot(a,ones(size(a))*i,'.')
    hold on    
end    
hold off
figure(3);
% [ls,alv]=longRunobj(cs);
[ls,alv]=OccObj(cs);
% [ls,alv]=OccALVObj(cs);
plot(ls*180/pi,[m:-1:1]),SetBox,%,xlim([0 360])
% plot(cos(ls),[m:-1:1]),xlim([-1.1 1])
% plot(sin(ls),[m:-1:1])

n=80;%compass(h(n,3),h(n,4),'r');hold on;
load temp
figure(3),compass(cos(ls(n,:)),sin(ls(n,:))); hold on;
compass(alv(n,1),alv(n,2),'r');hold off;
figure(4),compass(cos(ls2(n,:)),sin(ls2(n,:))); hold on;
compass(alv2(n,1),alv2(n,2),'r');hold off;
n=28;%compass(h(n,3),h(n,4),'r');hold on;
compass(cos(ls(n,:)),sin(ls(n,:))); hold on;
compass(alv(n,1),alv(n,2),'r');hold off;
n=29;%compass(h(n,3),h(n,4),'r');hold on;
compass(cos(ls(n,:)),sin(ls(n,:))); hold on;
compass(alv(n,1),alv(n,2),'r');hold off;
n=32;%compass(h(n,3),h(n,4),'r');hold on;
compass(cos(ls(n,:)),sin(ls(n,:))); hold on;
compass(alv(n,1),alv(n,2),'r');hold off;

function[ls,alv]=OccALVObj(cs)
ls=ones(length(cs),4)*NaN;
for i=1:length(cs)
    ls(i,1)=cs(i).cents(1);
    if(i<=55) 
        ls(i,2)=cs(i).cents(2);
        ls(i,3)=cs(i).cents(3);
        ls(i,4)=cs(i).cents(4);
    elseif(i<=64) 
        ls(i,2)=cs(i).cents(2);
        ls(i,3)=cs(i).cents(3);
    else ls(i,3)=cs(i).cents(2);      
    end;
    alv(i,1)=2*mean(cos(ls(i,find(~isnan(ls(i,:))))));
    alv(i,2)=2*mean(sin(ls(i,find(~isnan(ls(i,:))))));
end
ls(56,4)=ls(56,3);
ls(65,2)=ls(65,1);

function[ls,alv]=OccObj(cs)
ls=ones(length(cs),4)*NaN;
for i=1:length(cs)
    ls(i,1)=cs(i).cents(1);
    ls(i,2)=cs(i).cents(2);
    if(i<=50) 
        ls(i,3)=cs(i).cents(3);
        ls(i,4)=cs(i).cents(4);
    elseif(i<=73) ls(i,3)=cs(i).cents(3);
    end;
    alv(i,1)=2*mean(cos(ls(i,find(~isnan(ls(i,:))))));
    alv(i,2)=2*mean(sin(ls(i,find(~isnan(ls(i,:))))));
end
ls(51,4)=ls(51,3);
ls(74,3)=ls(74,2);

function[ls,alv]=longRunobj(cs)
ls=ones(length(cs),6)*NaN;
for i=1:length(cs)
    ls(i,1)=cs(i).cents(1);
    if(i<29) 
%         ls(i,2)=cs(i).cents(1);
        ls(i,5)=cs(i).cents(2);
        ls(i,6)=cs(i).cents(3);
    elseif(i<32) 
        ls(i,2)=cs(i).cents(2);
        ls(i,4)=cs(i).cents(3);
        ls(i,5)=cs(i).cents(4);
        ls(i,6)=cs(i).cents(5);
    else
        ls(i,2)=cs(i).cents(2);
        ls(i,3)=cs(i).cents(3);
        ls(i,4)=cs(i).cents(4);
        ls(i,5)=cs(i).cents(5);
        ls(i,6)=cs(i).cents(6);
    end;
    alv(i,1)=2*mean(cos(ls(i,find(~isnan(ls(i,:))))));
    alv(i,2)=2*mean(sin(ls(i,find(~isnan(ls(i,:))))));
end