function LookAtBads(fn,nums)
dwork;
cd GantryProj\Bees
fn=['90_21_in30.avi'];
fi=aviinfo(fn);
refim=aviread(fn,1);
NumFrames=fi.NumFrames
load 90_21_in30Data_Andy_115_177;
load 90_21_in30_ThreshErrors;
r=[];
Err=0.1396;
t=0.5
for i=1:length(t)
    sfn=[fn(1:end-4) 'ProgDataT' num2str(t(i)) '_115_177.mat'];
    load(sfn);
    [EndPt(:,1) EndPt(:,2)]=pol2cart((Orients),10);
    EndPt(:,2)=-EndPt(:,2);
    EndPt=EndPt+Cents;
    is=find(abs(Errors(i,:))>Err);
    NumBads(i)=length(is);
    Bigs=find(Areas>(1.125*median(Areas)));
    Smalls=find(Areas<(0.8*median(Areas)));
    Eccents=find(Eccent<(0.9*median(Eccent)));
    [y,OutBs]=OutofBounds(Bounds,fn(1:5));
    NBigs(i)=length(Bigs);
    NSmalls(i)=length(Smalls);
    NEccents(i)=length(Eccents);
    NOuts(i)=length(OutBs);
    BigBad(i)=length(intersect(is,Bigs));
    SmallBad(i)=length(intersect(is,Smalls));
    EccBad(i)=length(intersect(is,Eccents));
    OutBad(i)=length(intersect(is,OutBs));
    Gone=unique([Bigs Smalls OutBs Eccents]);
    NGone(i)=length(Gone);
    NBadGone(i)=length(intersect(is,Gone));
    for j=is
        if(isempty(r))
            num=ceil(FrameNum(j)/2)
            f=aviread(fn,num);
            dif=imsubtract(refim.cdata,f.cdata);
            if(mod(FrameNum(j),1)) k = 2;
            else k=1;
            end

            im=f.cdata;
            d=double(rgb2gray(dif(k:2:end,k:2:end,:)));
            e=d>(t(i)*(max(max(d))));
            tbig=100;
            bigs=bwareaopen(e,tbig,8);
            tlil=15;
            lils=bwareaopen(e,tlil,8);
            bwclean=imsubtract(lils,bigs);
            bwclean=imfill(bwclean,'holes');
            figure(1)
            imagesc(dif(k:2:end,k:2:end,:));
            [x1,x2,y1,y2]=SetBigBBox(Bounds(j,:),50,50,720/2,576/2);
            hold on;
            plot(EndPt(j,1),EndPt(j,2),'r.')
            plot([Cents(j,1) EndPt(j,1)]',[Cents(j,2) EndPt(j,2)]','r')
            plot(CentsEntered(j,1)/2,CentsEntered(j,2),'g.')
            plot([TipsEntered(j,1) CentsEntered(j,1)]/2',[TipsEntered(j,2) CentsEntered(j,2)]','g')
            hold off;
            axis square
            axis([x1,x2,y1,y2])
            title(num2str(Errors(i,j)*180/pi))
            figure(2)
            imagesc(bwclean);
            axis square
            axis([x1,x2,y1,y2])
            str=[''];
            if(ismember(j,Bigs)) str = ['Big ']; end; 
            if(ismember(j,Smalls)) str = [str 'Small ']; end; 
            if(ismember(j,Eccents)) str = [str 'Eccent ']; end; 
            if(ismember(j,OutBs)) str = [str 'Out']; end; 
           title(str)
            figure(3)
            imshow(f.cdata(k:2:end,:,:),[],'InitialMagnification','Fit');

            axis square
            axis([2*x1,2*x2,y1,y2])
%             hold on
%             plot(TipsEntered(j,1),TipsEntered(j,2),'g.')
%             plot([TipsEntered(j,1) CentsEntered(j,1)]',[TipsEntered(j,2) CentsEntered(j,2)]','g')
%             hold off
            r=input('press');
        else
            break;
        end;
    end
end
figure(2),bar(t,NumBads)