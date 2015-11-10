function ProcessFlights2012
% get all the data
s=dir('*All.mat');

% set the experiment type: 2 is 3 LMs
exptype=2;

% process the filenames so we know what type of flight is in each
% strictly speaking, this should be done on avi files but it works ok here
% for getting the flight type and other relevant variables
for i=1:length(s)
    d(i)=ProcessBeeFileName2012(s(i).name,exptype);
end

% set the distance from the nest to include data
dLim = [0 3; 3 6; 6 10; 7 100];
% this gets only the learning flights (ftype=2)

for i=1:4
    [pcs,npts]=ProcessLearningFlights(d([d.ftype]==2),dLim(i,:));
    mpc(i,:)=mean(pcs);
    medpc(i,:)=median(pcs);
end
% keyboard

function[pcs,npts]=ProcessLearningFlights(flist,dLim)

% for each flight ...
s=[]; allpsi=[];
allnor=[]; allcs=[]; allep=[];

porall(4).lmor=[];
lmorall(3).lmor=[];
npts=[];
pcs=[];
cols=['r';'y';'k';'g'];

for i=1:length(flist)
    
    fn=flist(i).name;
    
    % print number of file it is doing
    disp([i length(flist)])
     
    % load the data
    load(fn);    
    % re-scale the data
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,Areas]= ...
        ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,compassDir,Areas);

    % once we have all the data processed for a folder, we could do this all in one go
    % and save all the data as a new data file type
    %     save([fn(1:end-7) 'ReSc.mat'])

    % these next variables are very common
    % get flight direction relative to the direction to the nest
    f2n=AngularDifference(Cent_Os,OToNest);
    %         % get flight direction relative to the body orientation
    ppsi=AngularDifference(Cent_Os,sOr);


    % get the 'control' points
    Pts=GetControlPts(LM);
    
    is=[];

    if(length(dLim)==1)
        % find all data before the bee is first over dlim cm from the nest
        iout=find(DToNest>dLim,1);
        % get indices of interest
        if(~isempty(iout))
            is=1:iout-1;
        end
    else
        % find all the data between when the bee first goes outside dlim(1) 
        % before it then gets over dlim(2)
        i1=find(DToNest>dLim(1),1);
        if(~isempty(i1))
            i2=find(DToNest>dLim(2),1);
            if(isempty(i2))
                is=i1:length(t);
            else
                is=i1:i2-1;
            end
        end        
    end
    nLM=length(LMs);

    if(~isempty(is))

        % get the Landmark data in a more manageable form
        for j=1:nLM
            lmorall(j).lmor=[lmorall(j).lmor;LMs(j).LMOnRetina(is)];
            lmonret(j).LMOnRetina=LMs(j).LMOnRetina(is);
        end
        
        cs=Cents(is,:);
        % get all the looking points
        [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPts2012...
            (NestOnRetina(is),lmonret,t(is),cs,10,[],3,3);
                
        % get the retinal positions of the 'control' points
        PtsOnRetina=PositionOnRetina(Pts,Cents(is,:),sOr(is),compassDir);
        [meanC,meanT,meanTind,len,in,ptils,sn,en]=LookingPts2012...
            (NestOnRetina(is),PtsOnRetina,t(is),cs,10,[],3,3);

%         figure(1)
%         subplot(2,2,1)
%         AngHist(sOr(in)*180/pi)
%         for j=1:nLM
%             subplot(2,2,1+j)
%             AngHist(sOr(ils(j).is)*180/pi)           
%         end

        % plot stuff
        es=EndPt(is,:);
        if 0
            figure(1)
            PlotNestAndLMs(LM,LMWid,nest)
            axis equal
            hold on
            g=0.1;
            for j=1:length(sn)
                ip=GetTimes(t,[t(sn(j))-g t(en(j))+g]);
                plot(cs(ip,1),cs(ip,2),'k')
            end
            plotb(ils(1).is,Cents,EndPt,[],'r',-1)
            plotb(in,Cents,EndPt,[],'k',-1)
%             plotb(is,Cents,EPt,[],'b',-1)
%             for i=1:length(ptils)
%                 plot(Pts(i,1),Pts(i,2),[cols(i) 'o'],'MarkerSize',14,'MarkerFaceColor',cols(i))
%                 plot(es(ptils(i).is,1),es(ptils(i).is,2),[cols(i) '.'])%,'MarkerSize',8)
%             end
%             for i=1:length(ils)
%                 plot(es(ils(i).is,1),es(ils(i).is,2),[cols(i) 'o'])%,'MarkerSize',8)
%             end
            CompassAndLine('k',cmPerPix,[],compassDir)
            hold off
%             figure(2)
%             [y,x]=AngHist(sOr(is(ils(1).is))*180/pi);
%             [y1,x]=AngHist(sOr(is(abs(lmonret(1).LMOnRetina*180/pi)<10))*180/pi);
%             plot(x,y/sum(y),x,y1/sum(y1),'r:')
        end
        ilall=[ils ptils];
        for j=1:length(ilall)
            np(j)=length(ilall(j).is);
        end
        npts=[npts;np length(is)];
        pcs=[pcs;100*np/length(is)];
        
        % collect general data
        s=[s;sOr(is)'];
        v_s=MyGradient(sOr(is),t(is))'*180/pi;
%         dsdt=[dsdt;v_s];
        subplot(2,1,1)
        plot(t(is),sOr(is)*180/pi);
        subplot(2,1,2)
        plot(t(is),v_s);
            
        allpsi=[allpsi;ppsi(is)];
        allnor=[allnor;NestOnRetina(is)];
%         allcs=[allcs;cs(ils(1).is,:)];
        allcs=[allcs;cs(in,:)];
        allep=[allep;es];
%         for j=1:4
%             porall(j).lmor=[porall(j).lmor; PtsOnRetina(j).LMOnRetina];
%         end
%         
%         % these next bits are alsp
%         [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
%         [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
%         [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
%         b=intersect(psi0,f2n0);
%         
%         % get incidents from frames
%         [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
%         [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
%         [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
%         [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);
    else
%         [meanC,meanT,meanTind,len,in1,ils,sn,en]=LookingPts2012...
%             (NestOnRetina,lmonret,DToNest,t,Cents,10);
%         [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);
%         if(~isequal(in,in1))
%             keyboard;
%         end
    end
end
% figure
subplot(2,1,1),
AngHist(s*180/pi)
subplot(2,1,2),
for i=1:nLM
    [y,x]=AngHist(s(abs(lmorall(i).lmor*180/pi)<10)*180/pi);
    ypl(i,:)=y./sum(y);
end
plot(x,ypl);
keyboard

function[pts]=GetControlPts(LM)

% get angular positions and sistances relative to the nest
[angs,ds]=cart2pol(LM(:,1),LM(:,2));

% get positions midway between each LM and one above/below top and bottom
% each at a distance the average distance of the LMs 
md=mean(ds);

if(size(LM,1)>1)
    ang_diffs=AngularDifference(angs)*0.5;
    [px,py]=pol2cart(angs(1:end-1)+ang_diffs,md);
    [b4x,b4y]=pol2cart(angs(1)-ang_diffs(1),md);
    [aftx,afty]=pol2cart(angs(end)+ang_diffs(end),md);
    pts=[b4x,b4y; px,py; aftx,afty];
else
    ang_diffs=pi/6;
    [b4x,b4y]=pol2cart(angs(1)-ang_diffs(1),md);
    [aftx,afty]=pol2cart(angs(end)+ang_diffs(end),md);
    pts=[b4x,b4y; aftx,afty];
end