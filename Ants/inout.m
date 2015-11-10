% inout plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: inout('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function inout(fbit,dout,din,aso,asi,tso,tsi,alo,ali,ndiv)

if((nargin<1)) fbit=[]; end;
if(nargin<10) ndiv=10;end;

% out stuff
if((nargin<2)|isempty(dout))
    disp('  ');disp('OUTS:')
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    dout=input('Enter just: d for [0 d] or return for all flight: ');
end;
if((nargin<4)|isempty(aso))
    disp('  ');
    disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
    aso=input('Enter just: r for [-r r] or return for all flight: ');
end;
if((nargin<6)|isempty(tso))
    disp('  ');
    %     disp('Enter times as [t1 t2] in the range [' num2str([min(t) max(t)]) '].']);
    disp('Enter times as [t1 t2] in secs.');
%     tso=input('Enter just t for [0 t] or return for all flight: ');
    disp('Enter just t to remove all flights < t secs long')
    tso=input('enter return for all flight(s): ');
end;
if((nargin<8)|isempty(alo))
    disp('  ');
    disp('Enter range of retinal positions of LMs as [r1 r2] in degrees.');
    alo=input('Enter just: r for [-r r] or return for all flight: ');
end;

% in stuff
if((nargin<3)|isempty(din))
    disp('  ');disp('INS:')
    %     disp('Enter range of distances from nest as [d1 d2] in cm, max ' num2str);
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    din=input('Enter just: d for [0 d] or return for all flight: ');
end;
if((nargin<5)|isempty(asi))
    disp('  ');
    disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
    asi=input('Enter just: r for [-r r] or return for all flight: ');
end;
if((nargin<6)|isempty(tsi))
    disp('  ');
    disp('Enter times as [t1 t2] in secs.');
%     tsi=input('Enter just t for last t secs or return for all flight: ');
    disp('Enter just t to remove all flights < t secs long')
    tsi=input('enter return for all flight(s): ');
    %     if(length(tsi==1)) tsi=-tsi;
end;
if((nargin<9)|isempty(ali))
    disp('  ');
    disp('Enter range of retinal positions of LMs as [r1 r2] in degrees.');
    ali=input('Enter just: r for [-r r] or return for all flight: ');
end;
if(isempty(ali)&isempty(alo))
    [oo,no,lmo,outfs,PeakOOuts,TOfDayO,PeakOOuts2]=histdata([fbit 'out'],dout,0,aso,tso,ndiv);
else 
    [outs,outfs]=histdataLM([fbit 'out'],dout,0,aso,tso,alo,ndiv);
end
if(isempty(ali)&isempty(alo))
    [oi,ni,lmi,infs,PeakOIns,TOfDayI,PeakOIns2]=histdata([fbit 'in'],din,0,asi,tsi,ndiv);
else [ins,outfs]=histdataLM([fbit 'in'],din,0,asi,tsi,ali,ndiv);
end

outfn=GetOutFn(dout,din,aso,asi,tso,tsi,alo,ali);

lcol=['r';'k';'y';'g'];
blen=1;
x=[-170:ndiv:180];
kk=([19:36 1:18]);
k2=([31:36 1:36 1:5]);
x2=[-230:10:230];

CurrBiol=1;
if(isempty(ali)&isempty(alo))
    
    nLM=length(lmo);
    for i=1:nLM 
        LM(i,:)=lmo(i).LM;
        LMWid(i)=lmo(i).LMWid;
    end
    % hack to make N plot in centre of the graph
%     x=0:ndiv:350;
    figure(1),subplot(111)
    lo=oo(kk)/sum(oo);
    li=oi(kk)/sum(oi);
    plot(x,lo,x,li,'r')
    axis tight; ax=axis; ylim([0 ax(4)])
    if(isempty(aso)&isempty(asi))
        tstr=['(blue, n=' int2str(sum(oo)) ') vs in (red, n=' int2str(sum(oi)) ')'];
        t2str=[''];
    else
        t2str=['Looking at nest'];
        tstr=['(blue, n=' int2str(sum(oo)) ') vs in (red, n=' int2str(sum(oi)) ') Looking at Nest'];
    end
    Setbox;title(['Body orientation, out ' tstr])
    figure(11+length(lmi))
    plot(x2,lo(k2),x2,li(k2),'r');
    axis tight; ax=axis; ylim([0 ax(4)])
    Setbox;title(['Body orientation wrapped, out ' tstr])
    
    x=[-170:ndiv:180];
    figure(2),subplot(111)
    plot(x,no./sum(no),x,ni./sum(ni),'r')
    axis tight; ax=axis; ylim([0 ax(4)])
    title(['Retinal position of nest, out ' tstr])
    for i=1:length(lmi)
        figure(3+i-1),subplot(111)
        plot(x,lmo(i).frls/sum(lmo(i).frls),x,lmi(i).frls./sum(lmi(i).frls),'r')
        axis tight; ax=axis; ylim([0 ax(4)])
        [lst,lc]=LMStr(i,LM);
        title([lst ' LM on retina, out ' tstr],'Color',lc)
    end
    couts=[];eouts=[];
    for j=1:nLM 
        olor(j).LMOnRetina=[]; 
        olor(j).OToLM=[]; 
    end;
    for i=1:length(outfs)
        couts=[couts;outfs(i).Cents];
        eouts=[eouts;outfs(i).EndPt];
        for j=1:nLM
            olor(j).LMOnRetina=[olor(j).LMOnRetina;outfs(i).lOnR(j).rl*pi/180];
            olor(j).OToLM=[olor(j).OToLM;outfs(i).lOnR(j).OToLM];
        end
    end
    olor(1).LM=LM;
    oso=[outfs.sOr];
    ofd=[outfs.fdir];
    onr=[outfs.nOnR];
    oton=[outfs.o2nest];
    BeeFDirPlot(oso,ofd,onr,olor,13+nLM,'OUT: ',oton,[30:40])
    cins=[];eins=[];
    for j=1:nLM 
        ilor(j).LMOnRetina=[]; 
        ilor(j).OToLM=[]; 
    end;
    for i=1:length(infs)
        cins=[cins;infs(i).Cents];
        eins=[eins;infs(i).EndPt];
        for j=1:nLM 
            ilor(j).LMOnRetina=[ilor(j).LMOnRetina;infs(i).lOnR(j).rl*pi/180];
            ilor(j).OToLM=[ilor(j).OToLM;infs(i).lOnR(j).OToLM];
        end
    end
    ilor(1).LM=LM;
    oso=[infs.sOr];
    ifd=[infs.fdir];
    onr=[infs.nOnR];
    oton=[infs.o2nest];
    BeeFDirPlot(oso,ifd,onr,ilor,18+2*nLM,'IN: ',oton,[30:40])

    % flight direction
    figure(50)
    [y,xs]=AngHist([outfs.fdir]*180/pi,0:10:360,0,0);fdiro=y./sum(y);
    [y,xs]=AngHist([infs.fdir]*180/pi,0:10:360,0,0);fdiri=y./sum(y);
    plot(xs,fdiro,xs,fdiri,'r:')
    Setbox;axis tight
    xlabel('flight direction')
    ylabel('frequency (normalised)')
%     figure(3+i),subplot(111)
%     if(length(couts))
%         plot(eouts(:,1),eouts(:,2),'b.',...
%             [couts(:,1) eouts(:,1)]',[couts(:,2) eouts(:,2)]','b')
%         hold on;
%     end
%     if(length(couts))
%         plot(eins(:,1),eins(:,2),'r.',...
%             [cins(:,1) eins(:,1)]',[cins(:,2) eins(:,2)]','r')
%         hold on;
%     end
%     PlotNestAndLMs(LM,LMWid,outfs(1).nest);
%     CompassAndLine('k',[],[],0)
%     axis equal,  hold off;
    
    [p_o,xs]=AngHist(PeakOOuts,0:10:360,1,0);
    [p_i,xs]=AngHist(PeakOIns,0:10:360,1,0);
    np_o=p_o(kk)/sum(p_o);
    np_i=p_i(kk)/sum(p_i);
    if(~CurrBiol)
    figure(4+length(lmi)),plot(x,np_o,x,np_i,'r')
    title('frequency of peak orientations in each flight');Setbox;axis tight
    figure(12+length(lmi)),
    plot(x2,np_o(k2),x2,np_i(k2),'r');
    title('frequency of peak os wrapped');Setbox;axis tight
    end
%     figure(5+length(lmi))
%     plot(TOfDayO,PeakOOuts,'bx',TOfDayI,PeakOIns,'ro')
%     legend('outs','ins')
%     title('peak orientation vs time of day; blue x=outs, red o =ins');
    
%     m1=[0 15.5;15.5 24];
%     m2=[0 16.5;16.5 24];
%     while 1
%         figure(8+length(lmi))
%         i1out=find((TOfDayO>=m1(1,1))&(TOfDayO<m1(1,2)));
%         xs=[0:ndiv:360];
%         os=[];
%         for i=i1out os=[os outfs(i).sOr*180/pi]; end
%         if(isempty(os)) fo=NaN*ones(size(x));
%         else fo=AngHist(os,xs,1,0);    
%         end
%         i2out=find((TOfDayO>=m1(2,1))&(TOfDayO<m1(2,2)));
%         os=[];
%         for i=i2out os=[os outfs(i).sOr*180/pi]; end
%         if(isempty(os)) fo2=NaN*ones(size(x));
%         else fo2=AngHist(os,xs,1,0);    
%         end
%         os=[];
%         i1in=find((TOfDayI>=m2(1,1))&(TOfDayI<m2(1,2)));
%         for i=i1in os=[os infs(i).sOr*180/pi]; end
%         if(isempty(os)) fi=NaN*ones(size(x));
%         else fi=AngHist(os,xs,1,0);    
%         end
%         i2in=find((TOfDayI>=m2(2,1))&(TOfDayI<m2(2,2)));
%         os=[];
%         for i=i2in os=[os infs(i).sOr*180/pi]; end
%         if(isempty(os)) fi2=NaN*ones(size(x));
%         else fi2=AngHist(os,xs,1,0);    
%         end
%         if(isnan(fo(1)))
%             if(isnan(fi(1))) fa=NaN*ones(size(x));
%             else fa=fi;
%             end
%         elseif(isnan(fi(1))) fa=fo;
%         else fa=[fo+fi];
%         end
%         if(isnan(fo2(1)))
%             if(isnan(fi2(1))) fa2=NaN*ones(size(x));
%             else fa2=fi2;
%             end
%         elseif(isnan(fi2(1))) fa2=fo2;
%         else fa2=[fo2+fi2];
%         end
% %         subplot(3,1,1), plot(x,fa(kk)./sum(fa),x,fa2(kk)./sum(fa2),'r')
% %         if(~isempty([fa fa2])) axis([-170 180 0 max([fa./sum(fa) fa2./sum(fa2)])]); end;
% %         title(['Time 1 = [' num2str(m(1,:)) '] (n=' int2str(sum(fa)) ...
% %             ' blue); Time 2 = [' num2str(m(2,:)) '] n=' int2str(sum(fa2)) ' (red)']);
% %         ylabel('All')
%         nfo=fo(kk)./sum(fo);
%         nfo2=fo2(kk)./sum(fo2);
% %         subplot(2,1,1), plot(x,nfo,x,nfo2,'r')
% %         if(~isempty([fo fo2])) axis([-170 180 0 max([fo./sum(fo) fo2./sum(fo2)])]); end
% %         title(['Time 1 = [' num2str(m1(1,:)) '] (n=' int2str(sum(fa)) ...
% %             ' blue); Time 2 = [' num2str(m1(2,:)) '] n=' int2str(sum(fa2)) ' (red)']);
% %         ylabel('outs');
%         subplot(2,1,1), plot(x2,nfo(k2),x2,nfo2(k2),'r');axis tight
%         if(~isempty([fo fo2])) ylim([0 max([nfo nfo2])]); end
%         Setbox;
%         nfi=fi(kk)./sum(fi);
%         nfi2=fi2(kk)./sum(fi2);
% %         subplot(2,1,2), plot(x,nfi,x,nfi2,'r')
% %         if(~isempty([fi fi2])) axis([-170 180 0 max([fi./sum(fi) fi2./sum(fi2)])]); end;
% %         title(['Time 1 = [' num2str(m2(1,:)) '] (n=' int2str(sum(fa)) ...
% %             ' blue); Time 2 = [' num2str(m2(2,:)) '] n=' int2str(sum(fa2)) ' (red)']);
% %         ylabel('ins');
%         subplot(2,1,2), plot(x2,nfi(k2),x2,nfi2(k2),'r');axis tight
%         if(~isempty([fi fi2])) ylim([0 max([nfi nfi2])]); end;
%         Setbox;
%         % Peaks for different times of day
%         figure(10+length(lmi))
%         P1Out=PeakOOuts(i1out);P2Out=PeakOOuts(i2out);
%         P1In=PeakOIns(i1in);P2In=PeakOIns(i2in);
%         [p_o1,xs]=AngHist(P1Out,0:10:360,1,0);
%         [p_o2,xs]=AngHist(P2Out,0:10:360,1,0);
%         [p_i1,xs]=AngHist(P1In,0:10:360,1,0);
%         [p_i2,xs]=AngHist(P2In,0:10:360,1,0);
%         s1=sum(p_o1+p_o2); s2=sum(p_i1+p_i2);
% %         subplot(2,1,1),plot(x,p_o1(kk)/s1,x,p_o2(kk)/s1,'r')
% %         title(['Time 1 = [' num2str(m1(1,:)) '] (n=' int2str(sum(fa)) ...
% %             ' blue); Time 2 = [' num2str(m1(2,:)) '] n=' int2str(sum(fa2)) ' (red)']);
% %         ylabel('outs');
%         np_o1=p_o1(kk)/s1;
%         np_o2=p_o2(kk)/s1;
%         subplot(2,1,1),plot(x2,np_o1(k2),x2,np_o2(k2),'r')
%         axis tight;Setbox;
% %         subplot(2,1,2),plot(x,p_i1(kk)/s2,x,p_i2(kk)/s2,'r');
% %         title(['Time 1 = [' num2str(m2(1,:)) '] (n=' int2str(sum(fa)) ...
% %             ' blue); Time 2 = [' num2str(m2(2,:)) '] n=' int2str(sum(fa2)) ' (red)']);
% %         ylabel('ins');
%         np_i1=p_i1(kk)/s2;
%         np_i2=p_i2(kk)/s2;
%         subplot(2,1,2),plot(x2,np_i1(k2),x2,np_i2(k2),'r')
%         axis tight;Setbox;
% 
%         disp(' ');
%         disp('OUT: enter time splits as 4 element vector [t1 t2 t3 t4] in 24 hrs');
%         inp=input('single number means [0 t t 24]. Return to end: ');
%         if(isempty(inp)) break;
%         elseif(length(inp)==4) m1(1,:)=inp([1 2]); m1(2,:)=inp([3 4]);
%         else m1=[0 inp(1);inp(1) 24];
%         end
%         disp(' ');
%         disp('IN: enter time splits as 4 element vector [t1 t2 t3 t4] in 24 hrs');
%         inp=input('single number means [0 t t 24]. Return to skip: ');
%         if(length(inp)==4)  m2(1,:)=inp([1 2]); m2(2,:)=inp([3 4]);
%         elseif(length(inp)==1) m2=[0 inp(1);inp(1) 24];
%         end
%     end
%     
%     % save the peak data
%     SavePeaks(outfn,PeakOOuts,PeakOIns,P1Out,P2Out,P1In,P2In,m1,m2);
%     % Time of Day plots
%     p1=[0 90 180 270];th=45;
%     while 1
%         figure(9+length(lmi))
%         
%         pstr=[]; for i=1:length(p1) pstr=[pstr int2str(p1(i)) '; ']; end
%         [y,hrs,sig1,tot]=PlotPeakTimes(PeakOOuts,TOfDayO,p1,th,2);
%         subplot(2,1,1),bar(hrs,y',1); % plot(hrs,y1,hrs,y2,'r')
% %         ylabel('outs');xlabel(['significance = ' num2str(sig1,3)]);
% %         title([t2str ': Time of Day for \pm ' num2str(th) ' of ' pstr])       
%         hs=text(hrs,max(y(:))*ones(size(hrs))+0.04,int2str(tot'));axis tight;Setbox;
% 
%         [y,hrs,sig2,tot]=PlotPeakTimes(PeakOIns,TOfDayI,p1,th,2);
%         subplot(2,1,2),bar(hrs,y',1); % plot(hrs,y1,hrs,y2,'r')
% %         ylabel('ins');xlabel(['significance = ' num2str(sig2,3)]);        
%         hs=text(hrs,max(y(:))*ones(size(hrs))+0.04,int2str(tot'));axis tight;Setbox
%         
%         inpi=input('enter peaks + dist as [p1 p2 etc d] in degrees, return to end:  ');
%         if(length(inpi)<3) break; 
%         else p1=inpi(1:end-1); th=inpi(end);
%         end
%     end
    
    % Density plots
    if(~CurrBiol)
    m=2;
    mi=min([couts;cins]);
    ma=max([couts;cins]);
    while(~isempty(m))
        figure(6+length(lmi));BeePosPlot(couts,m,LM,LMWid,outfs(1).nest,mi,ma)
        title(['Positions when ' t2str ': Outs'],'Color','b');
        figure(7+length(lmi));BeePosPlot(cins,m,LM,LMWid,outfs(1).nest,mi,ma)
        title(['Positions when ' t2str ': Ins'],'Color','b');
        m=input('change spacing? return to end:   ');
    end
    end
%     figure(8+length(lmi))
%     plot(PeakOOuts,PeakOOuts2,'bx',PeakOIns,PeakOIns2,'ro')    
else
    nLM=length(outs);
    for i=1:nLM 
        LM(i,:)=outs(i).LM;
        LMWid(i)=outs(i).LMWid;
    end
    for j=1:nLM
        figure(1)
        subplot(nLM,1,j)
%         x=0:ndiv:350;
        % hack to make N plot in centre of the graph
        nos=outs(j).fos(kk)/sum(outs(j).fos);
        nis=ins(j).fos(kk)/sum(ins(j).fos);
        plot(x,nos,x,nis,'r')
        [lmst,lmc]=LMStr(j,LM);
        axis tight; ax=axis; ylim([0 ax(4)])
        tstr=['(blue, n=' int2str(sum(outs(j).fos)) ') vs in (red, n=' ...
            int2str(sum(ins(j).fos)) ')'];
        title(['Body orientation when looking at ' lmst ', out ' tstr])
%         x=-180:ndiv:180;
        figure(11+nLM+j-1)
        plot(x2,nos(k2),x2,nis(k2),'r');
        axis tight; ax=axis; ylim([0 ax(4)])
        Setbox;title(['Body O looking at ' lmst ' wrapped, out ' tstr])
        
        figure(2)
        subplot(nLM,1,j)
        plot(x,outs(j).frns/sum(outs(j).frns),x,ins(j).frns/sum(ins(j).frns),'r')
        axis tight; ax=axis; ylim([0 ax(4)])
        title(['Retinal position of nest when looking at ' lmst ', out ' tstr])
        for i=1:nLM
            figure(3+i-1)
            subplot(nLM,1,j)
            plot(x,outs(j).frls(i,:)/sum(outs(j).frls(i,:)), ...
                x,ins(j).frls(i,:)/sum(ins(j).frls(i,:)),'r')
            axis tight; ax=axis; ylim([0 ax(4)])
            [lst,lc]=LMStr(i,LM);
            title([lst ' LM on retina when looking at ' lmst ', out ' tstr],'Color',lc)
        end
        figure(3+nLM+(j-1))
        if(length(outs(j).sOr))
            c=outs(j).Cents;
            clear e;[e(:,1) e(:,2)]=pol2cart(outs(j).sOr,blen); c=c-1*e;e=2*e+c;
            plot(e(:,1),e(:,2),'b.',[c(:,1) e(:,1)]',[c(:,2) e(:,2)]','b','LineWidth',1)
        end
        hold on;
%         PlotNestAndLMs(LM,LMWid,outs(1).nest);
%         CompassAndLine('k');
%         axis equal,  hold on;

        %figure(4+nLM+2*(j-1))
        if(length(ins(j).sOr))
            c=ins(j).Cents;
            clear e;
            [e(:,1) e(:,2)]=pol2cart(ins(j).sOr,blen);
            c=c-1*e;e=2*e+c;
            plot(e(:,1),e(:,2),'r.',[c(:,1) e(:,1)]',[c(:,2) e(:,2)]','r','LineWidth',1)
        end
        PlotNestAndLMs(LM,LMWid,outs(1).nest);
        CompassAndLine('k',[],[],0)
        axis equal,  hold off;
        [p_o,xs]=AngHist([outs(j).PeakOs],0:10:360,1,0);
        [p_i,xs]=AngHist([ins(j).PeakOs],0:10:360,1,0);
        figure(3+2*nLM)
        subplot(nLM,1,j),plot(x,p_o(kk),x,p_i(kk),'r')
        title(['frequency of peak orientations when looking at ' lmst ' LM']);axis tight
%         figure(4+2*nLM)
%         subplot(nLM,1,j),
%         plot(outs(j).TOfDay,outs(j).PeakOs,'bx',ins(j).TOfDay,ins(j).PeakOs,'ro')
%         title(['peak orientation vs time when looking at: ' lmst ' LM; x outs, o ins']);
    end    
    % save the peak data
%     SavePeaks(outfn,outs,ins,LM);

    % Density plots
    m=2;
    while(~isempty(m))    
        for j=1:nLM
            [lmst,lmc]=LMStr(j,LM);
            mi=min([outs(j).Cents;ins(j).Cents]);
            ma=max([outs(j).Cents;ins(j).Cents]);
            figure(3+2*nLM+2*j);BeePosPlot(outs(j).Cents,m,LM,LMWid,outs(1).nest,mi,ma)
            title(['Positions when looking at ' lmst ' LM: Outs'],'Color',lmc);
            figure(4+2*nLM+2*j);BeePosPlot(ins(j).Cents,m,LM,LMWid,outs(1).nest,mi,ma)
            title(['Positions when looking at ' lmst ' LM: Ins'],'Color',lmc);
        end
        m=input('change spacing? return to end:   ');
    end
end

function SavePeaks(fn,PeakOOuts,PeakOIns,P1Out,P2Out,P1In,P2In,tM,tM2)
SaveP=[];
disp(' ');
% disp('Change directory (if necessary) then enter filename.')
f=input(['enter filename, currently: ' fn '. Return if  ok: '],'s');
if(~isempty(f)) fn=[f '.dat']; end;

fid=fopen(fn,'w');
if(isstruct(PeakOOuts))
    outs=PeakOOuts;
    ins=PeakOIns;
    LM=P1Out;
    nlm=size(LM,1);
    fprintf(fid,'Out:');
    for j=1:nlm
        [lmst,lmc]=LMStr(j,LM);
        fprintf(fid,'%s\t',lmst);
        lsout(j)=length(outs(j).PeakOs);
    end
    fprintf(fid,'In:');
    for j=1:nlm
        [lmst,lmc]=LMStr(j,LM);
%         fprintf(fid,'%s LM: peak T\t',lmst);
        fprintf(fid,'%s\t',lmst);
        lsin(j)=length(ins(j).PeakOs);
    end
    maxl=max([lsout lsin]);
    fprintf(fid,'\n');
    for i=1:maxl
        for j=1:nlm
            if(i<=lsout(j)) fprintf(fid,'%3d\t',outs(j).PeakOs(i));
            else fprintf(fid,'   \t');
            end
        end
        for j=1:nlm
            if(i<=lsin(j)) fprintf(fid,'%3d\t',ins(j).PeakOs(i));
            else fprintf(fid,'   \t');
            end
        end
        fprintf(fid,'\n');
    end
else
    fprintf(fid,'   \t   Out   \t         \t   \t    In   \t         \n');
    fprintf(fid,'All\t%4.1f-%4.1f\t%4.1f-%4.1f\tAll\t%4.1f-%4.1f\t%4.1f-%4.1f\n',...
        tM(1,1),tM(1,2),tM(2,1),tM(2,2),tM2(1,1),tM2(1,2),tM2(2,1),tM2(2,2));
    lout=[length(PeakOOuts) length(P1Out) length(P2Out)];
    lin=[length(PeakOIns) length(P1In) length(P2In)];
    maxl=max([lout lin]);
    for i=1:maxl
        if(i<=lout(1)) fprintf(fid,'%3d\t',PeakOOuts(i));
        else fprintf(fid,'     \t');
        end
        if(i<=lout(2)) fprintf(fid,'   %3d   \t',P1Out(i));
        else fprintf(fid,'         \t');
        end
        if(i<=lout(3)) fprintf(fid,'   %3d   \t',P2Out(i));
        else fprintf(fid,'         \t');
        end
        if(i<=lin(1)) fprintf(fid,'%3d\t',PeakOIns(i));
        else fprintf(fid,'     \t');
        end
        if(i<=lin(2)) fprintf(fid,'   %3d   \t',P1In(i));
        else fprintf(fid,'         \t');
        end
        if(i<=lin(3)) fprintf(fid,'   %3d   \n',P2In(i));
        else fprintf(fid,'         \n');
        end
    end
end
fclose(fid);

function [y,hrs,p,tot]=PlotPeakTimes(PeakOOuts,TOfDayO,p,th,binw)
if(nargin<5) binw=1; end;
na=length(p);
for i=1:na 
    [tp(i).ts,mas(i),mis(i)]=GetPeakTimes(PeakOOuts,TOfDayO,p(i),th);
end
mi=round(min(mis)); 
ma=round(max(mas));
if(isnan(ma)) 
    mi=11;
    ma=17;
elseif(ma==mi) ma=ma+1; 
end;
for i=1:na 
    [y(i,:),hrs]=hist(tp(i).ts,mi:binw:ma); 
end;
if((~isnan(mas(1)))&(~isnan(mas(2)))) p=ranksum(tp(1).ts,tp(2).ts);
else p=[];
end
tot=sum(y);
tot(find(tot==0))=1;
for i=1:na 
    y(i,:)=y(i,:)./tot;
end
% y1=y1./sum(y1);
% y2=y2./sum(y2);

function[tp,ma,mi] = GetPeakTimes(ps,ts,p,th)
ps=ps*pi/180;
p=p*pi/180;
th=th*pi/180;
d=abs(AngularDifference(ps,p));
is=find(d<th);
if(isempty(is)) tp=[];ma=NaN;mi=NaN;
else
    tp=ts(is);
    ma=max(tp);
    mi=min(tp);
end
function [outfn] =GetOutFn(dout,din,aso,asi,tso,tsi,alo,ali)
% outfn=['PeaksOutD' num2str(dout) 'T' num2str(tso) 'Nest'  num2str(aso) ...
outfn=['PeaksOutT' num2str(tso) 'Nest'  num2str(aso) 'LM' num2str(alo) ...
     'InT' num2str(tsi) 'Nest'  num2str(asi) 'LM' num2str(ali) '.dat'];

function BeePosPlot(cs,m,LM,LMWid,nest,mi,ma)
% [d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[mi(1):m:ma(1)],[mi(2):m:ma(2)]);
if(isempty(cs)) return; end;
% [d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[300:m:1200],[100:m:1000]);
[d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[-55:m:55],[-55:m:55]);
d=d.*(d>1);
% [d,a,b,x,y]=Density2D(cs,[],m);
contourf(x,y,max(d(:))-d);
colormap gray
hold on;
PlotNestAndLMs(LM,LMWid,nest);
hold off
CompassAndLine('k',[],[],0)
axis equal