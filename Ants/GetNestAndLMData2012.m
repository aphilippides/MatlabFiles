% function GetNestAndLMData(f)
%
% function to interactively get position of nest and landmark in file f
% (entered as a string without the .avi extension)
%
% Allows picking to initialise from a previous file
%
% USAGE:
%
% eg:   GetNestAndLMData('90_21_out10')

function[fn,rep]=GetNestAndLMData2012(f,dat,flist,CalList,vO,exptype,Check)

fn=[f 'NestLMData.mat'];
ff=[f '.avi'];

rep=-1;
AxX=[1 1440 1 810];

disp(' ')
disp(['nest and Lm for file ' f])
disp(' ')
if(nargin<7)
    Check=0;
end

if(isfile(fn))
    if(Check)
        [vO,vObj]=VideoReaderType(ff);
% 
%         if(vO)
%             vObj=VideoReader(ff);
%         else
%             vObj=[];
%         end

        load(fn)
        im=MyAviRead(ff,refim,vObj);
        imagesc(im);
        PlotStuff(im,nest,LM,NestWid,LMWid,AxX,cmPerPix,exptype);
        title(['frame: ' int2str(refim) ' should be no bee; Cal file' CalibFile])
        if(dat.ftype>3)
            xlabel(['Nest file is ' NestFile])
        end
        disp([fn ' already exists']);
        inp=input('Type 0 to overwrite:  ');
        if(isempty(inp)||(inp~=0))
            rep=1;
            return;
        end;
        if(dat.ftype>3)
            [NestPos,NestWid,NestFile]=GetNestFile(flist,dat);
            disp(' ')
        else
            NestPos=-1;
            NestFile=-2;
        end       
    else
        return;
    end
else
    [vO,vObj]=deal(0,[]);%VideoReaderType(ff);

    % get the calibration file
    CalibFile=GetCalibrationFile(CalList,dat);
    if(CalibFile==-1)
        keyboard
    else
        load(CalibFile)
    end
    disp(' ')
    if(dat.ftype>3)
        [NestPos,NestWid,NestFile]=GetNestFile(flist,dat);
        disp(' ')
    else
        NestPos=-1;
        NestFile=-2;
    end
end
[avf,lastframe]=MyAviInfo(ff);

if(dat.ftype==2) 
    % L flight
    refim=lastframe;
else
    refim=1;
end

% pick the frame with/without a bee
FirstTime=1;
while 1
    im=MyAviRead(ff,refim,vObj);
    imagesc(im);
    title(fn)
%     axis(AxX); 
    axis equal;
    xlabel(['Frame ' int2str(refim) ' out of ' int2str(lastframe)])
    a=input('return if no bee, frame number; negative to redo:  ');
    if(isempty(a)) 
        break;
    elseif(a>0) 
        refim=a;
    elseif(FirstTime)
        refim=lastframe;
        FirstTime=0;
    else
        refim=mod(refim+10,lastframe);
    end
end

% Initialise from a previous file and get the nest position if not known
if(isfile(fn))
    Picked=fn;
else
    Picked=InitFile(flist,dat);
end
imagesc(im);
% axis(AxX);
AxX=axis;
axis equal;
if(ischar(Picked)) 
    load(Picked,'LM','LMWid','nest','NestWid');
else
    % Get each Landmark 
    disp(' ');
    disp('click in figure window to select LMs')
    if(exptype~=3)
        title('Click centre of each LM then return');
        [x,y]=ginput(dat.nlm);
        X=[x y];
        LM=X(LMOrder2012(X),:);
        if(exist('cmPerPix','var'))
            LMWid=ones(dat.nlm,1)*dat.lmw/cmPerPix;
        else
            title('Click 4 points on top of LM for width estimates')
            [x,y]=ginput(4);
            X=[x y];
            ds=diff(X);
            d=sqrt(sum(ds.^2,2));
            LMWid=ones(dat.nlm,1)*mean(d([1 3]));
            cmPerPix=dat.lmw/LMWid(1);
        end
    elseif(exptype==3)
        title('Click the bottom right corners of the board');
        [x,y]=ginput(dat.nlm);
        X=[x y];
        LM=X(LMOrder2012(X),:);
        LMWid=NaN*ones(dat.nlm,1);
    end

    % get nest position if learning/return
    if(dat.ftype<4)
        x=[];
        while(length(x)~=5)
            disp(' ');
            disp('Click 5 points in figure window to get nest')
            disp('centre of nest then 4 points for width estimates')
            title('Click centre of nest then 4 points for width estimates')
            [x,y]=ginput(5);
        end
        X=[x y];
        nest=X(1,:);
        ds=diff(X);
        d=sqrt(sum(ds.^2,2));
        NestWid=mean(d([2 4]));
    end
end

nlm=size(LM,1);
mlp=ceil(nlm/2);
if(isfield(dat,'NestVec'))
    NestVec=dat.NestVec;
else
    NestVec=[20 0];
end
% set/overwrite Nest Position from NestFile
if(dat.ftype>=4)
    if(NestPos==-1)
        % guesstimated nest position
        nest=LM(mlp,:)+NestVec/cmPerPix;
        NestWid=0.5/cmPerPix;
        disp('this shouldn''t be happening')
        keyboard;
    else
        % nest position defined by previously experienced flight
        nest=mean(LM+NestPos,1);
    end
end

asone=0;
while 1
    PlotStuff(im,nest,LM,NestWid,LMWid,AxX,cmPerPix,exptype);
    if(asone)
        xlabel('return end; l move LMs singly; a change axis')%r rescale;
    else
        xlabel('return end; l move LMs together; a change axis')%r rescale; 
    end
    if(dat.ftype<4)
        pts=[LM;nest];
        ptWid=[LMWid;NestWid];
    else
        pts=LM;
        ptWid=LMWid;
    end
    [adj,b,x,y]=GetNearestClickedPt(pts);
    if(adj==0) 
        break;
    elseif(b==108)
        asone=mod(asone+1,2);
    elseif(b==97)
%             axis auto
%             axis equal
        while 1
            AxX=input('pick new axes format [x1 x2 y1 y2]');
            if(isequal(size(AxX),[1 4])) 
                break; 
            end;
        end        
    else
        if(exptype==3)
            if(adj==1)
                oth=2;
            else
                oth=1;
            end
            [pts(adj,:),dum,d]=GetNewPoint(pts(adj,:),10,x,y,exptype,pts(oth,:));
        else
            [pts(adj,:),ptWid(adj),d]=GetNewPoint(pts(adj,:),ptWid(adj),x,y,exptype);
        end
        if(adj<=nlm)
            ptWid(1:nlm)=ptWid(adj);
            if(asone)
                inds=[1:adj-1 adj+1:nlm];
                for k=inds
                    pts(k,1)=pts(k,1)+d(1);
                    pts(k,2)=pts(k,2)+d(2);
                end
            end
        end
%         [pts(adj,:),ptWid(adj)]=GetNewPointOld(pts(adj,:),ptWid(adj));
    end;
    LM=pts(1:nlm,:);
    LMWid=ptWid(1:nlm);
    % set/overwrite Nest Position from NestFile
    if(dat.ftype<4)
        nest=pts(end,:);
        NestWid=ptWid(end);
    else
        if(NestPos==-1)
            % guesstimated nest position
            mlp=ceil(nlm/2);
            nest=LM(mlp,:)+NestVec/cmPerPix;
            NestWid=0.5/cmPerPix;
            disp('this shouldn''t be happening')
            keyboard;
        else
            % nest position defined by previously experienced flight
            nest=mean(LM+NestPos,1);
        end
    end
    save(fn,'nest','LM','LMWid','NestWid','refim','NestFile','NestPos',...
        'NestVec','CalibFile','rul','calibim','comp','cmPerPix','compassDir')
end
imcmPerPix=dat.lmw/LMWid(1);
save(fn,'nest','LM','LMWid','NestWid','refim',...
    'NestFile','NestPos','imcmPerPix','NestVec',...
    'CalibFile','rul','calibim','comp','cmPerPix','compassDir')

function[p,pw,d]=GetNewPoint(p,pw,x,y,exptype,pws)
oldp=p;
hold on;
col='g';
% if(nargin>2)
p=[x y];
if(exptype==3)
    h=plot([p(1) pws(1)],[p(2) pws(2)],[col '-x'],'LineWidth',1); 
else
    h=MyCircle(p,pw/2,col);
    h=[h;plot(p(1),p(2),[col 'x'])];
end
% else
%     h=[];    
% end
mm=2.5;
if(exptype==3)
    mma=50;
else
    mma=25;
end
pwadd=0.5;
a1=p-max(mm*pw,mma);
a2=p+max(mm*pw,mma);
axis([a1(1) a2(1) a1(2) a2(2)])
while 1
    title('click position; cursors move x; [ or ] dec/increase radius; a set axis; return end')
    [x,y,b]=ginput(1);
    if(isempty(x))
        d=p-oldp;
        delete(h);
        break;
    elseif(b==30) % up cursor
        p(2)=p(2)-pwadd;
    elseif(b==31) % down cursor
        p(2)=p(2)+pwadd;
    elseif(b==28) % left cursor
        p(1)=p(1)-pwadd;
    elseif(b==29) % right cursor
        p(1)=p(1)+pwadd;
    elseif(b==93) % right bracket ]
        pw=pw+pwadd;
    elseif(b==91) % left bracket [
        pw=max(pw-pwadd,1);
%     elseif(b==110) % n
%         pwadd=input(['n = ' num2str(pwadd) '; enter new value: ']);
    elseif(b==97) % a
        mma=input(['axis width = ' int2str(mma) '; enter new value: ']);
    else
        p=[x y];
    end
    delete(h);
    if(exptype~=3)
        h=MyCircle(p,pw/2,col);
        h=[h;plot(p(1),p(2),[col 'x'])];
    elseif(exptype==3)
        h=plot([p(1) pws(1)],[p(2) pws(2)],[col '-x'],'LineWidth',1); 
    end
    a1=p-max(mm*pw,mma);
    a2=p+max(mm*pw,mma);
    axis([a1(1) a2(1) a1(2) a2(2)])
end
hold off;

function[nestpos,nestw,nestf]=GetNestFile(flist,dat)
nestpos=-1;
nestw=-1;
nestf=-1;
disp(['get nest file for: ' dat.name]);
if(isempty(flist))
    disp('Dont know file for nest position. All files: ')
    WriteFileOnScreen(dir('*.avi'),2);
    keyboard;
    return
end

% find ones which aren't tests
notest=find([flist.ftype]<4);
% find matching bees
samebee=strmatch(dat.bee,{flist.bee},'exact');
poss=intersect(samebee,notest);
if(isempty(poss))
    disp('Dont know file for nest position. All files: ')
%     WriteFileOnScreen(dir('*.avi'),2);
%     keyboard;
    disp('  ');
    WriteFileOnScreen(flist,1);
    disp(' ');
    pic=ForceNumericInput(['select a file for ' dat.name ': '],1,1);
    nestf=[flist(pic).name(1:end-4) 'NestLMData.mat'];
    disp(['using nest file ' nestf]);
    load(nestf);
%     keyboard
    % need to get rel position of nest from LMs
    nestpos=[nest(1)-LM(:,1) nest(2)-LM(:,2)];  
    nestw=NestWid;
else
    flist=flist(poss);
    WriteFileOnScreen(flist,1);
    pic=input('select a file: ');
    nestf=[flist(pic).name(1:end-4) 'NestLMData.mat'];
    disp(['using nest file ' nestf]);
    load(nestf);
%     keyboard
    % need to get rel position of nest from LMs
    nestpos=[nest(1)-LM(:,1) nest(2)-LM(:,2)];  
    nestw=NestWid;
end

function[fl]=InitFile(flist,dat)
disp(['Initialise file for: ' dat.name]);
if(isempty(flist))
    fl=-1;
    return;
end

WriteFileOnScreen(flist,2);
if(flist(end).nlm==dat.nlm)
    fl=flist(end).name;
else
    fl=[];
end
disp(' ');
disp(['Using file ' fl ';']);
pic=input('return ok; 0 dont initialise; number=another file: ');
if(isempty(pic))
    if(isempty(fl))
        disp('No calibration file picked');
        fl=-1;
    end
elseif(isequal(pic,0))
    fl=-1;
else
    fl=flist(pic).name;
end
if(fl~=-1)
    fl=[fl(1:end-4) 'NestLMData.mat'];
end

function[p,pw]=GetNewPointOld(p,pw)
disp('may need debugging. See GetNewPoint')

mm=4;
mma=25;
a1=p-max(mm*pw,mma);
a2=p+max(mm*pw,mma);
axis([a1(1) a2(1) a1(2) a2(2)])
hold on;
h=[];
while 1
    disp(['Current point is (x,y,wid): ' num2str(p(1,1),4) ' ' num2str(p(1,2),4) ' ' num2str(pw,4)])
    inp =input('Enter new point [x,y,wid] or return : ');
    if(~isequal(size(inp),[1 3]))
        delete(h);
        break;
    end
    p=inp([1 2]);
    pw=inp(3);
    delete(h);
    h=MyCircle(p,pw/2,'b');
    a1=p-max(mm*pw,mma);
    a2=p+max(mm*pw,mma);
    axis([a1(1) a2(1) a1(2) a2(2)])
end
hold off;


function PlotStuff(im,nest,LM,NestWid,LMWid,AxX,cmPerPix,exptype)
imagesc(im);
axis(AxX);
axis equal;
title('Order: nest; LM; nest width, LM width')
hold on;
plot(nest(1),nest(2),'bx')
nhdl=MyCircle(nest,NestWid/2,'b');
set(nhdl,'LineWidth',1)
% standard experiment
if(exptype~=3)          
    lmw=LMWid(1)*cmPerPix;
    ylabel(['LM w=' num2str(lmw)])
    plot(LM(:,1),LM(:,2),'rx')
    MyCircle(LM,LMWid/2,'r');
elseif(exptype==3) 
    % board experiment
    plot(LM(:,1),LM(:,2),'r-x','LineWidth',1)  
    blen=CartDist(LM(1,:)-LM(2,:))*cmPerPix;
    ylabel(['board length =' num2str(blen)]) 
end
hold off;