%PaulTestOrients5
clear
s=dir('*.mov'); js=[1:length(s)];

for j= 2%js
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
       figure(j);      
	   PaulStickBall(newX,newY,true_theta2,15);title(f)
       
	   xx=[1:1:length(Speeds)];xx=xx*3.3333; 
	   figure(j+10)
		subplot(2,1,1);
		plot(xx,Speeds*300); axis([0 xx(end)-10 0 35])
           
		subplot(2,1,2);hold on;
        plot(xx,true_theta2*-57.3,'k');axis([0 xx(end)-10 0 180]);ca=gca;set(ca,'Ytick',[-180 -135 -90 -45 0 45 90 135 180])
       
	
	   xxxx=[1:1:511];xx=xx*3.3333; 
	   figure(11)
		subplot(3,1,1);
		plot(xxxx,Speeds(570:1080)*300); axis([0 510 0 35])
        
		subplot(3,1,2);hold on;
        plot(xxxx,true_theta2(570:1080)*-57.3,'k');axis([0 510 0 180]);ca=gca;set(ca,'Ytick',[-180 -135 -90 -45 0 45 90 135 180])

			subplot(3,1,3);hold on;
        %plot(xxxx,true_theta2(570:1080)*-57.3,'k');axis([0 510 0 180]);ca=gca;set(ca,'Ytick',[-180 -135 -90 -45 0 45 90 135 180])
dthet = diff(true_theta2);
        a=find(abs(dthet)>pi);dthet(a)=abs(dthet(a))-(2*pi);
        dthet=GetTheta(dthet);
		dthet=BufferedSmoothAng(dthet,5);
        plot(xxxx,dthet(570:1080)*17190,'k');axis([0 510 -550 550]);ca=gca;set(ca,'Ytick',[-360 -180 0 180 360]);plot([0 510],[80 80]);plot([0 510],[-80 -80])
		
    end%best ant not 0
end%j
