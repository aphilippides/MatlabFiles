function RemoveAllShadows(fn,imn)%,pn)
load(fn) 
figure(1),hist(MeanCol,40)
shads=[];
sLevel=200;
goods=1:size(Cents,1);
while 1
    s=input('enter shadow level; return to skip');
    if(~isempty(s))
        sLevel=s;
        shads=find(MeanCol>=sLevel);
        if(isempty(shads)) 
            sLevel=200;
            break;
        end
        [m,i]=min(MeanCol(shads));
        ind=shads(i(1));
        figure(2)
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead(imn,fr,1);
        imagesc(f);
        plotb(ind,Cents,EPt,EndPt,elips,'g')
    else break;
    end
end
goods=setdiff([1:length(MeanCol)],shads);

if(isempty(shads)) return; end;
cfn=[fn(1:end-4) 'OLD.mat'];
if(~isfile(cfn)) copyfile(fn,cfn); end;
save(cfn,'sLevel','shads','-append');
FrameNum=FrameNum(goods);
Areas=Areas(goods);
WhichB=WhichB(goods);
MeanCol=MeanCol(goods);
Cents=Cents(goods,:);
Orients=Orients(goods);
EndPt=EndPt(goods,:);
Bounds=Bounds(goods,:);
NLess=NLess(goods);
area_e=area_e(goods);
EPt=EPt(goods,:);
elips=elips(goods);
odev=odev(goods);
ang_e=ang_e(goods);
len_e=len_e(goods);
eccent=eccent(goods);

% save([pn 'SLev.mat'],'sLevel','shads');
save(fn,'FrameNum','MeanCol', 'WhichB','sLevel','shads', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent');

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