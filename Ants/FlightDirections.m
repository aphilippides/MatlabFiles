% ino plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: ino('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function FlightDirections(fn,dout,Plotting)

if(nargin<1) fn=['out']; end;
if(nargin<3) Plotting=1; end;

if(isequal('out',fn)) ino=0;
else ino=1;% elseif(isequal('in',fn)) ino=1;
end

if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end

flt_dirs=[];ts=[];ep=[];ors=[];ns=[];dns=[];
for i=1:4 lm(i).lm=[]; end

for j=1:length(fn)
    j
    load(fn(j).name);
    lmo=LMOrder(LM);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
    end
    Cent_Os=Cent_Os*180/pi;
    flt_dirs=[flt_dirs;Cent_Os];
    ors=[ors;so_resc'*180/pi];
    ts=[ts;t'];
    dns=[dns;DToNest];
    if(Plotting)
        figure(4)
        AngHist(Cent_Os,0:10:360);
        title(['Flight direction of file ' fn(j).name])
        figure(5)
        PlotBee(Cents,EndPt)
        hold on;
        PlotNestAndLMs(LM,LMWid,nest);
        hold off
        figure(3)
        mi=min([so_resc'*180/pi;Cent_Os]);ma=max([so_resc'*180/pi;Cent_Os]);
        plot(so_resc*180/pi,Cent_Os,'.',[mi ma],[mi ma],'r--');
        title(['scatter of flight direction vs heading; file ' fn(j).name])
        axis tight;xlabel('heading')
        ylabel('Flight Direction')
        figure(1)
        AngHist(mod(flt_dirs,180),0:10:360);xlim([-5 185])
        title('Axis of flight direction: All flights')
        figure(2)
        AngHist(flt_dirs,0:10:360);
        title('Flight direction: All flights')
        inp=input('enter 0 to skip plotting or return to continue:  ');
        if(inp==0) Plotting=0; end;
    end
end
save FlightDirectionData flt_dirs ts
figure(2)
AngHist(flt_dirs,0:10:360);
title('Flight direction: All flights')
figure(1)
AngHist(mod(flt_dirs,180),0:10:360);
xlim([-5 185])
title('Axis of Flight direction: All flights')
figure(3)
mi=min([ors;flt_dirs]);ma=max([ors;flt_dirs]);
plot(ors,flt_dirs,'.',[mi ma],[mi ma],'r--');
axis tight
title('scatter of flight direction vs heading')
xlabel('heading')
ylabel('Flight Direction')

while 1
    % dist stuff
    disp('  ');
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    dout=input('Enter: d for [0 d], -d for [d inf], return to end: ');
    if(isempty(dout)) break;
    elseif(length(dout)==1)
        if(dout>0) dout=[0 dout];
        else dout=[-dout 1e6];
        end
    end
    is=find((dns>=(dout(1)))&(dns<=(dout(2))));
    figure(2)
    AngHist(flt_dirs(is),0:10:360);
    title(['Flight direction: dists ' num2str(dout(1)) ' to ' num2str(dout(2))])
    figure(1)
    AngHist(mod(flt_dirs(is),180),0:10:360);
    xlim([-5 185])
    title(['Axis of Flight direction: dists ' num2str(dout(1)) ' to ' num2str(dout(2))])
    figure(3)
    mi=min([ors(is);flt_dirs(is)]);ma=max([ors(is);flt_dirs(is)]);
    plot(ors(is),flt_dirs(is),'.',[mi ma],[mi ma],'r--');
    axis tight
    title(['scatter of flight direction vs heading: dists ' num2str(dout(1)) ' to ' num2str(dout(2))])
    xlabel('heading')
    ylabel('Flight Direction') 
end

while 1
    tr=input('enter time range of data to plot: ');
    if(isempty(tr)) break;
    else
        is=find((ts>=(tr(1)))&(ts<=(tr(2))));
        figure(2)
        AngHist(flt_dirs(is),0:10:360);
        title(['Flight direction: All flights; Times ' ...
            num2str(tr(1)) ' to ' num2str(tr(2))])
        figure(1)
        AngHist(mod(flt_dirs,180),0:10:360);
        xlim([-5 185])
        title('Flight direction: All flights - axis')
        figure(3)
        mi=min([ors(is);flt_dirs(is)]);ma=max([ors(is);flt_dirs(is)]);
        plot(ors(is),flt_dirs(is),'.',[mi ma],[mi ma],'r--');
        axis tight
        title('scatter of flight direction vs heading')
        xlabel('heading')
        ylabel('Flight Direction')
        title(['Flight direction: All flights; Times ' ...
            num2str(tr(1)) ' to ' num2str(tr(2))])
    end
end


function[is]=GetIs(dn,DToNest)
% if(isempty(dn)) dn=[0 max(DToNest)+.001];
% elseif(length(dn)==1) dn=[0 dn];
% end;
% if(isempty(as)) as=[-180.01 180.01];
% elseif(length(as)==1) as=[-as as];
% end;
% if(isempty(rt)) rt=[0 t(end)+.001];
% elseif(length(rt)==1) rt=[t(end)-rt t(end)];
% end;
% if(isempty(al)) al=[-180.01 180.01];
% elseif(length(al)==1) al=[-al al];
% end;

% ias=find((NOnR>=as(1))&(NOnR<as(2)));
is=find((DToNest'>=dn(1))&(DToNest'<dn(2)));
% is=intersect(ias,ids);
% its=find((t>=rt(1))&(t<rt(2)));
% ial=find((LMs>=al(1))&(LMs<al(2)));
% i2=intersect(ial,its);
% is=intersect(is,i2);