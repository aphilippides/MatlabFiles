function plotb(is,c1,e1,ell,col,bw)
if(nargin<6) 
    bw=50; 
end;
% if(isempty(is))
if(isequal(is,-1))
    is=1:size(c1,1);
end
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
if(~isempty(ell))
    for i=is
        plot(ell(i).elips(:,1),ell(i).elips(:,2),col)
    end
end
if(bw>0)
    a1=round(mean(c1(is,:),1)-bw);
    a2=round(mean(c1(is,:),1)+bw);
    axis equal
    axis([a1(1) a2(1) a1(2) a2(2)])
end
hold off