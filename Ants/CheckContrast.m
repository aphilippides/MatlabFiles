function CheckContrast

s=dir('*.jpg');
for i=1:length(s)
    i
    im=imread(s(i).name);
%     im(:,:,3)=0;
%     bw=double(rgb2gray(im));
    bw=double(im(:,:,2));
    bw=bw(1:10:end,1:10:end);
    sl1(i,:)=bw(100,:);
    sl2(i,:)=bw(150,:);
    sl3(i,:)=bw(200,:);
    figure(1)
    imagesc(bw);
    thresh=100;
    t=bw<thresh;
%     tbig=250;
%     bigs=bwareaopen(e,tbig,8);
    tlil=1e3;
    lils=bwareaopen(t,tlil,8);
    bwclean=lils;%imsubtract(lils,bigs);
    % fill in holes
    bwclean=imfill(lils,'holes');
    figure(2)
    imagesc(bwclean);
    obj=bw.*double(bwclean);
    [nr,nc]=size(bw);
    mi=mean(bw,2);
    [L,NumBees] = bwlabeln(bwclean, 8);
    S = regionprops(L,'Area','Centroid','PixelList');
    [m,k]=max([S.Area]);
    pl=S(k).PixelList;
    for j=1:nr
        iob=find(pl(:,2)==j);
        iob=pl(iob,1);
        ib=setdiff(1:nc,iob);
        mo(j)=mean(bw(j,iob));
        mb(j)=mean(bw(j,ib));
    end
        figure(3)
    plot(1:nr,mi,1:nr,mb,'r',1:nr,mo,'k')
    figure(4)
    webcon1(i,:)=(mo-mb)./mb;
    webcon2(i,:)=(mo-mi')./mi';
%     maxi=max(bw');
%     mini=min(bw');
%     Mich=(maxi-mini)./(maxi+mini);
        plot(1:nr,webcon1(i,:),1:nr,webcon2(i,:),'r')%,1:nr,Mich,'k')
        %     mbi=mean(bw,
        save webconsGreen webcon1 webcon2 sl1 sl2 sl3
end

[ma, mai]=max(sl1');[mi, mii]=min(sl1');
Mich1=(ma-mi)./(ma+mi)
[ma, mai]=max(sl2');[mi, mii]=min(sl2');
Mich2=(ma-mi)./(ma+mi)
[ma, mai]=max(sl3');[mi, mii]=min(sl3');
Mich3=(ma-mi)./(ma+mi)
figure(3)

% for i=1:13
% subplot(7,2,i)
% plot(1:400,sl1(i,:),1:400,sl3(i,:),'g',1:400,sl2(i,:),'r')
% ylabel([int2str((i-1)*30) ' degrees'])
% ylim([40 250])
% end
% subplot(7,2,14)
% plot([0:12]*30,Mich1,[0:12]*30,Mich3,'g',[0:12]*30,Mich2,'r'),axis([0 360 0 1])
s=dir('*.jpg');
figure(3)
for i=1:30
    fn=s(i).name;
k1(i)=findstr(fn,'_');
k2(i)=findstr(fn,'.');
order(i)=str2num(fn(1:k1(i)-1));
end
for j=1:16
    i=find(order==j);
    fn=s(i).name;
subplot(8,2,j)
plot(1:365,sl1(i,:),1:365,sl3(i,:),'g',1:365,sl2(i,:),'r')
ylabel([fn((k1(i)+1):(k2(i)-1)) ' degrees'])
ylim([0 255])
end
figure(4)
for j=17:30
    i=find(order==j);
    fn=s(i).name;
subplot(8,2,j-16)
plot(1:365,sl1(i,:),1:365,sl3(i,:),'g',1:365,sl2(i,:),'r')
ylabel([fn((k1(i)+1):(k2(i)-1)) ' degrees'])
ylim([0 255])
end
subplot(8,2,16)
plot(1:30,Mich1,1:30,Mich3,'g',1:30,Mich2,'r'),axis([0 30 0 1])
ylabel(['Michelson Contrast'])