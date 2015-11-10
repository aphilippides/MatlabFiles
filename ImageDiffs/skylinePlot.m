function skylinePlot(s,gap,c)
if(nargin<3) c='b'; end; 
[w,h]=size(s);
news=s+gap*[0:(w-1)]'*ones(1,h);
% is=[181:360 1:180];
is=[1:360];
plot(-179:180,news(:,is)',c)
set(gca,'YDir','reverse')
axis tight
Setbox,xlabel('azimuth')
