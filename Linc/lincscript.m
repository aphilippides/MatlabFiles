function lincscript(x,y)
gn=GetName(x,y)
if(~isfile(gn)) return; end;
% s=dir('2550_0800.jpg');
% fn=(s(1).name);
load(gn)
rs=10:60;
goal=unw(rs,:);
load positions
xs=0:50:2900;
ys=0:50:1750;

for i=1:length(xs)
    i
    for j=1:length(ys)
        fnM(i,j).fn=GetName(xs(i),ys(j));
        if(isfile(fnM(i,j).fn))
            load(fnM(i,j).fn);
%             fnM(i,j).im=unw;
            d(i,j)=sum(sum((unw(rs,:)-goal).^2));
        else
            d(i,j)=NaN;
%             fnM(i,j).im=NaN;
        end
    end
%     save MData fnM
end

save(['Goal' gn], 'd') 
pcolor(d)
% for i=1:length(fs)
%     if(mod(i,100)==0) i
%     end;
%     fn=(fs(i).name);
%     load([fn(1:end-4) '.mat'])
%     d(i)=sum(sum((unw(rs,:)-goal).^2));
% end

function[fn]=GetName(x,y)
fn=[GetN(x) '_' GetN(y) '.mat'];

function[f]=GetN(x)
if(x<10) f=['000' int2str(x)];
elseif(x<100) f=['00' int2str(x)];
elseif(x<1000) f=['0' int2str(x)];
else f=int2str(x);
end