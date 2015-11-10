% this example program shows you how to get all the data from learning
% flights only, and then process data that is between 3 and 10 cm from the
% nest and to plot the points at which the bee is facing the nest

function ProcessFlights2012ExampleProgram
% d=GetFileList;

% set the distance from the nest to include data
dLim = [0 100];%7];

% ComparePauses

% this gets only the learning flights (ftype=2)
% ProcessLearningFlights(d([d.ftype]==2),dLim);

% this gets only the tests (ftype=4, 5 or 6)
vLim=1.5; % this is the velocity below which is deemed a pause
tLim=0.21;  % this is the minimum time between pauses


arcLim=[pi/6 0.2];  % arcLim=[pi/20 0.03]; % these are old 'standard' values 

% PlotFlights(d,dLim,[],arcLim,1);


% cd('D:\Bees12\1 BigLMfiles')


% dwork; 
% cd bees12\Small1LmFiles\

% the directories you will look at, in order of plotting
dirs={'../Small1LmFiles';'../Big1LMFiles';'../Bees 2012 3lm alls'};

% the colours you will plot them
cols=['k- ';'r: ';'b--'];

titlestrs={'Small near LM';'Big far LM';'3 LMs'};
% this is needed for plotting multiple dirs
ih=[1 2 0];
% use these for the comparing Flightlengths
dLims=[0 3;0 6;0 9;0 12;0 15]; % m=1; n=2;
% use this for looking at flight near the nest in eg ProcessLearningFlights
dLims=[0 3];
% for looking at all flights
arcLim=[pi/6 0.2];
% arcLim=[pi/6 0.2]/2;
% arcLim=[pi/20 0.03];
% arcLim=[-1 -1];  % gets all the data
% FlightLengths(dirs,cols,titlestrs,dLims,ih,0,arcLim)

disp(' ')
dLims=[0 ForceNumericInput('enter distance from nest to examine: ')];

disp(' ')
disp('enter the degrees and time to get more/less turning points')
disp('eg [30 0.2] gets only major ones')
disp('eg [10 0.03] gets more')
arcLim=ForceNumericInput('enter [-1 -1] for all flight: ');

arcLim(1)=arcLim(1)*pi/180;
% titlestrs=cell(cd);
% this to look at stuff flight by flight
FlightLengths({'./'},cols,{''},dLims,0,1,arcLim)


% ProcessTestFlights(d(ismember([d.ftype],4:6)),vLim,tLim);

% good flight to test is: T42_L01S_1459_1707All.mat
% fn='T42_L01S_1459_1707All.mat';
% nfl=strmatch(fn,{d.name});
% % PlotFlights(d,dLim,[],arcLim,1);
% PlotFlights(d(nfl),dLim,[],arcLim,1);

% ComparePauses

% PlotFlights(d([d.ftype]==2),dLim,tLim,arcLim,0)


function FlightLengths(dirs,cols,tstrs,dLims,ih,tpl,arcLim)
origdir=cd;
% dLims=[0 3;0 6;0 9;0 12;0 15]; %m=3; n=2;
if(nargin<4)
    dLims=[0 3;0 6;0 9;0 12;0 15]; % m=1; n=2;
    ih=[1 2 0];
end 
% how many columns of figs to plot
n=2; 
% how many columns of figs to plot
m=ceil(size(dLims,1)/n);

for i=1:length(dirs)
    cd(char(dirs(i)))
    d=GetFileList;
    
    % get only learning flights
    d=d([d.ftype]==2);
    
    % get ones which have no letter or are 'as'
    d(rem([d.time],1)>0.01).name
    d=d(rem([d.time],1)<=0.01);

    % the stuff for #of flights is hacked for 3 Lm files
    % this shows the number of files which are 1st 2nd etc flights
    %     fnum=[d.fltnum];
%     y=Frequencies(fnum,1:10)

    % pick only the 1st 3 flights
    d=d([d.fltnum]<=3);
%     dat(i)=LengthOfFlightSegments(d,dLims,cols(i,:),ih(i),tstrs,m,n);
    [so(i,:),nl(i,:),x1,x2]=PlotFlights(d,dLims,[],arcLim,tpl);

%     figure(i),clf
%     ProcessLearningFlights(d,dLims,cols(i,:),ih(i),tpl);
end
figure(3)
for i=1:size(so,1)
    subplot(2,1,1)
    plot(x1,so(i,:)./sum(so(i,:)),cols(i,:));
    hold on
    subplot(2,1,2)
    plot(x2,nl(i,:)./sum(nl(i,:)),cols(i,:));
    hold on
end
subplot(2,1,1)
xlabel('N LM on retina during pauses.');
title(['learning flights within ' int2str(dLims)]);
% legend(tstrs);
ylabel('frequency')
axis tight
hold off
subplot(2,1,2)
xlabel('Body Orientation during pauses');ylabel('frequency')
legend(tstrs);
ylabel('frequency')
axis tight
hold off
% keyboard
cd(origdir);


function ComparePauses
% set the distance from the nest to include data
dLim = [0 100];%7];
arcLim=[pi/6 0.2];

% cd('D:\Bees12\1 BigLMfiles')
d=GetFileList;

[sob,nlb,x1,x2]=PlotFlights(d([d.ftype]>3),dLim,[],arcLim,0);
% d=d([d.ftype]==2);
% d=d([1:69]);
% [sob,nlb,x1,x2]=PlotFlights(d,dLim,[],arcLim,0);
% cd('D:\Bees12\AllFiles 1lm Feb 16')
% d=GetFileList;
% [sos,nls,x1,x2]=PlotFlights(d([d.ftype]>3),dLim,[],arcLim,0);
% cd(origdir)
% 
% figure(3)
% subplot(2,1,1)
% plot(x1,nlb/sum(nlb),'k',x1,nls/sum(nls),'r:')
% title('N LM on retina during pauses.');
% xlabel('Solid: single near Lm; dash: single far lm ');
% ylabel('frequency')
% axis tight
% 
% subplot(2,1,2)
% plot(x2,sob/sum(sob),'k',x2,sos/sum(sos),'r:')
% title('Body Orientation during pauses');ylabel('frequency')
% xlabel('Solid: single near Lm; dash: single far lm ');
% axis tight

function[outdat]=LengthOfFlightSegments(flist,dLims,cst,isho,tstrs,m,n)
lens=NaN*ones(length(flist),size(dLims,1)+1);
props=NaN*ones(length(flist),size(dLims,1));

% this is the maximum distance ring for comparison across conditions
maxd=[0 40];
for i=1:length(flist)

    % print number of file it is doing
    disp([i length(flist)])
    
    % get the filename
    fn=flist(i).name;

    % load the data
    clear DToNest cmPerPix
    load(fn);
    if(exist('DToNest','var'))
        %         if(~exist('cmPerPix','var'))
        %             load([fn(1:end-7) 'NestLMData.mat']);
        %             save(fn,'cmPerPix','compassDir','-append')
        %         end
        % re-scale the data
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,Areas]= ...
            ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,compassDir,Areas);
        
        % these next variables are very common
        
        % get flight direction relative to the direction to the nest
        f2n=AngularDifference(Cent_Os,OToNest);
        
        % get flight direction relative to the body orientation
        ppsi=AngularDifference(Cent_Os,sOr);

        % get the distance covered on each step
        distcov=[0;CartDist(diff(Cents))];

        % subdivide the data. This does it based on distance.
        for j=1:size(dLims,1)
            [lens(i,j),is]=GetTimeDist(DToNest,dLims(j,:),t);
            distco(i,j)=sum(distcov(is));
            mspeed(i,j)=mean(Speeds(is));
        end
%         lens(i,end)=t(end)-t(1);
        lens(i,end)=GetTimeDist(DToNest,maxd,t);
        props(i,:)=100*lens(i,1:end-1)./lens(i,end);
    end
end
props=props(~isnan(lens(:,1)),:);
lens=lens(~isnan(lens(:,1)),:);
figure(1)
for i=1:size(dLims,1)
    subplot(m,n,i)
    [y,x]=hist(lens(:,i),0:0.5:15);
    plot(x,y./sum(y),cst)
    if(isho); hold on;
    else hold off;
    axis tight; XYLegend('time (s)','frequency',tstrs);
    title(['times in [' int2str(dLims(i,:)) ']'])
    end
end

subplot(m,n,i+1)
% errorbar([3:3:15 20],mean(lens),std(lens),cst)
% errorbar([dLims(:,2)' max(dLims(:))*2]-0.25+isho*0.25,median(lens),iqr(lens),cst)
errorbar([dLims(:,2)' maxd(2)]-0.25+isho*0.25,median(lens),iqr(lens),cst)
if(isho); hold on;
else hold off;
    axis tight; XYLegend('distances','time (s)',tstrs);
    title(['length of flight against distance median/iqr'])
    x=get(gca,'XTickLabel'); x(end)={[int2str(maxd(2)) '=all']};
    set(gca,'XTickLabel',x);
end

tpl={'props';'distco';'mspeed'};
xstrs={'% of flight';'distance covered';'mean speed'};
rs=[1,4,0.5];
for k=1:length(tpl)
    eval(['tp=' char(tpl(k)) ';']);
    figure(1+k)
    for i=1:size(dLims,1)
        subplot(m,n,i)
        [y,x]=hist(tp(:,i),[0:5:100]*rs(k));
        plot(x,y./sum(y),cst)
        if(isho); hold on;
        else hold off;
            axis tight;
            XYLegend(char(xstrs(k)),'frequency',tstrs);
            title([char(xstrs(k)) ' in [' int2str(dLims(i,:)) ']'])
        end
    end
    subplot(m,n,i+1)
    % errorbar(3:3:15,mean(props),std(props),cst)
    errorbar(dLims(:,2)-0.25+isho*0.25,median(tp),iqr(tp),cst)
    if(isho); hold on;
    else hold off;
        title([char(xstrs(k)) ' against distance median/iqr'])
        axis tight; XYLegend('distances',char(xstrs(k)),tstrs);
    end
end

outdat.ml=median(lens);
outdat.sl=iqr(lens);
outdat.l=lens;
outdat.mp=median(props);
outdat.sp=iqr(props);
outdat.p=props;
outdat.d=distco;
outdat.sp=mspeed;


function XYLegend(xs,ys,tstrs)
xlabel(xs);
ylabel(ys);
if(~isempty(tstrs))
    legend(tstrs,'Location','Best')
end

function[l,is]=GetTimeDist(DToNest,dLim,t)
i1=find(DToNest>dLim(1),1);
if(~isempty(i1))
    i2=find(DToNest>dLim(2),1);
    if(isempty(i2))
        is=i1:length(t);
    else
        is=i1:i2;
    end
    l=t(is(end))-t(is(1));
else
    is=[];
    l=NaN;
end


function[ny,sy,x1,x2]=PlotFlights(flist,dLim,tLim,arcLim,pl)

zls=[];

pOr=[];pCs=[];pEp=[];pNor=[];pLmor(3).lmor=[];
NLMAtPauses=[];
AllLMAtPauses=[];
sOrAtPauses=[];
NorAtPauses=[];
DAtPauses=[];
DLMAtPauses=[];
CsAtPauses=[];
PauseLengths=[];
porall(4).lmor=[];
lmorall(3).lmor=[];
npts=[];
pcs=[];
cols=['r';'y';'k';'g'];

% for each flight ...
for i=1:length(flist)

    % print number of file it is doing
    disp([i length(flist)])
    
    % get the filename
    fn=flist(i).name;

    % load the data
    clear DToNest cmPerPix
    load(fn);
    if(exist('DToNest','var'))
%         if(~exist('cmPerPix','var'))
%             load([fn(1:end-7) 'NestLMData.mat']);
%             save(fn,'cmPerPix','compassDir','-append')
%         end
    % re-scale the data
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,Areas]= ...
        ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,compassDir,Areas);

    % these next variables are very common

    % get flight direction relative to the direction to the nest
    f2n=AngularDifference(Cent_Os,OToNest);

    % get flight direction relative to the body orientation
    ppsi=AngularDifference(Cent_Os,sOr);

    % get the 'control' points. These points are on a circle defined by the
    % LMs and mid-way in between them. Is designed for 3 LMs
    Pts=GetControlPts(LM);
   
    % subdivide the data. This does it based on distance.
    i1=find(DToNest>dLim(1),1);
    if(~isempty(i1))
        i2=find(DToNest>dLim(2),1);
        if(isempty(i2))
            is=i1:length(t);
        else
            is=i1:i2-1;
        end
    else
        is=[];
    end
%     is=1:length(t);
    cs=Cents(is,:);
    es=EndPt(is,:);

    % get number of 'Landmarks'
    nLM=length(LMs);
    if(~isempty(is))


        %             subplot(2,2,1)
        %             plot(sOr(is([dat.sp]))*180/pi,'.')
        %             title('body orient facing nest')
        %             for j=1:nLM
        %                 subplot(2,2,1+j)
        %                 plot(LMs(j).LMOnRetina(is([dat.sp]))*180/pi,'.')
        %                 title(['body orient facing LM' int2str(j)])
        %             end

        % find the north-most landmark
        lmangs=cart2pol(LM(:,1),LM(:,2));
        [mang,N_ind]=min(abs(AngularDifference(lmangs,compassDir)));

        % get all the points where the bee is looking at the nest or points
        % that define the landmarks. This is designed for cylinders so in
        % the case of the board experiments where the landmarks are the
        % bottom corners of the board, this will return looking at them
        %             for j=1:nLM
        %                 lmonret(j).LMOnRetina=LMs(j).LMOnRetina(is);
        %             end
        %             [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPts2012...
        %                 (NestOnRetina(is),lmonret,t(is),cs,5,[],3,3);
        %             PauseLengths=[];
        %
        % disp('use ThroughZero or whatever and check it!!!')
        
        % get the pauses of the arcs
        aso=AngleWithoutFlip(sOr(is));
        if(arcLim(1)<0)
            i_tps=is;
        else
        try
        [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetArcs(aso,t(is),arcLim(1),arcLim(2),0);
        tps=sort([ma mi]);
        i_tps=is(tps);
        catch me
            i_tps=[];
            disp(['prob with GetArcs and file ' fn])
            disp('*****')            
        end
        end
        %             pm=sin(dang(tps))>0;
        %             c=1;
        %             while(c<length(tps))
        %                 s=mod(pm(c)+1,2);
        %                 if(pm(c+1)==s) c=c+1;
        %                 else
        %                     tps=tps([1:c c+2:end]);
        %                     pm=sin(dang(tps))>0;
        %                 end
        %             end
        % figure(2),plot(cs(:,1),cs(:,2),cs(mi,1),cs(mi,2),'gs',cs(ma,1),cs(ma,2),'ro'...
        %     ,cs(tps,1),cs(tps,2),'k*')
        tpts=t(i_tps);
        zls=[zls diff(tpts)];

        % get some data on the Pauses

        NLMAtPauses=[NLMAtPauses LMs(N_ind).LMOnRetina(i_tps)'];
        sOrAtPauses=[sOrAtPauses sOr(i_tps)];
        catp=cs(i_tps,:);
        dlmx=LMs(N_ind).LM(1)-catp(:,1);
        dlmy=LMs(N_ind).LM(2)-catp(:,2);
        CsAtPauses=[CsAtPauses;catp];
        DAtPauses=[DAtPauses CartDist(catp)'];
        DLMAtPauses=[DLMAtPauses CartDist([dlmx dlmy])'];

        tlm=zeros(nLM,length(i_tps));
        if(~isempty(i_tps))
            for k=1:nLM
                tlm(k,:)=LMs(k).LMOnRetina(i_tps)';
            end
            AllLMAtPauses=[AllLMAtPauses tlm];
            NorAtPauses=[NorAtPauses NestOnRetina(i_tps)'];
        end
        if pl
            figure(2)
            subplot(3,1,1)
            plot(t(is),aso*180/pi,tpts,aso(i_tps)*180/pi,'ro')
            xlabel('time (s)');ylabel('body orientation (rel to North)')
            axis tight
            grid
            title(fn)
            subplot(3,1,2)
%             plot(t(is),DToNest(is),tpts,DToNest(i_tps),'ro')
            ltemp= LMs(N_ind).LMOnRetina*180/pi;
            plot(t(is),ltemp(is),tpts,ltemp(i_tps),'ro')
            %             plot(t(is),AngleWithoutFlip(Cent_Os(is))*180/pi)
%             xlabel('time (s)');ylabel('distance to nest (cm)')
            xlabel('time (s)');ylabel('North LM on retina')
            grid
            axis tight

            subplot(3,1,3)

            % plot the north-most landmark
%             plot(t(is),LMs(N_ind).LMOnRetina(is)*180/pi,...
%                 tpts,LMs(N_ind).LMOnRetina(i_tps)*180/pi,'ro')
%             xlabel('time (s)');ylabel('N LM on retina')

            plot(t(is),NestOnRetina(is)*180/pi,...
                tpts,NestOnRetina(i_tps)*180/pi,'ro')
            xlabel('time (s)');ylabel('Feeder centre on retina')
            ylabel('Nest on retina')
            grid
            axis tight

            % plot the flights
            figure(1)
            % plot the nest and the Landmarks
            PlotNestAndLMs(LM,LMWid,nest)
            axis equal
            hold on

            % plot the bee's path in blue
%             plot(cs(:,1),cs(:,2),'b')
            col='b';
            plot(es(:,1),es(:,2),[col '.'],...
                [cs(:,1) es(:,1)]',[cs(:,2) es(:,2)]',col)

            % plot a compass and a line: 2nd argument is empty if you don't
            % want to scale things
            CompassAndLine('k',[],[],compassDir);
            MyCircle(LMs(N_ind).LM(1),LMs(N_ind).LM(2),1.3*LMWid(N_ind)/2,'r');
            MyCircle(0,0,0.5*NestWid*cmPerPix,'m');
            hold off
            title(fn)

            % pause to view output
            disp('press any key to continue')
            dbpause

        end
    end
    end
end

figure(3)
subplot(3,2,1)
[ny,x1]=AngHist(NLMAtPauses*180/pi);
xlabel('N LM on retina during pauses');ylabel('frequency')
axis tight

subplot(3,2,2)
plot(NorAtPauses*180/pi,NLMAtPauses*180/pi,'o')
xlabel('nest on retina');ylabel('N LM on retina')
axis tight

subplot(3,2,3)
[sy,x2]=AngHist(sOrAtPauses*180/pi);
xlabel('Body Orientation during pauses');ylabel('frequency')
axis tight

subplot(3,2,4)
plot(sOrAtPauses*180/pi,NLMAtPauses*180/pi,'o')
xlabel('body orientation');ylabel('N LM on retina')
axis tight

subplot(3,2,5)
[sy,x2]=AngHist(NorAtPauses*180/pi);
xlabel('Nest on retina during pauses');ylabel('frequency')
axis tight

subplot(3,2,6)
plot(sOrAtPauses*180/pi,NorAtPauses*180/pi,'o')
xlabel('body orientation');ylabel('Nest on retina')
axis tight
% keyboard
figure(4)
subplot(2,2,1)
plot(DAtPauses,sOrAtPauses*180/pi,'o')
xlabel('disance to nest');ylabel('body orientation')
subplot(2,2,2)
plot(DAtPauses,NLMAtPauses*180/pi,'o')
xlabel('disance to nest');ylabel('N LM on retina')
subplot(2,2,3)
plot(DLMAtPauses,NLMAtPauses*180/pi,'o')
xlabel('disance to LM');ylabel('N LM on retina')
subplot(2,2,4)
plot(DLMAtPauses,NorAtPauses*180/pi,'o')
xlabel('disance to LM');ylabel('Nest retina')



% this takes a list of learning flights and distance limits
function ProcessTestFlights(flist,vLim,tLim)

if 1
    % make some empty arrays to collect summary data in
s=[]; allpsi=[];
allnor=[]; allcs=[]; allep=[]; allfdir=[];
allbouts=[]; allsum_fr=[]; allspee=[];

pOr=[];pCs=[];pEp=[];pNor=[];pLmor(3).lmor=[];

porall(4).lmor=[];
lmorall(3).lmor=[];
npts=[];
pcs=[];
cols=['r';'y';'k';'g'];

% for each flight ...
for i=1:length(flist)

    % print number of file it is doing
    disp([i length(flist)])
    
    % get the filename
    fn=flist(i).name;

    % load the data
    clear DToNest
    load(fn);
    
    % re-scale the data
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,Areas]= ...
        ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,compassDir,Areas);

    % these next variables are very common

    % get flight direction relative to the direction to the nest
    f2n=AngularDifference(Cent_Os,OToNest);

    % get flight direction relative to the body orientation
    ppsi=AngularDifference(Cent_Os,sOr);

    % get the 'control' points. These points are on a circle defined by the
    % LMs and mid-way in between them. Is designed for 3 LMs
    Pts=GetControlPts(LM);
   
    % subdivide the data. This does it based on distance.
    % currently ot used but will see
%     i1=find(DToNest>dLim(1),1);
%     if(~isempty(i1))
%         i2=find(DToNest>dLim(2),1);
%         if(isempty(i2))
%             is=i1:length(t);
%         else
%             is=i1:i2-1;
%         end
%     end
    is=1:length(t);

    % get number of 'Landmarks'
    nLM=length(LMs);
    if(~isempty(is))
          
        % get centroids head and Landmatk data for the points we are
        % interested in in a more manageable form
        cs=Cents(is,:);
        es=EndPt(is,:);
        for j=1:nLM
            lmonret(j).LMOnRetina=LMs(j).LMOnRetina(is);
        end

        % get all the points where the bee is looking at the nest or points
        % that define the landmarks. This is designed for cylinders so in
        % the case of the board experiments where the landmarks are the
        % bottom corners of the board, this will return
        [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPts2012...
            (NestOnRetina(is),lmonret,t(is),cs,5,[],3,3);

        % get the retinal positions of the 'control' points
        PtsOnRetina=PositionOnRetina(Pts,Cents(is,:),sOr(is),compassDir);
        [meanC,meanT,meanTind,len,in,ptils,sn,en]=LookingPts2012...
            (NestOnRetina(is),PtsOnRetina,t(is),cs,5,[],3,3);
        
        % these next bits are used to get all the points where psi and
        % flight direction relative to the nest are within +/- 10 degrees
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);

        % this then finds points where *both* psi and flight dir relative
        % to the nest  are within +/- 10 degrees
        b=intersect(psi0,f2n0);
        
        %         % get incidents from frames
        % not using this at the moment
%         [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
%         [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
%         [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
%         [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        % collect summary data
        ilall=[ils ptils];
        threshlk=1;
        for j=1:length(ilall)
            np(j)=length(ilall(j).is);
            len=[ilall(j).len];           
            nbouts(j)=sum(len>threshlk);
            sum_fr(j)=sum(len(len>threshlk));
        end
        allbouts=[allbouts;nbouts];
        allsum_fr=[allsum_fr;100*sum_fr/length(is)];
        npts=[npts;np length(is)];
        pcs=[pcs;100*np/length(is)];
        
        s=[s;sOr(is)'];
        allpsi=[allpsi;ppsi(is)];
        allfdir=[allfdir;f2n(is)];
        allnor=[allnor;NestOnRetina(is)];
        for j=1:nLM
            lmorall(j).lmor=[lmorall(j).lmor;LMs(j).LMOnRetina(is)];
        end
        for j=1:4
            porall(j).lmor=[porall(j).lmor; PtsOnRetina(j).LMOnRetina];
        end
        %         allcs=[allcs;cs(ils(1).is,:)];
        allcs=[allcs;cs(is,:)];
        allep=[allep;es(is,:)];
        
%         % this gets all the nest looking points
%         allcs=[allcs;cs(in,:)];
%         allep=[allep;es(in,:)];

        % plot stuff
        % get the pauses
        [dat,smSp]=GetPauses(Speeds(is),t(is),vLim,tLim,0.05,0);
        % collect smoothed speeds
        allspee=[allspee;smSp'];
        maxsp(i)=prctile(smSp,95);
        if(~isempty(dat))
            pOr=[pOr;sOr(is([dat.sp]))' sOr(is([dat.mp]))' sOr(is([dat.ep]))'];
        pCs=[pCs;cs([dat.sp]',:) cs([dat.mp]',:) cs([dat.ep]',:)];
        pEp=[pEp;es([dat.sp]',:) es([dat.mp]',:) es([dat.ep]',:)];
        pNor=[pNor;NestOnRetina(is([dat.sp]')) NestOnRetina(is([dat.mp]')) ...
            NestOnRetina(is([dat.ep]'))];
        for j=1:nLM
            pLmor(j).lmor=[pLmor(j).lmor;LMs(j).LMOnRetina(is([dat.sp]')) ...
                LMs(j).LMOnRetina(is([dat.mp]')) LMs(j).LMOnRetina(is([dat.ep]'))];
        end  
        
        if 1
            figure(1)
            PlotNestAndLMs(LM,LMWid,nest)
            axis equal
            hold on

            % plot the bee's path in blue
            plot(cs(:,1),cs(:,2),'b')

            % these make extra long bees: this is used for debugging to check
            % that where the bee is 'looking is actually where we think they
            % are. To see the effect, comment/uncomment which says which bee
            % head ie ePlot, to plot
            eLs=(es-cs)*25+cs;
            %         ePlot=eLs;
            ePlot=es;

            % plot a ball and stick diagram for the points when paused 
            plotb([dat.sp],cs,ePlot,[],'r',-1)
            plotb([dat.mp],cs,ePlot,[],'g',-1)
            plotb([dat.ep],cs,ePlot,[],'k',-1)

            % plot a compass and a line
            CompassAndLine('k',cmPerPix,[],compassDir)
            hold off

            figure(2)
            subplot(2,2,1)
%             plot(sOr(is([dat.sp]))*180/pi,'.')
%             title('body orient facing nest')
%             for j=1:nLM
%                 subplot(2,2,1+j)
%                 plot(LMs(j).LMOnRetina(is([dat.sp]))*180/pi,'.')
%                 title(['body orient facing LM' int2str(j)])
%             end

            subplot(2,2,1)
            plot(t(is),sOr(is)*180/pi)
            subplot(2,2,2)
            plot(t(is),DToNest(is))


            % pause to view output
            disp('press any key to continue')
            pause
        end
        end
    end
end
save temp
end
load temp
keyboard
plotPauseDistances(pOr,pCs,s,allcs)
i2s=1:length(s);
is=1:length(pOr);

% need to do this as with the distance plots because the is bit is
% searching all columns of the pOr bit
i2s=find(abs(s*180/pi)<10);
is=find(abs(pOr(:,1)*180/pi)<10);

plotSummaryTestFlightData(is,i2s,LM,LMWid,nest,cmPerPix,compassDir,...
    pOr,pCs,pEp,pNor,pLmor,lmorall,allnor,s,cs,es)

function plotPauseDistances(pOr,pCs,s,allcs)
hs=0:50;
allds=CartDist(allcs);
i2s=abs(s*180/pi)<10;
[y,x]=hist(allds(i2s),hs);
[y2,x]=hist(allds(~i2s),hs);
 
% need to do each plot for whether is start middle pr end of flight
for i=1:2
    subplot(1,2,i)
    ds=CartDist(pCs(:,[(2*i)-1 2*i]));
    is=abs(pOr(:,i)*180/pi)<10;
    [z,x]=hist(ds(is),hs);
    [z2,x]=hist(ds(~is),hs);
    plot(x,y/sum(y),'r:',x,y2/sum(y2),'k:',...
        x,z/sum(z),'r',x,z2/sum(z2),'k')
    xlim([0 20])
end

function plotSummaryTestFlightData(is,i2s,LM,LMWid,nest,cmPerPix,compassDir,...
    pOr,pCs,pEp,pNor,pLmor,lmorall,allnor,s,cs,es)
figure(3)
clf
PlotNestAndLMs(LM,LMWid,nest)
axis equal
hold on
plotb(is,pCs(:,1:2),pEp(:,1:2),[],'k')
CompassAndLine('k',cmPerPix,[],compassDir)
hold off
figure(4)
subplot(3,2,1)
[y,x]=AngHist(s(i2s)*180/pi);
[y1,x]=AngHist(pOr(is,1)*180/pi);
[y2,x]=AngHist(pOr(is,2)*180/pi);
plot(x,y/sum(y),'k',x,y1/sum(y1),'b--',x,y2/sum(y2),'r:')
axis tight
% legend('all','start','mid'),
title('body')
subplot(3,2,2)
[y,x]=AngHist(allnor(i2s)*180/pi);
[y1,x]=AngHist(pNor(is,1)*180/pi);
[y2,x]=AngHist(pNor(is,2)*180/pi);
plot(x,y/sum(y),'k',x,y1/sum(y1),'b--',x,y2/sum(y2),'r:')
axis tight
title('nest on ret')
osFromNest=(mod(cart2pol(LM(:,1),LM(:,2))-compassDir,2*pi))*180/pi;
osFromNest(osFromNest>180)=osFromNest(osFromNest>180)-360;
nLM=length(pLmor);
for j=1:nLM
    subplot(3,2,2+j)
    [y,x]=AngHist(lmorall(j).lmor(i2s)*180/pi);
    [y1,x]=AngHist(pLmor(j).lmor(is,1)*180/pi);
    [y2,x]=AngHist(pLmor(j).lmor(is,2)*180/pi);
    plot(x,y/sum(y),'k',x,y1/sum(y1),'b--',x,y2/sum(y2),'r:',...
        [osFromNest(j) osFromNest(j)],[0 max(y1)/sum(y1)],'k')
    axis tight
    title(['LM' int2str(j) ' on ret'])
end


function[dat,smSp]=GetPauses(Speeds,t,vLim,tLim,sm_len,pl)
% Smooth the Speeds
% mean smoothing
smSp=TimeSmooth(Speeds,t,sm_len);
% median smoothing
% smSp=medfilt1(Speeds);

dat=[];
ist=1;
c=1;
if(pl); plotPauses(t,smSp,Speeds,dat); end
while 1
    % get the indices from the end of the last pause
    is=ist:length(smSp);
    % find the next point where speed goes below vLim
    i1=find(smSp(is)<vLim,1)+ist-1;
    if(isempty(i1))
        % if none, break out of the while loop
        break;
    else
        % set start of the pause;
        dat(c).sp=i1;
        dat(c).tsp=t(i1);
        
        % set the end by finding the next time it rises above vLim
        i2=find(smSp(i1:end)>vLim,1)+i1-1;
        if(isempty(i2))
            % if there isn't a next point it's the end of the flight
            dat(c).ep=length(smSp);
            dat(c).tep=t(end);
            break
        else
            % if there is, set it as end of the pause
            dat(c).ep=i2-1;
            dat(c).tep=t(i2-1);  
            ist=i2;
        end
        % increment pause count
        c=c+1;
    end
    if(pl); plotPauses(t,smSp,Speeds,dat); end
end

% now merge pauses that are too close
% might have to do something more subtle to do with 
% a) speed bee reaches between pauses
% b) distance travelled between end and next start
% c) orientation etc changes between end and next start
while(length(dat)>1)
    ts=[dat.tsp];
    te=[dat.tep];
    td=ts(2:end)-te(1:end-1);
    i=find(td<tLim,1);
    if(isempty(i))
        break;
    else
        dat(i).ep=dat(i+1).ep;
        dat(i).tep=dat(i+1).tep;
        dat=dat([1:i i+2:end]);
    end
    if(pl); plotPauses(t,smSp,Speeds,dat); end
end

for i=1:length(dat)
    dat(i).len=dat(i).tep-dat(i).tsp;
    dat(i).mp=round(0.5*(dat(i).sp+dat(i).ep));
end

function plotPauses(t,smSp,Speeds,dat)
plot(t,smSp,'k',t,Speeds,'g:')
hold on
for i=1:length(dat)
    is=dat(i).sp:dat(i).ep;
    plot(t(is),smSp(is),'r.-')
end
hold off

% this takes a list of learning flights and distance limits
function ProcessLearningFlights(flist,dLim,cst,isho,topl)

% make some empty arrays to collect summary data in
s=[]; allpsi=[];
allnor=[]; allcs=[]; allep=[]; allfdir=[];
allbouts=[]; allsum_fr=[];

npts=[];
pcs=[];
cols=['r';'y';'k';'g'];

% for each flight ...
for i=1:length(flist)

    % print number of file it is doing
    a=[i length(flist)]
    
    % get the filename
    fn=flist(i).name;

    % load the data
    clear NestOnRetina
    load(fn);
    
    % re-scale the data
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,Speeds,Vels,Cent_Os,OToNest,Areas]= ...
        ReScaleData2012(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,t,OToNest,cmPerPix,compassDir,Areas);

    % once we have all the data processed for a folder, we could do this all in one go
    % and save all the data as a new data file type
    %     save([fn(1:end-7) 'ReSc.mat'])
    % but I haven't done this as yet

    % these next variables are very common

    % get flight direction relative to the direction to the nest
    f2n=AngularDifference(Cent_Os,OToNest);

    % get flight direction relative to the body orientation
    ppsi=AngularDifference(Cent_Os,sOr);

    % get the 'control' points. These points are on a circle defined by the
    % LMs and mid-way in between them. Is designed for 3 LMs
    Pts=GetControlPts(LM);
   
    % find all the data between when the bee first goes outside dlim(1)
    % before it then gets over dlim(2)
    % alternatively here one could get other data
    [~,is]=GetTimeDist(DToNest,dLim,t);

    % get number of 'Landmarks'
    nLM=length(LMs);
    if(i==1)
        porall(nLM+1).lmor=[];
        porall(nLM+1).lklens=[];
        lmorall(nLM).lmor=[];       
        lmorall(nLM).lklens=[];       
    end
    if(~isempty(is))

        % get centroids head and Landmatk data for the points we are
        % interested in in a more manageable form
        cs=Cents(is,:);
        es=EndPt(is,:);
        for j=1:nLM
            lmonret(j).LMOnRetina=LMs(j).LMOnRetina(is);
        end
        nor=NestOnRetina(is);
        
        % get all the points where the bee is looking at the nest or points
        % that define the landmarks. This is designed for cylinders so in
        % the case of the board experiments where the landmarks are the
        % bottom corners of the board, this will return
%         [meanC,meanT,meanTind,inlen,in,ils,sn,en]=LookingPts2012...
%             (nor,lmonret,t(is),cs,5,[],3,3);
% 
%         % get the retinal positions of the 'control' points
        PtsOnRetina=PositionOnRetina(Pts,Cents(is,:),sOr(is),compassDir);
%         [~,~,~,~,~,ptils,~,~]=LookingPts2012...
%             (nor,PtsOnRetina,t(is),cs,5,[],3,3);

        % **************************************
        % for some reason LookingPts2012 is buggy - need to fix by
        % comparing to Thru0Pts which is more recent and works
        GapBetLks=0.05;
        [in,in_Ind,snp,enp,meanT,ins,inlen,tlen]= ...
            Thru0Pts(nor,t(is),pi/18,[],GapBetLks);
        for j=1:nLM
            [ils(j).is,~,~,~,~,~,ils(j).len,ils(j).tlen]=...
                Thru0Pts(lmonret(j).LMOnRetina,t(is),pi/18,[],GapBetLks);
        end
        for j=1:length(PtsOnRetina)
            [ptils(j).is,~,~,~,~,~,ptils(j).len,ptils(j).tlen]=...
                Thru0Pts(PtsOnRetina(j).LMOnRetina,t(is),pi/18,[],GapBetLks);
        end
        % these next bits are used to get all the points where psi and
        % flight direction relative to the nest are within +/- 10 degrees
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],GapBetLks);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],GapBetLks);

        % this then finds points where *both* psi and flight dir relative
        % to the nest  are within +/- 10 degrees
        b=intersect(psi0,f2n0);
        
        %         % get incidents from frames
        % not using this at the moment
%         [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
%         [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
%         [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
%         [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        % collect summary data
        ilall=[ils ptils];
        threshlk=0;
        for j=1:length(ilall)
            np(j)=length(ilall(j).is);
            len=[ilall(j).len];           
            nbouts(j)=sum(len>threshlk);
            sum_fr(j)=sum(len(len>threshlk));
        end
        allbouts=[allbouts;nbouts];
        allsum_fr=[allsum_fr;100*sum_fr/length(is)];
        npts=[npts;np length(is)];
        pcs=[pcs;100*np/length(is)];
        
        s=[s;sOr(is)'];
        allpsi=[allpsi;ppsi(is)];
        allfdir=[allfdir;f2n(is)];
        allnor=[allnor;nor];
        for j=1:nLM
            lmorall(j).lmor=[lmorall(j).lmor;LMs(j).LMOnRetina(is)];
            lmorall(j).lklens=[lmorall(j).lklens [ils(j).len]];       
        end
        for j=1:(nLM+1)
            porall(j).lmor=[porall(j).lmor; PtsOnRetina(j).LMOnRetina];
            porall(j).lklens=[porall(j).lklens [ptils(j).len]];       
        end
        %         allcs=[allcs;cs(ils(1).is,:)];
%         allcs=[allcs;cs(is,:)];
%         allep=[allep;es(is,:)];
        
        % this gets all the nest looking points
        allcs=[allcs;cs(in,:)];
        allep=[allep;es(in,:)];

        % this gets all the NLM looking points
        nl=ceil(nLM/2);
        allcs=[allcs;cs([ils(nl).is],:)];
        allep=[allep;es([ils(nl).is],:)];

        % plot stuff
        if topl
            figure(1)
            PlotNestAndLMs(LM,LMWid,nest)
            axis equal
            hold on
            title(['flight ' fn ', distance ' int2str(dLim)])
            ylabel('red N-LM looks; blue: nest looks')
            xlabel('press any key to continue')
            
            % plot the bee's path in blue 
            plot(cs(:,1),cs(:,2),'b')

            % plot the control points 
            plot(Pts(:,1),Pts(:,2),'rx','MarkerSize',16)
                
            % these make extra long bees: this is used for drebugging to check
            % that where the bee is 'looking is actually where we think they
            % are. To see the effect, comment/uncomment which says which bee
            % head ie ePlot, to plot
            eLs=(es-cs)*25+cs;
            %         ePlot=eLs;
            ePlot=es;

            % plot a ball and stick diagram for the points when it is
            % facing the nest in black
            plotb(in,cs,ePlot,[],'b',-1)

            % plot a ball and stick diagram for the points when it is
            % facing the Northern most landmark in red
            cols=['r';'y';'k'];
            for j=1:nLM
                plotb(ils(j).is,cs,ePlot,[],cols(j),-1)
            end
            
            % plot a compass and a line
            CompassAndLine('k',-1,[],compassDir,3);
            hold off

            figure(2)
            np2=ceil(0.5*(nLM+1));
            subplot(2,np2,1)
            plot(t(is),nor*180/pi,t(is(in)),nor(in)*180/pi,'r.')
%             title('body orient facing nest')
            title('retinal pos nest')
            axis tight; grid;
%             xlabel(['len ' int2str(inlen) '; ' ...
%                 int2str(sum(inlen>threshlk)) '>' int2str(threshlk)])
            xlabel(['Nest look lengths: ' int2str(inlen)])
                ylabel('red dots are nest looks')

%             AngHist(sOr(in)*180/pi)
            for j=1:nLM
                subplot(2,np2,1+j)
%                 AngHist(sOr(ils(j).is)*180/pi)
%                 title(['body orient facing LM' int2str(j)])
                
             plot(t(is),lmonret(j).LMOnRetina*180/pi, ...
                 t(is(ils(j).is)),lmonret(j).LMOnRetina(ils(j).is)*180/pi,'r.')
                axis tight; grid; 
                xlabel(['LM look lengths ' int2str([ils(j).len]) ])%'; ' ...
%                     int2str(nbouts(j)) '>' int2str(threshlk)])
                title(['retinal pos of LM' int2str(j)])
                ylabel('red dots are LM looks')
            end

            % pause to view output
            disp('press any key to continue')
            pause
        end
    end
end
% plot summary data
nl=ceil(nLM/2);
strs={'allsum_fr(:,nl),2.5:5:47.5';'allbouts(:,nl),1:8';'[lmorall(nl).lklens],1:20'};
tst={'% time NLM lks';'incidents NLm lks';'length incidents NLM lks'};
figure(1)
for i=1:length(strs)
    subplot(3,1,i)
    eval(['[y,x]=hist(' char(strs(i)) ');']);
    plot(x,y/sum(y),cst)
    if(isho); hold on;
    else
        hold off;
        axis tight
        title(char(tst(i)))
    end
end

figure(2)
subplot(2,2,1)
bar(mean(allsum_fr))
title('mean % time LM/ctrl looks')

subplot(2,2,2)
bar(mean(allbouts))
title('mean incidents LM/ctrl lks')

subplot(2,2,3)
for j=1:nLM
    melen(j)=mean([lmorall(j).lklens]);
end
for j=1:(nLM+1)
    melen(j+nLM)=mean([porall(j).lklens]);
end
bar(melen)
title('mean length incidents LM/ctrl')

subplot(2,2,4)
clf
PlotNestAndLMs(LM,LMWid,nest); hold on;
CompassAndLine('k',-1,[],compassDir,3);
plot(Pts(:,1),Pts(:,2),'rx','MarkerSize',16); 
plot(allcs(:,1),allcs(:,2),'b.')
hold off; axis equal; axis tight
title('LM/ctrl (xs) positions')

% this plots a histogram of the data collated from above
% s is body orienttaton, allnor is retinal nest position
% lmorall(i).lmor is retinal position of i'th LM
figure(3)
col='k';
np2=ceil(0.5*(nLM+2));
subplot(np2,2,1)
[y,x]=AngHist(s*180/pi); plot(x,y./sum(y),col);
title('body orientation');axis tight
subplot(np2,2,2)
[y,x]=AngHist(allnor*180/pi);
plot(x,y./sum(y),col); title('retinal nest pos'); axis tight
for j=1:nLM
    subplot(np2,2,2+j)
    [y,x]=AngHist(lmorall(j).lmor*180/pi); plot(x,y./sum(y),col);
    title(['retinal LM ' int2str(j) ' pos']); axis tight
end

% can also subdivide what data is looked at. For instance here I compare
% psi over the full range compoared to psi when looking at N LM

% this plots different data during the looks
% you can change what dat is eg 
np2=ceil(0.5*(nLM+1));
dats={'s';'allpsi';'allfdir'};
strs={'body orient';'psi';'flt direction'};
for i=1:length(dats)
    figure(3+i)
    eval(['dat=' char(dats(i)) ';'])
    tst=char(strs(i));
    subplot(np2,2,1)
    [y,~]=AngHist(dat*180/pi);
    [y1,x]=AngHist(dat((abs(allnor*180/pi)<10))*180/pi);
    % [y2,x]=AngHist(dat((abs(lmorall(j).lmor*180/pi)<10))*180/pi);
    plot(x,y/sum(y),'r--',x,y1/sum(y1),'k');%,x,y2/sum(y2),'r:')
    axis tight
    title([tst ' facing nest (solid) vs all (dash)']);
    for j=1:nLM
        subplot(np2,2,j+1)
        [y,~]=AngHist(dat*180/pi);
        [y1,x]=AngHist(dat((abs(lmorall(j).lmor*180/pi)<10))*180/pi);
        plot(x,y/sum(y),'r--',x,y1/sum(y1),'k'); axis tight
        title([tst ' facing LM ' int2str(j) ' (solid) vs all (dash)']);
    end
end
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


function[d]=GetFileList
% get all the data
s=dir('*All.mat');

% process the filenames so we know what type of flight is in each
% strictly speaking, this should be done on avi files but it works ok here
% for getting the flight type and other relevant variables
for i=1:length(s)
    d(i)=ProcessBeeFileName2015(s(i).name,'All.');
end