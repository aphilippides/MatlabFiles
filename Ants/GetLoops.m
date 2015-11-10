function[loops,Picked]=GetLoops(cs,ds,t,in,sOr,fdir,c_o,plo,fn,e1,LM,LMWid,nest)

loops=[];
Picked=[];

if(in) 
    revd=ds(end:-1:1);
    sp=length(t)-find(revd>5,1)+1;
    is=1:sp;
else
    is=find(ds>5,1):length(t);
end
if(isempty(is)) return; end;

tlim=[0.1 4.005];
c=1;
for i=1:(length(is)-1)
    t1=t(is(i));
    js=GetTimes(t(1:end-1),t1+tlim);
    co=c;
    for j=js
        if(isCross(cs(is(i):is(i)+1,:),cs(j:j+1,:)))
            loops(c).sp=is(i);%cs(is(1),:);
            loops(c).ep=j+1;%cs(j+1,:);
            loops(c).is=is(i):j+1;
            loops(c).fn=fn;
            loops(c).iall=is;
            ds=CartDist(cs(loops(c).is),cs(is(i)));
            loops(c).len=max(ds);
            loops(c).picked=0;
            c=c+1
        end
    end
    %     sp=loops(co:c-1).sp;
    %     ep=loops(co:c-1).ep;
    %     plot(cs(is(i):js(1),1),cs(is(i):js(1),2),'k- .',...
    %         cs(js,1),cs(js,2),'r- .');
    %     hold on,
    %     for k=co:c-1
    %         lo=[loops(k).is];
    %         plot(cs(lo,1),cs(lo,2),'b:o')
    %     end
    %     hold off
end
% plot(cs(is,1),cs(is,2),'r- .');
% hold on,
nc=c-1;
Picked=zeros(1,nc);
curr=1;
edg=5;
if(plo)
    while 1
%     for k=1:c-1
        lo=[loops(curr).is];
        i2=max(1,lo(1)-edg):min(length(is),lo(end)+edg);
        figure(1)
        PlotNestAndLMs(LM,LMWid,nest,0);
        hold on
        plot(cs(is,1),cs(is,2),'r-',cs(i2(1),1),cs(i2(1),2),'rs')%,'MarkerFaceColor','r')
        text(cs(i2(1),1),cs(i2(1),2),'S')
        lo2=lo(1):4:lo(end);
        if(Picked(curr))
            plot(e1(lo2,1),e1(lo2,2),'b.',[cs(lo2,1) e1(lo2,1)]',[cs(lo2,2) e1(lo2,2)]','b',cs(lo,1),cs(lo,2),'b')
            title([fn ': loop ' int2str(curr) '/' int2str(nc) '; SELECTED'],'Color','b')
        else
            plot(e1(lo2,1),e1(lo2,2),'r.',[cs(lo2,1) e1(lo2,1)]',[cs(lo2,2) e1(lo2,2)]','r')
            title([fn ': loop ' int2str(curr) '/' int2str(nc) ],'Color','r')
        end
        axis equal,
        hold off
        figure(2)
        subplot(3,1,1)
%         plot(t(i2),sOr(i2),'r- .',t(lo),sOr(lo),'b:o')
        plot(t(i2),AngleWithoutFlip(sOr(i2)),'r- .',t(lo),AngleWithoutFlip(sOr(lo)),'b:o')
        ylabel('Body orient'),axis tight,title(fn)
        subplot(3,1,2)
        plot(t(i2),AngleWithoutFlip(c_o(i2)),'r- .',t(lo),AngleWithoutFlip(c_o(lo)),'b:o')
        ylabel('Flight Dir'),axis tight,
        subplot(3,1,3)
        plot(t(i2),fdir(i2),'r- .',t(lo),fdir(lo),'b:o')
        ylabel('Rel Flight dir'),axis tight,
        disp(' ');
        disp('enter 1 to select/deselect; return continue;');
        inp=input('u to go back one file; n for next file:    ','s');
        if(isempty(inp)) curr=curr+1;
        elseif(isequal(inp,'u')) curr=curr-1;
        elseif(isequal(inp,'n')) break;
        elseif(isequal(str2num(inp),1))
            Picked(curr)=mod(Picked(curr)+1,2);
%             curr=curr+1;
        end
        curr=min(nc,max(1,curr));
    end
end
% hold off

% [idx,c]=kmeans([sin(sOr') sin(Cent_Os) (Speeds-mean(Speeds))/std(Speeds)],3)
% for i=1:3
% is=find(idx==i);
% plot3(sOr,Cent_Os,Speeds,'o');
% hold on
% plot3(sOr(is),Cent_Os(is),Speeds(is),'ro')
% hold off
% pause
% end
% [idx,c]=kmeans([(sOr') (Cent_Os) (Speeds)],3)


function[cr]=isCross(l1,l2)

x1=l1(1,1); y1=l1(1,2);
x2=l1(2,1); y2=l1(2,2);
x3=l2(1,1); y3=l2(1,2);
x4=l2(2,1); y4=l2(2,2);

[x,y]=IntersectionPoint(x1,x2,x3,x4,y1,y2,y3,y4);

cr=0;
if((x>=min(x1,x2))&&(x<=max(x1,x2)))
    if((y>=min(y1,y2))&&(y<=max(y1,y2)))
        if((x>=min(x3,x4))&&(x<=max(x3,x4)))
            if((y>=min(y3,y4))&&(y<=max(y3,y4))) cr=1; end
        end
    end
end


% % get lowest xs as x1, x3
% if(l1(1,1)<=l1(2,1))
% else
%     x1=l1(2,1); y1=l1(2,2);
%     x2=l1(1,1); y2=l1(1,2);
% end
%
% if(l2(1,1)<=l2(2,1))
% else
%     x3=l2(2,1); y3=l2(2,2);
%     x4=l2(1,1); y4=l2(1,2);
% end


% % xs don't overlap
% if((x3>x2)&&(x4>x2)) return; end;
% if((x3<x1)&&(x4<x1)) return; end;
%
% % ys don't overlap
% if((y3>max(x1,x2))&&(x4>max(x1,x2))) return; end;
% if((x3<min(x1,x2))&&(x4<min(x1,x2))) return; end;
%
% if((y3>min(y1,y2))&&(y4<max(y1,y2)))
%     cr=1;
%     return;
% end;
%
% if((y3<min(y1,y2))&&(y4<max(y1,y2)))
%     cr=1;
%     return;
% end;