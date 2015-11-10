function[outrms]=RemoveBeesProg(fnm,vidfn,vObj,FRLEN)

% dwork;
% cd GantryProj\Bees
outrms=[];
load(fnm);
i=strfind(fnm,'Prog');
fi=fnm(1:i-2);

if(nargin<2)
    if(~exist('vidfn','var'))
        vidfn=[fi '.avi'];
    end
end

if(nargin<3)
    vObj=[];
end

if(nargin < 4)
    FRLEN=0.02;
end

load([fi 'NestLMData.mat']);
tempfile=[fnm(1:end-4) 'TempCopy.mat'];
copyfile(fnm,tempfile);

fr=floor(0.5*(FrameNum(1)+1));
f=MyAviRead(vidfn,fr,vObj);

if(exist('NumFrs','var'))
elseif(exist('StartEnd','var'))
    NumFrs=StartEnd(1):StartEnd(2);
    NumFrs=NumFrs*2-1;
else
    nb=length(NumBees);
    NumFrs=1:nb;
    if(~exist('FullFrame','var'))
    elseif(FullFrame==1)
        nb=nb*2-1;
        NumFrs=NumFrs*2-1;
    end
end

% Because we sequentially remove bees, this should be a unique identifier
% Checked.fr=[];Checked.WhichB=[];Checked.isb=[];
Checked=[-1 -1 0];

% this is how close to the nest in cm that the bee needs to be to be
% checked
dlim=3;

% if quickplot=1, means do not plot bees as colours
quickplot=0;
while 1
    [shads,endflag]=RemoveAreasAndShadows(MeanCol,Areas,Cents,EPt,EndPt,elips,fnm,...
        FrameNum,WhichB,FRLEN,vidfn,vObj,NumFrs,f,quickplot);
    if(endflag)
        break;
    end
    % Check ones over the nest
    if(exist('nest','var'))
        [shads,Checked]=CheckNestData(shads,Checked,Cents,EPt,elips,...
            FrameNum,WhichB,vidfn,vObj,dlim,nest,cmPerPix,3);
    end
    % Remove the data
    RemoveData_Path(fnm,fnm,shads)
    load(fnm);
end
end


function[rms]=RmBeesGraphical(cs,bads,fnum,hd)
rms=[];
h=[];
while 1
    figure(fnum)
    subplot(hd)
    hold on
    title('click top left of box; return end and bottom right of box')
    xlabel('bees inside (*) to be removed; return end')
    [x,y]=ginput(1);
    if(isempty(x))
        return;
    end
    h2=plot(x,y,'w*');
    title('click bottom right of box')
    xlabel('bees inside (*) to be removed; return end')
    [x2,y2]=ginput(1);
    if(~isempty(x2))
        x=[x x2];
        y=[y y2];
        boxx=x([1 2 2 1 1]);
        boxy=y([1 1 2 2 1]);
        rms=find((cs(:,1)>x(1))&(cs(:,1)<x(2))&(cs(:,2)>y(1))&(cs(:,2)<y(2)));
        rms=setdiff(rms,bads);
        delete(h)
        delete(h2)
        if(isempty(rms))
            h=plot(boxx,boxy,'w');
        else
            h=plot(boxx,boxy,'w',cs(rms,1),cs(rms,2),'*');
        end
    end
end
figure(fnum)
subplot(hd)
hold off
end


function[nb,fr]=NumBLeft(FrameNum,vals,aRms)
gs=setdiff(1:length(FrameNum),aRms);
[nb,fr]=Frequencies(FrameNum(gs),vals);
end

function[aRms]=RemoveDataSel(areas,meanCol,arLevel,OvOrUnd,WhichB) %,Cents,EPt,elips,FrameNum,fn,vObj)
if(OvOrUnd==1)
    aRms=find(areas<arLevel(1));
elseif(OvOrUnd==2)
    aRms=find(meanCol>arLevel(1));
else
    aRms=find((meanCol>arLevel(2))&(areas<arLevel(1)));
end
if(isempty(aRms))
    return;
end
% return % % if doing  simple version
% more complex version only removes data where the number to be removed are
% less than 25% of that bee ie needs to remove over 75% of that bee
wbRms=WhichB(aRms);
ilist=unique(wbRms);
if(~isempty(ilist))
    out=[];
    for i=ilist
        nin=sum(wbRms==i);
        nt=sum(WhichB==i);
        if((nin/nt)<0.25)
            out=[out aRms(wbRms==i)];
        end
    end
    aRms=setdiff(aRms,out);
else
    return;
end
end


function[shads,endflag]=RemoveAreasAndShadows(MeanCol,areas,Cents,EPt,EndPt,elips,...
    fnm,FrameNum,WhichB,FRLEN,fn,vObj,frlist,f,quickplot)

endflag=0;

fignums=[5,6,7];
for i=1:length(fignums)
    figure(fignums(i))
    clf
end

% set the configuration of the plot
figure(fignums(1));
nPl=3;
m=nPl;%+1;
n=1;
% plot the initial data
ax(1)=subplot(m,n,1);
hist(areas,40)
xlabel('areas')
axis tight;hold on
ax(2)=subplot(m,n,2);
hist(MeanCol,40)
xlabel('bee colour')
axis tight;hold on
ax(3)=subplot(m,n,3);
plot(areas,MeanCol,'o')
xlabel('areas');
ylabel('bee colour')
axis tight;hold on
for i=1:nPl-1
    yl(i,:)=ylim(ax(i));
end
yl(nPl,:)=[max(areas) max(MeanCol)];

shads=[];

% flag that says all bees have been removed
nobflag=0;
h=[];
while 1
    % plot the rest of the bees
    hs=PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,shads,...
        fignums([2,3]),f,frlist,quickplot);

    figure(fignums(1));
    drawnow;
%     subplot(ax(1));
    % Get a clicked point from subplot
    [x,y,b,ind,h_p]=GinputSubplot(1,ax,'Select cutoff in a graph; return remove bees; g graphical; x end');
    if(isempty(x))
        % if return is pressed, remove bees
        break;
    elseif(isequal(b,120))
        % if x is pressed, stop checking
        endflag=1;
        shads=[];
        break;
    elseif(isequal(b,103))
        % if g is pressed, graphically remove bees
        shads=RmBeesGraphical(Cents,[],fignums(2),hs(1));
    else
        cutoff=[x,y];
        shads=RemoveDataSel(areas,MeanCol,cutoff,ind,WhichB);

        % plot the line on the graph
        figure(fignums(1));
        delete(h);
        subplot(ax(ind));
        if(ind==3)
            h=plot(ax(ind),[0 cutoff(1) cutoff(1)],...
                [cutoff(2) cutoff(2) yl(nPl,2)],'r','LineWidth',1.5);
        else
            h=plot(ax(ind),[cutoff(1) cutoff(1)],yl(i,:),'r','LineWidth',1.5);
        end
        %         subplot(nPl+1,1,nPl+1);
        %         [num_b,fra]=NumBLeft(FrameNum,frlist,shads);
        %         plot(fra,num_b)

        %         % plot the most shadow-like bee
        %         if(sum(num_b)==0)
        %             nobflag=1;
        %         elseif(isempty(shads))
        %             disp(['no bees above ' int2str(s) '; enter >=200 to not process shadows']);
        %             figure(1)
        %             subplot(hs(1));
        %             title(['no bees above ' int2str(s) '; enter >=200 to not process shadows']);
        %         else
        %             [m,i]=min(MeanCol(shads));
        %             ind=shads(i(1));
        %             figure(7)
        %             fr=floor(0.5*(FrameNum(ind)+1));
        %             f=MyAviRead(fn,fr,vObj);
        %             imagesc(f);
        %             plotb(ind,Cents,EPt,EndPt,elips,'g')
        %         end
    end
end
% if(isempty(shads))
%     sLevel=min(sLevel,200);
% end
% save(fnm,'sLevel','shads','-append');
figure(fignums(1))
for i=1:nPl
    subplot(ax(i));
    hold off;
end
end

function[x,y,b,ind,h_p] = GinputSubplot(n,h,tstr)

gcf
title(tstr)
[x,y,b]=ginput(n);
h_p=gca;
ind=find(h_p==h);
if(isempty(b))
    ind=[];
else
end
end


function RemoveData_Path(fnin,fnPath,i_out)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
Areas=Areas(is);
Cents=Cents(is,:);
Orients=Orients(is);
WhichB=WhichB(is);
EndPt=EndPt(is,:);
Bounds=Bounds(is,:);
MeanCol=MeanCol(is);
NLess=NLess(is);
len_e=len_e(is);
area_e=area_e(is);
EPt=EPt(is,:);
elips=elips(is);
odev=odev(is);
ang_e=ang_e(is);
eccent=eccent(is);
v1=MyGradient(Cents(:,1),FrameNum);
v2=MyGradient(Cents(:,2),FrameNum);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

clear fnin is i_out
save(fnPath);
% save(fnout,'FrameNum','MeanCol', 'WhichB', ...
%     'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
%     'area_e','EPt','elips','odev','ang_e','len_e','eccent',...
%     'Speeds','Vels','Cent_Os','nest','LM','LMWid','NestWid','thresh');
end

function[hs]=PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,rms,...
    fnum,f,frlist,quickplot)
cs = ['b';'g';'r';'c';'y'];
count=1;
str=[];
strL=[];
x=1;
goods =setdiff(1:length(FrameNum),rms);
ilist=unique(WhichB(goods));
figure(fnum(1)),
clf
hs(1)=subplot('position',[0.08 .35 0.85 0.575]);
if(nargin>7)
    hold off;
    imagesc(f);
end

hold on;
if(quickplot||(length(goods)>500))
    plot(Cents(goods,1),Cents(goods,2),'b.');
else
    for i=1:length(ilist)
        ks = find(WhichB==ilist(i));
        ks = intersect(goods,ks);
        is=ks(1:x:end);
        col=cs(mod(i,5)+1,:);
        %for is=1:n
        plot(EPt(is,1),EPt(is,2),[col '.'])
        plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
        %     sbit=[int2str(i) ': ' col ' ' int2str(length(is)) ' ' num2str(FrameNum(is(1))*FRLEN)];
        sbit=[int2str(ilist(i)) ': ' col ' ' int2str(length(is)) ' ' int2str(FrameNum(is(1)))];
        str=[str sbit '; '];
        strL=strvcat(strL,  sbit);
        text(Cents(is(1),1),Cents(is(1),2),int2str(ilist(i)),'Color',col)
    end
    xlabel(str)
    WriteFileNames(strL,3)
    disp(' ');
end
title('data to be used')
hold off;

hs(2)=subplot('position',[0.08 .08 0.85 0.2]);
[num_b,fra]=NumBLeft(FrameNum,frlist,rms);
plot(fra,num_b)
xlabel('frame')
ylabel('#bee/frame')
axis tight;
ylow(0)

% plot the excluded bees
if(length(fnum)>1)
    ilist=unique(WhichB(rms));
    figure(fnum(2)),
    cla
    if(nargin>7)
        hold off;
        imagesc(f);
    end
    if(isempty(ilist))
        return;
    end
    hold on;
    if(quickplot||(length(rms)>20))
        plot(Cents(rms,1),Cents(rms,2),'b.');
    else
        for i=ilist
            ks = find(WhichB==i);
            ks = intersect(rms,ks);
            is=ks(1:x:end);
            col=cs(mod(count,5)+1,:);
            plot(EPt(is,1),EPt(is,2),[col '.'])
            plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
            %         str=[str int2str(i) ': ' col ' ' int2str(length(is)) ' ' num2str(FrameNum(is(1))*FRLEN) '; '];
            %         strL=strvcat(strL,  [int2str(i) ': ' col ' ' int2str(length(is)) ' ' ...
            %             num2str(FrameNum(is(1))*FRLEN)]);
            %         text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
            count = count + 1;
        end
    end
    %     xlabel(str)
    %     WriteFileNames(strL,3)
    title('excluded data')
    hold off;
end
end


function WriteFileNames(fns, NumOnLine)
if isempty(fns)
    return;
end

L=size(fns,1);
N=fix(L/NumOnLine)-1;
M=rem(L,NumOnLine);
for i=0:N
    for j=1:NumOnLine
        fn=i*NumOnLine+j;
        fprintf('%s   ',fns(fn,:));
    end
    fprintf('\n');
end
for i=1:M
    fn=(N+1)*NumOnLine+i;
    fprintf('%s ',fns(fn,:));
end
end


function plotb(is,c1,e1,e2,ell,col)
bw=75;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=is
    plot(ell(i).elips(:,1),ell(i).elips(:,2),col)
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])
hold off
end