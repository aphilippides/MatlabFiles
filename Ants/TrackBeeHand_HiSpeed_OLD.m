function[dat,mask] = TrackBeeHand_HiSpeed(nums)
% dwork;
% cd GantryProj
cd s0000033
fn = 'dvr00';
if(nargin<1)
    nums=[1:5:1623];
    nums=[100:10:200];
end
CentsEntered=[];TipsEntered=[];
for num=nums
    num
    if(num<10) f=[fn '000' int2str(num) '.tif'];
    elseif(num<100) f=[fn '00' int2str(num) '.tif'];
    elseif(num<1000) f=[fn '0' int2str(num) '.tif'];
    else f=[fn int2str(num) '.tif'];
    end
    i=imread(f);
    imagesc(i);
    [p,q]=ginput(2);
    if(length(p)==2)
        CentsEntered=[CentsEntered; p(1) q(1)];
        TipsEntered=[TipsEntered; p(2) q(2)];
        ds=TipsEntered-CentsEntered;
        Cents=0.5*(TipsEntered+CentsEntered);
        Orients=cart2pol(ds(:,1),ds(:,2));
        save('HiSpeedData.mat','TipsEntered','Cents','Orients','CentsEntered');%
    end
end

ds=TipsEntered-CentsEntered;
Cents=0.5*(TipsEntered+CentsEntered);
Orients=cart2pol(ds(:,1),ds(:,2));
ends=Cents+ds/2;
hold on
plot(Cents(:,1),Cents(:,2),'r.')
plot([Cents(:,1) ends(:,1)]',[Cents(:,2) ends(:,2)]','b')
hold off