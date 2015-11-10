function GetPaths(fn)

fnm=['90_21_in30.avi'];
figure(1),ShowBeePath(fn,0,0,fnm)
load(fn);
ilist=unique(WhichB);
lmn=fn(1:5);
FullPaths=[];
for i=ilist
    v=ilist(i);
    is = find(WhichB==v);
%     if(OutofBounds(Bounds(is(1),:),lmn)==1)
%         if(OutofBounds(Bounds(is(end),:),lmn)==2) FullPaths = [FullPaths v];
%         elseif(OutofBounds(Bounds(is(end),:),lmn)==1) FullPaths = [FullPaths v];
%         end
%     elseif(OutofBounds(Bounds(is(1),:),lmn)==2)
%         if(OutofBounds(Bounds(is(end),:),lmn)==1) FullPaths = [FullPaths v];
%         elseif(OutofBounds(Bounds(is(end),:),lmn)==2) FullPaths = [FullPaths v];
%         end
%     end            
    StartPts(i) = is(1);
    EndPts(i) = is(end);
    if(length(is)>1)
        vel(i,:)=Cents(is(end),:)-Cents(is(end-1),:);
    else
        vel(i,:) = [0 0];
    end
    PathLength(i) = length(is);
end

% match those that aren't full paths
Outs = setdiff(ilist,[FullPaths]);
for i=Outs
    flag=1;
    while(flag)
        NOuts=setdiff(Outs,i);
        [IsS,iS]=IsEndPt(EndPts(i),StartPts(NOuts),FrameNum,Cents,vel);
        if(IsS)
            [NOuts,StartPts,EndPts,vel,PathLength,WhichB]=JoinPaths(i,NOuts(iS),WhichB,NOuts,StartPts,EndPts,vel,PathLength,Cents,ilist);
            if(OutofBounds(Bounds(EndPts(i),:),lmn))
                flag=0;
                if(OutofBounds(Bounds(StartPts(i),:),lmn))
                    FullPaths = [FullPaths i];
                end
            end
        else
            flag=0;
        end
    end
end

ilist=unique(WhichB);

Vels=zeros(size(Cents));
for i=ilist
   is = find(WhichB==i);
   if(length(is)>1)
       v=diff(Cents(is,:))./[diff(FrameNum(is))' diff(FrameNum(is))'];
       Vels(is,:)=[v;v(end,:)];
   else
       Vels(is,:)=[0 0];
   end
end
Speeds=sqrt(sum(Vels.^2,2));
Cent_Os=cart2pol(Vels(:,1),Vels(:,2));

% for all full paths, check which orientation is consistent 
% when bee enters and use that to deteremine flip

% Also, check the orientation thing when first measured
    

save([fn(1:end-4) 'Path.mat'],'FrameNum','Areas','NumBees','Cents','Orients', ...
    'WhichB','EndPt','Bounds','Eccent','FullPaths','Speeds','Vels','Cent_Os');

figure(2),ShowBeePath([fn(1:end-4) 'Path.mat'],0,0,fnm)

function[Nns,Ns,Ne,Nv,NPLen,Nw]=JoinPaths(st,en,w,ns,s,e,v,PLen,cs,ilist)
is=find(w==en);
Nw=w;
Nw(is)=st;
newis=find(Nw==st);
Nns=setdiff(ns,en);

i=find(ilist==en);
% NPLen=RemoveRow(PLen',i)';
% Ns=RemoveRow(s',i)';
% Ne=RemoveRow(e',i)';
% Nv=RemoveRow(v,iS);
NPLen=PLen;
Ns=s;
Ne=e;
Nv=v;

i=find(ilist==st);
Ns(i) = newis(1);
Ne(i) = newis(end);
if(length(newis)>1)
    Nv(i,:) = cs(newis(end),:)-cs(newis(end-1),:);
else
    Nv(i,:) = [0 0];
end
NPlen(i)=length(newis);

function[IsStart, IStart] = IsEndPt(EndPt,StartPts,frames,Cents,vel)
dfns = frames(StartPts)-frames(EndPt);
for i=1:length(StartPts)
    PredPos=Cents(EndPt,:)+dfns(i)*vel(i,:);
    ds(i) = sqrt(sum((PredPos-Cents(StartPts(i),:)).^2));
    dls(i)=sqrt(sum((Cents(EndPt,:)-Cents(StartPts(i),:)).^2));
end
ifns=find((dfns>0)&(dfns<=8));
if(isempty(ifns))
    IsStart = 0;
    IStart=0;
else
    [md,mi] = min(ds(ifns));
    if(md<8)
        IsStart = 1;
        IStart=ifns(mi);
    else
        IsStart = 0;
        IStart=0;
    end
end
