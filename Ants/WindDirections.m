function WindDirections

% [a,b]=xlsread('Roof WindDir.xls');
% cdirs={'n','nne','ne','ene','e','ese','se','sse','s','ssw','sw','wsw','w','wnw','nw','nnw','calm'};
% lcd=length(cdirs);
% fos=zeros(lcd,36);
% foos=zeros(lcd,36);
% fois=zeros(lcd,36);
% % Gte times
% for i=1:length(b)
%     FTime(i) = TimeFromFn(char(b(i,1)));%
% end
% 
% l3=find(FTime<15.5);
% g3=find(FTime>=15.5);
% l4=find(FTime<16.5);
% g4=find(FTime>=16.5);
% 
% for j=1:lcd
%     inds(j).is=[];
%     c=char(cdirs(j));
%     c=(cdirs(j));
%     for k=1:size(b,1)
%         if(isequal(b(k,5),c))
%             inds(j).is=[inds(j).is k];
%         end
%     end
%     jnds=[inds(j).is];
%     [fos(j,:),foos(j,:),fois(j,:)]=GetHistdata(jnds,b);
% end
% 
% save RoofWindData
% 
% sinds=[];ninds=[];
% 
% for i=7:11
%     sinds=[sinds [inds(i).is]];
% end
% for i=[1:3 15 16]
%     ninds=[ninds [inds(i).is]];
% end
% calm = inds(17).is;

load RoofWindData
cdirs={'n','nne','ne','ene','e','ese','se','sse','s','ssw','sw','wsw','w','wnw','nw','nnw','calm','nw to ne','se to sw','se','s'};
tsp=16;
PeakData=[];
for i=1:16%21
    if(i<18) is=[inds(i).is];
    elseif(i==18) is =ninds;
    elseif(i==19) is=sinds;
    elseif(i==20) is = 222:284;
    else is=284:462;
    end

    
    nfls(i)=length(is);
    
    if(nfls(i)>=1)
        [d,d,d,d,d,pe]=GetHistdata(is,b);
        PeakData=[PeakData [pe;ones(size(pe))*i]];
        
            nis=find((pe<45)|(pe>=315));
            nns(i,1)=length(nis);
        eis=find((pe>=45)&(pe<135));
            nns(i,2)=length(eis);
        sis=find((pe>=135)&(pe<225));
            nns(i,3)=length(sis);
        wis=find((pe>=225)&(pe<315));
            nns(i,4)=length(wis);
    else nns(i,1:4)=0;
    end
    
%     figure(2),plot(FTime(is),'o','MarkerSize',12),grid on
%     if(nfls(i)>=2)
%         figure(1)
%         while 1
%             ls=intersect(is,find(FTime<tsp));
%             gs=intersect(is,find(FTime>=tsp));
%             nl=length(ls);ng=length(gs);
%             [fol,fool,foil,noutl,ninl]=GetHistdata(ls,b);
%             [fog,foog,foig,noutg,ning]=GetHistdata(gs,b);
%             subplot(3,1,1),Plot2os(fol,fog,char(cdirs(i)))
%             xlabel(['All Flights b4/after ' num2str(tsp) ' (n=' int2str(nl) ', ' int2str(ng) ')'])
%             subplot(3,1,2),Plot2os(fool,foog)
%             xlabel(['Outs b4/after ' num2str(tsp) ' (n=' int2str(noutl) ', ' int2str(noutg) ')'])
%             subplot(3,1,3),Plot2os(foil,foig)
%             xlabel(['All Flights b4/after ' num2str(tsp) ' (n=' int2str(ninl) ', ' int2str(ning) ')'])
%             tsp=input('enter new split time:  ');
%             if(isempty(tsp)) 
%                 tsp=16;
%                 break; 
%             end;
%         end
%     end
end

bars=nns;
is=find(nfls<=4)
nns(is,:)=0;
bar(0:22.5:350,100*nns./(s*[1 1 1 1]))
jebfig(9)
axis tight

xs=[0:10:360];
k2=([31:36 1:36 1:5]);
x2=[-230:10:230];
x=[-170:10:180];
figure(1),subplot(111)
% hack to make N plot in centre of the graph
lx=length(x);
m=round(0.5*lx);
kk=([m+1:lx 1:m]);

for j=1:lcd
    nfls(j)=length(inds(j).is);
    lo(j,:)=fos(j,kk)/sum(fos(j,:));
    [mm,mo(j)]=max(lo(j,:))
    li(j,:)=foos(j,kk)/sum(foos(j,:));
    la(j,:)=fois(j,kk)/sum(fois(j,:));
    figure(j);
    jebfig
    yy=[0 max(lo(j,:))];
    plot(x2,lo(j,k2))%,x2,li(j,k2),'r',x2,la(j,k2),'k','LineWidth',2);
    hold on,plot([-180 -180;-90 -90;0 0;90 90;180 180]',[yy;yy;yy;yy;yy]','k:')
    wd=(j-1)*22.5;
    if(wd>180) wd=wd-360; end;
    plot([wd wd],[yy],'k'),hold off
    axis tight; ax=axis; ylim([0 ax(4)])
    tstr=['(blue, n=' int2str(sum(fos(j,:))) ') vs outs (red, n=' int2str(sum(foos(j,:))) ') vs ins (black, n= ' int2str(sum(fois(j,:))) ')'];
    Setbox;title(['Body orientation, All ' tstr])
end

figure(2),subplot(2,1,1)
lo=ooo(kk)/sum(ooo);
li=oio(kk)/sum(oio);
la=oao(kk)/sum(oao);
plot(x2,lo(k2),x2,li(k2),'r',x2,la(k2),'k','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(ooo)) ') vs S (red, n=' int2str(sum(oio)) ') vs calm (black, n= ' int2str(sum(oao)) ')'];
Setbox;title(['Body orientation, N ' tstr])
subplot(2,1,2)
lo=ooi(kk)/sum(ooi);
li=oii(kk)/sum(oii);
la=oai(kk)/sum(oai);
plot(x2,lo(k2),x2,li(k2),'r',x2,la(k2),'k','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(ooi)) ') vs S (red, n=' int2str(sum(oii)) ') vs calm (black, n= ' int2str(sum(oai)) ')'];
Setbox;title(['Body orientation, N ' tstr])

function[fos,foos,fois,nout,nin,PeakOs]=GetHistdata(jnds,b)
xs=[0:10:360];
lcd=1;
j=1;
nout=0;nin=0;
fos=zeros(lcd,36);
foos=zeros(lcd,36);
fois=zeros(lcd,36);
PeakOs=[];
for i=jnds
    clear DToNest
    fn=char(b(i,1));%s(i).name;
    load(fn)
    lmo=LMOrder(LM);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end
    %     o=(mod(sOr,2*pi))*180/pi;
    o=sOr_sc*180/pi;
    fo=AngHist(o,xs,1,1);
    fos(j,:)=fos(j,:)+fo;
    [mb,mx,ma]=CircularPeaks(fo,xs);
    if(length(mb)>=1)
        PeakOs=[PeakOs mx(1)];
    else         PeakOs=[PeakOs NaN];
    end
    if(~isempty(strfind(fn,'in'))) 
        fois(j,:)=fois(j,:)+fo;
        nin=nin+1;
    else foos(j,:)=foos(j,:)+fo;
        nout=nout+1;
    end
end

function Plot2os(fos,fis,ts)
if(nargin<3) ts=[]; 
else ts=['Wind from ' ts ': '];
end
xs=[0:10:360];
k2=([31:36 1:36 1:5]);
x2=[-230:10:230];
x=[-170:10:180];
lx=length(x);
m=round(0.5*lx);
kk=([m+1:lx 1:m]);

lo=fos(kk)/sum(fos);
li=fis(kk)/sum(fis);
plot(x2,lo(k2),x2,li(k2),'r','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(fos)) ') vs (red, n=' int2str(sum(fis)) ')'];
Setbox;title([ts 'Body orientation, ' tstr])



