function RemoveAllEdges(fn,imn)
im=MyAviRead(imn,1,1);
load(fn) 
if(max(NumBees)<=1)return; end;

goods=1:size(Cents,1);
while 1
    imagesc(im)
    hold on;
    plot(EPt(goods,1),EPt(goods,2),'b.')
    plot([Cents(goods,1) EPt(goods,1)]',[Cents(goods,2) EPt(goods,2)]','b')
    hold off
    s=input('enter good area as [x1 x2 y1 y2]; return to end');
    if(~isempty(s))
        if(length(s)==4) 
            goods=find((Cents(:,1)>=s(1))&(Cents(:,1)<=s(2)) ...
                &(Cents(:,2)>=s(3))&(Cents(:,2)<=s(4)));
            EdgeOut=s;
        end
    else break;
    end
end

if(~exist('EdgeOut')) return; end;
copyfile(fn,[fn(1:end-4) 'OLD.mat']);
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

save(fn,'FrameNum','MeanCol', 'WhichB','EdgeOut', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent');