function ShowBoundariesB(B,offx,offy,col,LWid)
if(nargin<5) LWid=0.5; end;
if(nargin<4) col = 'b'; end;
if(nargin<3) offx = 0; end;
if(nargin<2) offy = 0; end;
for k=1:length(B),
    boundary = B{k};
    plot(boundary(:,2)+offx, boundary(:,1)+offy, col,'LineWidth',LWid);
    hold on
end
hold off