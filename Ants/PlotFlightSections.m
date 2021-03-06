function[loops]=PlotFlightSections(fn,onept,excl,tex)

if((nargin<1)||isempty(fn)) fn=[]; 
else fn=[' ' fn ' '];
end;
if(nargin<2) onept=1; end;
if(nargin<3) excl=0; end;
if(nargin<4) tex=0.01; end;

inp=input('enter LM number for data relative to LM; return relative to nest:  ');
if(isempty(inp)) 
    norlm=0;
    tst=['Nest'];
elseif(inp==1)
    norlm=1;
    tst=['N LM'];
else
    norlm=2;
    tst=['S LM'];
end

disp(' ');
disp(['return: psi=0 and ' tst ' facing'])
disp(['1: psi=0 and ' tst ' looking (subtly different to the above)'])
disp(['2: psi=0 '])
disp(['3: ' tst ' facing'])
disp(['4: ' tst ' looking'])
opt=input('Choose what data to look at:  ');

if(isempty(opt)) opt=0; end
strs={['psi=0 and facing ' tst];['psi=0 and looking at ' tst];...
    'psi=0';['facing ' tst];['looking at ' tst]};
tst2=char(strs(opt+1));

[allo2nl,o2nl,o2nPl,o2nFl,o2nNl,dSl,dSlP,dSlF,dSlN,allsl,sl,slP,slF,slN]=...
    psi0Loops([fn 'loop'],'rx -',norlm,opt,onept,excl,tex);
[allo2n,o2n,o2nP,o2nF,o2nN,dSo,dSoP,dSoF,dSoN,allso,so,soP,soF,soN]= ...
    psi0([fn 'out'],'b. -',norlm,opt,onept,excl,tex);
figure(1);
hold on;
[allo2ni,o2ni,o2nPi,o2nFi,o2nNi,dSi,dSiP,dSiF,dSiN,allsi,si,siP,siF,siN]=...
    psi0([fn 'in'],'rx -',norlm,opt,onept,excl,tex);
axis equal
title(['positions when ' tst2])

nor=AngHist(AngularDifference(allo2n,allso)*180/pi);
nori=AngHist(AngularDifference(allo2ni,allsi)*180/pi);
norl=AngHist(AngularDifference(allo2nl,allsl)*180/pi);
norP=AngHist(AngularDifference(o2nP,soP)*180/pi);
norPi=AngHist(AngularDifference(o2nPi,siP)*180/pi);
norPl=AngHist(AngularDifference(o2nPl,slP)*180/pi);

figure(2)
[y1,x]=AngHist(allo2n*180/pi);[y2,x]=AngHist(o2n*180/pi);
[yF,x]=AngHist(o2nF*180/pi);[yP,x]=AngHist(o2nP*180/pi);
[yN,x]=AngHist(o2nN*180/pi);[mN,iN]=max(yN);
[m1,i1]=max(y1);[m2,i2]=max(y2);
[mP,iP]=max(yP);[mF,iF]=max(yF);
op=x([i2 i1 iP iF iN]);

[s1,x]=AngHist(allso*180/pi);[s2,x]=AngHist(so*180/pi);
[sF,x]=AngHist(soF*180/pi);[sP,x]=AngHist(soP*180/pi);
[sN,x]=AngHist(soN*180/pi);

[y3,x]=AngHist(allo2ni*180/pi);[y4,x]=AngHist(o2ni*180/pi);
[yFi,x]=AngHist(o2nFi*180/pi);[yPi,x]=AngHist(o2nPi*180/pi);
[yNi,x]=AngHist(o2nNi*180/pi);[mNi,iN]=max(yNi);
[m3,i1]=max(y3);[m4,i2]=max(y4);
[mPi,iP]=max(yPi);[mFi,iF]=max(yFi);
ip=x([i2 i1 iP iF iN]);

[s3,x]=AngHist(allsi*180/pi);[s4,x]=AngHist(si*180/pi);
[sFi,x]=AngHist(siF*180/pi);[sPi,x]=AngHist(siP*180/pi);
[sNi,x]=AngHist(siN*180/pi);

%loops
[y3l,x]=AngHist(allo2nl*180/pi);[y4l,x]=AngHist(o2nl*180/pi);
[yFl,x]=AngHist(o2nFl*180/pi);[yPl,x]=AngHist(o2nPl*180/pi);
[yNl,x]=AngHist(o2nNl*180/pi);
[s3l,x]=AngHist(allsl*180/pi);[s4l,x]=AngHist(sl*180/pi);
[sFl,x]=AngHist(slF*180/pi);[sPl,x]=AngHist(slP*180/pi);
[sNl,x]=AngHist(slN*180/pi);

if(opt~=0)
    subplot(2,1,1),plot(x,y2/sum(y2),x,y1/sum(y1),'b:'),axis tight
xlabel(['Peak of psi0 = ' int2str(op(1)) ', ht=' num2str(m2/sum(y2),3) ...
    ', n=' int2str(sum(y2)) '; Peak of all = ' int2str(op(2)) ', ht=' num2str(m1/sum(y1),3)])
title(['OUT: orientation to ' tst ', solid=' tst2 ', dotted=all'])
subplot(2,1,2),plot(x,y3/sum(y3),'r:',x,y4/sum(y4),'r'),axis tight
xlabel(['Peak of psi0 = ' int2str(ip(1)) ', ht=' num2str(m4/sum(y4),3) ...
    ', n=' int2str(sum(y4)) '; Peak of all = ' int2str(ip(2)) ', ht=' num2str(m3/sum(y3),3)])
title(['IN: orientation to ' tst ', solid=' tst2 ', dotted=all'])

else
    t1st=['Out (-) v In (:), '];
    if(onept) t1st=[t1st 'Incids'];
    else t1st=[t1st 'All']
    end
    if(excl) t1st=[t1st ' Ex: ']; 
    else t1st=[t1st ': '];
    end;
%     subplot(2,3,1),plot(x,y2/sum(y2)),axis tight
% xlabel(['OUT: psi0+nest facing= ' int2str(op(1)) ', ht=' num2str(m2/sum(y2),3) ...
%     ', n=' int2str(sum(y2))])
% title([t1st 'orientation to ' tst ', psi0 and nest facing'])
% subplot(2,3,4),plot(x,y4/sum(y4),'r'),axis tight
% xlabel(['IN: psi0+nest facing= ' int2str(ip(1)) ', ht=' num2str(m4/sum(y4),3) ...
%     ', n=' int2str(sum(y4))])
%     
% subplot(2,3,2),plot(x,yF/sum(yF)),axis tight
% xlabel(['Out Peak Facing=' int2str(op(4)) ', ht=' num2str(mF/sum(yF),3) ', n=' int2str(sum(yF))])
% title([t1st 'orientation to ' tst ', facing nest only'])
% subplot(2,3,5),plot(x,yFi/sum(yFi),'r'),axis tight
% xlabel(['IN Peak Facing=' int2str(ip(4)) ', ht=' num2str(mFi/sum(yFi),3) ', n=' int2str(sum(yFi))])
% 
% subplot(2,3,3),plot(x,yP/sum(yP)),axis tight
% xlabel(['Out Peak Psi0=' int2str(op(3)) ', ht=' num2str(mP/sum(yP),3) ', n=' int2str(sum(yP))])
% title([t1st 'orientation to ' tst ', Psi 0 only'])
% subplot(2,3,6),plot(x,yPi/sum(yPi),'r'),axis tight
% xlabel(['IN Peak Psi0=' int2str(ip(3)) ', ht=' num2str(mPi/sum(yPi),3) ', n=' int2str(sum(yPi))])

PlotTheData(x,y1,y2,y3,y4,yP,yF,yPi,yFi,yN,yNi,tst,t1st,['O to ' tst])
% PlotTheDataL(x,y1,y2,y3,y4,yP,yF,yPi,yFi,y3l,y4l,yPl,yFl,tst,t1st,['O to ' tst])
figure(3);
PlotTheData(x,s1,s2,s3,s4,sP,sF,sPi,sFi,sN,sNi,tst,t1st,'body orientation')
% PlotTheDataL(x,s1,s2,s3,s4,sP,sF,sPi,sFi,s3l,s4l,sPl,sFl,tst,t1st,'body orientation')
figure(4);
subplot(2,1,1)
plot(x,norP/sum(norP),x,norPi/sum(norPi),'r:',x,norPl/sum(norPl),'k--'),
axis tight,title([t1st ', Retinal position of ' tst ' when psi=0'])
subplot(2,1,2)
plot(x,nor/sum(nor),x,nori/sum(nori),'r:',x,norl/sum(norl),'k--'),
axis tight,title([t1st ', Retinal position of ' tst ' all data'])

% rates of change of body orientation when o2n is in a certain range
end
figure(6)
[yo,x]=hist(abs(dSo)*180/pi,[0:50:500]);
[yi,x]=hist(abs(dSi)*180/pi,[0:50:500]);
[yoP,x]=hist(abs(dSoP)*180/pi,[0:50:500]);
[yiP,x]=hist(abs(dSiP)*180/pi,[0:50:500]);
[yoF,x]=hist(abs(dSoF)*180/pi,[0:50:500]);
[yiF,x]=hist(abs(dSiF)*180/pi,[0:50:500]);
[yoN,x]=hist(abs(dSoN)*180/pi,[0:50:500]);
[yiN,x]=hist(abs(dSiN)*180/pi,[0:50:500]);
subplot(2,2,1),plot(x,yo/sum(yo),x,yi/sum(yi),'r:'),
title(['psi0 and facing; n=' int2str(sum(yo)) ' and ' int2str(sum(yi))])
subplot(2,2,2),plot(x,yoF/sum(yoF),x,yiF/sum(yiF),'r:')
title(['facing; n=' int2str(sum(yoF)) ' and ' int2str(sum(yiF))])
subplot(2,2,3),plot(x,yoP/sum(yoP),x,yiP/sum(yiP),'r:'),
title(['psi0; n=' int2str(sum(yoP)) ' and ' int2str(sum(yiP))])
subplot(2,2,4),plot(x,yoN/sum(yoN),x,yiN/sum(yiN),'r:'),
title(['nest flying; n=' int2str(sum(yoN)) ' and ' int2str(sum(yiN))])
save tempplotflightsections


function PlotTheDataL(x,s1,s2,s3,s4,sP,sF,sPi,sFi,s3l,s4l,sPl,sFl,tst,t1st,t2st)

[sm1,i1]=max(s1);[sm2,i2]=max(s2);
[smP,iP]=max(sP);[smF,iF]=max(sF);%[smN,iN]=max(sN);
sop=x([i2 i1 iP iF]);% iN]);
[sm3,i3]=max(s3);[sm4,i4]=max(s4);
[smPi,iP]=max(sPi);[smFi,iF]=max(sFi);%[smNi,iN]=max(sNi);
sip=x([i4 i3 iP iF]);% iN]);
[sm3l,i3]=max(s3l);[sm4l,i4]=max(s4l);
[smPl,iP]=max(sPl);[smFl,iF]=max(sFl);%[smNi,iN]=max(sNi);
slp=x([i4 i3 iP iF]);% iN]);

    no=sum(s2);ni=sum(s4);nl=sum(s4l);
    subplot(2,2,1),plot(x,s2/no,x,s4/ni,'r:',x,s4l/nl,'k--'),axis tight
xlabel({['OUT:p=' int2str(sop(1)) ', ht=' num2str(sm2/no,2) ', n=' int2str(no) ...
    '; IN:p=' int2str(sip(1)) ', ht=' num2str(sm4/ni,2) ', n=' int2str(ni) ]; ...
    ['LOOP:p=' int2str(slp(1)) ', ht=' num2str(sm4l/nl,2) ', n=' int2str(nl)]})
title([t1st t2st ', psi0 and ' tst ' facing'])
    
    no=sum(sF);ni=sum(sFi);nl=sum(sFl);
    subplot(2,2,3),plot(x,sF/no,x,sFi/ni,'r:',x,sFl/nl,'k--'),axis tight
xlabel({['OUT:p=' int2str(sop(4)) ', ht=' num2str(smF/no,2) ', n=' int2str(no) ...
    '; IN:p=' int2str(sip(4)) ', ht=' num2str(smFi/ni,2) ', n=' int2str(ni)]; ...
    ['LOOP:p=' int2str(slp(4)) ', ht=' num2str(smFl/nl,2) ', n=' int2str(nl)]})
title([t1st t2st ', facing ' tst ' only'])

    no=sum(sP);ni=sum(sPi);nl=sum(sPl);
    subplot(2,2,2),plot(x,sP/no,x,sPi/ni,'r:',x,sPl/nl,'k--'),axis tight
xlabel({['OUT:p=' int2str(sop(3)) ', ht=' num2str(smP/no,2) ', n=' int2str(no) ...
    '; IN:p=' int2str(sip(3)) ', ht=' num2str(smPi/ni,2) ', n=' int2str(ni)]; ...
    ['LOOP:p=' int2str(slp(3)) ', ht=' num2str(smPl/nl,2) ', n=' int2str(nl)]})
title([t1st t2st ', Psi 0 only'])

    no=sum(s1);ni=sum(s3);nl=sum(s3l);
    subplot(2,2,4),plot(x,s1/no,x,s3/ni,'r:',x,s3l/nl,'k--'),axis tight
xlabel({['OUT:p=' int2str(sop(2)) ', ht=' num2str(sm1/no,2) ', n=' int2str(no) ...
    '; IN:p=' int2str(sip(2)) ', ht=' num2str(sm3/ni,2) ', n=' int2str(ni)]; ...
    ['LOOP:p=' int2str(slp(2)) ', ht=' num2str(sm3l/nl,2) ', n=' int2str(nl)]})
title([t1st t2st ', All data'])


function PlotTheData(x,s1,s2,s3,s4,sP,sF,sPi,sFi,sN,sNi,tst,t1st,t2st)

[sm1,i1]=max(s1);[sm2,i2]=max(s2);
[smP,iP]=max(sP);[smF,iF]=max(sF);[smN,iN]=max(sN);
sop=x([i2 i1 iP iF iN]);
[sm3,i3]=max(s3);[sm4,i4]=max(s4);
[smPi,iP]=max(sPi);[smFi,iF]=max(sFi);[smNi,iN]=max(sNi);
sip=x([i4 i3 iP iF iN]);

    no=sum(s2);ni=sum(s4);
    subplot(2,2,1),plot(x,s2/no,x,s4/ni,'r:'),axis tight
xlabel(['OUT:peak=' int2str(sop(1)) ', ht=' num2str(sm2/no,2) ', n=' int2str(no) ...
    '; IN:peak=' int2str(sip(1)) ', ht=' num2str(sm4/ni,2) ', n=' int2str(ni)])
title([t1st t2st ', psi0 and ' tst ' facing'])
    
    no=sum(sF);ni=sum(sFi);
%     subplot(2,2,3),plot(x,sF/no,x,sFi/ni,'r:'),axis tight
    subplot(2,2,3),plot(x,sF/no,x,sFi/ni,'r:',x,sN/sum(sN),'k-',x,sNi/sum(sNi),'k--'),axis tight
xlabel(['OUT:peak=' int2str(sop(4)) ', ht=' num2str(smF/no,2) ', n=' int2str(no) ...
    '; IN:peak=' int2str(sip(4)) ', ht=' num2str(smFi/ni,2) ', n=' int2str(ni)])
title([t1st t2st ', facing ' tst ' only'])

    no=sum(sP);ni=sum(sPi);
    subplot(2,2,2),plot(x,sP/no,x,sPi/ni,'r:'),axis tight
xlabel(['OUT:peak=' int2str(sop(3)) ', ht=' num2str(smP/no,2) ', n=' int2str(no) ...
    '; IN:peak=' int2str(sip(3)) ', ht=' num2str(smPi/ni,2) ', n=' int2str(ni)])
title([t1st t2st ', Psi 0 only'])

    no=sum(s1);ni=sum(s3);
    subplot(2,2,4),plot(x,s1/no,x,s3/ni,'r:'),axis tight
xlabel(['OUT:peak=' int2str(sop(2)) ', ht=' num2str(sm1/no,2) ', n=' int2str(no) ...
    '; IN:peak=' int2str(sip(2)) ', ht=' num2str(sm3/ni,2) ', n=' int2str(ni)])
title([t1st t2st ', All data'])



function[allo2n,o2n,o2nP,o2nF,o2nN,dSo,dSoP,dSoF,dSoN,allsos,sos,sosP,sosF,sosN] ...
    = psi0Loops(inout,st,norlm,opt,onept,excl,tex)

% Get Data file
fs=dir('Loops*.mat');
WriteFileOnScreen(fs,1);
Picked=input('select output file; return for all:  ');
if(isempty(Picked)) Picked=1:length(fs); end;
fns=fs(Picked);

rs=[];rsm=[];ra_s=[];ra_sm=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];
ts=[];

allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

psiP=[];sosP=[];allcsP=[];o2nP=[];
psiF=[];sosF=[];allcsF=[];o2nF=[];
psiN=[];sosN=[];allcsN=[];o2nN=[];
dSo=[];dSoP=[];dSoF=[];dSoN=[];

allrelf=[];allpsi=[];

for k=1
    load(fns(1).name);
    %     if(~isequal(fns,1))
    %         load(fns(k).name);
    %         changedir(loops(1).fn);
    %     end
    for i=1:length(loops)
        clear Cent_Os sOr OToNest LMs
        l=loops(i).loop;
        pic=loops(i).Picked;
        fn=loops(i).fn;
        load(fn);
        if(exist('sOr'))
        
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        lmo=LMOrder(LM);
        fdir=AngularDifference(Cent_Os,sOr);
        [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);

        if(norlm==0) relf2n=AngularDifference(Cent_Os,OToNest);
        else
            relf2n=AngularDifference(Cent_Os,LMs(lmo(norlm)).OToLM);
            in=ils(lmo(norlm)).is;
        end

        % get indices within a loop
        loopis=[];
        for j=1:length(l)
            if(pic(j))
                is=l(j).is;
                loopis=union(loopis,is);
            end
        end
        
        % run filters
        thr=10;
        ipsi=intersect(find(abs(fdir*180/pi)<thr),loopis);
        inest=intersect(find(abs(relf2n*180/pi)<thr),loopis);
        iface=intersect(in,loopis);
        ib=intersect(ipsi,iface);
        
        if(opt==0) is=ib;
        elseif(opt==1) is=intersect(ipsi,in);
        elseif(opt==2) is=ipsi;
        elseif(opt==3) is=iface;
        elseif(opt==4) is=in;
        end
        
        if(excl)
            iface=setdiff(iface,ib);
            ipsi=setdiff(ipsi,ib);
        end
        %
        if(i==1)
            nLM=length(LMs);
            figure(1)
         PlotNestAndLMs(LM,LMWid,[0 0],0);     hold on;
           
            %             for lm=1:nLM
            %                 if(length(allLM)<lm)
            %                     allLM(lm).LMOnRetina=[];
            %                     allLM(lm).OToLM=[];
            %                     allLM(lm).psilm=[];
            %                     allLM(lm).allpsilm=[];
            %                 end
            %             end
        end
        
        allsos=[allsos sOr(loopis)];
        allcos=[allcos Cent_Os(loopis)'];
        if(norlm==0) allo2n=[allo2n OToNest(loopis)'];
        else allo2n=[allo2n LMs(lmo(norlm)).OToLM(loopis)'];
        end
        allpsi=[allpsi fdir(loopis)'];
        allrelf=[allrelf relf2n(loopis)'];
%         for lm=1:nLM
%             allLM(lm).allpsilm=[allLM(lm).allpsilm fdir(ils(lm).is)'];
%         end;
       
        figure(1);
        % either plot one data point for each incident 
        % of nest facing/flying or the whole thing
        [psi,sos,allcs,o2n,db]=GetPData(Cents,t,is,st,onept,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psi,sos,allcs,o2n,tex);                
        [psiP,sosP,allcsP,o2nP,dP]=GetPData(Cents,t,ipsi,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiP,sosP,allcsP,o2nP,tex);                
        [psiF,sosF,allcsF,o2nF,dF]=GetPData(Cents,t,iface,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiF,sosF,allcsF,o2nF,tex);                
        [psiN,sosN,allcsN,o2nN,dN]=GetPData(Cents,t,inest,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiN,sosN,allcsN,o2nN,tex);                
        
%         dSo=[dSo db];
%         dSoP=[dSoP dP];
%         dSoF=[dSoF dF];
%         dSoN=[dSoN dN];

        dSo=[dSo;db];
        dSoP=[dSoP;dP];
        dSoF=[dSoF;dF];
        dSoN=[dSoN;dN];

        %         psinest=[psinest fdir(intersect(is,in))'];
%         allLM(1).LM=LM;
%         for lm=1:nLM
%             allLM(lm).LMOnRetina=[allLM(lm).LMOnRetina;LMs(lm).LMOnRetina(is)];
%             allLM(lm).OToLM=[allLM(lm).OToLM;LMs(lm).OToLM(is)];
%             allLM(lm).psilm=[allLM(lm).psilm fdir(intersect(is,ils(lm).is))'];
%         end
        
        else disp(['file ' fn ' not processed ******']);
        end
    end    
end
figure(1);
hold off;

function[allo2n,o2n,o2nP,o2nF,o2nN,dSo,dSoP,dSoF,dSoN,allsos,sos,sosP,sosF,sosN] ...
    = psi0(inout,st,norlm,opt,onept,excl,tex)

s=dir(['*' inout '*All.mat']);
% WriteFileOnScreen(s,1);
% Picked=input('select file numbers. Return to select all:   ');
% if(isempty(Picked)) Picked=1:length(s); end;
Picked=1:length(s);

rs=[];rsm=[];ra_s=[];ra_sm=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];
ts=[];

allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

psiP=[];sosP=[];allcsP=[];o2nP=[];
psiF=[];sosF=[];allcsF=[];o2nF=[];
psiN=[];sosN=[];allcsN=[];o2nN=[];
dSo=[];dSoP=[];dSoF=[];dSoN=[];

allrelf=[];allpsi=[];

for k=1
    %     if(~isequal(fns,1))
    %         load(fns(k).name);
    %         changedir(loops(1).fn);
    %     end
    for i=1:length(Picked)
        i
        clear Cent_Os sOr OToNest LMs
        fn=s(Picked(i)).name;
        load(fn);
        if(exist('sOr'))
        
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        lmo=LMOrder(LM);
        fdir=AngularDifference(Cent_Os,sOr);

        [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);
        
        if(norlm==0) relf2n=AngularDifference(Cent_Os,OToNest);
        else
            relf2n=AngularDifference(Cent_Os,LMs(lmo(norlm)).OToLM);
            in=ils(lmo(norlm)).is;
        end
        
        % run filters
        thr=10;
        ipsi=find(abs(fdir*180/pi)<thr);
        inest=find(abs(relf2n*180/pi)<thr);
        iface=in;
        ib=intersect(ipsi,iface);
        
        if(opt==0) is=ib;
        elseif(opt==1) is=intersect(ipsi,in);
        elseif(opt==2) is=ipsi;
        elseif(opt==3) is=iface;
        elseif(opt==4) is=in;
        end
        
        if(excl)
            iface=setdiff(iface,ib);
            ipsi=setdiff(ipsi,ib);
        end
        %
        if(i==1)
            nLM=length(LMs);
            figure(1)
         PlotNestAndLMs(LM,LMWid,[0 0],0);     hold on;
           
            %             for lm=1:nLM
            %                 if(length(allLM)<lm)
            %                     allLM(lm).LMOnRetina=[];
            %                     allLM(lm).OToLM=[];
            %                     allLM(lm).psilm=[];
            %                     allLM(lm).allpsilm=[];
            %                 end
            %             end
        end
        
        allsos=[allsos sOr];
        allcos=[allcos Cent_Os'];
        if(norlm==0) allo2n=[allo2n OToNest'];
        else allo2n=[allo2n LMs(lmo(norlm)).OToLM'];
        end
        allpsi=[allpsi fdir'];
        allrelf=[allrelf relf2n'];
%         for lm=1:nLM
%             allLM(lm).allpsilm=[allLM(lm).allpsilm fdir(ils(lm).is)'];
%         end;
        

        
%         figure(1);
        % either plot one data point for each incident 
        % of nest facing/flying or the whole thing
        [psi,sos,allcs,o2n,db]=GetPData(Cents,t,is,st,onept,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psi,sos,allcs,o2n,tex);                
        [psiP,sosP,allcsP,o2nP,dP]=GetPData(Cents,t,ipsi,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiP,sosP,allcsP,o2nP,tex);                
        [psiF,sosF,allcsF,o2nF,dF]=GetPData(Cents,t,iface,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiF,sosF,allcsF,o2nF,tex);                
        [psiN,sosN,allcsN,o2nN,dN]=GetPData(Cents,t,inest,st,onept-2,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psiN,sosN,allcsN,o2nN,tex);                
        
%         dSo=[dSo db];
%         dSoP=[dSoP dP];
%         dSoF=[dSoF dF];
%         dSoN=[dSoN dN];

        dSo=[dSo;db];
        dSoP=[dSoP;dP];
        dSoF=[dSoF;dF];
        dSoN=[dSoN;dN];
        
        %         psinest=[psinest fdir(intersect(is,in))'];
%         allLM(1).LM=LM;
%         for lm=1:nLM
%             allLM(lm).LMOnRetina=[allLM(lm).LMOnRetina;LMs(lm).LMOnRetina(is)];
%             allLM(lm).OToLM=[allLM(lm).OToLM;LMs(lm).OToLM(is)];
%             allLM(lm).psilm=[allLM(lm).psilm fdir(intersect(is,ils(lm).is))'];
%         end
        
        else disp(['file ' fn ' not processed ******']);
        end
    end    
end
figure(1);
hold off;

function[psi,sos,allcs,o2n,dSo]=GetPData(Cents,t,is,st,onept,...
    fdir,LMs,OToNest,Cent_Os,sOr,norlm,lmo,fn,psi,sos,allcs,o2n,tex)

if(abs(onept)==1) 
    [st,en,ldum,incid]=PlotFBits(Cents,t,is,st,onept);
    is=incid; 
end
psi=[psi fdir(is)'];
sos=[sos sOr(is)];
allcs=[allcs; Cent_Os(is)];
if(norlm==0) 
    o2n=[o2n OToNest(is)'];
    bb=OToNest*180/pi;
    str=' nest';
    [mo,ro]=MeanAngle(OToNest(is));
    medo=circ_median(OToNest(is));
else o2n=[o2n LMs(lmo(norlm)).OToLM(is)'];
    [mo,ro]=MeanAngle(LMs(lmo(norlm)).OToLM(is));
    medo=circ_median(LMs(lmo(norlm)).OToLM(is));
    bb=LMs(lmo(norlm)).OToLM'*180/pi;
    str=' LM';
end
% calculate angular medians and means
[mp,rp]=MeanAngle(fdir(is));medp=circ_median(fdir(is));
[ms,rs]=MeanAngle(sOr(is)');meds=circ_median(sOr(is)');
[mc,rc]=MeanAngle(Cent_Os(is));medc=circ_median(Cent_Os(is));
dSo=[length(is) meds ms rs medc mc rc medo mo ro medp mp rp]; 

% tex=0.2;

% dSo=[];
% if(onept==1)
%     da=MyGradient(AngleWithoutFlip(sOr),t);
% %     dSo=[dSo median(abs(da))];
%     for i=1:length(st)       
%         ts=GetTimes(t,[t(st(i))-tex;t(en(i))+tex]);
%         j1s=ts(1):st(i);%ts(2);
%         j2s=en(i):ts(2);
%         js=ts(1):ts(2);
%         ks=st(i):en(i);
% 
%         pea= round(bb(incid(i)));
%         if((pea>320)&(pea<=350))
% %             tl=t(ts(2))-t(ts(1));
%             tl=t(st(i))-t(ts(1));
% %             da=abs(AngularDifference(sOr(ts(1)),sOr(js)));
%         dSo=[dSo median(abs(da(js)))];  
% %         dSo=[dSo AngularDifference(sOr(ts(2)),sOr(ts(1)))/tl];  
%         
% %         figure(4)    
% %         subplot(3,1,1),plot(t(js),sOr(js)*180/pi,t(ks),sOr(ks)*180/pi,'r.')
% %         ylabel('Body orientation'),axis tight
% %         title([fn(1:end-4) ': peak=' int2str(pea) '; T=' num2str(t(incid(i)))]) 
% %         subplot(3,1,2),plot(t(js),fdir(js)*180/pi,t(ks),fdir(ks)*180/pi,'r.')
% %         ylabel('\psi'),axis tight
% %         subplot(3,1,3),plot(t(js),bb(js),t(ks),bb(ks),'r.')
% %         ylabel(['Orientation to' str]),axis tight
% % figure(1)
% % hdl=plot(Cents(incid(i),1),Cents(incid(i),2),'ks');
% % 
% %         disp('press return to continue')
% %         pause
% %         delete(hdl);
%         end
%     end
% end


function[s,e,l,incid]=PlotFBits(cs,t,is,st,opt,so)
if(isempty(is)) 
    s=[];e=[];l=[];incid=[];
    return; 
end;
d=diff(is);
[s,e,l,incid]=StartFinish(t,is,0.1);
% if(opt>=0)
%     figure(1)
%     for i=1:length(s)
%         % either plot one data point for each incident
%         % of nest facing/flying or the whole thing
%         if(opt==1) plot(cs(incid(i),1),cs(incid(i),2),st)
%         else
%             js=s(i):e(i);
%             plot(cs(js,1),cs(js,2),st)
%         end
%     end
% end

function[s,e,l,incid]=StartFinish(t,is,th)
s=[];e=[];l=[];
if(isempty(is)) return; end;
i=1;
while 1
    s=[s is(i)];
    ex=find(diff(t(is(i:end)))>th,1);
    if(isempty(ex)) 
        e=[e is(end)];
        break;
    else e=[e is(i+ex-1)];
    end
    i=i+ex;
end
l=e-s+1;
for i=1:length(s)
    is=s(i):e(i);
    meanT(i)=mean(t(is));
    incid(i)=GetTimes(t,meanT(i));
end
    

function changedir(fn)
if(isequal(fn(1:4),'2E20')) cd ../2' east all'/
elseif(isequal(fn(1:4),'2w20')) cd ../'2 west'/
elseif(isequal(fn(1:2),'W8')) cd ../'west 8'/
elseif(isequal(fn(1:2),'N8')) cd ../'north 8'/
elseif(isequal(fn(1:2),'E8')) cd ../'east 8'
elseif(isequal(fn(1:2),'s8')) cd ../'south 8'
end


function psi0looks
all=[];al1=[];al2=[];nn=0;nl1=0;nl2=0;nb1=0;nb2=0;
th=0.1745;
for i=1:length(loops)
    all=[all;loops(i).fdir(loops(i).in)];
    %     al1=[al1;loops(i).fdir(loops(i).ils(1).is)];
    %     al2=[al2;loops(i).fdir(loops(i).ils(2).is)];
    nn=nn+length(find(abs(loops(i).fdir(loops(i).in))<th));
    nl1=nl1+length(find(abs(loops(i).fdir(loops(i).ils(1).is))<th));
    nl2=nl2+length(find(abs(loops(i).fdir(loops(i).ils(2).is))<th));
    ib1=intersect(loops(i).ils(1).is,loops(i).in);
    ib2=intersect(loops(i).ils(2).is,loops(i).in);
    nb1=nb1+length(find(abs(loops(i).fdir(ib1))<th));
    nb2=nb2+length(find(abs(loops(i).fdir(ib2))<th));
    al1=[al1;loops(i).fdir(ib1)];
    al2=[al2;loops(i).fdir(ib2)];
end
[y,x]=AngHist(all*180/pi);[y1,x]=AngHist(al1*180/pi);[y2,x]=AngHist(al2*180/pi);
plot(x,y/sum(y),'b',x,y1/sum(y1),'r--',x,y2/sum(y2),'k:','LineWidth',1.5),setbox,axis tight

