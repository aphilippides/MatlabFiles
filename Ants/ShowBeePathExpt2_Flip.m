function ShowBeePath(fnm,PrettyPic,x,NestLMfn)
% dwork;
% cd GantryProj\Bees
load(fnm);
i=strfind(fnm,'Path');
fi=fnm(1:i-1);
if(nargin<4) load([fi 'NestLMData.mat']);
else load(NestLMfn);
end

if(nargin < 2) x=1; end
if(nargin < 3) PrettyPic=1; end

figure(1);
hold off;
if(PrettyPic)
    fn=[fi '.avi'];
    f=MyAviRead(fn,1,1);
    imagesc(f);
    hold on;
    MyCircle(nest,NestWid/2,'g');
    for i=1:size(LM,1)
    MyCircle(LM(i,:),LMWid(i)/2,'r');
    end
else
    MyCircle(nest,NestWid/2,'g');
    hold on;
    MyCircle(LM,LMWid/2,'r');
    axis equal
end
[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;
[EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
EPt=EPt+Cents;

cs = ['b';'g';'r';'c';'y'];
ilist=unique(WhichB);
count=1;
str=[];
inp=[];
for i=ilist
    is=[];
    ks = find(WhichB==i);
    is=ks(1:x:end);
    col=cs(mod(count,5)+1,:);
    figure(1);
    hold on;
    %for is=1:n
    plot(EPt(is,1),EPt(is,2),[col '.'])
    plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
    str=[str int2str(i) ' ' col ' ' int2str(length(is)) '; '];
    text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
    %end
    %     for k=1:100:length(is)
    if(isempty(inp)|inp==0)
        figure(2)
        for k=1:4:length(is)
            fr=floor(0.5*(FrameNum(is(k))+1));
            f=MyAviRead(fn,fr,1);
            imagesc(f);
            plotb(is(k),Cents,EPt,EndPt,elips,col)
            inp=input(['FNum=' int2str(FrameNum(is(k))) '; return to continue; 0 to stop; -1 to end']);
            if((inp==0)|(inp==-1)) break; end;
        end
        fl=input('press 1 to flip; else to continue\n');
        if(fl==1) 
            for ind=is
                if(ang_e(ind)>0) ang_e(ind)=ang_e(ind)-pi;
                else ang_e(ind)=ang_e(ind)+pi;
                end
            end
        end
    end
    count = count + 1;
end

t=FrameNum*0.02;
sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,0.1);

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
save(fnm)

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