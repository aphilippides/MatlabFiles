% function DrawLengthBar(AxHdl,BarLen,XPos,YPos,Col,Thickness)
% function darws a bar of length BarLen*(X-axis length) at position (Xpos,YPos)
% in coloir Col and thickness Thickness

function DrawLengthBar(AxHdl,BarLen,XPos,YPos,Col,Thickness)

X=get(AxHdl,'XLim');
Y=get(AxHdl,'YLim');
x1=XPos*(X(2)-X(1))+X(1);
x2=x1+BarLen*(X(2)-X(1));
y=YPos*(Y(2)-Y(1))+Y(1);
hold on;
plot([x1 x2],[y y],Col,'LineWidth',Thickness)
hold off