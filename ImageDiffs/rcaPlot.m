function rcaPlot(s,gap,goal,c)
if(nargin<3) c='b'; end; 
[w,h]=size(s);

mins=min(s')'*ones(1,h);
maxes=max(s')'*ones(1,h)-mins;
s=(s-mins)./maxes;

news=s+gap*[0:(w-1)]'*ones(1,h);
[errs,errvals,otherms]=GetRCAErrsNM(news,goal,0.05,0,3);

is=[181:360 1:180];
plot(-180:179,news(:,is)',c,errs,errvals,[c 's']),
hold on
for i=1:length(otherms)
    plot(otherms(i).angs,otherms(i).vs,[c 'o'])
end
hold off
axis tight
Setbox,xlabel('azimuth'),ylabel('Error (normalised and shifted)')