% function CalibrateFilesVisually

% s=dir(['*Calib.mat']);
% WriteFileOnScreen(s,1);
% Picked=input('select file numbers:   ');
% CalibFn=s(Picked).name;
% 
% load(CalibFn)
s2=dir(['*All.mat']);
LM1=[];LM2=[];LM3=[];LM4=[];ns=[];
for i=1:length(s2)
    load(s2(i).name)
    lmo=LMOrder(LM);
    lmos(i,:)=lmo;
%     if(exist('cmPerPix'))
%     [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
%         ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,lmn,t,OToNest,cmPerPix,compassDir);
%     else
%     [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
%         ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,lmn,t,OToNest,[],[]);
%     end
    nlm=size(LM,1);
    LM1=[LM1;LM(lmo(1),:) LMWid(lmo(1))];
    if(nlm==2) LM2=[LM2;LM(lmo(2),:) LMWid(lmo(2))];
    elseif(nlm==4)
        LM2=[LM2;LM(lmo(2),:) LMWid(lmo(2))];
        LM3=[LM3;LM(lmo(3),:) LMWid(lmo(3))];
        LM4=[LM4;LM(lmo(4),:) LMWid(lmo(4))];
    end
    ns=[ns;nest NestWid];
end

if(nlm==1)
    figure(1);
    MyCircle(LM1(:,[1 2]),LM1(:,3)/2,'r');hold on
    plot(ns(:,1),ns(:,2),'bx')
    axis equal;set(gca,'YDir','reverse');
    title('nest and LM Positions: blue is new North')
    ToN=LM1-ns;
    mToN=mean(ToN);
    mN=mean(ns);
    compassDirVisual=cart2pol(mToN(1),mToN(2));
    compDs=cart2pol(ToN(:,1),ToN(:,2));
    plot([ns(:,1)';LM1(:,1)'],[ns(:,2)';LM1(:,2)'],'r:')
    plot([mN(1) mN(1)+mToN(1)],[mN(2) mN(2)+mToN(2)],'b- s','Linewidth',2)
    hold off;
    figure(2), 
    hist(compDs*180/pi)
    title(['NDirection = ' num2str(compassDirVisual*180/pi)])
    figure(3);
    for i=1:size(ns,1)
        MyCircle(LM1(i,[1 2]),LM1(i,3)/2,'r');hold on
        plot(ns(i,1),ns(i,2),'bx')
        axis equal;set(gca,'YDir','reverse');
        title('nest and LM Positions: blue is new North')
        plot([ns(i,1)';LM1(i,1)'],[ns(i,2)';LM1(i,2)'],'r:')
        plot([mN(1) mN(1)+mToN(1)],[mN(2) mN(2)+mToN(2)],'b- s','Linewidth',2)
        xlabel(s2(i).name)
        pf=input(['file ' s2(i).name '. Return to continue or 1 to stop pausing: ']);
        if(isequal(pf,1)) break; end;
        hold off;
    end

elseif(nlm==4)
    ToN=LM3-ns;
    mToN=median(ToN);
    mN=mean(ns);
    compassDirVisual=cart2pol(mToN(1),mToN(2));
    compDs=cart2pol(ToN(:,1),ToN(:,2));
    figure(1);
    MyCircle(LM3(:,[1 2]),LM3(:,3)/2,'r');hold on
    plot(ns(:,1),ns(:,2),'bx')
    axis equal;set(gca,'YDir','reverse');
    title('nest and LM Positions: blue is new North')
    plot([ns(:,1)';LM3(:,1)'],[ns(:,2)';LM3(:,2)'],'r:')
    plot([mN(1) mN(1)+mToN(1)],[mN(2) mN(2)+mToN(2)],'b- s','Linewidth',2)
    hold off;
    figure(2), 
    hist(compDs*180/pi)
    title(['NDirection = ' num2str(compassDirVisual*180/pi)])
    figure(3);
    for i=1:size(ns,1)
        MyCircle(LM3(i,[1 2]),LM3(i,3)/2,'r');hold on
        plot(ns(i,1),ns(i,2),'bx')
        axis equal;set(gca,'YDir','reverse');
        title('nest and LM Positions: blue is new North')
        plot([ns(i,1)';LM3(i,1)'],[ns(i,2)';LM3(i,2)'],'r:')
        plot([mN(1) mN(1)+mToN(1)],[mN(2) mN(2)+mToN(2)],'b- s','Linewidth',2)
        xlabel(s2(i).name)
        pf=input(['file ' s2(i).name '. Return to continue or 1 to stop pausing: ']);
        if(isequal(pf,1)) break; end;
        hold off;
    end
end
inp=input('input 1 if this looks ok and files will be updated: ');
if(inp==1)
    s=dir(['*Calib.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    CalibFn=s(Picked).name;
    load(CalibFn)
    save(CalibFn,'compassDirVisual','-append')
    compassDirCalib=compassDir;
    compassDir=compassDirVisual;
    for i=1:length(s2) 
        save(s2(i).name,'compassDir','compassDirCalib','-append'); 
    end
end