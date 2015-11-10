function[h]=CompassAndLine(col,cmPerPix,lc,NAng,barlength)

h=[];
if(nargin<1) col='w'; end; 
a=axis;
set(gca,'YDir','reverse'); 
xl=a(2)-a(1);
yl=a(4)-a(3);
sx=a(1)+0.1*xl;
sy=a(3)+0.1*yl;
if((nargin<2)||isempty(cmPerPix))  
    cmPerPix=1; 
end
% length of the compass
if((nargin<3)||isempty(lc)) 
    lc = yl*0.1; 
end;
if((nargin<4)||(NAng==0)) NAng=4.9393; end;
[ex ey]=pol2cart(NAng,lc);  
% [ex ey]=pol2cart(-1.3434,lc);  
hold on;
h=plot([sx sx+ex],[sy sy+ey],col,'LineWidth',1.5);
h=[h;text(sx+ex,sy+ey*1.3,'N','Color',col)];
h=[h;text(sx,sy,'S','Color',col)];

% bar
if(cmPerPix>0)
    ep=a(2)-0.01*yl;
    if(nargin<5)
        if(size(cmPerPix,1)==2)
            lbar=cmPerPix(1)/cmPerPix(2);
        else
            lbar=10/cmPerPix;
        end;
        while(lbar>(xl*0.6))
            lbar=lbar*0.5;
        end
        h=[h;text(ep-0.55*lbar,sy-0.02*yl,[num2str(lbar*cmPerPix,3) 'cm'],'Color',col)];
    else
        lbar=barlength/cmPerPix;
        h=[h;text(ep-0.55*lbar,sy-0.02*yl,[num2str(barlength,2) 'cm'],'Color',col)];
    end
    h=[h;plot([ep-lbar ep],[sy sy],col,'LineWidth',1.5)];
end
if(~ishold(gca)) 
    hold off; 
end;
axis(a)