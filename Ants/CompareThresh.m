function CompareThresh
l=dir('*avi')
for i=1:2%length(l)
    f=l(i).name;
%     ns(i).fn=HandData(l(i).name,2);
    s=CheckHand(f(1:end-4));
end

function[s]=CheckHand(f)
load([f '_Hand.mat']);
goods=setdiff(1:length(angs),[bads,unsure]);
% gfs=fnums(goods)';
s(1)=GetData1([f '_Prog.mat']);
s(2)=GetData1([f '_Prog_2.mat']);
s(3)=GetData2([f '_Prog_2.mat']);

for i=1:3
%     is=GetTimes(s(i).f,fnums');
    if(i==3) [dc,is]=getis(cs,s(i).cent);
    else is=GetTimes(s(i).f,fnums');
    end    
    s(i).is=is;
    s(i).dc=s(i).cent(is,:)-cs;
    s(i).sdc=sum(s(i).dc.^2,2);
    s(i).da=AngularDifference(s(i).ang(is),angs);
    ks=find(s(i).da>(pi/2));
    s(i).da(ks)=s(i).da(ks)-pi;
    ks=find(s(i).da<(-pi/2));
    s(i).da(ks)=s(i).da(ks)+pi;    
end
keyboard

function[d,is]=getis(cs,c2s);
is=[];
for i=1:size(cs,1)
    d1=CartDist(c2s,cs(i,:));
    [d(i),ind]=min(d1);
    if(d(i)<5) is=[is ind]; end;
end

function[s]=GetData1(fn)
load(fn);
s.ang=CleanOrients(ang_e);
s.s=AngleWithoutFlip([s.ang])*180/pi;
s.cent=Cents;
[e1x,e1y]=pol2cart([s.ang],20);e1=[e1x',e1y'];
s.EPt=Cents+e1;
% s.el=elips;
s.ar=Areas;
% s.len=20;
s.nb=NumBees;
s.f=FrameNum;
s.t=FrameNum*0.02;
s=orderfields(s);

function[s]=GetData2(fn)
load(fn);

for i=1:length(len_e)
    s.ang(i)=len_e(i).ang;
    s.cent(i,:)=len_e(i).cent;
    s.EPt(i,:)=len_e(i).EPt;
    s.ar(i)=len_e(i).ar;
%     s.len(i)=len_e(i).len;
end
s.ang=CleanOrients([s.ang]);
s.s=AngleWithoutFlip([s.ang])*180/pi;
s.nb=NumBees;
s.f=FrameNum;
s.t=FrameNum*0.02;
s=orderfields(s);

function Compare2
l=dir('*Prog_2.mat')
for i=1:length(s)
    %    TrackBeeExpt2_2(s(i).name)
    fn=l(i).name;
    load(fn)
    ae1=CleanOrients(ang_e);
    s1=AngleWithoutFlip(ae1)*180/pi;
    c1=Cents;
    [e1x,e1y]=pol2cart(ae1,20);
    e1=[e1x',e1y'];
    e1=c1+e1;
    el1=elips;
    t1=FrameNum*0.02;
    nb1=NumBees;
    f1=FrameNum;

    load([l(i).name(1:end-6) '.mat'])
    ae2=CleanOrients(ang_e);
    c2=Cents;
    [e1x,e1y]=pol2cart(ae2,20);
    e2=[e1x',e1y'];
    e2=c2+e2;
    el2=elips;
    t2=FrameNum*0.02;
    s2=AngleWithoutFlip(ae2)*180/pi;
    nb2=NumBees;
    f2=FrameNum;

    is=union(find(nb1==1),find(nb2==1));
    ls=20*ones(length(FrameNum));
    ff=[fn(1:end-11) '.avi'];
    %     [inf,nf]=MyAviInfo(ff);
    inf=aviinfo(ff);nf=inf.NumFrames;
    for j=1:length(is)
        fr=ceil(is(j)/2);
        %         f=MyAviRead(ff,fr,nf);
        im=aviread(ff,fr);
        f=im.cdata;
        imagesc(f);

        hold on
        ind=find(is(j)==f1);
        if(~isempty(ind))
            i1(j)=ind;
            plotb(i1(j),c1,e1,el1,'r');
        else i1(j)=0;
        end
        ind=find(is(j)==f2)
        if(~isempty(ind))
            i2(j)=ind;
            plotb(i2(j),c2,e2,el2,'g');
        else i2(j)=0;
        end
        hold off
        in=input(['which better, 1=red, 2=green, return=?']);
        if(isempty(in)) in=0; end;
        inp(j)=in;
    end
end

function[fnew]=HandData(fn,sk)
fs=fn(1:end-4);
load([fs '_Prog.mat'])
fnew=[fs '_Hand.mat'];
nb=NumBToNB(NumBees);
is=find(nb==1);
isAdjusted=is(1:sk:end);
bads=[];
unsure=[];
for i=1:length(isAdjusted);
    k=isAdjusted(i)
    fr=floor((FrameNum(k)+1)/2);
    f=aviread(fn,fr);
    im=f.cdata;
    imagesc(im)
    hold on
    plot(Cents(k,1),Cents(k,2),'g.')
    a1=round(Cents(k,:)-50);
    a2=round(Cents(k,:)+50);
    axis equal
    axis([a1(1) a2(1) a1(2) a2(2)])
    title([int2str(k) ' out of ' int2str(isAdjusted(end))])
    hold off
    [x,y,b]=ginput(1);
    if(isempty(x))
        cs(i,:)=Cents(k,:);
        es(i,:)=Cents(k,:);
        angs(i)=NaN;
        bads=[bads i];
    else
        if(b~=1) uns=1;
        else uns=0;
        end
        while(1)
            [pts,redo,skip,uns]=AdjustPts([Cents(k,:);[x y]],im,FrameNum(k),uns);
            if(skip)
                cs(i,:)=pts(1,:);
                es(i,:)=pts(1,:);
                d=es(i,:)-cs(i,:);
                angs(i)=NaN;%cart2pol(d(1),d(2));
                bads=[bads i];
                break;
            elseif(redo==0)
                cs(i,:)=pts(1,:);
                es(i,:)=pts(2,:);
                d=es(i,:)-cs(i,:);
                angs(i)=cart2pol(d(1),d(2));
                if(uns)
                    unsure = [unsure i];
                end
                break;
            end
        end
    end
    %     [e1x,e1y]=pol2cart(ang_e(k),20);
    %     e=[e1x,e1y];
    %     e=Cents(k,:)+e;
    %     hold on
    %     plot([Cents(k,1) e(1)],[Cents(k,2) e(2)],'b')
    %     pause
    isDone(i)=k;
    fnums(i)=FrameNum(k);
    save(fnew,'cs','es','bads','unsure','EndPt','isDone','angs','fnums');
end

function[pts,redo,skip,unsure]=AdjustPts(pts,im,fr,unsure)
redo=0;
skip=0;
ystr=[];
a1=mean(pts,1)-50;
a2=mean(pts,1)+50;
X=[a1(1) a2(1) a1(2) a2(2)];
if(unsure) ystr='unsure';end;
while(1)
    imagesc(im);
    axis square
    axis(X), hold on;
    plot(pts(:,1),pts(:,2),'g--',pts(2,1),pts(2,2),'go')
    hold off

    title('Left click near a point to move it, right click to indicate unsure')
    xlabel('Return to finish, r to re-do, s to skip;')
    ylabel(['Frame ' int2str(fr) ';  ' ystr])
    [p,q,b]=ginput(1);
    if(char(b)=='r')
        redo=1;
        break;
    elseif(char(b)=='s')
        skip=1;
        break;
    elseif(isempty(p)) break;
    else
        vs=pts-ones(length(pts),1)*[p,q];
        ds=sum(vs.^2,2);
        [mini_d,i_m]=min(ds);
        pts(i_m,:)=[p q];
        if(b~=1)
            unsure=1;
            ystr='unsure';
        end;
    end
end