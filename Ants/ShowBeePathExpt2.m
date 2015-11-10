function[outrms]=ShowBeePathExpt2(fnm,PrettyPic,x,FRLEN,vObj,NestLMfn)

% dwork;
% cd GantryProj\Bees
outrms=[];
load(fnm);
i=strfind(fnm,'Path');
fi=fnm(1:i-1);

if(nargin<5)
    vObj=[];
end

if(nargin<6) 
    load([fi 'NestLMData.mat']);
else
    load(NestLMfn);
end

if(nargin < 4) 
    FRLEN=0.02; 
end
if(nargin < 3) 
    x=1; 
end
if(nargin < 2) 
    PrettyPic=1; 
end

fn=[fi '.avi'];
f=MyAviRead(fn,FrameNum(1),vObj);

nb=length(NumBees);
frlist=1:nb;
if(FullFrame==1)
    nb=nb*2-1;
    frlist=frlist*2-1;
end

% figure windows to plot in
figlist=[1 2 3 4 5];

% clear them all
for i=figlist
    figure(i)
    clf;
end

PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,[],figlist(1),f,frlist);
% PlotBeesSeq(fi,WhichB,EPt,Cents,LM,LMWid,nest,NestWid,...
%     EndPt,elips,FrameNum,FRLEN,x,PrettyPic);

% [rms,xLevel]=RemoveEdges(Cents,EPt,EndPt,elips,fnm);
% RemoveData_Path(fnm,fnm,rms);
% load(fnm);

% this is how close to the nest in cm that the bee needs to be to be
% checked; this should be greater than the width of the nest *especially*
% with the new files which have a disk over the nest
dlim=max(3,(0.5*NestWid*cmPerPix)+1.5);

% Because we sequentially remove bees, this should be a unique identifier
% Checked.fr=[];Checked.WhichB=[];Checked.isb=[]; 
Checked=[-1 -1 0];

% remove really small 'bees'
[aRms,arLevel]=RemoveAreas(MeanCol,Areas,Cents,EPt,elips,fnm,...
    FrameNum,WhichB,FRLEN,f,fn,vObj,frlist,figlist);

% Check ones over the nest
[aRms,Checked]=CheckNestData(aRms,Checked,Cents,EPt,elips,...
    FrameNum,WhichB,fn,vObj,dlim,nest,cmPerPix,figlist(4));

% Show the ones that are being excluded as a check before removal
PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,aRms,figlist(1:2),f,frlist);

% Remove the data
RemoveData_Path(fnm,fnm,aRms)
load(fnm);

% remove shadows ie light coloured 'bees'
[shads,sLevel]=RemoveShadows(MeanCol,Areas,Cents,EPt,EndPt,elips,fnm,...
    FrameNum,WhichB,FRLEN,fn,vObj,frlist,f,figlist);

% Check ones over the nest
[shads,Checked]=CheckNestData(shads,Checked,Cents,EPt,elips,...
    FrameNum,WhichB,fn,vObj,dlim,nest,cmPerPix,figlist(4));

% Show the ones that are being excluded as a check before removal
PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,shads,figlist(1:2),f,frlist);

% Remove the data
RemoveData_Path(fnm,fnm,shads)
load(fnm);

% Remove bees iteratively
rms=[];
bhdl=[];
while 1
%     delete(bhdl)
    disp(' ')
    disp(['removed = ' int2str(unique(WhichB(rms)))])
    hs=PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,rms,figlist(1),f,frlist);
    disp('enter number, n, to remove, -n to add, 0 graphical, return end')
    torm=input('vector for many, single n to view: ');
    
    if(isempty(torm))
        break;
    else
        if(torm==0)
            rms=union(rms,RmBeesGraphical(Cents,rms,figlist(1),hs(1)));
        else
            if(length(torm)==1)
                if(torm<0)
                    tstr='bee to be added back in';
                    inds=find(WhichB==-torm);
                else
                    tstr='bee to be removed';
                    inds=find(WhichB==torm);
                end
                i1=1;
                ta=1;
                topl=1;
                disp(' ')
                figure(figlist(4))
                while((topl==1)&&(i1<=length(inds)))
                    plotbFrame(fn,inds(i1),FrameNum,vObj,Cents,EPt,elips,tstr)
                    isb=input([int2str(i1) '/' int2str(length(inds)) ...
                        ': 0 to stop; return continue: ']);
                    if(isequal(isb,0))
                        topl=0;
                    end
                    i1=i1+ta;
                end
                disp(' ')
            end
            for i=torm
                if(i>0)
                    rms=union(rms,find(WhichB==i));
                else
                    rms=setdiff(rms,find(WhichB==-i));                    
                end
            end
        end
    end
end
rms=CheckNestData(rms,Checked,Cents,EPt,elips,...
    FrameNum,WhichB,fn,vObj,dlim,nest,cmPerPix,figlist(4));
RemoveData_Path(fnm,fnm,rms);
end
% badbs=find(diff(FrameNum(goods))==0);
% if(~isempty(badbs))
%     inp=input('Enter 0 to check doubles. -1 for keyboard');
%     if(inp==-1) keyboard;    
%     elseif(inp==0)
%         for i1=badbs
%             i2=i1+1;
%             figure(2)
%             fr=floor(0.5*(FrameNum(i1)+1));
%             f=MyAviRead(fn,fr,vObj);
%             imagesc(f);
%             plotb(i1,Cents,EPt,EndPt,elips,col)
%             figure(3)
%             imagesc(f);
%             plotb(i2,Cents,EPt,EndPt,elips,col)
%             inp=input(['t = ' num2str(FrameNum(i1)*FRLEN) '; press 2 to remove fig 2, 3 for fig 3, 0 for both']);
%             if(inp==2) rms=[rms i1]
%             elseif(inp==3) rms=[rms i2];
%             else rms=[rms i1 i2];
%             end
%         end
%     end;
% end

function[rms]=RmBeesGraphical(cs,bads,fnum,hd)
rms=[];
h=[];
while 1
    figure(fnum)
    subplot(hd)
    hold on
    title('click top left of box; return end and bottom right of box')
    xlabel('bees inside  (*) to be removed; return end')
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

function[aRms,arLevel]=RemoveAreas(MeanCol,areas,Cents,EPt,elips,fnm,...
    FrameNum,WhichB,FRLEN,f,fn,vObj,frlist,figlist)
nPl=2;
figure(figlist(3)),
clf
ax(1)=subplot(nPl+1,1,1);
hist(areas,40)
xlabel('areas');axis tight;hold on
ax(2)=subplot(nPl+1,1,2);
plot(areas,MeanCol,'o')
xlabel('areas');
ylabel('bee colour');
axis tight;hold on
for i=1:nPl
    yl(i,:)=ylim(ax(i));
end

aRms=[];
h=[];
arLevel=[];
save(fnm,'arLevel','aRms','-append');
% flag that says all bees have been removed
nobflag=0;
while 1
    if(isempty(arLevel))
        arLevel=ForceNumericInput('enter area cutoff; return to skip:  ');
    elseif(nobflag==1)
        disp(['AREA ' int2str(arLevel) ' TOO HIGH; NO BEES LEFT!!']);
        arLevel=ForceNumericInput(['enter area cutoff below ' int2str(arLevel) ': '],1);
        nobflag=0;
    else
        arLevel=ForceNumericInput(['enter area cutoff; currently ' ...
            int2str(arLevel) '; return end:  ']);
    end
    if(~isempty(arLevel))
        delete(h);
        aRms=RemoveDataSel(areas,arLevel,0,Cents,EPt,elips,...
            FrameNum,WhichB,fn,vObj);
        PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,aRms,figlist([1 2]),f,frlist);
        figure(figlist(3));
        for i=1:nPl
            h(i)=plot(ax(i),[arLevel arLevel],yl(i,:),'r');
        end 
        subplot(nPl+1,1,nPl+1);
        [num_b,fra]=NumBLeft(FrameNum,frlist,aRms);
        plot(fra,num_b)
        % check all bees haven't been removed; if so, reset
        if(sum(num_b)==0)
            nobflag=1;
        else    
            save(fnm,'arLevel','aRms','-append');
        end
    else
        break;
    end
end
for i=1:nPl
    subplot(ax(i));
    hold off;
end
end

function[nb,fr]=NumBLeft(FrameNum,vals,aRms)
gs=setdiff(1:length(FrameNum),aRms);
[nb,fr]=Frequencies(FrameNum(gs),vals);
end

function[aRms]=RemoveDataSel(areas,arLevel,OvOrUnd,Cents,EPt,elips,...
    FrameNum,WhichB,fn,vObj)
if(OvOrUnd)
    aRms=find(areas>=arLevel);
else
    aRms=find(areas<arLevel);
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


function[shads,sLevel]=RemoveShadows(MeanCol,areas,Cents,EPt,EndPt,elips,...
    fnm,FrameNum,WhichB,FRLEN,fn,vObj,frlist,f,figlist)

nPl=2;
figure(figlist(3))
clf
ax(1)=subplot(nPl+1,1,1);
hist(MeanCol,40)
xlabel('bee colour')
axis tight;hold on
ax(2)=subplot(nPl+1,1,2);
plot(areas,MeanCol,'o')
xlabel('areas');
ylabel('bee colour')
axis tight;hold on
for i=1:nPl-1
    yl(i,:)=ylim(ax(i));
end
yl(nPl,:)=xlim(ax(nPl));

shads=[];
s=[];
sLevel=200;
h=[];

% flag that says all bees have been removed
nobflag=0;
while 1    
    if(isempty(s))
        s=input('enter shadow level; return to skip: ');
    elseif(nobflag==1)
        disp(['SHADOW LEVEL ' int2str(s) ' TOO LOW; NO BEES LEFT!!']);
        s=ForceNumericInput(['enter shadow level; currently ' int2str(s) ': '],1);
        nobflag=0;
    else
        s=input(['enter shadow level; currently ' int2str(s) '; return end: ']);
    end

    if(~isempty(s))
        sLevel=s;
        shads=RemoveDataSel(MeanCol,sLevel,1,Cents,EPt,elips,...
            FrameNum,WhichB,fn,vObj);
        
        % plot the rest of the bees
        hs=PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,shads,figlist(1:2),f,frlist);
        % plot the line on the graph
        delete(h);
        figure(figlist(3));
        for i=1:nPl-1
            h(i)=plot(ax(i),[sLevel sLevel],yl(i,:),'r');
        end
        h(nPl)=plot(ax(nPl),yl(nPl,:),[sLevel sLevel],'r');
        subplot(nPl+1,1,nPl+1);
        [num_b,fra]=NumBLeft(FrameNum,frlist,shads);
        plot(fra,num_b)
        
        % plot the most shadow-like bee
        if(sum(num_b)==0)
            nobflag=1;
        elseif(isempty(shads)) 
            disp(['no bees above ' int2str(s) '; enter >=200 to not process shadows']);
            figure(1)
            subplot(hs(1));
            title(['no bees above ' int2str(s) '; enter >=200 to not process shadows']);
        else
            [m,i]=min(MeanCol(shads));
            ind=shads(i(1));
            figure(figlist(4))
            fr=floor(0.5*(FrameNum(ind)+1));
            f=MyAviRead(fn,fr,vObj);
            imagesc(f);
            plotb(ind,Cents,EPt,EndPt,elips,'g')
        end
    else
        break;
    end
end
if(isempty(shads))
    sLevel=min(sLevel,200);
end
save(fnm,'sLevel','shads','-append');
for i=1:nPl
    subplot(ax(i));
    hold off;
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

function[NinFr]=NumInFrame(FrameNum,frtocheck)

for i=1:length(frtocheck)
    NinFr(i)=sum(FrameNum==frtocheck(i));
end
end

function[hs]=PlotManyBees(Cents,EPt,FrameNum,WhichB,FRLEN,rms,fnum,f,frlist)
cs = ['b';'g';'r';'c';'y'];
count=1;
str=[];
chstr='CHECK AS DOUBLE BEES';
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

for i=1:length(ilist)
    ks = find(WhichB==ilist(i));
    ks = intersect(goods,ks);
    NinFr=NumInFrame(FrameNum(goods),FrameNum(ks));
    is=ks(1:x:end);
    col=cs(mod(i,5)+1,:);
    hold on;
    %for is=1:n
    plot(EPt(is,1),EPt(is,2),[col '.'])
    plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
    %     sbit=[int2str(i) ': ' col ' ' int2str(length(is)) ' ' num2str(FrameNum(is(1))*FRLEN)];
    sbit=[int2str(ilist(i)) ': ' col ' ' int2str(length(is)) '/' ...
        int2str(sum(NinFr>1)) ' ' int2str(FrameNum(is(1)))];
    str=[str sbit '; '];
    if(sum(NinFr>1)==length(ks))
        chstr=[chstr ' ' int2str(ilist(i))];
    end
    strL=strvcat(strL,  sbit);
    text(Cents(is(1),1),Cents(is(1),2),int2str(ilist(i)),'Color',col)
end
title('data to be used')
xlabel(str)
WriteFileNames(strL,3)
disp(' ');
disp(chstr)
disp(' ');
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
    for i=ilist
        ks = find(WhichB==i);
        ks = intersect(rms,ks);
        is=ks(1:x:end);
        col=cs(mod(count,5)+1,:);
        hold on;
        plot(EPt(is,1),EPt(is,2),[col '.'])
        plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
%         str=[str int2str(i) ': ' col ' ' int2str(length(is)) ' ' num2str(FrameNum(is(1))*FRLEN) '; '];
%         strL=strvcat(strL,  [int2str(i) ': ' col ' ' int2str(length(is)) ' ' ...
%             num2str(FrameNum(is(1))*FRLEN)]);
%         text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
        count = count + 1;
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


function[edges,xLevel]=RemoveEdges(Cents,EPt,EndPt,elips,fnm)
edges=[];
xLevel=2000;
while 1
    s=input('enter edge level; return to skip');
    if(~isempty(s))
        xLevel=s;
        if(xLevel>700) edges=find(Cents(:,1)>=xLevel)';
        else edges=find(Cents(:,1)<=xLevel)';
        end
    else break;
    end
end
save(fnm,'xLevel','edges','-append');
end

function plotb(is,c1,e1,e2,ell,col)
bw=50;
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