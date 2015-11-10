function[dat,mask] = TrackBee_Check(fn,nums)

if(nargin<1)
    %     fn = '90_21_out3.avi';
    %     nums=[130:407];
    fn = '90_21_in30.avi';
    nums=[115:177];
end

k=strfind(fn,'.avi');
sfn=['ProgFiles\' fn(1:k-1) '_Prog.mat']

fi=aviinfo(fn);
NumFrames=fi.NumFrames
if(nargin<2) nums=1:NumFrames; end;
wid=fi.Width; ht=fi.Height;
refim=aviread(fn,1);

doubling=1;
load(sfn)
% Orients = CleanOrients(Orients);
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;
k=1;
picwid=25;
for num=nums
    num
    f=aviread(fn,num);
    imagesc(f.cdata)
    n=ceil(mean(NumBees(2*num-1:2*num)));
    title(['Frame Num = ' int2str(num) ';    num bees = ' num2str(n)])
    axis image
    hold on
    for j=1:n
        if(doubling) i2=[k k+n]; end;
        plot(EndPt(i2,1),EndPt(i2,2),'r.')
        plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','r')
        c=mean(Cents(i2,:));
        axis([c(1)-picwid,c(1)+picwid,c(2)-picwid,c(2)+picwid])
        k=k+1;
    end
    k=k+sum(NumBees(2*num-1:2*num));
    pause
    hold off;
end
