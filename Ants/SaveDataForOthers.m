function SaveDataForOthers
str='out';
s=dir(['*' str '*All.mat'])
% flts=10:12;  % N8
flts=[1 4 7];  % N8
for i=flts % 1:length(s) % 
    
    %     cmpdir=4.93;%0.6;%
    %     cmpdir=fltsec(i).cmpdir;
    fn=s(i).name;
    load(fn);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end

    NorthDir=4.9393;
    heads=Cents;
    [EPt(:,1) EPt(:,2)]=pol2cart(ang_e,1);
    body=Cents-EPt;
    bearing=OToNest;
    body_orient=sOr';
    t=t';
    lmo=LMOrder(LM);
    LM=LM(lmo,:);
    LMWid=LMWid(lmo);
%     is=180:2:200;
    is=1:length(sOr)
    subplot(1,2,1)
    PlotNestAndLMs(LM,LMWid,[0 0])
    hold on
    plotb(is,body,heads,[],'k')
%     axis([-3.2259   20.4171  -10.2963   13.3467])
    DrawCompass;
    title(fn)
    hold off
    subplot(1,2,2)
    plot(t(is),body_orient(is)*180/pi,t(is),NestOnRetina(is)*180/pi,'k-x',t(is),bearing(is)*180/pi,'r-x')
    legend('body axis/orientation','retinal nest position','bearing to nest','Location','Best')
    save([fn(1:end-7) ' Jochen.mat'],'heads','body','t','NestOnRetina',...
        'body_orient','bearing','NorthDir','LM','LMWid','nest')
    nest
    
end
s(flts).name