function PlotBee(c,e,plotwid,col)
if(nargin<3) col='b';
elseif(ischar(plotwid))
    col=plotwid;
    plotwid=25;
elseif(nargin<4) col='r'; 
end;

plot([c(:,1) e(:,1)]',[c(:,2) e(:,2)]',[col '-'],...
    e(:,1),e(:,2),[col '.'])
axis equal
if(nargin>=3) 
    if(~isempty(plotwid))
        axis([c(1)-plotwid  c(1)+plotwid c(2)-plotwid c(2)+plotwid])
    end
end;