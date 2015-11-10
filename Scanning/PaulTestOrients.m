%PaulTestOrients
clear
s=dir('*.mov'); js=[1:length(s)];
Pause_Theta=[];All_Theta=[];
for j=js
    f=s(j).name(1:end-4);
    fn=[f '_ProgWhole.mat'];
    LMfn=[f 'NestLMData.mat'];
    load(fn);load(LMfn);
    if (BestAnt>0)
        goodframes=find(WhichB==BestAnt);
        X=Cents(goodframes,1);Y=Cents(goodframes,2);
        theta=mod(ang_e(goodframes),2*pi);
        alternate_theta=mod((ang_e(goodframes)-pi),2*pi);
        %-----Get a body angle
        prev_theta = (3*pi)/2;
        true_theta=[];
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
        %------Transform X and Y
        sqx=[-10 -10 10 10];sqy=[-7.5 7.5 7.5 -7.5];
        TFORM = cp2tform([LM(:,1) LM(:,2)],[sqx' sqy'],'projective');
        [newX,newY] = tformfwd(TFORM,X,Y);
        %---for when there were more than one ant FrameNum(GoodFrames) ??
        v1=MyGradient(newX,FrameNum(goodframes));
        v2=MyGradient(newY,FrameNum(goodframes));
        Vels=[v1' v2'];[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));
        Speeds=SmoothVec(Speeds,11,'symmetric');
        %--find discrete pause bits
        Slow=zeros(size(Speeds));
        a=find(Speeds<0.0083);Slow(a)=1;
        Changes=[0 diff(Slow)];
        EndScans = find(Changes==-1);
        StartScans = find(Changes==1);
        %------------------
        true_theta=SmoothVec(true_theta,5,'symmetric');
        %[path_theta,path_speed]=cart2pol(diff(newX),diff(newY));
        [bearing,r]=cart2pol((newX-newX(1)),(newY-newY(1)));
        All_Theta=[All_Theta, true_theta];
        %------figure
                figure;
                subplot(4,1,1);
                plot(r);title(f)
                subplot(4,1,2)
                plot(Speeds*300);axis([0 length(Speeds) 0 2.5])
                subplot(4,1,3)
                plot(true_theta)
                subplot(4,1,4)
                plot(eccent);title(int2str(mean(eccent)))
        %-----------
        for k=1:length(EndScans)
            Pause_Theta=[Pause_Theta, true_theta(StartScans(k):EndScans(k))];
        end%k numscans
    end%best ant not 0

end%j
% figure(2)
% rose(Pause_Theta);title('pause')
% figure(1)
% rose(All_Theta);title('all')
