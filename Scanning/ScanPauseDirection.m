function ScanPauseDirection
s=dir('*.mov'); js=[1:length(s)];
FixN=[];FixL=[];FixR=[];
AllFixes=[];TotalN=0;TotalL=0;TotalR=0;
for j=js
	f=s(j).name(1:end-4);
	if (f(6:8)=='TrN');
		
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
% 		figure
% 		subplot(3,1,1);hold on
% 		plot(Speeds*300);axis([0 length(Speeds) 0 10]);
% 		plot([0 length(Speeds)], [4 4]);
% 
% 		subplot(3,1,2);
% 		plot(true_theta2)
% 
% 		subplot(3,1,3);hold on
		dthet = [0 diff(true_theta2)];
		a=find(abs(dthet)>pi);dthet(a)=abs(dthet(a))-(2*pi);
		dthet=SmoothVec(dthet,3,'symmetric');
		dthet=abs(dthet)*17190;
% 		plot(dthet,'k');axis([0 length(Speeds) 0 360]);plot([0 length(Speeds)], [60 60]);
% 		%ScanFrames=GetScanFrames(Speeds,true_theta,Sp_th,Dthet_th);

		%--------------------fixations
		InFixation=zeros(1,length(Speeds));
		fixes=find(((Speeds'*300)<=4)&(dthet<=60));
		if (isempty(fixes)==0)
			InFixation(fixes)=1;
% 			subplot(3,1,2);hold on
% 			a=find(InFixation==1);plot(a,true_theta2(a),'kd','MarkerSize',2)
			[Fix]=FixStats(true_theta2,InFixation);
		AllFixes=[AllFixes;Fix];
		switch f(4)
			case 'N'
				FixN=[FixN;Fix];TotalN=TotalN+length(Speeds);
			case 'L'
				FixL=[FixL;Fix];TotalL=TotalL+length(Speeds);
			case 'R'
				FixR=[FixR;Fix];TotalR=TotalR+length(Speeds);
		end
		end%got fixes to play
	
	end%best ant not 0
end%TrNfile
end%j
 FixPlots(FixR,FixN,FixL,TotalR,TotalN,TotalL)
% 
% size(AllFixes)
%-----------
function [Fix]=FixStats(th,fix);%

fix=medfilt1(fix,5);%fill in small holes

Changes=diff(fix);
a=find(Changes==1);Starts=a+1;
a=find(Changes==-1);Ends=a+1;
if (isempty(Ends)==0)
	if Ends(1)<Starts(1);Ends=Ends(2:end);end
	if Starts(end)>Ends(end);Starts=Starts(1:end-1);end

	for j=1:length(Starts)
		Fix(j,1)=Ends(j)-Starts(j);
		Fix(j,2)=median(th(Starts(j):Ends(j)));
	end
else
	Fix=[];
end
	
