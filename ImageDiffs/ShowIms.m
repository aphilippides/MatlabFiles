function ShowIms(s,RS)

if(nargin<1) 
    s=dir('*.jpg');
%     s=dir('*RSC.mat');
    s=dir('*_Binary.mat');
%     s=dir('*_BlurBinary.mat');
% s=dir('*Centred.mat')
end;

bit=1;

% RS=GetRS(s);
% load MidPoints

if(exist('RS'))
    rsf=1;
    RS=RS(1:2);
else rsf=0;
end;

j=1;
len=length(s);
while(j<=length(s))
    j;
    fn=s(j).name;
    %     i=imread(fn);
    load(fn);
    
%     newimall=frame;
%     il=rgb2gray(newimall);
%     %     il=frame(end:-1:1,:,:);
%     %     RS=[748,2795];
%     if(rsf)
%         il=imresize(il,RS);
%         newimall=imresize(newimall,RS);
%     end

imagesc(newimall);
axis image;

bina(end,:)=1;
bina=double(bwfill(bina,'holes'));
bl=bwlabel(bina);
S=regionprops(bl,'Area');
as=sort([S.Area]);
% leave only the biggest object
if(length(as)>1)
    bina=bwareaopen(bina,round(as(end-1)*1.1));
end

for i=1:size(bina,2)
    skyl_lo(i)=double(find([0;bina(:,i)]==0,1,'last'));
    skyl_hi(i)=double(find([bina(:,i)]==1,1,'first'));
end
hold on
wi=1:length(skyl_hi);
plot(wi,skyl_hi,'r',wi,skyl_lo,'c')
hold off
    title([int2str(j) '/' int2str(len) '; ' fn])
    x=input('Press c to end, u to go back, return continue','s');
    %     colormap(gray)
    if(isempty(x))
        j=mod(j+bit,len);
        if(j==0) j=len; end;
%         break;
    elseif(isequal(x,'u'))
        j=mod(j-bit,len);
        if(j==0) j=len; end;
%         break;
    elseif(isequal(x,'c')) break;
    end

% j=j+5;
end