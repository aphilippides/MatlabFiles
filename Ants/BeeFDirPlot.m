% function BeeFDirPlot(so,fdir,nor,lor,fnum,tst,otonest,fnum2,psiang,opt)
%
% function to plot various phase plane etc plots based on psi etc
% if fnum2 is a single number, plots the later plots as a subplot
%
% could change this to negative number

function BeeFDirPlot(so,fdir,nor,lor,fnum,tst,otonest,fnum2,psiang,opt)
if(nargin<5) fnum=1; end;
if(nargin<6) tst=[]; end;
if(isempty(so)) return; end;

ds=AngularDifference(fdir,so)*180/pi;
[d,a,b,x1,y]=Density2D(ds,nor,[-180:10:180],[-180:10:180]);

if(nargin<9) 
    psi0=find(abs(ds)<10);
    psiang =[0 10];
else
    psiang=abs(psiang);
    psi0=find((abs(ds)>=psiang(1))&(abs(ds)<=psiang(2)));
end

if(nargin<10) opt=1; end
% [df,a,b,x,y]=Density2D(fdir*180/pi,nor,[0:10:360],[-180:10:180]);
% [dso,a,b,x,y]=Density2D(so*180/pi,nor,[0:10:360],[-180:10:180]);


figure(fnum)
% subplot(3,1,1)
% contourf(x,y,df)
% title([tst 'Retinal nest position vs (top to bottom) flight direction, body orientation and difference'])
% subplot(3,1,2)
% contourf(x,y,dso)
% subplot(3,1,3)
if(~opt) contourf(x1,y,d)
else
    contourf(x1,y,max(d(:))-d)
    colormap gray
end
title([tst 'Retinal nest position vs \psi'])
xlabel('\psi');ylabel('Retinal nest position');Setbox;axis tight

figure(fnum+1)
[d,a,b,x1,y]=Density2D(ds,so*180/pi,[-180:10:180],[0:10:360]);
if(~opt) contourf(x1,y,d)
else
    contourf(x1,y,max(d(:))-d)
    colormap gray
end
title([tst 'body orientation vs \psi']);
xlabel('\psi');ylabel('body orientation');Setbox;axis tight
if(nargin>=7)
    dtonest=AngularDifference(fdir,otonest)*180/pi;
    [dstonest,a,b,x1,y]=Density2D(ds,dtonest,[-180:10:180],[-180:10:180]);
    figure(fnum+2)
    if(~opt) contourf(x1,y,dstonest)
    else
        contourf(x1,y,max(dstonest(:))-dstonest)
        colormap gray
    end
    title([tst 'flight direction vs \psi']);
    xlabel('\psi');ylabel('flight direction relative to nest');Setbox;axis tight
    figure(fnum+3)
    [y,xs]=AngHist(dtonest,0:10:360,0,0);rel2n=y./sum(y);
    botonest=AngularDifference(so,otonest)*180/pi;
    [y,xs]=AngHist(botonest,0:10:360,0,0);bo2n=y./sum(y);
    plot(xs,rel2n,'b',xs,bo2n,'r')
    xlabel('angle (degrees)');ylabel('frequency');Setbox;axis tight
    title([tst 'Flight direction (blue) and body orientation (red) relative to nest']);
end

nLM=length(lor);
plotlmstuff=(nLM>0)&&isequal(length(fdir),length(lor(nLM).LMOnRetina));


if(plotlmstuff)
for i=1:nLM
    figure(fnum+4+i) 
    lst=LMStr(i,lor(1).LM);
    llor=[lor(i).LMOnRetina]*180/pi;
    dtolm=AngularDifference(fdir,lor(i).OToLM)*180/pi;
    [d,a,b,x1,y]=Density2D(ds,llor,[-180:10:180],[-180:10:180]);
    [df,a,b,x1,y]=Density2D(ds,dtolm,[-180:10:180],[-180:10:180]);
    [dso,a,b,x,y]=Density2D(so*180/pi,llor,[0:10:360],[-180:10:180]);

    if(~opt) contourf(x1,y,d)
    else
        contourf(x1,y,max(d(:))-d)
        colormap gray
    end
    title([tst lst ' LM, Retinal position vs \psi'])
    xlabel('\psi');ylabel([lst ' LM, Retinal position']);Setbox;axis tight
    figure(fnum+4+nLM+i) 
    if(~opt) contourf(x1,y,df)
    else
        contourf(x1,y,max(df(:))-df)
        colormap gray
    end
    title([tst ' Flight direction relative to ' lst ' LM, vs \psi'])
    xlabel('\psi');ylabel(['Flight direction relative to ' lst ' LM']);Setbox;axis tight
end
end

if(plotlmstuff) denses=zeros(3+2*nLM,36);
% else denses=zeros(3,36);
end
if(~isempty(psi0)&&opt)
    sb=['\pm[' int2str(psiang(1)) ' ' int2str(psiang(2)) ']'];
    [y,xxs]=AngHist(nor(psi0),0:10:360,0,0);denses(1,:)=y./sum(y);
    strs(1).s=['Retinal nest position when \psi=' sb];
    y=AngHist(dtonest(psi0),0:10:360,0,0);denses(2,:)=y./sum(y);
    strs(2).s=['Flight direction relative to nest when \psi=' sb];
    y=AngHist(ds,0:10:360,0,0);denses(3,:)=y./sum(y);
    strs(3).s='\psi';
    % check in case using data from 1 and 2 LMs
    sp=3;
    if(plotlmstuff)
        for i=1:nLM
            lst=LMStr(i,lor(1).LM);
            y=AngHist(lor(i).LMOnRetina(psi0)*180/pi,0:10:360,0,0);denses(sp+i,:)=y./sum(y);
            strs(sp+i).s=['Retinal ' lst ' LM position when \psi=0'];
            dtolm=AngularDifference(fdir,lor(i).OToLM)*180/pi;
            y=AngHist(dtolm(psi0),0:10:360,0,0);denses(sp+nLM+i,:)=y./sum(y);
            strs(sp+nLM+i).s=['Flight direction relative to ' lst ' LM when \psi=0'];
        end
    end
    for i=1:size(denses,1)
        if(length(fnum2)>1) figure(fnum2(i));
        else
            figure(fnum2)
            subplot(nLM+2,2,i)
        end
        if(~isequal(tst(1),'I')) 
            plot(xxs,denses(i,:),'b')
            Setbox;axis tight
            xlabel(strs(i).s)
            ylabel('frequency (normalised)')
        else
            hold on
            plot(xxs,denses(i,:),'r')
            hold off
            Setbox;axis tight
            xlabel(strs(i).s)
            ylabel('frequency (normalised)')
        end
    end
end

% d=d.*(d>1);
% contourf(x,y,max(d(:))-d);
% colormap gray
