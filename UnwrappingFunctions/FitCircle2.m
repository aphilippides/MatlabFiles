function [c,rad] = FitCircle2(im,sp,axw)
clf
imagesc(im);
if(nargin==3) 
    axis(axw); 
end;
axis equal;
hold on;
if(nargin<2)
    [c,rad]=GetStartPoint;
else
    c=sp(1:2);
    rad=sp(3);
    t=pi/2;
end
MyCircleLocal(c(1),c(2),rad,'r');
plot(c(1),c(2),'r.');
hold off;

[c,rad]=AdjustCircle(im,c,rad);

function[c,rad]=AdjustCircle(im,c,rad,str)
imagesc(im)
axis equal
if(nargin>3)
    xlabel(str);
end
hold on;
col='w';
if(nargin>2)
    h=MyCircleLocal(c,rad,col);
    h=[h;plot(c(1),c(2),[col 'x'],'MarkerSize',10)];
else
    h=[];    
end
pwadd=0.25;
while 1
    r=rad*1.2;
    axis([c(1)-r c(1)+r c(2)-r c(2)+r])
    title('click position; cursors move x; [ or ]: change radius x; x set x; return end')
    [x,y,b]=ginput(1);
    if(isempty(x))
        delete(h);
        break;
    elseif(b==30) % up cursor
        c(2)=c(2)-pwadd;
    elseif(b==31) % down cursor
        c(2)=c(2)+pwadd;
    elseif(b==28) % left cursor
        c(1)=c(1)-pwadd;
    elseif(b==29) % right cursor
        c(1)=c(1)+pwadd;
    elseif(b==93) % right bracket ]
        rad=rad+pwadd;
    elseif(b==91) % left bracket [
        rad=max(rad-pwadd,1);
    elseif(b==120) % x
        pwadd=input(['x = ' num2str(pwadd) '; enter new value: ']);
    else
        c=[x y];
    end
    delete(h);
    h=MyCircleLocal(c,rad,col);
    h=[h;plot(c(1),c(2),[col 'x'],'MarkerSize',10)];
end
hold off;


function[c,rad]=GetStartPoint
title('Click 7 points on the radius')
[x,y]=ginput(7);
% solve
abc=pinv([x,y,ones(size(x))])*(x.^2+y.^2);

c=[abc(1)/2,abc(2)/2];
rad=mean(sqrt((x-c(1)).^2+(y-c(2)).^2));

% function[lhdl] = MyCircleLocal(x,y,Rad,col,NumPts,fillc)
%
% Function draws circles of radius Rad(i) at x(:,i),y(:,i). 
% col is colour, NumPts the number of points to draw the circle
% defaults are blue and 50 and fills it if fillc = 1 (default 0)
%
% if x is a 2D row vector, it uses x as position and other parameters 
% shift across one eg y is rad
%
% function returns ldhl, handles to the lines
function[lhdl] = MyCircleLocal(x,y,Rad,col,NumPts,fillc)
ho=ishold;
if(size(x,2)==2)
    if(nargin<5) 
        fillc=0;
    else
        fillc=NumPts;
    end
    if((nargin<4)||isempty(col)) 
        NumPts=50;
    else
        NumPts=col;
    end;
    if(nargin<3) 
        col = 'b';
    else
        col=Rad;
    end;
    Rad=y;
    y=x(:,2);
    x=x(:,1);
else
    if(nargin<6) 
        fillc=0; 
    end;
    if((nargin<5)||isempty(NumPts)) 
        NumPts=50; 
    end;
    if(nargin<4) 
        col = 'b'; 
    end;
end

Thetas=0:2*pi/NumPts:2*pi;
lhdl=zeros(length(Rad));
if(size(col,1)==1)
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col);
            hold on;
        end
        lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col);
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col);
        hold on
    end
else
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col(i,:));
            hold on;
        end
        lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col(i,:));
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col(i,:));
        hold on
    end
end
if(~ho) 
    hold off; 
end;
