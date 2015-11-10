function ResizeAndCrop(s,RS,Cr)

for j=1:length(s)
    j
    fn=s(j).name;
    load(fn);
    newim=imresize(newim,RS);
    newimall=imresize(newimall,RS);
    newim=newim(Cr(1):Cr(2),:);
    newimall=newimall(Cr(1):Cr(2),:,:);
    save([fn(1:end-11) '_RSC.mat'],'newim','newimall','RS','Cr')
    imagesc(newim)
    colormap gray
    axis image
end
