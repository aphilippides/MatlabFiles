function DrawCompass(NAng,col,lc)

if((nargin<1)||isempty(NAng)) 
    NAng=4.9393; 
end;
if(nargin<2) 
    col='k'; 
end; 
set(gca,'YDir','reverse'); 
a=axis;
xl=a(2)-a(1);
yl=a(4)-a(3);
sx=a(1)+0.1*xl;
sy=a(3)+0.1*yl;
if((nargin<3)||isempty(lc)) 
    lc = yl*0.1; 
end;
[ex ey]=pol2cart(NAng,lc);  
% [ex ey]=pol2cart(-1.3434,lc);  
hold on;
plot([sx sx+ex],[sy sy+ey],col,'LineWidth',1.5)
text(sx+ex,sy+ey*1.3,'N','Color',col);
text(sx,sy,'S','Color',col);
if(~ishold(gca)) 
    hold off; 
end;
