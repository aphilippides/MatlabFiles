function GetSkylinesFromBinary

s=dir('*Binary.mat');

skyc=200;
for i=1:length(s)
    i
    fn=s(i).name;
%     fn=['video_test' int2str(s(i)) '_Binary.mat'];
    [im,imhe,mask,sky_hi,sky_lo,skysum,skysumh,skysumb,vals]= ...
        binim(fn,skyc,1);
    title(['image ' int2str(i) ': ' fn])
    drawnow;
    skyl_hi(i,:)=sky_hi;
    skyl_lo(i,:)=sky_lo;
    save([fn(1:end-11) 'Mask.mat'],'mask','im','imhe','sky_hi','sky_lo');
%     pause
end
subplot(1,2,1)
skylinePlot(skyl_hi,15,'k')
subplot(1,2,2)
skylinePlot(skyl_lo,15,'k')
save skylinedata.mat skyl*
% keyboard
% note for video_test data, there are 126 Binary images which are
% from 31 to 219 but in weird steps of 31] [33 34] [36 37] [39 40] 
% these seem to correspond (as there are 126 of each set) to the UnW
% images which start at 318:15:2193.
%
% have discivered the cock-up: *UnW files were read in but only the first 3
% of the digits of their file name were output which meant i got lucky in
% getting all 126. Hasve renmaed with the originals in the fodler
% BadlyNamed until I choose to delete them
% 
% The code below is a check and aide memoire

% s2=dir('*UnW.mat');
% 
% for i=1:length(s)
%     load(s2(i).name);
%     fnew=[s2(i).name(1:end-7) '_Binary.mat'];
% %     load(s(i).name);
%     load(fnew);
%     a(i)=isequal(newim,unw_bw);
%         b(i)=isequal(newimall,uint8(unw_im));
%     subplot(2,1,1),imagesc(newimall)
%     title([s(i).name ' ' int2str([a(i) b(i)])])
%     subplot(2,1,2),imagesc(uint8(unw_im))
%     title([s2(i).name ' ' int2str([a(i) b(i)])])
%     pause
% end


% this ftn processes an image into skyline
function[il,ilhe,bina,skyl_hi,skyl_lo,skysum,skysumh,skysumb,vals]= ...
    binim(fn,skyc,pl)

load(fn);
wid=size(newim,2);

bina(end,:)=1;
bina=double(bwfill(bina,'holes'));
bl=bwlabel(bina);
S=regionprops(bl,'Area');
[m,ind]=max([S.Area]);
% leave only the biggest object
bina=bl==ind;

% fill in any holes below 'horizon' at sides of image
rsum=sum(bina,2);
full_1=find(rsum==wid,1,'first');
bina(full_1:end,[1 wid])=1;
bina=double(bwfill(bina,'holes'));

% now cualculate a hi and low skyline
for i=1:wid
    skyl_lo(i)=double(find([0;bina(:,i)]==0,1,'last'));
    skyl_hi(i)=double(find([bina(:,i)]==1,1,'first'));
end

%plot im and sky
if pl
    imagesc(newimall)
    hold on;
    plot(1:wid,skyl_lo,'r',1:wid,skyl_hi,'c','LineWidth',1.5)
    axis image
    hold off
end

% histeg'ed image and sky only
imhe=double(histeq(newim));
skyonly=double(~bina);

% this gets the image with sky being 0
il=double(newim).*bina;
ilhe=double(imhe).*bina;

% get a sum of the amount of 'ground' from the varoius manipulations
skysum=sum(il);
skysumh=sum(ilhe);
skysumb=sum(bina);

% this then makes the sky a uniform colour, skyc
il=il+skyc*skyonly;
ilhe=ilhe+skyc*skyonly;

% this bit seems to be emphasising sky: not entirely sure why
sky=double(newim).*skyonly;
skyh=double(imhe).*skyonly;
sky2=il*1e3+sky;
skyh2=il*1e3+skyh;

% get some vals: again was poss useful but might not still be
vals=[max(sky(:)) min(sky2(:)) max(skyh(:))  min(skyh2(:))];



function[il,ilhe,bina,skyl_hi,skyl_lo,skysum,skysumh,skysumb,vals]= ...
    binimAll(newim,imhe,imrgb,skyc,fn)

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
imagesc(imrgb),hold on;
plot(1:wid,skyl_lo,'r',1:wid,skyl_hi,'c','LineWidth',1.5)
axis image, hold off

