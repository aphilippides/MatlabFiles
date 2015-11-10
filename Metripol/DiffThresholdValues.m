function[Area,MeanIntensity,PeakMax,BestCentroid,bound]=DiffThresholdValues(s,orig,mov1,TVals)

if(nargin<4)
    minT=graythresh(s);
    TVals=[minT:0.05:1];
end
SingCents=[];DoubCents=[];
MyProps=struct('centroids',{},'maxima',{},'areas',{},'meanintensities',{});
for i=1:length(TVals)
    TVals(i)
    bw=im2bw(s,TVals(i));
    bw=imfill(bw,'holes');
    newbw=RemoveCrap(bw);    
    props=regionprops(bwlabel(newbw),'Area','Centroid');
    vs(i)=sum([props.Area]);
    NumObj(i)=length(props);
    if(length(props)>=1)
        MyProps(i).centroids=cat(1, props.Centroid);
        MyProps(i).areas=[props.Area];
        for j=1:NumObj(i)
            cent=[MyProps(i).centroids(j,:)];
            mask=bwselect(newbw,cent(1),cent(2));
            news=SetToColMask(orig,imcomplement(mask),0);
            [m,is]=max(news);
            [n,k]=max(m);
            MyProps(i).maxima(j,:)=[k,is(k)];
            MyProps(i).meanintensities(j)=mean2(news);
        end
    end
end
goods=intersect(find(vs<=2e4),find(vs>0));
ibad=max(find(vs>2e4));
medobj=ceil(median(NumObj(goods)));
cutoff=min(find(NumObj(goods)<=medobj));
cutoff=cutoff+ibad;
TVal=TVals(cutoff);
Maxima=[];Centroids=[];Areas=[];
for i=cutoff:length(MyProps)
    Maxima=[Maxima;[MyProps(i).maxima]];
    Centroids=[Centroids;[MyProps(i).centroids]];
    Areas=[Areas;[MyProps(i).areas]'];    
end
uns=unique(Maxima,'rows')
for i=1:size(uns,1)
    numin(i)=length(find(ismember(Maxima,uns(i,:),'rows')));
end
inds=find(numin>1);
evidenceMax=numin(inds);
RealMaxes=uns(inds,:);
FalseMaxes=setdiff(uns,RealMaxes,'rows');
figure,imshow(s);
hold on; plot(RealMaxes(:,1),RealMaxes(:,2),'rx','MarkerSize',10)
hold on; plot(FalseMaxes(:,1),FalseMaxes(:,2),'go','MarkerSize',10)
for i=1:size(RealMaxes,1) 
    h=text(RealMaxes(i,1)-3,RealMaxes(i,2)-12,int2str(evidenceMax(i)));
    set(h,'FontSize',12,'Color','r')
end
ThreshAndBound(s,0,TVal);
hold off;

% Get rid of stuff pertaining to spurious maxima
[f,l]=ismember(Maxima,RealMaxes,'rows');
for i=1:size(RealMaxes,1)
    RMAreas(i)=mean(Areas(find(l==i)));
end
NonSpur=find(l);
opts=zeros(1,14);
opts(1)=1;
opts(2:3)=0.1;
[c,o,p,e]=kmeans(RealMaxes,Centroids(NonSpur,:),opts);
evidenceC=sum(p);
for i=1:size(RealMaxes,1) 
    sds(i,1)=std(Centroids(find(p(:,i)),1)-c(i,1));
    sds(i,2)=std(Centroids(find(p(:,i)),2)-c(i,2));
end

figure,imshow(s);
hold on; plot(c(:,1),c(:,2),'rx','MarkerSize',10)
for i=1:size(RealMaxes,1) 
    h=text(c(i,1)-3,c(i,2)-12,int2str(evidenceC(i)),'Color','r');
    set(h,'FontSize',12)
    if(evidenceC(i)>1)
    MyEllipse(c(i,:), sds(i,1)/sqrt(evidenceC(i)),sds(i,2)/sqrt(evidenceC(i)),100,'b');
    end
end
bound=ThreshAndBound(s,0,TVal);
hold off;
f=[mov1 'AllPeaks'];
%print(f,'-dbmp','-r0'); 

% Area=mean(vs(cutoff:end));
% mean[MyProps(i).areas(j)(cutoff:end));
for i=cutoff:length(MyProps)
    js=find(ismember([MyProps(i).maxima],RealMaxes,'rows'));
    meanInt(i)=mean([MyProps(i).meanintensities(js)]);
    sumArea(i)=sum([MyProps(i).areas(js)]);
end
MeanIntensity=mean(meanInt);
%Area=mean(sumArea);
Area=sumArea(cutoff);
title(['Area = ' num2str(Area) ',   Mean Intensity = ' num2str(MeanIntensity) ',']);

% plot peak max
for i=1:size(RealMaxes,1)
    peakvals(i)=s(RealMaxes(i,2),RealMaxes(i,1));
end
[m,i]=max(peakvals);
PeakMax=RealMaxes(i,:);
figure,imshow(s),hold on,
plot(RealMaxes(i,1),RealMaxes(i,2),'rx')
h=text(RealMaxes(i,1)-3,RealMaxes(i,2)-12,num2str(m));
set(h,'FontSize',12,'Color','r')
% F = getframe(gca);
f=[mov1 'MaxPeak'];
%print(f,'-dbmp','-r0'); 

% plot peaks with areas 33% over largest area
is=find((RMAreas./max(RMAreas))>0.33);
figure,imshow(s),hold on,
plot(RealMaxes(is,1),RealMaxes(is,2),'rx')
for i=1:length(is)
    h=text(RealMaxes(is(i),1)-3,RealMaxes(is(i),2)-12,num2str(RMAreas(is(i))));
    set(h,'FontSize',12,'Color','r')
end
for i=cutoff:length(MyProps)
    js=ismember(RealMaxes(is,:),[MyProps(i).maxima],'rows');
    if(sum(js)==size(RealMaxes,1))
        T=TVals(i);
        break
    end
end
% F = getframe(gca);
% mov3 = addframe(mov3,F);
f=[mov1 'PeaksArea'];
%print(f,'-dbmp','-r0'); 

% plot 2 centroids with higest evidences
[peaks,e]=sort(evidenceC);
if((length(e)>=2))
    if((peaks(end)>4)&(peaks(end-1)<4))es=e(end); 
    else es=e(end:-1:end-1);
    end
else es = e; 
end;

figure,imshow(s),hold on,
plot(c(es,1),c(es,2),'rx')
for i=1:length(es)
    h=text(c(es(i),1)-3,c(es(i),2)-12,num2str(evidenceC(es(i))));
    set(h,'FontSize',12,'Color','r')
end
f=[mov1 'SelectedCentroids'];
%print(f,'-dbmp','-r0'); 
BestCentroid=c(es(1),:);
plot(BestCentroid(1),BestCentroid(2),'bx')

function[newb]=RemoveCrap(bw)
props=regionprops(bwlabel(bw),'Area','Centroid');
Thresh=20;
as=[props.Area];
centroids = cat(1, props.Centroid);
inds=find(as>Thresh);      % also do something with centroid
if(isempty(inds)) newb=bw*0;
else newb=bwselect(bw,centroids(inds,1),centroids(inds,2)); 
end