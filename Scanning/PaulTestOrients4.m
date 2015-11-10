%PaulTestOrients4
clear
s=dir('*.mov'); js=[1:length(s)];
d_thet_cum=[];Speeds_cum=[];
for j= js
    f=s(j).name(1:end-4);
    fn=[f '_ProgWhole.mat'];
    LMfn=[f 'NestLMData.mat'];
    load(fn);load(LMfn);
    if (BestAnt>0)
        goodframes=find(WhichB==BestAnt);
        X=Cents(goodframes,1);Y=Cents(goodframes,2);

        theta=GetTheta(ang_e(goodframes));
        alternate_theta=GetTheta(theta-pi);
        %------Transform X and Y
        sqx=[-10 -10 10 10];sqy=[7.5 -7.5 -7.5 7.5];
        TFORM = cp2tform([LM(:,1) LM(:,2)],[sqx' sqy'],'projective');
        [newX,newY] = tformfwd(TFORM,X,Y);
        %-------Smooth X and Y
        newX=SmoothVec(newX,5,'symmetric');
        newY=SmoothVec(newY,5,'symmetric');
        %---for when there were more than one ant FrameNum(GoodFrames) ??
        v1=MyGradient(newX,FrameNum(goodframes));
        v2=MyGradient(newY,FrameNum(goodframes));
        Vels=[v1' v2'];[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));
        %-----Get a body angle
        true_theta=Choose_Theta(theta,alternate_theta,((3*pi)/2),Speeds,Cent_Os);
		true_theta2 = BufferedSmoothAng(true_theta,5);
		 true_theta2=GetTheta(true_theta2);
		%------figure
       fignum=figure;set(fignum,'WindowStyle','docked')
        subplot(3,2,1); 
        PaulStickBall(newX,newY,true_theta2,15);title(f)
        subplot(3,2,2);
        plot(newX,newY);axis equal;line([sqx,-10],[sqy,7.5]);axis equal;axis([-14 14 -11 11])
        subplot(3,1,2)
        plot(Speeds*300);hold on;line([0 length(Speeds)],[7 7]);axis([0 length(Speeds) 0 12])
        subplot(3,1,3);hold on;
        plot(true_theta2,'k');plot(Cent_Os,'b');title('path blue - extracted black - 2-dashed');
        axis([0 length(Speeds) -pi pi])
% 		
% 		subplot(4,1,4);hold on;
% 		d_thet=GetDTheta(true_theta2);
% 		d_thet_cum=[d_thet_cum,d_thet*17190];Speeds_cum=[Speeds_cum,Speeds'*300];
		
    end%best ant not 0
end%j
fignum=figure;set(fignum,'WindowStyle','docked')
plot(Speeds_cum,d_thet_cum,'k.','MarkerSize',2)
disp('d')
%         %--find discrete pause bits
%         Slow=zeros(size(Speeds));
%         a=find(Speeds<0.0083);Slow(a)=1;
%         b=find(Slow==0);
%         Changes=[0 diff(Slow)];
%         EndScans = find(Changes==-1);
%         StartScans = find(Changes==1);
%------------------
