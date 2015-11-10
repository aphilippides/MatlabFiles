function[dnew]=imdiffsBinary(goal,Lims)

s=dir('I*RSC.mat')

skyc=250;
if(nargin<2) Lims=1; end;
if(nargin<1) goal=length(s);end;

fn=s(goal).name;
load(fn);
% newimall=adapthisteq(newimall);
gall=newimall;
gim=double(newim);
g_he=double(histeq(newim));
[g_nosky,g_noskyhe,g_bin,g_sh,g_sl,g_sum,g_sumh,g_sumb]=binimAll(gim,g_he,newimall,Lims,skyc,s(goal).name);

skyhi=zeros(length(s),size(newim,2));
skylo=zeros(length(s),size(newim,2));
for j=1:length(s)
    disp(['goal ' int2str(goal) '; im ' int2str(j)])
    
    load(s(j).name);
    he_im=double(histeq(newim));
    newim=double(newim);
    [nosky,noskyhe,bin,sh,sl,sums,sumh,sumb,va]=binimAll(newim,he_im,newimall,Lims,skyc,s(j).name);
    skyhi(j,:)=sh;
    skylo(j,:)=sl;
    sky_sumh(j,:)=sumh;
    sky_sumb(j,:)=sumb;    
    vals(j,:)=va;

    draw(j)=sum(sum((newim-gim).^2));
    draw_he(j)=sum(sum((he_im-g_he).^2));
    dnosky(j)=sum(sum((nosky-g_nosky).^2));
    dnoskyhe(j)=sum(sum((noskyhe-g_noskyhe).^2));
    dbin(j)=sum(sum((bin-g_bin).^2));
    dskyhi(j)=sum((sh-g_sh).^2);
    dskylo(1,j)=sum((sl-g_sl).^2);
    dskylo(2,j)=sum((sums-g_sum).^2);
    dskylo(3,j)=sum((sumh-g_sumh).^2);
    dskylo(4,j)=sum((sumb-g_sumb).^2);

    [min_r(j),rim1,imin1,mind1(j),dd1(j,:)]=VisualCompass(newim,gim);
    [min_h(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(he_im,g_he);
    [min_ns(j),rim3,imin3,mind3(j),dd3(j,:)]=VisualCompass(noskyhe,g_nosky);
    [min_nsh(j),rim4,imin4,mind4(j),dd4(j,:)]=VisualCompass(noskyhe,g_noskyhe);
    [min_bin(j),rim5,imin5,mind5(j),dd5(j,:)]=VisualCompass(bin,g_bin);
    [min_slhi(j),rim6,imin6,mind6(j),dd6(j,:)]=VisualCompass(sh,g_sh);
    [min_sllo(1,j),rim7,imin7,mind7(j),dd7(j,:)]=VisualCompass(sl,g_sl);
    [min_sllo(2,j),rim8,imin8,mind8(j),dd8(j,:)]=VisualCompass(sums,g_sum);
    [min_sllo(3,j),rim9,imin9,mind9(j),dd9(j,:)]=VisualCompass(sumh,g_sumh);
    [min_sllo(4,j),rim10,imin10,mind10(j),dd10(j,:)]=VisualCompass(sumb,g_sumb);

    %  il2=imfilter(il,h,'replicate');
    %     title([int2str(j) ': ' s(j).name]);
    %     figure(1)
    %     imagesc(il)
    %     figure(2),
    %     rdplot(dd(j,:)), hold on,    rdplot(dd2(j,:),'r'), hold off,
end
dall=[draw;draw_he;dnosky;dnoskyhe;dbin;dskyhi;dskylo];
ang_all=[min_r;min_h;min_ns;min_nsh;min_bin;min_slhi;min_sllo];
for i=1:(size(ang_all,1))
    [es1,ns]=min([ang_all(i,:)-1;361-ang_all(i,:)]);
    ms=find(ns==2);es1(ms)=es1(ms)*-1;
    es_all(i,:)=es1;
end

dmed=prctile(dall,80,2);
dscale=dall./(dmed*ones(1,size(dall,2)));

is=1:length(s);
outfile=['Goal' int2str(goal) 'Med' int2str(Lims) 'BinAll.mat'];
clear g* nosky noskyhe bin sh sl newim newimall he_im
save(outfile)

% m=medfilt1(skylines,3);
% g=m(goal,:);
% g2=skylines(goal,:);
% for i=1:length(s) df(i)=sum((g-m(i,:)).^2); df2(i)=sum((g2-skylines(i,:)).^2); end;

% plot(is,df/max(df),'k',is,df2/max(df2),'k:x',is,dnew/max(dnew),'r-s')
% if(goal==1) bs=length(s)-4:length(s);
% else bs=1:5;
% end
% keyboard
% plot(is,df2/median(df2(bs)),'k','LineWidth',1.5)
% % plot(is,df/median(df(bs)),'k',is,df2/median(df2(bs)),'k:x',is,dnew/median(dnew(bs)),'r-s',is,sd/median(sd(bs)),'b--*')
% set(gca,'FontSize',14)
% xlabel('distance (m)')
% ylabel('error (normalised)')
% axis tight
% Setbox
% figure(2)
% VisCompSkylines(skylines,goal)
% xlabel('distance (m)')
% ylabel('error (degrees)')
% axis tight
% Setbox
% [es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
% [es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
% figure(3)
% plot(is,es1,is,es2,'r')
% xlabel('distance (m)')
% ylabel('error (degrees)')
% axis tight
% Setbox
% % plot(is,dnew/max(dnew),is,d/max(d),'r',is,sd/max(sd),'k-x',is,df/max(df),'b-o')
% keyboard
% nl=floor(size(dd2,2)/2);
% plot([-nl+1:nl],dd2(2,[nl+1:end 1:nl]))
% nl=floor(size(dd,2)/2);plot([-nl:nl],dd(22,[nl+1:end 1:nl]))
% for i=1:length(s) plot(m(i,:)+i*50);hold on; end;hold off;

function[il,ilhe,bina,skyl_hi,skyl_lo,skysum,skysumh,skysumb,vals]= ...
    binim(newim,imhe,imrgb,Lims,skyc,fn);

wid=size(newim,2);
il=double(newim);
fnew=[fn(1:end-8) '_Binary.mat'];
load(fnew);

bina(end,:)=1;
bina=double(bwfill(bina,'holes'));
bl=bwlabel(bina);
S=regionprops(bl,'Area');
as=sort([S.Area]);
% leave only the biggest object
if(length(as)>1)
    bina=bwareaopen(bina,round(as(end-1)*1.1));
end

il=double(newim).*double(bina);
ilhe=double(imhe).*double(bina);
skysum=sum(il);
skysumh=sum(ilhe);
skysumb=sum(double(bina));

sky=double(newim).*double(~bina);
skyh=double(imhe).*double(~bina);
sky2=il*1e3+sky;
skyh2=il*1e3+skyh;

vals=[max(sky(:)) min(sky2(:)) max(skyh(:))  min(skyh2(:))];

il=il+skyc*double(~bina);
ilhe=ilhe+skyc*double(~bina);

for i=1:wid
    skyl_lo(i)=double(find([0;bina(:,i)]==0,1,'last'));
    skyl_hi(i)=double(find([bina(:,i)]==1,1,'first'));
end
% imagesc(imrgb),hold on;
% plot(1:wid,skyl_lo,'r',1:wid,skyl_hi,'c','LineWidth',1.5)
% axis image, hold off

function[il,ilhe,bina,skyl_hi,skyl_lo,skysum,skysumh,skysumb,vals]= ...
    binimAll(newim,imhe,imrgb,Lims,skyc,fn);

wid=size(newim,2);
il=double(newim);
fnew=[fn(1:end-8) '_Binary.mat'];
load(fnew);

bina(end,:)=1;
bina=double(bwfill(bina,'holes'));

il=double(newim).*double(bina);
ilhe=double(imhe).*double(bina);
skysum=sum(il);
skysumh=sum(ilhe);
skysumb=sum(double(bina));

sky=double(newim).*double(~bina);
skyh=double(imhe).*double(~bina);
sky2=il*1e3+sky;
skyh2=il*1e3+skyh;

vals=[max(sky(:)) min(sky2(:)) max(skyh(:))  min(skyh2(:))];

il=il+skyc*double(~bina);
ilhe=ilhe+skyc*double(~bina);

for i=1:wid
    skyl_lo(i)=double(find([0;bina(:,i)]==0,1,'last'));
    skyl_hi(i)=double(find([bina(:,i)]==1,1,'first'));
end
% imagesc(imrgb),hold on;
% plot(1:wid,skyl_lo,'r',1:wid,skyl_hi,'c','LineWidth',1.5)
% axis image, hold off


function rdplot(d,c)
d=d./max(d);
if(nargin<2) c='b-'; end;
[n,le]=size(d);
nl=floor(le/2);
if(mod(le,2))
    for i=1:n
        plot([-nl:nl],d(i,[nl+1:end 1:nl]),c);
    end
else
    for i=1:n
        plot([-nl:nl-1],d(i,[nl+1:end 1:nl]),c)
    end
end


