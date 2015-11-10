function[zz]=GetLoop(fn,athresh,NestArc)
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

if(nargin<4)
    tInc=0.5;
    te=t(end);
    ils=GetTimes(t,te-2);
    ilen=length(t);
    iall=[];
    chosen=[];
    j=1;
    zz(1).good=0;
    zz(1).fn=fn;
    zz(1).is=iall;
    zz(1).zz=[];
else 
end
while 1
    %         CompassAndLine('k',[],[],compassDir)
    % get angle to circle around nest
    if(length(iall)>1)
        [area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
        sp=Cents(iall(end),:);
        c=mean(Cents(iall,:));
        [dang,tn]=Ang2Nest(NestArc,angles(1),c,sp);
    end
    lent=length(t);
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
    text(Cents(ils,1),Cents(ils,2),'Start')
    text(Cents(ilen,1),Cents(ilen,2),'End','Color','r')
    axis equal
    hold off

    % get start point or select other options
    xlabel('Cursor arrows moves available points. t to change the time increment');
    [ind1,b]=GetNearestClickedPt(Cents(ileft,:),'click start; right click or b if bad or no loops; return ok');
    if(isempty(b))
        fla=FlushResponse;
        if(fla==2)
            te=t(end);
            ils=GetTimes(t,te-2);
            ilen=length(t);
            iall=[];
            zz=[];
            zz(1).good=0;
            zz(1).is=iall;
            zz(1).fn=fn;
            zz(1).zz=[];
            chosen=[];
            j=1;
        elseif(fla<3)
            if(length(iall)>1)
                zz(j).good=1;
                zz(j).fn=fn;
                zz(j).is=iall;
                zz(j).zz=[];
            end
            %             zz(j).ds=dang;
            %             zz(j).angs=angs;
            %             zz(j).zigs=zigs;
            %             zz(j).zags=zags;
            %             zz(j).angles=angles;
            %             zz(j).t2nest=dang;
            %             zz(j).lzig=lzig;
            %             zz(j).zigas=zigas*180/pi;
            %             zz(j).lzag=lzag;
            %             zz(j).zagas=zagas*180/pi;
            if(fla==0) break;
            elseif(length(iall)>1)
                chosen=union(chosen,iall);
                j=j+1;
                ilen=iall(1);
                ils=min(ilen-1,GetTimes(t,t(ilen)-2));
                iall=[];%ils:ilen;
%                 zz(j).good=0;
%                 zz(j).fn=fn;
%                 zz(j).is=iall;
            end
        elseif(fla==4) break;
        end
    elseif((b==3)||(b==2)||(isequal(b,'b')))
        if(j==1) title('file is declared bad');
        else title('no more loops wanted');
        end;
        fla=FlushResponse;
        if(fla==0) break;
        elseif(fla==2)
            te=t(end);
            ils=GetTimes(t,te-2);
            ilen=length(t);
            iall=[];%ils:ilen;
            chosen=[];
            j=1;
            zz=[];
            zz(1).good=0;
            zz(1).fn=fn;
            zz(1).is=iall;
            zz(1).zz=[];
        elseif(fla==4) break;
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