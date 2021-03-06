function[thresh]=CheckBeeThreshLevel(fn,thresh,nums)

frameadd=5;
tadd=5;
k=strfind(fn,'.avi');
WhichB=[];BPos=[];BInds=[];
MaxD=1200;
lmn=[fn(1:k-1) 'NestLMData.mat'];
[inf,NumFrames]=MyAviInfo(fn);
if(isfile(lmn))
    load(lmn);
    refim
    [refim]=MyAviRead(fn,refim,1);
else
    [refim]=MyAviRead(fn,NumFrames,1);
end

if(nargin<3); 
    ind=1; 
end;%nums=1:NumFrames; end;
if(nargin<2) 
    thresh=50; 
end;
% get first fram
f=MyAviRead(fn,ind,1);
dif=imsubtract(refim,f);

while 1
    for i=[1 2]
        [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,boun]= ...
            FindBeeExpt2(dif(i:2:end,:,:),mod(i,2),f(i:2:end,:,:),thresh,1);
        if(isempty(WhichB)) MaxBInd=0;
        else MaxBInd=max(WhichB);
        end
        [BPos,BInds] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
        [ind n]
        mn=min(9,n);
        [co,ro]=NumPl(mn);
        figure(i)
        for j=1:mn
            eval(['subplot(' int2str(co) ',' int2str(ro) ',j)']);
            imagesc(f)
            title(['Frame ' int2str(ind) '; bees ' num2str(n) 'Thresh=' int2str(thresh)])
            hold on,
            for k = 1:length(boun)
                boundary = boun{k};
                plot(boundary(:,2), boundary(:,1)*2-mod(i,2), 'y', 'LineWidth', 2)
            end
            PlotBee(c(j,:),e(j,:),'b')
            PlotBee(c(j,:),ee(j,:),'r')
            plot(ell(j).elips(:,1),ell(j).elips(:,2),'g')
            hold off
        end
        xlabel(['; arrows slev, n=+5, 0=keyboard, return end'])
    end
    [x,y,b]=ginput(1);
    if(isempty(x))
        break;
    elseif(b==30)
        thresh=thresh+tadd;
    elseif(b==31)
        thresh=thresh-tadd;
    elseif(b==48)
        disp(['frameadd=' int2str(frameadd) '; tadd=' int2str(tadd)]);
        keyboard
    elseif(b==110)
        ind=min(NumFrames,ind+frameadd);
        f=MyAviRead(fn,ind,1);
        dif=imsubtract(refim,f);
    end
end

function[c,r]=NumPl(mn)
if(mn<2)
    c=1;
    r=1;
elseif(mn<4)
    c=2;
    r=2;
elseif(mn<6)
    c=3;
    r=2;
else
    c=3;
    r=3;
end