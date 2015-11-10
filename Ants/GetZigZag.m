function[zz]=GetZigZag(fn,athresh,NestArc)
compassDir=4.9393;
load(fn);
lmo=LMOrder(LM);
if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
end
% [EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,0.5);
% EndPt=EndPt+Cents;

tInc=0.5;
ils=1;
ilen=max(ils+1,GetTimes(t,t(1)+2));
iall=[];
chosen=[];
j=1;
zz=InitZigZag(fn);
flip=1;
lent=length(t);
while 1
    if(length(iall)>1)
        [area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
        % sort 180 degree ambiguity
        ep=Cents(iall(1),:);
        sp=Cents(iall(end),:);
        t2s=cart2pol(sp(1)-ep(1),sp(2)-ep(2));
        if(abs(AngularDifference(t2s,angles(1)))>(pi/2)) angles=angles+pi;end
        angles=mod(angles,2*pi);

        angs=mod(angles-compassDir,2*pi);
        dang=AngularDifference(angs(flip),Cent_Os(iall))*180/pi;
        zigs=iall(find(dang<-athresh));
        zags=iall(find(dang>athresh));
        [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,Cents);
        [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,Cents);
        c=mean(Cents(iall,:));
        % get angle to circle around nest
        [dang,tn]=Ang2Nest(NestArc,angles(1),c,sp);
    end
    ils=min(max(ils,1),lent-1);
    ilen=max(2,min(ilen,lent));
    ileft=ils:ilen;
    iallp=intersect(iall,ileft);
    chosenp=intersect(chosen,ileft);

    % Plot stuff
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;    
    plot(Cents(ileft,1),Cents(ileft,2),'k')
    plot(Cents(iallp,1),Cents(iallp,2),'r')
    plot(Cents(chosenp,1),Cents(chosenp,2),'go')
    text(Cents(ils,1),Cents(ils,2),'S')
    text(Cents(ilen,1),Cents(ilen,2),'E','Color','r')
    axis equal
    hold off

    %     plot(EndPt(:,1),EndPt(:,2),'y.')
%     plot([Cents(:,1) EndPt(:,1)]',[Cents(:,2) EndPt(:,2)]','y')
%     plot(EndPt(iall,1),EndPt(iall,2),'b.')
%     plot([Cents(iall,1) EndPt(iall,1)]',[Cents(iall,2) EndPt(iall,2)]','b')
%     plot(EndPt(zigs,1),EndPt(zigs,2),'ko')
%     plot(EndPt(zags,1),EndPt(zags,2),'ro')
%     for i=1:length(zig1)
%         is=zig1(i):zig2(i);
%         plot(Cents(is,1),Cents(is,2),'k')
%     end
%     for i=1:length(zag1)
%         is=zag1(i):zag2(i);
%         plot(Cents(is,1),Cents(is,2),'r')
%     end
%     plot(ellip(:,1),ellip(:,2),'r')
%     PlotAngLine(angles,c);
%     plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'ko','MarkerFaceColor','k')
%     plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'ro','MarkerFaceColor','r')

%     zz(j).good=1;
%     xlabel(num2str(dang))
%     break;
    xlabel('Cursor arrows moves available points. t to change the time increment');
    [ind1,b]=GetNearestClickedPt(Cents(ileft,:),'click start pt; right click or b if bad; return to stop;f to flip angle');
    if(isempty(b))
        fla=FlushResponse;
        if(fla==2)
            ils=1;
            ilen=max(ils+1,GetTimes(t,t(1)+2));
            iall=[];
            chosen=[];
            j=1;
            zz=InitZigZag(fn);
        elseif(fla<3)
            if(length(iall)>1)
                zz(j).good=1;
                zz(j).fn=fn;
                zz(j).is=iall;
                zz(j).ds=dang;
                zz(j).angs=angs;
                zz(j).zigs=zigs;
                zz(j).zags=zags;
                zz(j).angles=angles;
                zz(j).t2nest=dang;
                zz(j).lzig=lzig;
                zz(j).zigas=zigas;
                zz(j).lzag=lzag;
                zz(j).zagas=zagas;
            end
            if(fla==0) break;
            elseif(length(iall)>1)
                chosen=union(chosen,iall);
                j=j+1;
                ils=iall(end)+1;
                ilen=max(ils+1,GetTimes(t,t(ils)+2));
                iall=[];
%                 zz(j)=InitZigZag(fn);              
            end
        elseif(fla==4) break;
        end
    elseif((b==3)||(b==2)||(isequal(b,'b')))
        if(j==1) title('file is declared bad'); 
        else title('no zig zags found'); 
        end;
        fla=FlushResponse;
        if(fla==0) break;
        elseif(fla==2)
            ils=1;
            ilen=max(ils+1,GetTimes(t,t(1)+2));
            iall=[];
            chosen=[];
            zz=[];
            j=1;
            zz=InitZigZag(fn);
        elseif(fla==4) break;
        end
    elseif(isequal(b,'f'))
        if(flip==1) flip=2;
        else flip=1;
        end
    elseif(b==28) ils=max(ils+1,GetTimes(t,t(ils)+tInc));
    elseif(b==29) ils=min(ils-1,GetTimes(t,t(ils)-tInc));
    elseif(b==30) ilen=min(ilen-1,GetTimes(t,t(ilen)-tInc));
    elseif(b==31) ilen=max(ilen+1,GetTimes(t,t(ilen)+tInc));
    elseif(isequal(b,t))
        while 1
            newt=input(['Enter new increment, currently ' num2str(tInc) ':  ']);
            if(newt>0)
                tInc=newt;
                break;
            end
        end
    else
        ind1=ileft(ind1);
        while 1
            [ind2,b]=GetNearestClickedPt(Cents(ileft,:),'click end pt');
            if(ind2>0)
                ind2=ileft(ind2);
                break;
            end
        end
        if(ind1>ind2)
            tmp=ind1;
            ind1=ind2;
            ind2=tmp;
        end
        iall=ind1:ind2;
    end;
end
    
function[zz]=InitZigZag(fn)
zz(1).good=0;
zz(1).fn=fn;
zz(1).is=[];
zz(1).angles=[NaN NaN]; zz(1).angs=[NaN NaN];
zz(1).ds=NaN;  zz(1).lzag=NaN;
zz(1).t2nest=NaN; zz(1).lzig=NaN;
zz(1).zigas=[]; zz(1).zagas=[];
zz(1).zigs=[]; zz(1).zags=[];


function[fla]=FlushResponse
while 1
    disp(' ');
    disp('0: next file; 1: do another bit; 2: next file without this bit');
    inp=input('r: redo whole file; z, go back:  ','s');
    if(isequal(inp,'0'))
        fla=0;
        break;
    elseif(isequal(inp,'1'))
        fla=1;
        break;
    elseif(isequal(inp,'r'))
        fla=2;
        break;
    elseif(isequal(inp,'z'))
        fla=3;
        break;
    elseif(isequal(inp,'2'))
        fla=4;
        break;
    end
end
    
function PlotAngLine(angs,c)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',xs([2 4]),ys([2 4]),'g')