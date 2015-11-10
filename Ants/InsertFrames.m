function InsertFrames(fnin,fn_out,dat_in,FRLEN)
load(fnin);
% correct the number of bees
if(FullFrame==1)
    inds=floor(([dat_in.fr]+1)/2);
    NumBees(inds)=NumBees(inds)+1;
else
    NumBees([dat_in.fr])=NumBees([dat_in.fr])+1;
end
for i=1:length(dat_in.fr)
    fr=dat_in.fr(i);
    if(ismember(fr,FrameNum))
        disp('something wrong with beeCoordsCheckGap or beecoordsCheckNest')
    else
    % finr the position before the insert
    b4=find(FrameNum<fr,1,'last');
        
    % insert the data we have
    FrameNum=InsertInVec(FrameNum,fr,b4,1);
    Cents=InsertInVec(Cents,dat_in.cs(i,:),b4,0);
    EPt=InsertInVec(EPt,dat_in.ep(i,:),b4,0);
    EndPt=InsertInVec(EndPt,dat_in.ep(i,:),b4,0);
    Orients=InsertInVec(Orients,dat_in.or(i),b4,1);
    ang_e=InsertInVec(ang_e,dat_in.or(i),b4,1);
    len_e=InsertInVec(len_e,dat_in.len(i),b4,1);

    % interpolate some data
    odev=mod(FrameNum,2);
    if(isempty(b4))
        WhichB=InsertInVec(WhichB,WhichB(1),b4,1);
    else
        if(length(WhichB)<(b4+2))
            WhichB=InsertInVec(WhichB,WhichB(b4),b4,1);
        elseif((fr-FrameNum(b4))>(FrameNum(b4+2)-fr))
            WhichB=InsertInVec(WhichB,WhichB(b4+2),b4,1);
        else
            WhichB=InsertInVec(WhichB,WhichB(b4),b4,1);
        end
    end

    % put some NaNs in
    Areas=InsertInVec(Areas,NaN,b4,1);
    Bounds=InsertInVec(Bounds,NaN*ones(size(Bounds(1,:))),b4,0);
    MeanCol=InsertInVec(MeanCol,NaN,b4,1);
    NLess=InsertInVec(NLess,NaN,b4,1);
    area_e=InsertInVec(area_e,NaN,b4,1);
    elips=InsertInVec(elips,NaN,b4,1);
    eccent=InsertInVec(eccent,NaN,b4,1);
    end
end

t=FrameNum*FRLEN;
v1=MyGradient(Cents(:,1),FrameNum);
v2=MyGradient(Cents(:,2),FrameNum);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

clear dat_in fnin v1 v2 i fr;
save(fn_out)

function[v]=InsertInVec(v,x,b4,isrow)

if(isstruct(v))
    v2=v;
    x=NaN*ones(size(v(1).elips));
    v(end+1).elips=x;
    if(isempty(b4))
        v(1).elips=x;
        v(2:end)=v2;
    else
        v(b4+1).elips=x;
        v((b4+2):end)=v2((b4+1):end);
    end
elseif(isrow)
    if(isempty(b4))
        v=[x v];
    else
        v=[v(1:b4) x v((b4+1):end)];
    end
else
    if(isempty(b4))
        v=[x; v];
    else
        v=[v(1:b4,:); x; v((b4+1):end,:)];
    end
end

