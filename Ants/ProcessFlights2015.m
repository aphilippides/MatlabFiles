function ProcessFlights2015

% set up the experiment you want
experiment_string='';

% get all the data
d=GetFileList(experiment_string);

% filter by the flight name to get a specific:
% type or types of flight: ftype (eg 6 is test)
ftype=6;
% numer or numbers of flights: fltnum
fltnum=4;
% which bee to use
bee='FB7';
% flist=FilterByFlightName(d,ftype,fltnum,bee);
flist=FilterByFlightName(d,-1,-1,-1);
% if any of these are -1 it gets all 
% eg d=FilterByFlightName(d,ftype,fltnum,-1); gets all bees

% this is an example of how you would look at data and gather some basic
% stats
dLim=[];%[0 7];
arcLim=[pi/6 0.2];  % arcLim=[pi/20 0.03]; % these are old 'standard' values 
toplot=0; % whether toplot or not

% Pick whether pauses are based on the turning points of arcs; PauseOpt=1
% or on speed: PauseOpt=2; 
PauseOpt=2;
PlotFlightsAndGatherData(flist,dLim,arcLim,PauseOpt,toplot)

% this is an exmaple of how you would filter by multiple distances
% this function looks at the lengths of flights in different distance rings
% these are the different distance rings 
% this only works for learning flights
% dLims=[0 3;0 6;0 9;0 12;0 15];
% flist=FilterByFlightName(d,2,-1,-1);
% LengthOfFlightSegments(d,dLims,'k- ',0);

% this is an example of how you would do the above but for multiple
% differnt experiments etc
% FlightLengths(dirs,cols)


function PlotFlightsAndGatherData(flist,dLim,arcLim,PauseOpt,pl)

% make some empty arrays to collect summary data in
allcs=[];
allsOr=[];
allNoR=[];
allNorthLM=[];
NLMAtPauses=[];
AllLMAtPauses=[];
sOrAtPauses=[];
NorAtPauses=[];
DAtPauses=[];
DLMAtPauses=[];
CsAtPauses=[];

for i=1:3
    allLMs(i).LMOnR=[];
end

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

    is=FilterByDistance(DToNest,dLim);
    
    % get the centroids and the end points of the bees for plotting
    cs=Cents(is,:);
    es=EndPt(is,:);
    
    % find the north-most landmark from the nest
    lmangs=cart2pol(LM(:,1),LM(:,2));
    [mang,N_ind]=min(abs(AngularDifference(lmangs,compassDir)));

    % put all the data together
    allcs=[allcs;cs];
    allsOr=[allsOr sOr(is)];
    allNoR=[allNoR NestOnRetina(is)'];
    allNorthLM=[allNorthLM LMs(N_ind).LMOnRetina(is)'];

    % get number of 'Landmarks' and gather LM data
    nLM=length(LMs);
    for k=1:nLM
        allLMs(k).LMOnR=[allLMs(k).LMOnR LMs(k).LMOnRetina(is)'];
    end
    
    if(~isempty(is))

        % get all the points where the bee is looking at the nest or points
        % that define the landmarks. This is designed for cylinders so in
        % the case of the board experiments where the landmarks are the
        % bottom corners of the board, this will return looking at them
        %             for j=1:nLM
        %                 lmonret(j).LMOnRetina=LMs(j).LMOnRetina(is);
        %             end
        %             [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPts2012...
        %                 (NestOnRetina(is),lmonret,t(is),cs,5,[],3,3);
        % disp('use ThroughZero or whatever and check it!!!')
        
        if(PauseOpt==1)
            % this gets pauses which are turning points of minima and maxima
        % get the pauses of the arcs
        aso=AngleWithoutFlip(sOr(is));
        [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetArcs(aso,t(is),arcLim(1),arcLim(2),0);
        tps=sort([ma mi]);
        i_tps=is(tps);
        % figure(2),plot(cs(:,1),cs(:,2),cs(mi,1),cs(mi,2),'gs',cs(ma,1),cs(ma,2),'ro'...
        %     ,cs(tps,1),cs(tps,2),'k*')
%         zls=[zls diff(tpts)];
        else
            vLim=1.5; % this is the velocity below which is deemed a pause
            tLim=0.21;  % this is the minimum time between pauses
            sm_len=0.05; % this is how much to smooth the speeds
            [dat,smSp]=GetPausesSpeed(Speeds(is),t(is),vLim,tLim,0.05,1);
            if(isempty(dat))
                i_tps=[];
            else
                i_tps=is([dat.mp]);
            end
        end
        % get some data on the Pauses
        tpts=t(i_tps);
        NLMAtPauses=[NLMAtPauses LMs(N_ind).LMOnRetina(i_tps)'];
        sOrAtPauses=[sOrAtPauses sOr(i_tps)];
        catp=cs(i_tps,:);
        dlmx=LMs(N_ind).LM(1)-catp(:,1);
        dlmy=LMs(N_ind).LM(2)-catp(:,2);
        CsAtPauses=[CsAtPauses;catp];
        DAtPauses=[DAtPauses CartDist(catp)'];
        DLMAtPauses=[DLMAtPauses CartDist([dlmx dlmy])'];

%                 tlm=zeros(nLM,length(i_tps));
%                 for k=1:nLM
%                     tlm(k,:)=LMs(k).LMOnRetina(i_tps)';
%                 end
%         AllLMAtPauses=[AllLMAtPauses tlm];
        NorAtPauses=[NorAtPauses NestOnRetina(i_tps)'];

        if pl
            figure(2)
            subplot(3,1,1)
            plot(t(is),aso*180/pi,tpts,aso(i_tps)*180/pi,'ro')
            xlabel('time (s)');ylabel('body orientation (rel to North)')
            axis tight
            grid
            title(fn)
            subplot(3,1,2)
            plot(t(is),DToNest(is),tpts,DToNest(i_tps),'ro')
            %             plot(t(is),AngleWithoutFlip(Cent_Os(is))*180/pi)
            xlabel('time (s)');ylabel('distance to nest (cm)')
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
            
            % plot a circle around the northmost landmark
            MyCircle(LMs(N_ind).LM(1),LMs(N_ind).LM(2),1.3*LMWid(N_ind)/2,'r');
            
            % plot a circle around the nest/feeder to show it's width
            MyCircle(0,0,0.5*NestWid*cmPerPix,'m');
            hold off
            title(fn)

            % pause to view output
            disp('press any key to continue')
            pause

        end
    end
    end
end

% plot a heat map of the position of the bee
figure(4)

% this gets the Density map. It inputs the x y positions from allcs
% the x-y bin centres are specified by the vectors which are the 3rd and
% 4th input parameters to Density2D
xbins=-20:3:15;
ybins=-20:2.5:20;
[D]=Density2D(allcs(:,1),allcs(:,2),xbins,ybins);

% plot a filled contour
contourf(xbins,ybins,D);
% contourf(xbins,ybins,D,0:100:600);
% change the colorap from white to black
g=colormap('gray');
colormap(g(end:-1:1,:));
hold on
PlotNestAndLMs(LM,LMWid,nest)
axis equal
hold off

figure(6)
% plot the data as a heat map
% plot(allcs(:,1),allcs(:,2),'.')
imagesc(xbins,ybins,D);
hold on
PlotNestAndLMs(LM,LMWid,nest)
axis equal
hold off

% plot summary histigrams of the angular data
figure(5)
subplot(3,2,1)
[y,x]=AngHist(allsOr*180/pi);
xlabel('Body orientation');ylabel('frequency')
axis tight

subplot(3,2,2)
[y,x]=AngHist(allNorthLM*180/pi);
xlabel('North Landmark');ylabel('frequency')
axis tight

subplot(3,2,5)
[y,x]=AngHist(allNoR*180/pi);
xlabel('Retinal nest positions');ylabel('frequency')
axis tight

for i=1:nLM
    subplot(3,2,3+i)
    [y,x]=AngHist(allLMs(i).LMOnR*180/pi);
    xlabel(['Landmark ' int2str(i)]);ylabel('frequency')
    axis tight
end

% plot similar data on the pauses
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

function FlightLengths% (experiment_strings,cols)
% thse could be passed in as input arguments
cols=['k- ';'r: ';'b--'];
dirs={'../Small1LmFiles';'../Big1LMFiles';'../Bees 2012 3lm alls'};

% these 
dLims=[0 3;0 6;0 9;0 12;0 15];
% this is to make the plotting work 
ih=[1 2 0];
for i=1:length(dirs)
    % cd(char(dirs(i)))
    d=GetFileList(char(dirs(i)));
    d=FilterByFlightName(d,2,-1,-1);
    % the below doesn't wprk for 3 Lm files
%     d=d([d.fltnum]<=3);
    lens=LengthOfFlightSegments(d,dLims,cols(i,:),ih(i));
end
cd(origdir);

function FlightLengthsChangingDirectory(dirs,cols)
origdir=cd;

dLims=[0 3;0 6;0 9;0 12;0 15];
ih=[1 2 0];
for i=1:length(dirs)
    % cd(char(dirs(i)))
    d=GetFileList;
    d=d([d.ftype]==2);
    % the below doesn't wprk for 3 Lm files
%     d=d([d.fltnum]<=3);
    lens=LengthOfFlightSegments(d,dLims,cols(i,:),ih(i));
end
cd(origdir);




% % filter by the flight name to get a specific:
% % type or types of flight: ftype (eg 6 is test)
% ftype=6;
% % numer or numbers of flights: fltnum
% fltnum=4;
% % which bee to use
% bee='FB7';
% d=FilterByFlightName(d,ftype,fltnum,bee);
% % if any of these are -1 it gets all 
% % eg
% % d=FilterByFlightName(d,ftype,fltnum,-1);
% % gets all bees
% % [will change this function a little] 

function[out]=FilterByFlightName(d,ftype,fltnum,bee)
% this first gets the type of flight ie learning, test or return;
% eg test is 6
if(ftype==-1)
    TypeOfFlight=ones(1,length(d));
else
    TypeOfFlight=ismember([d.ftype],ftype);
end

% this now  gets A specific number or numbers of flights
% here 4th flight
if(fltnum==-1)
    NumberOfFlight=ones(1,length(d));
else
    NumberOfFlight=ismember([d.fltnum],fltnum);
end
% if I want only a single bee
if(isequal(bee,-1))
    WhichBee=ones(1,length(d));
else
    WhichBee=zeros(1,length(d));
    for i=1:length(d)
        if(isequal(d(i).bee,bee))
            WhichBee(i)=1;
        end
    end
end

% to select, combine the vectors above
out=d(logical(TypeOfFlight.*WhichBee.*NumberOfFlight));

% this function shows an example of how you separate the data based on
% different distance segments. It basically goes through each file, loads
% it in and then calls the function
function[lens,props]=LengthOfFlightSegments(flist,dLims,cst,isho)
lens=NaN*ones(length(flist),size(dLims,1)+1);
props=NaN*ones(length(flist),size(dLims,1));
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
        
        % subdivide the data for each of the different distance divisions
        % This does it based on distance but it could be done otherwise
        % eg on speed or something else
        for j=1:size(dLims,1)
            [is,lens(i,j)]=FilterByDistance(DToNest,dLims(j,:),t);
        end
        
        % this then works out how long the flight segment 
        lens(i,end)=t(end)-t(1);
        props(i,:)=100*lens(i,1:end-1)./lens(i,end);
    end
end

% the rest of this plots the data and is not needed for General p

% this tidies sorts out some NaN's in the data which happen if there's no
% data in a certain section
props=props(~isnan(lens(:,1)),:);
lens=lens(~isnan(lens(:,1)),:);

% set the title in figure 1
figure(1)
title(['lengths; 0 to: ' int2str(dLims(:,2)')])
for i=1:5
    
    % in each subplot plot the frequency of the binned time data for each
    % distance interval
    subplot(3,2,i)
    [y,x]=hist(lens(:,i),0:0.5:15);
    plot(x,y./sum(y),cst)
    axis tight
    
    % all this 'hold' stuff basically allows me to run the function
    % multiple times for different sets of the data
    if(isho); hold on;
    else hold off;
    end
    title(['time within ' int2str(dLims(i,2)) ' (s)'])
end

% finally plot the data as an errorbar. Note here 'isho' is used to stagger
% the data from different data sets so it can be seen
subplot(3,2,6)
% errorbar([3:3:15 20],mean(lens),std(lens),cst)
errorbar([3:3:15 20]-0.25+isho*0.25,median(lens),iqr(lens),cst)
axis tight
if(isho); hold on;
else hold off;
end

% do the same for the proportions
figure(3)
title(['proportions; 0 to: ' int2str(dLims(:,2)')])
for i=1:5
    subplot(3,2,i)
    [y,x]=hist(props(:,i),0:5:100);
    plot(x,y./sum(y),cst)
    axis tight
    if(isho); hold on;
    else hold off;
    end
    title(['% of flight within ' int2str(dLims(i,2))])
end
subplot(3,2,6)
% errorbar(3:3:15,mean(props),std(props),cst)
errorbar([3:3:15]-0.25+isho*0.25,median(props),iqr(props),cst)
axis tight
if(isho); hold on;
else hold off;
end


% [will change this function a little]

function[d]=GetFileList(experiment_string)
if(nargin<1)
    experiment_string=[];
end
s=dir(['*_*' experiment_string '*All.mat']);

% process the filenames so we know what type of flight is in each
% strictly speaking, this should be done on avi files but it works ok here
% for getting the flight type and other relevant variables
for i=1:length(s)
    d(i)=ProcessBeeFileName2015(s(i).name);
end