clear
s=dir('*.jpg')
load MidPoints
if(~exist('RS'))
    s2=dir('*Centred.mat')
    load(s2(1).name);
    RS=size(newim);
end
for j=1:length(s)
    j
    i=imread(s(j).name);
    xold=mpts(j);
    im=imresize(i,RS);
    imagesc(im);
    newimall=im(:,[xold:end 1:xold-1],:);
    f=s(j).name;
    save([f(1:end-4) 'Centred.mat'],'newimall','-append')
end