function NoisePaper(ns)
dwork
cd ../Current/Linc/NoisePaper/noise_results/
cd ev1/
% cd ../n'osiy learn/'
% cd ../'learn run database/'
% cd ../'learn run fan/'
if(nargin<1) ns=40; end;
s=dir(['00' int2str(ns) '_*_?.txt']);
s=[s;dir(['*learn.txt'])]
for i=1:length(s)
    fn=s(i).name
    out=ParseGantryFile(fn);
%     WriteFile(fn,out.x,out.y)
    [m1,d1,nb1(i,:),ds,cs]=BestMatch(out,1);
    [m1,d1,nb2(i,:),ds,cs]=BestMatch(out,2);
    [m1,d1,nb3(i,:),ds,cs]=BestMatch(out,3);
    [nb1 nb2 nb3]
    figure(1)
    PlotRoute(out)
    hold on
    figure(3),plot(m1),hold on,plot([out.whichWpt],'r'),hold off
%     figure(2),plot(d1,'kx'),hold on,plot(ds),hold off
    t=1:length(d1);
    figure(2),plot(t,out.wptth,t,out.alvth,'r',t(cs),out.alvth(cs),'k.')
%     figure(2),plot(1:length(d1),d1,cs,d1(cs),'rx')
end
hold off
figure(1),hold off
figure(2),hold off
figure(4)
PCSuccess=100-100*[nb1(:,1)./nb1(:,2) nb2(:,1)./nb2(:,2) nb3(:,1)./nb3(:,2)]
bar(PCSuccess)
Setbox;
axis([0.5 10.5 0 100])
ylabel('% success')
me=round(mean(PCSuccess))
st=round(std(PCSuccess))
figure(1)
axis equal
axis([220 1400 220 850])
% keyboard

function PlotRoute(out)
cs=['bs';'rs';'gs';'ks'];
plot(out.x,out.y)
hold on;
for i=1:size(out.wpts,1)
    plot(out.wpts(i,4),out.wpts(i,5),cs(1+mod(i,4),:)); 
end

function[m1,d1,NBad,ds,cs]=BestMatch(out,opt)
t=length(out.wpty);
wpts=out.wpts;
vwpts=out.final(wpts(:,1),:);
for i=1:t
    alv=[out.alvx(i) out.alvy(i)];
    angi=out.alvth(i);
    vis=out.final(i,:);
    for j=1:size(wpts,1)
        if((nargin<1)|(opt==1)) ds(i,j)=sqrt(sum((alv-wpts(j,[2 3])).^2));
        elseif(opt==2) ds(i,j)=abs(AngularDifference(out.wpts(j,6),angi));
        else
            % Jochen style
            ds(i,j)=sum((vis-vwpts(j,:)).^2);
        end
    end
    [d1(i) m1(i)]=min(ds(i,:));
end
cs = find([out.whichWpt]==m1); 
NBad=[sum([out.whichWpt]~=m1) t];

function WriteFile(fn,x,y)
fid=fopen([fn(1:end-4) 'Path2.txt'],'w');
for i=1:length(x)-1
    fprintf(fid,'%d %d\n',x(i),y(i));
end
fprintf(fid,'%d %d\n',x(i),y(i));
fclose(fid)