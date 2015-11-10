dwork;
cd New\unwrappedOz\'route 3 - tussocky'\
s=dir('I*RSC.mat')
for i=1:length(s)
%     imdiffsBinary(i,1);
%     imdiffsBinaryOneObj(i,1,250);
%     imdiffsOz(i,3);
%     imdiffsOz(i,5);
%     imdiffsOz(i,9);
%     imdiffsOz(i,15);
end
cd ../'route 4 - mediumV2'/
s=dir('I*RSC.mat')
for i=1:length(s)
%     imdiffsBinary(i,1);
    imdiffsBinaryOneObj(i,1,250);
%     imdiffsOz(i,3);
%     imdiffsOz(i,5);
%     imdiffsOz(i,9);
%     imdiffsOz(i,15);
end
return
cd ../'route 1 - open'/
s=dir('I*RSC.mat')
for i=1:length(s)
%     imdiffsBinary(i,1);
    imdiffsBinaryOneObj(i,1,250);
%     imdiffsOz(i,3);
%     imdiffsOz(i,5);
%     imdiffsOz(i,9);
%     imdiffsOz(i,15);
end

cd ../'route 2 - open'/
s=dir('I*RSC.mat')
for i=1:length(s)
    imdiffsBinary(i,1);
    imdiffsBinaryOneObj(i,1,250);
%     imdiffsOz(i,5);
%     imdiffsOz(i,9);
%     imdiffsOz(i,15);
end
plotstuff



return

s=dir('*.jpg')
s=dir('*.mat')

% fn='cricket_pitch_195-sphere.jpg';
% i=imread(fn);
% ig=rgb2gray(i);
% ig=ig(100:600,:);
% ig=imresize(ig,[501,2760]);
% imagesc(ig);
% while 1
%     colormap gray;
%     [x,y]=ginput(1);
%     if(isempty(x)) break;
%     else
%         imagesc(ig);
%         hold on;
%         plot(x,y,'rx')
%         hold off
%         xold=round(x);
%     end
% end
% mpts(1)=xold;
% newg=ig(:,[xold:end 1:xold-1]);
for j=1:length(s)
    j
%     i=imread(s(j).name);
    load(s(j).name);
%     il=rgb2gray(frame);
    il=frame(end:-1:1,:,:);
%     il=imresize(il,[745,2760]);
    
    imagesc(il);
    while 1
        [x,y]=ginput(1);
        if(isempty(x)) break;
        else
            imagesc(il);
            hold on;
            plot(x,y,'rx')
            hold off
            xold=round(x);
            xlim([xold-200 xold+200])
        end
    end
    newim=il(:,[xold:end 1:xold-1],:);
    mpts(j)=xold;
%     dnew(j)=sum(sum((ig-il).^2));
%     
%     dnew(j)=sum(sum((newg-newim).^2));
f=s(j).name;
save(['../Centred/' f(1:end-4) 'Centred.mat'],'newim')
save MidPoints mpts
end
% for j=1:length(s)
%     j
%     i=imread(s(j).name);
%     il=rgb2gray(i);
%     il=imresize(il,max
%     ss(j,:)=size(il)
% end

