function ProcessShadowsScanning
s=dir('*.mov');
x=cd;
IntS=[];IntFs=[];
if(isempty(s)) disp(['No Files to process in folder ' x]); end;
load SkipListShad
for i=1:length(s)
    fn=s(i).name;[int2str(i) ':  ' fn]
    pn=fn(1:strfind(fn,'.mov')-1);
    AllN=[pn 'All.mat'];

%     if(CheckInterferingShadows(pn)) 
%         IntS=[IntS i]; 
%         IntFs=s(IntS);
%         save InterferingShadows IntS IntFs
%     end;
%     if(isfile([pn 'ALev.mat'])) 
%         load(AllN)
%         plot(Cents(:,1),Cents(:,2),'b-x')
%         if(~isempty(find(diff(FrameNum)==0,1)))
%             SkipList(i)=1
%         else
%             inp=input('enter 0 to skip; return ok')
%             if(inp==0)
%                 SkipList(i)=1
%             else
%                 SkipList(i)=0;
%             end
%         end
%     else 
%         SkipList(i)=0;
%     end
    

    if(isfile([pn 'ALev.mat'])) 
        if 1%(SkipList(i)~=1)
            nscan=str2num(pn(10:11));
            if(nscan>=0)
                GetShadDataWhole(AllN,pn,i);
            end
        end
    end
end
% save SkipListShad.mat SkipList

function plotb(is,c1,e1,e2,ell,col)
bw=50;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=is 
    plot(ell(i).elips(:,1),ell(i).elips(:,2),col) 
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])
hold off


function GetShadDataWhole(AllN,ff,filenum)
load([ff 'ALev.mat'])
ThreshVal=25;
% Check Shadow Data
if(aLevel~=500)
    load(AllN)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.mov'],refim,1);
    sAdjusted=find(Areas>aLevel);
    AllN
    for ind=sAdjusted
        fr=FrameNum(ind);
        f=MyAviRead([ff '.mov'],fr,1);
        dif=imsubtract(refim,f);
        [dif,addx]=Constrain2BBox(dif,Bounds(ind,:));
        [f,addx]=Constrain2BBox(f,Bounds(ind,:));
        [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= FindAntScanningShadow(dif,f,sLevel,ThreshVal,0);
        if(nb>0)
            c=[c(:,1)+addx(1) c(:,2)+addx(2)];
            % find nearest Centre
            dcs=CartDist(c,Cents(ind,:));
            [md,mi]=min(dcs);
            Cents(ind,:)=c(mi,:);
            area_e(ind)=ae(mi);
            EPt(ind,:)=ep(mi,:);
            elips(ind)=el(mi);
            len_e(ind)=le(mi);
            eccent(ind)=ec(mi);
            oe=oe(mi);
            d=abs(AngularDifference(ang_e(ind),oe));
            if(d>pi/2)
                if(oe<0) ang_e(ind)=oe+pi;
                else ang_e(ind)=oe-pi;
                end
                d=d-pi;
            else ang_e(ind)=oe;
            end
        end
        if(mod(ind,10)==0)
            [filenum ind sAdjusted(end) nb d*180/pi]
        end
    end
    save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
        'len_e','Cents','-append');
end

function[interf]=CheckInterferingShadows(pn)
imagesc(MyAviRead(pn,1,1))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end