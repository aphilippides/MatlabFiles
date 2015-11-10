function ProcessShadows
s=dir('*.avi');
x=cd;
IntS=[];IntFs=[];
if(isempty(s)) disp(['No Files to process in folder ' x]); end;
for i=1:length(s)
    fn=s(i).name;[int2str(i) ':  ' fn]
    pn=fn(1:strfind(fn,'.avi')-1);
    AllN=[pn 'All.mat'];

%     if(CheckInterferingShadows(pn)) 
%         IntS=[IntS i]; 
%         IntFs=s(IntS);
%         save InterferingShadows IntS IntFs
%     end;
    if(isfile([pn 'ALev.mat']))         
        GetShadData(AllN,pn);
%         GetShadDataWhole(AllN,pn);
     end
end

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

function GetShadData(AllN,ff);
load([ff 'ALev.mat'])
% Check Shadow Data
if(aLevel~=500)
    load(AllN)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.avi'],refim,1);
    sAdjusted=find(Areas>aLevel);
    AllN
    for ind=sAdjusted
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead([ff '.avi'],fr,1);
        dif=imsubtract(refim,f);
        if(odev(ind))
            [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                FindBeeExpt2_Shadow(dif(1:2:end,:,:),1,f(1:2:end,:,:),sLevel);
        else
            [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
        end
        if(nb==1)
%             imagesc(f);
%             plotb(ind,Cents,EPt,EndPt,elips,'g')
%             hold on;plotb(1,c,ep,a,el,'b')
            Cents(ind,:)=c;
            area_e(ind)=ae;
            EPt(ind,:)=ep;
            elips(ind)=el;
            len_e(ind)=le;
            eccent(ind)=ec;
            d=abs(AngularDifference(ang_e(ind),oe));
            if(d>pi/2)
                if(oe<0) ang_e(ind)=oe+pi;
                else ang_e(ind)=oe-pi;
                end
                d=d-pi;
            else ang_e(ind)=oe;
            end
            [ind sAdjusted(end) d*180/pi]
            save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
                'len_e','Cents','-append');
        end
    end
%     sAdjusted=[];
%     for ind=i1
%         figure(1),plot(Areas(i1)),hold on
%         plot(find(ind==i1),Areas(ind),'rs','MarkerFaceColor','r');hold off
%         figure(2)
%         fr=floor(0.5*(FrameNum(ind)+1));
%         f=MyAviRead([ff '.avi'],fr,1);
%         imagesc(f);
%         plotb(ind,Cents,EPt,EndPt,elips,'g')
%         dif=imsubtract(refim,f);
%         sAdjusted=[sAdjusted ind];
%         if(odev(ind))
%             [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
%                 FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
%         else
%             [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
%                 FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
%         end
%         if(nb==1)
%             plotb(1,c,ep,a,el,'b')
%             inp=input('enter 1 to stop; return to accept and continue','s');
%             if(isequal(inp,'1')) break;
%             else
%                 Cents(ind,:)=c;
%                 area_e(ind)=ae;
%                 EPt(ind,:)=ep;
%                 elips(ind)=el;
%                 len_e(ind)=le;
%                 eccent(ind)=ec;
%                 if(abs(AngularDifference(ang_e(ind),oe))>pi/2)
%                     if(oe<0) ang_e(ind)=oe+pi;
%                     else ang_e(ind)=oe-pi;
%                     end
%                 else ang_e(ind)=oe;
%                 end
%                 save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
%                     'len_e','Cents','-append');
%             end
%         end
%     end
%     clear refim f a oe dif i1 fr inp sas ae ep el c ec
end


function GetShadDataWhole(AllN,ff);
load([ff 'ALev.mat'])
% Check Shadow Data
if(aLevel~=500)
    load(AllN)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.avi'],refim,1);
    sAdjusted=find(Areas>aLevel);
    AllN
    for ind=sAdjusted
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead([ff '.avi'],fr,1);
        dif=imsubtract(refim,f);
        [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= FindBeeExpt2_WholeShadow(dif,f,sLevel);
        if(nb==1)
            Cents(ind,:)=c;
            area_e(ind)=ae;
            EPt(ind,:)=ep;
            elips(ind)=el;
            len_e(ind)=le;
            eccent(ind)=ec;
            d=abs(AngularDifference(ang_e(ind),oe));
            if(d>pi/2)
                if(oe<0) ang_e(ind)=oe+pi;
                else ang_e(ind)=oe-pi;
                end
                d=d-pi;
            else ang_e(ind)=oe;
            end
            [ind sAdjusted(end) d*180/pi]
            save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
                'len_e','Cents','-append');
        end
    end
end

function[interf]=CheckInterferingShadows(pn)
imagesc(MyAviRead(pn,1,1))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end