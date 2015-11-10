function DeWobble(s,RS,Cr)
if(nargin<1)
    
   s=dir('*Binary.mat')
end

for j=1:length(s)
    j
    fn=s(j).name;
    fnew=[fn(1:end-11) '_UnWob.mat'];
    if 1% (~isfile(fnew))
        load(fn);
        load([fn(1:end-11) 'Mask.mat'],'sky_lo','mask');
        [newim,newimall,wob]=eqheightNew(newim,newimall,1000,900:1400,101,mask);% newim;
        save(fnew,'newim','newimall','wob')
    else
        disp(['file ' fnew ' exists'])
        load(fnew); 
    end
        subplot(2,1,2)
        imagesc(newim); colormap gray
    axis image
    pause
end

function[il,il2,newi]=eqheightNew(newim,imrgb,v,rows, medlen,sk)

% NB these defaults are I think what we used for the data we did outside 
% before we did the JEB paper
if(nargin<4)
    rows=1:100;
end  
if(nargin<5)
    medlen=35;
end  

wid=size(newim,2);
% d=diff(imrgb(1:75,:,3));
% d2=diff(double(imrgb(1:100,:,3)));
d2=diff(double(imrgb(rows,:,3)));

[m,i]=max(d2);
newi=round(medfilt1(i,medlen));

% figure(1),
subplot(2,1,1)
imagesc(imrgb), hold on,
plot(1:wid,newi+rows(1),'r','LineWidth',2),hold off
% plot(1:wid,newi,'r','LineWidth',2),hold off
axis image
% ylim([0 100])

% keyboard

% newi=newi+15;  % NB this is a somewhat magic hack for old data
newi=newi-min(newi)+1;
il=zeros(v,wid);
il2=zeros(v,wid,3);
for k=1:wid
    il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
    il2(1:v,k,1:3)=imrgb(newi(k):newi(k)+(v-1),k,1:3);
end

function[newi]=AdjustPoints(newi,i,imrgb)
[x,y]=ginput(2)
x=round(x)
a1=newi(x(1))
a2=newi(x(2))
d3=i;
d3(x(1):x(2))=round(a1+(a2-a1)/(x(2)-x(1))*[0:(x(2)-x(1))]);
newi=round(medfilt1(d3,35));
figure(1),imagesc(imrgb), hold on,
plot(1:length(newi),newi,'r','LineWidth',2),hold off
ylim([0 100])