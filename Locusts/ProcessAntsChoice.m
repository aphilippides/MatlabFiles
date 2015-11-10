function ProcessAntsChoice

thr=175;%[180 175:5:190];%120:20:220;
sm_opt=[5 2];%;7 2;8 4;9 4];
bit=['Thresh' int2str(thr) 'S' int2str(sm_opt(1)) 'W' x2str(sm_opt(2))];
s=dir(['*Prog' bit '.mat']);
for i=1:length(s) 
    SingleAntsChoice(s(i).name);
    [nLeft(i,:),nRight(i,:)]=GetChoices(s(i).name)
%     disp('press any key to continue')
%     pause
end
save LeftRightData nLeft nRight

%     disp('  ');
%     WriteFileOnScreen(s,1);
%     disp(' ');
%     pic=ForceNumericInput(['select a file: '],1,1);




function[nLeft,nRight,Track]=GetChoices(fn)
k=strfind(fn,'_Prog');
trfn=[fn(1:k-1) 'Track' fn(k+5:end)];
load(trfn);
% ChoiceProportion=0.6;
% keyboard;

starts=[-1 2 3;-2 1 3;-3 1 2];
choices=[3 4;5 3;4 5];
n=size(starts,1);
for k=MazeToProcess
    % get axis limits of the maze (this is just for plotting)
    rs=find(sum(objmask==k,1));
    cs=find(sum(objmask==k,2));
    axl=[min(rs) max(rs) min(cs) max(cs)];
    % get positions of the ant in maze k
    x=[Track(k).pos];
    % find all the points at which it leaves an 'endzone'
    ldiff=diff(Track(k).dLabel);
    figure(k)
    all=[];
    for j=1:size(starts,1)
        % find all exits from endzone j and entry to the other 2,
        %  based on the difference in endzone and not endzone labels 
        % These are coded in starts 
        is=find(ismember(ldiff,starts(j,:)));
        vs=ldiff(is);
        % now use the difference between the endzone labels to find if it
        % was a left or right turn. These are coded in choices
        dvs=diff(vs);
        lefts=find(dvs==choices(j,1));
        rights=find(dvs==choices(j,2));
        nL(j)=length(lefts);
        nR(j)=length(rights);
        
        % find indices of start and end of  L/R choices
        % store in ch as [L1;L2] and [R1;R2] respectively and plot 
%         subplot(m,n,j+(k-1)*n)
        subplot(1,n,j)
        imagesc(mazemask)
        axis equal; axis(axl);
        hold on;
        L1=[]; L2=[]; R1=[]; R2=[];
        for i=1:length(lefts)
            L1(i)=is(lefts(i));
            L2(i)=is(lefts(i)+1);
            plot(x(1,L1(i):L2(i)),x(2,L1(i):L2(i)),'b',x(1,L2(i)),x(2,L2(i)),'bo')
        end
        for i=1:length(rights)
            R1(i)=is(rights(i));
            R2(i)=is(rights(i)+1);
            plot(x(1,R1(i):R2(i)),x(2,R1(i):R2(i)),'r',x(1,R2(i)),x(2,R2(i)),'ro')
        end
        ch(j).Ls=[L1;L2];
        ch(j).Rs=[R1;R2];
        hold off
        if(j==1)
            ylabel(['Maze ' int2str(k)])
            title('L blue, R red')
        end
        xlabel([int2str(nL(j)) ' lefts; ' int2str(nR(j)) ' rights'])
        
        all=[all [L1;L2] [R1;R2]];
    end
    nLeft(k)=sum(nL);
    nRight(k)=sum(nR);
    Track(k).nLeft=sum(nL);
    Track(k).nRight=sum(nR);
    Track(k).ch_is=ch;
    if(~isempty(all))
        [s,sis]=sort(all(1,:));
        all=all(:,sis);
        Track(k).lengths=all(2,:)-all(1,:);
    else
        Track(k).lengths=[];
    end
    Track(k).all=all;
    
    % Check the non choices jsut to make sure...
    % basic check to make sure they're not overlapping
    inp=input('enter 1 to review choices: ');
    if(isequal(inp,1))
        bad2=find([Track(k).lengths]<=0)
        bads=[];
        figure(10)
        sp=1;
        alli=[];
        for i=1:size(all,2)
            bads=intersect(bads,all(1,i):all(2,i));
            imagesc(mazemask)
            axis equal; axis(axl); hold on;
            i1=sp:all(1,i);
            plot(x(1,i1),x(2,i1),'k',x(1,all(1,i):all(2,i)),x(2,all(1,i):all(2,i)),'r')
            hold off
            alli=[alli sp:(all(2,i)-1)];
            sp=all(2,i);
            disp('B4 choice (black), choice (red); return to continue')
            title('B4 choice (black), choice (red); return to continue')
            pause
        end
        imagesc(mazemask)
        axis equal; axis(axl); hold on;
        i1=sp:size(x,2);
        plot(x(1,i1),x(2,i1),'k')
        hold off
        disp('after last choice (black), return to continue')
        title('after last choice (black), return to continue')
        pause
        disp(bads)
    end
end
save(trfn,'nLeft','nRight','Track','-append');

function SingleAntsChoice(fn)
load(fn)
k=strfind(fn,'_Prog');
load([fn(1:k-1) 'NestLMData.mat']);
outf=[fn(1:k-1) 'Track' fn(k+5:end)];
if(exist(outf,'file'))
    return;
end
nMaze=4;
for i=1:length(NumBees)
    is=find(FrameNum==i);
    dat(i).is=is;
    dat(i).fr=FrameNum(is);
    dat(i).cs=Cents(is,:);
    dat(i).ar=Areas(is);
    [dat(i).NumMaze,dat(i).WhichMaze]=WhichMaze(dat(i).cs,objmask,nMaze);
end

% get median area of ants in each maze
wm=[dat.WhichMaze];
for i=1:nMaze
    AntArea(i)=median(Areas(wm==i));
end
MazeToProcess=1:3;
Track=CombineMultipleAnts(dat,MazeToProcess,AntArea);
colormap default;
cols=colormap;%['b.';'r.';'k.']
imagesc(objmask)
hold on
colormap gray;
ChoiceProportion=0.6;
for i=MazeToProcess
    x=[Track(i).pos];
    xc=[x(1,:)-Maze(i).cent(1);x(2,:)-Maze(i).cent(2)];
    plot(x(1,:),x(2,:),'w')
    for j=1:3
        dtoend(j,:)=CartDist(x',Maze(i).ArmEnds(j,:))';
        [armx,army]=pol2cart(Maze(i).ArmAngs(j),1);
        dproj(j,:)=[armx army]*xc;
        dend(j)=[armx army]*[Maze(i).ArmEnds(j,:)-Maze(i).cent]';
        propalong(j,:)=dproj(j,:)./dend(j);
    end
    [mind,inArm]=min(dtoend);
    AntDLabel=inArm*10;
    for j=1:3
        is=(inArm==j)&(propalong(j,:)>ChoiceProportion);
        AntDLabel(is)=AntDLabel(is)+j;
    end
    dLabs=[10 11 20 22 30 33];
    for j=1:length(dLabs)
        n=floor(size(cols,1)/length(dLabs));
        plot(x(1,AntDLabel==dLabs(j)),x(2,AntDLabel==dLabs(j)),'x',...
            'Color',cols(n*j,:))
        hold on
    end    
    Track(i).dLabel=AntDLabel;
end
hold off
save(outf,'dLabs','Track','ChoiceProportion','MazeToProcess','objmask','mazemask');

function[Track]=CombineMultipleAnts(dat,MazeToProcess,AntArea)
ThreshDist=50;
nm=[dat.NumMaze];
NewDat=dat;
for i=MazeToProcess
    Track(i).pos=[];
    Track(i).fr=[];
    Track(i).is=[];
    for j=1:length(dat)
        is=find(dat(j).WhichMaze==i);
        if(length(is)>0)
            if(length(is)>1)
                is=GetOneAntFromMultiple(nm(i,:),j,dat,i,ThreshDist,AntArea);
            end
            Track(i).pos=[Track(i).pos dat(j).cs(is,:)'];
            Track(i).fr=[Track(i).fr dat(j).fr(is)];
            Track(i).is=[Track(i).is dat(j).is(is)];
        end
    end
    badfrs=find(nm(i,:)>1);
    numBad(i)=length(badfrs);
    x=[Track(i).pos];
    plot(x(1,:),x(2,:),'w')
end
numBad
    


% get one ant from several that are in that maze
function[ind]=GetOneAntFromMultiple(nm,badfr,dat,imaze,ThreshDist,AntArea)
% find the nearest good ant before or after
nearAnt=GetNearestAnt(nm,badfr);
is=find(dat(badfr).WhichMaze==imaze);
% find the nearest of the current ants to the previous one
if(isempty(nearAnt))
    % if there was no near ant pick the one who's area
    % is closest to the median for that maze
    [~,ind]=min(abs(AntArea(imaze)-dat(badfr).ar(is)));
else
    % find the neraest ant
    cnear=dat(nearAnt).cs(dat(nearAnt).WhichMaze==imaze,:);
    [mind,ind]=min(CartDist(dat(badfr).cs(is,:),cnear));
    % if it's not near enough, pick the one based on
    if(mind>ThreshDist)
        [~,ind]=min(abs(AntArea(imaze)-dat(badfr).ar(is)));
    end
end
ind=is(ind);

% find the nearest good ant before or after
function[nearAnt]=GetNearestAnt(nm,j)
% find the nearest frame before with one ant in it
b4=find(nm(1:j-1)==1,1,'last');
if(isempty(b4))
    b4=-1e8;
end
% find the best nearest frame after with one ant in it
aft=find(nm(j+1:end)==1,1,'first');
if(isempty(aft))
    aft=1e8;
else
    aft=aft+j;
end
% see which is closer
if((aft-j)<(j-b4))
    nearAnt=aft;
else
    nearAnt=b4;
end
if(abs(nearAnt)==1e8)
    nearAnt=[];
end

function[NumMaze,WhichMaze]=WhichMaze(cs,objmask,nms)
NumMaze=zeros(nms,1);
WhichMaze=[];
cs=round(cs);
for i=1:size(cs,1)
    WhichMaze(i)=objmask(cs(i,2),cs(i,1));
end
NumMaze=Frequencies(WhichMaze,1:nms)';
