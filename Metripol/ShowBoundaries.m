function[B] = ShowBoundaries(BW,col)
if(nargin<2) col = 'b'; end;
B = bwboundaries(BW);
for k=1:length(B),
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), col,'LineWidth',0.5);
    hold on
end
hold off