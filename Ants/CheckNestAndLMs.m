% s=dir('*.avi');
clear
s=dir('*All.mat');
LM1=[];LM2=[];LM3=[];LM4=[];ns=[];
jnds=1:length(s)
for i=jnds
    f=s(i).name(1:end-4)
%     lmn=[f 'NestLMData.mat'];
    lmn=[s(i).name];
    load(lmn)
    lmo=LMOrder(LM);
    lmos(i,:)=lmo;
    if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,lmn,t,OToNest,cmPerPix,compassDir);
    else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,lmn,t,OToNest,[],[]);
    end
    nlm=size(LM,1);
    if(~exist('compassDir','var')) 
        compassDir=4.9393;
        compassDirCalib=NaN;
    end;
    cdirs(i)=compassDir;
    cdir2(i)=compassDirCalib;
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
    [xcp,ycp]=pol2cart(cdirs,20);
    [xc2,yc2]=pol2cart(cdir2,20);
    plot([ns(:,1) xcp']',[ns(:,2) ycp']','g',[ns(:,1) xc2']',[ns(:,2) yc2']','m--')
    axis equal;set(gca,'YDir','reverse');
    hold off;
    title('nest and LM Positions')
    figure(2),
    d1s=CartDist(LM1(:,[1 2]),ns(:,[1 2]));
    plot(jnds,d1s,'r',jnds,LM1(:,3))
    title('LM width and distance between nest and LM')
    legend('nest to LM','LM width');
    figure(3),
    o1s=cart2pol(LM1(:,1)-ns(:,1),LM1(:,2)-ns(:,2))';
    o1s=AngleWithoutFlip(mod(o1s-cdirs,2*pi));
    plot(jnds,o1s*180/pi)
    title('orientation of LM from nest and compass direction')
    figure(4),
    plot(LM1(:,[1 2]),'r'),hold on;
    plot(ns(:,[1 2]),'b')
    title('x and y position for nest and LMs')
    legend('LM','nest');
    hold off
    [x,y]=pol2cart(o1s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAng=meanAng*180/pi
    LengthMean
    stdAngs=std(o1s)*180/pi
elseif(nlm==2)
    figure(1);
    MyCircle(LM1(:,[1 2]),LM1(:,3)/2,'r');hold on
    MyCircle(LM2(:,[1 2]),LM2(:,3)/2,'k');
    plot(ns(:,1),ns(:,2),'bx')
    [xcp,ycp]=pol2cart(cdirs,20);
    [xc2,yc2]=pol2cart(cdir2,20);
    plot([ns(:,1) xcp']',[ns(:,2) ycp']','g',[ns(:,1) xc2']',[ns(:,2) yc2']','m--')
    axis equal;set(gca,'YDir','reverse');
    hold off;
    title('nest and LM Positions')
    figure(2),
    d1s=CartDist(LM1(:,[1 2]),ns(:,[1 2]));
    d2s=CartDist(LM2(:,[1 2]),ns(:,[1 2]));
    plot(jnds,d1s,'r',jnds,d2s,'k')
    title('distance between nest and LMs')
    figure(3),
    o1s=cart2pol(LM1(:,1)-ns(:,1),LM1(:,2)-ns(:,2))';
    o2s=cart2pol(LM2(:,1)-ns(:,1),LM2(:,2)-ns(:,2))';
    o1s=AngleWithoutFlip(mod(o1s-cdirs,2*pi));
    o2s=AngleWithoutFlip(mod(o2s-cdirs,2*pi));
    plot(jnds,o1s*180/pi,'r',jnds,o2s*180/pi,'k')
    legend('N LM','S LM');
    title('orientation of LMs from nest')
    figure(4)
    plot(jnds,LM1(:,3),'r',jnds,LM2(:,3),'k')
    title('LM widths')
%     legend('nest to N LM','nest to S LM','N LM width',' S LM width');
    figure(5),
    plot(LM1(:,[1 2]),'r'),hold on;
    plot(LM2(:,[1 2]),'k')
    plot(ns(:,[1 2]),'b')
    title('x and y position for nest and LMs')
    legend('N LM','S LM','nest');
    hold off
    [x,y]=pol2cart(o1s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm1=meanAng*180/pi
    LemgthLM1=LengthMean
    stdAngsLM1=std(o1s)*180/pi
    [x,y]=pol2cart(o2s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm2=meanAng*180/pi
    LemgthLM2=LengthMean
    stdAngsLM2=std(o2s)*180/pi
else
    figure(1);
    MyCircle(LM1(:,[1 2]),LM1(:,3)/2,'r');hold on
    MyCircle(LM2(:,[1 2]),LM2(:,3)/2,'k');
    MyCircle(LM3(:,[1 2]),LM3(:,3)/2,'y');
    MyCircle(LM4(:,[1 2]),LM4(:,3)/2,'g');
    plot(ns(:,1),ns(:,2),'bx')
    [xcp,ycp]=pol2cart(cdirs,20);
    [xc2,yc2]=pol2cart(cdir2,20);
    plot([ns(:,1) xcp']',[ns(:,2) ycp']','g',[ns(:,1) xc2']',[ns(:,2) yc2']','m--')
    axis equal;set(gca,'YDir','reverse');
    hold off;
    title('nest and LM Positions')
    figure(2),
    d1s=CartDist(LM1(:,[1 2]),ns(:,[1 2]));
    d2s=CartDist(LM2(:,[1 2]),ns(:,[1 2]));
    d3s=CartDist(LM3(:,[1 2]),ns(:,[1 2]));
    d4s=CartDist(LM4(:,[1 2]),ns(:,[1 2]));
    plot(jnds,d1s,'r',jnds,d2s,'k',jnds,d3s,'y',jnds,d4s,'g')
    title('distance between nest and LMs')
    figure(3),
    o1s=cart2pol(LM1(:,1)-ns(:,1),LM1(:,2)-ns(:,2))';
    o2s=cart2pol(LM2(:,1)-ns(:,1),LM2(:,2)-ns(:,2))';
    o3s=cart2pol(LM3(:,1)-ns(:,1),LM3(:,2)-ns(:,2))';
    o4s=cart2pol(LM4(:,1)-ns(:,1),LM4(:,2)-ns(:,2))';
    o1s=AngleWithoutFlip(mod(o1s-cdirs,2*pi));
    o2s=AngleWithoutFlip(mod(o2s-cdirs,2*pi));
    o3s=AngleWithoutFlip(mod(o3s-cdirs,2*pi));
    o4s=AngleWithoutFlip(mod(o4s-cdirs,2*pi));
    plot(jnds,o1s*180/pi,'r',jnds,o2s*180/pi,'k',jnds,o3s*180/pi,'y',jnds,o4s*180/pi,'g')
    title('orientation of LMs from nest')
    legend('NW','NE','SE','SW')
    figure(4)
    plot(jnds,LM1(:,3),'r',jnds,LM2(:,3),'k',jnds,LM3(:,3),'y',jnds,LM4(:,3),'g')
    title('LM widths')
%     legend('nest to NW','nest to NE','nest to SE','nest to SW', ...
%         'NW width','NE width','SE width','SW width');
    figure(5),
    plot(LM1(:,[1 2]),'r'),hold on;
    plot(LM2(:,[1 2]),'k')
    plot(LM3(:,[1 2]),'y'),
    plot(LM4(:,[1 2]),'g')
    plot(ns(:,[1 2]),'b')
    title('x and y position for nest and LMs')
    legend('NW LM','NE LM','SE LM','SW LM','nest');
    hold off
    [x,y]=pol2cart(o1s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm1=meanAng*180/pi
    LemgthLM1=LengthMean
    stdAngsLM1=std(o1s)*180/pi
    [x,y]=pol2cart(o2s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm2=meanAng*180/pi
    LemgthLM2=LengthMean
    stdAngsLM2=std(o2s)*180/pi
    [x,y]=pol2cart(o3s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm3=meanAng*180/pi
    LemgthLM3=LengthMean
    stdAngsLM3=std(o3s)*180/pi
    [x,y]=pol2cart(o4s,1);mx=mean(x);my=mean(y);
    [meanAng,LengthMean]=cart2pol(mx,my);
    meanAngLm4=meanAng*180/pi
    LemgthLM4=LengthMean
    stdAngsLM4=std(o4s)*180/pi
end