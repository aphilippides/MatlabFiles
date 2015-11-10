function ReceptorPics(v,t,ve,col)
coff=501;
dmush;
% GetReceptorNoiseLevels(v,coff)
%FilterNoise(v,t)
ReceptorNoiseLevelsLine(v,coff,t,ve,col)
if(nargin<5) col ='b'; end;
% PlotReceptor(v,t,ve,col)



function PlotReceptor(pc,ts,v,col)
load MushMin/ReceptorNoiseLevelsT20_100V10
% v=1;
fn=['Mush/Jitter0Pc' x2str(pc) 'SSt0_5B5MaxGr1000Inn33Out99V' int2str(v) 'Recepts.dat'];
if(isfile(fn)) x=load(fn);
else
    % x=load(['Mush/Jitter0Pc' x2str(pc) 'SSt0_5B5Gr1000Inn33Out99Recepts.dat']);
    x=load(['Mush/Jitter0Pc' x2str(pc) 'SSt0_5B5Gr1000Inn33Out99V' int2str(v) 'Recepts.dat']);
end
t=x(:,1);
xover=(x(:,2:end)*1.324e-6)>(ones(size(x,1),1)*p99);
numover=sum(xover,2);
plot(t,numover,col)
PlotReceptors2d(xover,ts,t)

function GetReceptorNoiseLevels(v,coff,dn)
if(nargin<3|dn==0) cd MushMin;
else cd Mush;
end
h=load(['BasalRate2_5SSt0_5B5Gr2000Inn33Out99V' int2str(v) 'Recepts.dat'])*1.324e-6;
x=h(coff:end,2:end);
pc=[90,95,99,99.9];
for p=pc
    eval(['p' x2str(p) '=PCRange(x,p,1);']);
end
quartiles=iqr(x);

% save(['ReceptorNoiseLevelsT20_100V' int2str(v) '.mat'],'p90','p95','p99','p99_9','quartiles','coff');

function ReceptorNoiseLevelsLine(v,coff,B,dn,x)
if(nargin<4|dn==0) cd MushMin;
else cd TubeMin;
end
if(nargin<5)   
    h=load(['BasalRate2_5SSt0_5B' int2str(B) 'Gr2000Inn33Out99V' int2str(v) 'Line1000.dat'])*1.324e-6;
    x=h(coff:end,800:1200);
end
% pc=[2.5,5,25,75,95,97.5];
% for p=pc
%     p
%     eval(['p' x2str(p) '=prctile(x,p);']);
% end
% medi=median(x);
% mini=min(x);
% maxi=max(x);
%save(['ReceptorNoiseLevelsLineT50_100V' int2str(v) '.mat'],'p2_5','p5','p25','p75','medi','p95','p97_5','maxi','mini');
load(['ReceptorNoiseLevelsLineT30_50V' int2str(v) '.mat']);
plot((1:size(x,2))*0.5-size(x,2)/4,medi,'k')
hold on
plot((1:size(x,2))*0.5-size(x,2)/4,[p2_5;p97_5],'r')
plot((1:size(x,2))*0.5-size(x,2)/4,[mini;maxi],'b')
plot((1:size(x,2))*0.5-size(x,2)/4,[p25;p75],'g')
set(gca,'FontSize',14)
axis tight
YLim([0.063 0.115]*1e-6)
SetYTicks(gca,[],1e9)
ylabel('concentration [nM]')
xlabel('distance (\mum)')
setbox
hold off
figure
plot((1:size(x,2))*0.5-size(x,2)/4,[maxi-mini;p97_5-p2_5;p75-p25])
set(gca,'FontSize',14)
axis tight
YLim([0 3e-8])
SetYTicks(gca,[],1e9)
ylabel('concentration [nM]')
xlabel('distance (\mum)')
setbox
keyboard

function PlotReceptors2d(M,ts,ti)
INNER=33;
OUTER=99;
GridDim=100

cent_x=GridDim/2;
cent_y=GridDim/2;
XStart=cent_x-OUTER;
XEnd=cent_y+OUTER+1;
YStart=cent_x-OUTER;
YEnd=cent_y+OUTER+1;

NUM_RECEPTORS=1;
for i=XStart:(XEnd-1)
    for j=YStart:(YEnd-1)
        dist_pt = sqrt((cent_x-i)^2+(cent_y-j)^2)+0.5;
        % 			if(dist_pt<OUTER)
        % 				if(dist_pt>INNER) 
        % 					NumberOfSources++;
        % 					if(SOURCE_TYPE==6) DrawRect(i,j,i+1,j+1);
        % 				}
        % 			}
        if(dist_pt<=INNER) 
            recepts(NUM_RECEPTORS,:)=[i, j];
            NUM_RECEPTORS=NUM_RECEPTORS+1;
        end
    end
end

p=zeros(GridDim);
% for t=1:length(ts)
% mov = avifile('ReceptorsMovie.avi','fps',10)
mov = avifile('ReceptorsOvertwice99Pc0_75Movie.avi','fps',5)%,'compression','None')

for t=ts
    [m,ind]=min(abs(ti-t));
    for i=1:length(recepts)
        p(recepts(i,1),recepts(i,2))=M(ind,i);
    end
    % figure
    pcolor(p),SquareAx,shading flat
    F = getframe(gca);
    mov = addframe(mov,F);
end
mov = close(mov);

function FilterNoise(s,f)
Fs = 2000;
t = (6e4:1e5)/Fs;
[b,a] = ellip(8,0.01,80,f*2/Fs,'low');
% [H,w] = freqz(b,a,512);
% plot(w*Fs/(2*pi),abs(H));
% xlabel('Frequency (Hz)'); ylabel('Mag. of frequency response');
% grid;

sf = filter(b,a,s);
plot(t,s,t,sf,'r');
xlabel('Time (seconds)');
ylabel('Time waveform');
sf2=sf(2e4:end,:);

% plot(1:201,[min(s);median(s);max(s)]','r',1:201,[min(sf2);median(sf2);max(sf2)]','b')
% figure
p1=prctile(s,2.5);
p2=prctile(s,97.5);
sp=p2-p1;
sfp=max(sf2)-min(sf2);
sfp2=prctile(sf2,97.5)-prctile(sf2,2.5);
plot(-50:0.5:50,sp,'r',-50:0.5:50,sfp,'b',-50:0.5:50,sfp2,'g')
YLim([0 max(sfp)])
xlabel('Distance (\mum)')
ylabel('Concentration [NO] (M)')
% axis([0 1 -1 1]);