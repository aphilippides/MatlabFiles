function[nest1,nest2,nwid,narea,lm1,lm2,lmwid,lmarea] ...
    =MatchNestAndLM(nest,LMs,refim,im,nar,lar)
% nest is roughly 10/10,  Lm is 25 by 25 so
nw=8;lw=16;mw=100;
% 35 seems to be a good threshold...
nt=40;lt=40;
refim=double(rgb2gray(refim));
im=double(rgb2gray(im));
n=round(nest);
tpl=refim(n(2)-nw:n(2)+nw,n(1)-nw:n(1)+nw);
ima=im(n(2)-mw:n(2)+mw,n(1)-mw:n(1)+mw);
off=n-mw-1;
if(nargin<5) 
    [nest1,nest2,nwid,narea]=GetNest(nt,tpl,ima,off);
    for i=1:size(LMs,1)  
        l=round(LMs(i,:));
        tpl=refim(l(2)-lw:l(2)+lw,l(1)-lw:l(1)+lw);
        ima=im(l(2)-mw:l(2)+mw,l(1)-mw:l(1)+mw);
        off=l-mw-1;
        [lm1(i,:),lm2(i,:),lmwid(i),lmarea(i)]= ...
            GetNest(lt,tpl,ima,off);
    end
else
    [nest1,nest2,nwid,narea]=GetNest(nt,tpl,ima,off,nar);
    for i=1:size(LMs,1) 
        l=round(LMs(i,:));
        tpl=refim(l(2)-lw:l(2)+lw,l(1)-lw:l(1)+lw);
        ima=im(l(2)-mw:l(2)+mw,l(1)-mw:l(1)+mw);
        off=l-mw-1;
        [lm1(i,:),lm2(i,:),lmwid(i),lmarea(i)]= ...
            GetNest(lt,tpl,ima,off,lar);
    end
end

imagesc(im)
hold on;
ns=[nest1;nest2];ls=[lm1;lm2];
plot(ns(:,1),ns(:,2),'r.',ls(:,1),ls(:,2),'g.')
MyCircle([nest1;lm1],[nwid;lmwid],'r')
hold off;
axis([nest(1)-100 nest(1)+200 nest(2)-150 nest(2)+150])
drawnow

function[nest1,nest2,nwid,area]=GetNest(nt,tpl,i,off,ar);
bw=(i<nt);
bwclean=bwareaopen(bw,15,8);
% fill in holes
bwclean=imfill(bwclean,'holes');
[L,NumBees] = bwlabeln(bwclean, 8);
s = regionprops(L,'Area','Centroid','MajorAxisLength','MinorAxisLength');
if(nargin<5) 
    area=s(1).Area;
    nest1=s(1).Centroid;
    nwid=0.25*(s(1).MajorAxisLength+s(1).MinorAxisLength);
else
    as=[s.Area];
    [dum,ind]=min(abs(as-ar));
    area=as(ind);
    nest1=s(ind).Centroid;
    nwid=0.25*(s(ind).MajorAxisLength+s(ind).MinorAxisLength);
end   
cc = normxcorr2(tpl,i); 
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
nest2=[xpeak,ypeak]-0.5*(size(tpl,1)-1)+off;
nest1=nest1+off;