% function to darw bar chart with error bars held in E. if X is empty uses 
% X=1:length(Y). Width defaults to 0.5* width bar, Col defaults to blue
% function BarErrorBar(X,Y,E,Width,Cols)

function[h]=BarErrorBar(X,Y,E,BarWidth,ErrWidth,col)

if(nargin<6) col='b' ; end
if((nargin<5)||isempty(ErrWidth)) ErrWidth=0 ; end
if((nargin<4)||isempty(BarWidth)) BarWidth=0.8 ; end
if(isempty(X)) X=1:length(Y); end
ph=bar(X,Y,BarWidth);
h=gca;
YUp=Y+E;
hold on;
for i=1:length(ph)
    x=get(get(ph(i),'Children'),'XData');
    if(size(col,1)>1)
        set(ph(i),'FaceColor',col(2,:));
    end
    xs=mean(x);%([1 3],:));
    if(ErrWidth==0) Wid=0.33*mean(x(3,:)-x(1,:));
    else Wid=0.5*ErrWidth;
    end
    for j=1:length(xs)
        % vertical lines
        plot([xs(j) xs(j)],[Y(j,i) YUp(j,i)],col(1,:));
        % horizontal lines
        plot([xs(j)-Wid xs(j)+Wid],[YUp(j,i) YUp(j,i)],col(1,:));
    end
end
hold off
