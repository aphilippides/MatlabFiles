function CalcOpticFlowField

% load('C:\Users\andrewop\Downloads\ForAndy.mat')
load('C:\_MyDocuments\Current\Bees\HeadMovements\ForAndyAll.mat')
tdiff=0.0885;
xp=-1000:20:1000; 
yp=xp;

% get orientation to the nest
o2n=(-nest_on_retina+head_orientation_North)*pi/180;

%rotate everything so we're in the right direction
% TODO: do a pic of all the directions of flight etc
% Send to Lena
% then rotate it and see if it's right
rot=2; % do image based rotation
if(rot==1)
    % need to adda all angles on
end
% get positions from polar coords
cs=zeros(length(nest_on_retina),2);
[cs(:,1),cs(:,2)]=pol2cart(o2n+pi,distance_from_nest);

absn=abs(direction_of_flight_rel_Nest);
% absn=abs(nest_on_retina);
% is=find((distance_from_nest>250)&(distance_from_nest<350));
is=find((distance_from_nest>250)&(distance_from_nest<350)&(absn>15)&(absn<45));

% % calc dist assuming above ground
% % ht in pixels
% % doesn't really make muhc difference...
% ht=m;
% d2n_z=sqrt(ht^2+distance_from_nest.^2);
% distance_from_nest=d2n_z;

% is=is(1)
absornot=0;

% get data one by one and rotate them
xr=find(xp>=(max(xp)*sin(pi/4)),1)-1;
xl=find(xp>(-max(xp)*sin(pi/4)),1);
v=xl:xr;
allrs=zeros(length(v),length(v),length(is));
allrn=allrs;
nonrs=zeros(length(xp),length(xp),length(is));
for i=1:length(is)
    c=cs(is(i),:);
    [mr,mrto,mrfr]=RetRatesFromSpeeds(xp,yp,absornot,c,tdiff,...
        head_orientation_North(is(i)),distance_from_nest(is(i)),nest_on_retina(is(i)),m,to_nest(is(i)),...
        linear_speed(is(i)),direction_of_flight_rel_North(is(i)),head_angular_speed(is(i)));
    
    o=-(o2n(is(i))+pi); 
    rm=[cos(o) -sin(o);sin(o) cos(o)];
%     rm2=[cos(o) sin(o);-sin(o) cos(o)];
    if(rot==2)
%         rbwm=imrotate((mr>0),-o2n(is(i))*180/pi,'crop');
        rotm=imrotate(mr,-o*180/pi,'crop');
        rotm=rotm(v,v);
%         rbwm=rbwm(v,v);
        B = bwboundaries(mr<=0);
        lens(i)=length(B);
        bo=B{end}*mean(diff(xp))-xp((end))-20;
        bo=bo(:,[2 1]);
        cp=round(mean(bo));
        [md,ix]=min(abs(xp-cp(1)));
        [md,iy]=min(abs(yp-cp(2)));
        rbo=bo*rm';
        rc=c*rm';
        rcp=cp*rm';
        figure(1)
        subplot(1,2,1),imagesc(xp(v),yp(v),mr(v,v))%<0)
        hold on; plot(cp(1),cp(2),'.',0,0,'w+',c(1),c(2),'wo',bo(:,1),bo(:,2),'k'); hold off; 
        subplot(1,2,2),imagesc(xp(v),yp(v),rotm)%<0)
        hold on; plot(0,0,'w+',rc(1),rc(2),'wo',rbo(:,1),rbo(:,2),'k'); hold off; 
        figure(2)
        nonrs(:,:,i)=mr;
        allrs(:,:,i)=rotm;
        allrn(:,:,i)=rotm./max(abs(rotm(:)));
        if(to_nest(is(i))); 
            subplot(1,2,1);
        else
            subplot(1,2,2);
        end
        hold on;
        if(mr(iy,ix)<0)
            plot(rcp(1),rcp(2),'r.',rc(1),rc(2),'k+',rbo(:,1),rbo(:,2),'k');
        else
            plot(rcp(1),rcp(2),'k.',rc(1),rc(2),'r+',rbo(:,1),rbo(:,2),'r');
        end
    end
end


cwt=(to_nest(is)==1)&(direction_of_flight_rel_Nest(is)>0);
ccwt=(to_nest(is)==1)&(direction_of_flight_rel_Nest(is)<0);
cwf=(to_nest(is)==0)&(direction_of_flight_rel_Nest(is)<0);
ccwf=(to_nest(is)==0)&(direction_of_flight_rel_Nest(is)>0);

n=400;a=[-n n -n n];x=[0 15];y=[-20 -5:5 20]*1; y=[0:5 10:5:20]*1;
% str='imagesc(xp,yp,median(abs(nonrs(:,:,';
str='imagesc(xp(v),yp(v),(1+log(median(abs(allrs(:,:,';
s2=')));axis equal;axis(a);axis off;c=caxis;caxis([0 c(2)*1]);c(2)';
% str='contourf(xp(v),yp(v),median(abs(allrs(:,:,';
% s2=',y);axis(a);caxis(x);set(gca,''YDir'',''reverse'')';
i1=to_nest(is)==1;i2=to_nest(is)==0;
% i1=4;i2=2;i3=5;i4=1; % all approx 250 away 
figure(1)
colormap gray;g=colormap; colormap(g(end:-1:1,:))
subplot(1,2,1)
eval([str 'i1)),3)' s2]);
xlabel('to')    
subplot(1,2,2)
eval([str 'i2)),3)' s2]);
xlabel('from')    

labs={'CW to';'CW from';'CCW to';'CCW from'};
rot=1;
figure(3)
i1=4;i2=2;i3=5;i4=1; % all approx 250 away and f2nest 15-45
% i1=4;i2=5;i3=8;i4=6; % all approx 250 away and s2nest 15-45
colormap gray;g=colormap; colormap(g(end:-1:1,:))
for i=1:4
subplot(2,2,i)
eval([str 'i' int2str(i) ')),3)' s2]);
eval(['plot_beer(is(i' int2str(i) '),cs,head_orientation_North*pi/180,rot,o2n)'])
xlabel(labs(i))    
end

figure(2)
subplot(1,2,1); hold off;
subplot(1,2,2); hold off;


keyboard
% % get the combined data
[mrates,mratesto,mratesfrom]=RetRatesFromSpeeds(xp,yp,absornot,cs(is,:),tdiff,...
    head_orientation_North(is),distance_from_nest(is),nest_on_retina(is),m,to_nest(is),...
    linear_speed(is),direction_of_flight_rel_North_start(is),head_angular_speed(is));

figure(2)
subplot(2,2,1)
imagesc(xp,yp,mratesto); hold on; plot(0,0,'w+'); hold off; 
title('median rates: to nest')
subplot(2,2,2)
imagesc(xp,yp,mratesfrom); hold on; plot(0,0,'w+'); hold off; 
title('median rates: from nest')
subplot(2,2,3)
imagesc(xp,yp,mratesto-mratesfrom)
imagesc(xp,yp,mratesto>0); hold on; plot(0,0,'w+'); hold off; 
title('rates to nest>0 (red)')
% colorbar
subplot(2,2,4)
imagesc(xp,yp,(mratesfrom>0))
title('rates from nest>0 (red)');xlabel('Bees to (x), from (o)')
hold on
to=is(to_nest(is)==1);
fr=is(to_nest(is)==0);
plot(cs(to,1),cs(to,2),'wx',cs(fr,1),cs(fr,2),'wo',0,0,'w+')
axis([xp([1 end]) yp([1 end])])
set(gca,'YDir','reverse')
hold off
keyboard

function plot_beer(i,cs,so,rot,o2n,lb)
col='r';
lb=100;
hold on;
c=cs(i,:);
[ex,ey]=pol2cart(so(i),lb);
e=c-[ex,ey];

if(rot)
    o=-(o2n(i)+pi);
    rm=[cos(o) -sin(o);sin(o) cos(o)];
    c=c*rm';
    e=e*rm';
end
plot(c(1),c(2),[col '.'],[c(1) e(1)]',[c(2) e(2)]',col,...,
    0,0,[col '+'],'MarkerSize',10,'LineWidth',1.5)
hold off

function[mrates,mratesto,mratesfrom]=RetRatesFromSpeeds(xp,yp,absornot,cs,tdiff,head_orientation_North,...
    distance_from_nest,nest_on_retina,m,to_nest,...
    linear_speed,flt_dir,head_angular_speed)

cs2=cs;
% angle of head at next time point
h_or1=head_orientation_North*pi/180;
h_or2=(head_orientation_North+tdiff*head_angular_speed)*pi/180;
% speed in pixels
p_sp=linear_speed*100*m;
% flight angle
flt_ang=flt_dir*pi/180;
% new position
[cs2(:,1),cs2(:,2)]=pol2cart(flt_ang,p_sp*tdiff);
cs2=cs+cs2;

% plot bee
if 0
    [b(1) b(2)]=pol2cart(head_orientation_North(1)*pi/180,10);
    b=cs(1,:)-b;
    plot([0,cs(1,1)],[0,cs(1,2)],cs(1,1),cs(1,2),'o',...
        [b(1),cs(1,1)],[b(2),cs(1,2)],'k',0,0,'x','MarkerSize',14)
end
% get all the positions
[xpos,ypos]=meshgrid(xp);
for i=1:size(xpos,1)
    for j=1:size(xpos,2)
        d1=PositionOnRetina([xpos(i,j),ypos(i,j)],cs,h_or1,0);
        d2=PositionOnRetina([xpos(i,j),ypos(i,j)],cs2,h_or2,0);
        rates(i,j).retRate=...
            AngularDifference([d2.LMOnRetina],[d1.LMOnRetina])/tdiff;
        if(absornot)
            mrates(i,j)=median(abs([rates(i,j).retRate]));
            mratesto(i,j)=median(abs([rates(i,j).retRate(to_nest==1)]));
            mratesfrom(i,j)=median(abs([rates(i,j).retRate(to_nest==0)]));
        else
            mrates(i,j)=median([rates(i,j).retRate]);
            mratesto(i,j)=median([rates(i,j).retRate(to_nest==1)]);
            mratesfrom(i,j)=median([rates(i,j).retRate(to_nest==0)]);
        end
    end
end
