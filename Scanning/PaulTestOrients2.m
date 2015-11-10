%PaulTestOrients
clear
s=dir('*.mov');

%     f=s(i).name(1:end-4)
%     fn=[f '_ProgWhole.mat'];
% %     fn=[f '_Prog.mat'];
%     if(~isfile(fn))
% %          TrackBeeExpt2(s(i).name);
%        TrackBeeExpt2_Whole(s(i).name);
%     end
% end    
% 
% 
% s=dir('*_ProgWhole*')

js=[1:length(s)];
for j=js
    f=s(j).name(1:end-4)
fn=[f '_ProgWhole.mat'];
LMfn=[f 'NestLMData.mat'];
    
	load(fn);load(LMfn)
%     if (length(GoodAnts)>1)
        
    goodframes=find(WhichB==GoodAnts(1));

    X=Cents(goodframes,1);Y=Cents(goodframes,2);
    theta=mod(ang_e(goodframes),2*pi);
    alternate_theta=mod((ang_e(goodframes)-pi),2*pi);
    
    prev_theta = (3*pi)/2;
    for k=1:length(theta)
difference=abs(theta(k)-prev_theta);
if (difference>pi);difference=abs(difference-(2*pi));end
    alt_difference=abs(alternate_theta(k)-prev_theta);

if (alt_difference>pi);alt_difference=abs(alt_difference-(2*pi));end
    
        if ( (difference) < (alt_difference) )
    true_theta(k)=theta(k);
else
    true_theta(k)=alternate_theta(k);
end%if
prev_theta=true_theta(k);
    end%k
    
    sqx=[-10 -10 10 10];sqy=[-7.5 7.5 7.5 -7.5];
    TFORM = cp2tform([LM(:,1) LM(:,2)],[sqx' sqy'],'projective');
    [newX,newY] = tformfwd(TFORM,X,Y);
    windowsize=7;
    
%      v1=MyGradient(Cents(:,1),FrameNum);
%  v2=MyGradient(Cents(:,2),FrameNum);
     v1=MyGradient(newX,FrameNum);
  v2=MyGradient(newY,FrameNum);

 Vels=[v1' v2'];
 [Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));
%     
    newX=SmoothVec(newX,11,'symmetric');
    newY=SmoothVec(newY,11,'symmetric');
    true_theta=SmoothVec(true_theta,11,'symmetric');
    [path_theta,velocity]=cart2pol(diff(newX),diff(newY));
    figure;
    subplot(3,1,1)
    plot(velocity)
    subplot(3,1,2)
    plot(true_theta)
    d_theta=abs(diff(true_theta));
    %d_theta=SmoothVec(d_theta,11,'symmetric');
    subplot(3,1,3)
    plot(d_theta)
% %     plot(newX,newY); axis equal;axis([-14 14 -11 11])
% %     subplot(2,1,2)
% %     hold on; plot(mod(true_theta(2:end),2*pi),'k');plot(mod(path_theta,2*pi),'b');
% %     %plot(Cents(is,1),Cents(is,2))
% %     %set(gca,'YDir','reverse')
   


end%j

