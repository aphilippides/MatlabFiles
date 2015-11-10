function[withinbad,betweenbad,Lsize] = CheckIfZoomed

d=dir('./*.avi');
% withinbad=zeros(1,length(d));
% betweenbad=zeros(1,length(d));
OldRef = [];
for i=1:length(d)
    i
    n=aviinfo(d(i).name);
    r=aviread(d(i).name,1);
    refim1=rgb2gray(r.cdata);
    refim1=refim1(75:500,:);
    r=aviread(d(i).name,n.NumFrames);
    refim2=rgb2gray(r.cdata);
    refim2=refim2(75:500,:);
    [withinbad(i) Lsize(i)]=IsLMDifferent(refim1,refim2);
    if(i==1)
        OldRef=refim1;
        betweenbad=0;
    elseif(~withinbad(i))
        if(~isempty(OldRef)) 
            betweenbad(i)=IsLMDifferent(refim1,OldRef);
        else betweenbad(i)=0;
        end
        % OldRef = refim1;
    else  betweenbad(i)=1;
    end
end

function[isdiff,lmsize] = IsLMDifferent(i1,i2)
th=2*median(max(abs(i1-i2)));
isdiff=0;
tlil=300;
refim1=(i1<100);
refim2=(i2<100);
lm1=bwareaopen(refim1,tlil,4);
lm2=bwareaopen(refim2,tlil,4);
[L,n1] = bwlabeln(lm1, 8);
[L,n2] = bwlabeln(lm2, 8);
if((n1==1)&(n2==1))
    lmsize=sum(sum(lm1));
    l1=uint8(lm1).*i1;
    l2=uint8(lm2).*i2;
    mask=(l1(160:210,420:470));
    s=regionprops(L);
    [sx,sy]=floor(s.Centroid);
    for i=-10:10
        for j=-10:10
            im
            match(i+11,j+11)=MatchTemplate(mask,i2
    end
    end
    dif=abs(l1-l2);
    ndif=sum(sum(dif>th));
    if(ndif>(0.05*lmsize)) isdiff=ndif; end;
else isdiff=-1;
end

    