% Check Shadow Data: 
% first argument live is whether to check data 'live' or not
function[proc]=CheckShadowsBySize(live,Areas,sLevel,vidfn,vObj,AllN,FrameNum,...
    ThreshV,Cents,EPt,EndPt,elips)

% sfile=[AllN(1:(end-8)) 'SLev.mat'];
% if(isfile(sfile))
%     load(sfile);
%     save(AllN,'sLevel','shads','-append');
% end
% sLevel=85;
ff=vidfn(1:end-4);
if(sLevel~=200)
    proc=1;
    [sas,i1]=sort(Areas,'descend');
    load([ff 'NestLMData.mat']);
    save(AllN,'refim','-append');

    [refim]=MyAviRead(vidfn,refim,vObj);

    % Get area level
    figure(1)
    clf
    plot(Areas(i1))
    axis tight
    aLevel=1e6;
    while 1
        s=ForceNumericInput('enter area cutoff; areas ABOVE this will be re-processed; return ok/skip: ',...
            0,1);
        if(~isempty(s))
            aLevel=s;
            ind=find(sas<=aLevel,1);
            if(isempty(ind)) 
                ind=i1(1);
            else
                ind=i1(ind);
            end
            figure(2)
            if(aLevel>max(Areas))
                disp(['area= ' int2str(aLevel) '; *NO DATA WILL BE PROCESSED*'])
            elseif(aLevel<min(Areas))  
                disp(['area= ' int2str(aLevel) '; *ALL DATA WILL BE PROCESSED*'])
            else
                disp(['area= ' int2str(aLevel) '; data above this to be processed'])
            end
            
            fr=floor(0.5*(FrameNum(ind)+1));
            f=MyAviRead(vidfn,fr,vObj);
            imagesc(f);
            plotb(ind,Cents,EPt,elips,'g')
        else
            break;
        end
    end
    
    % get the frame w biggest bee to get the threshold
    ind=i1(1);
    fr=floor(0.5*(FrameNum(ind)+1));
    f=MyAviRead(vidfn,fr,vObj);
    
    % zoom into a box +/- 50 pixels around it
    xylim=size(f);
    a1=max(round(Cents(ind,:)-50),1);
    a2=min(round(Cents(ind,:)+50),xylim([2 1]));
    
    % get the difference image and threshold
    dif=rgb2gray(imsubtract(refim,f));
    dbw=double(dif(a1(2):a2(2),a1(1):a2(1))>ThreshV);
    dbw2=double(dif(a1(2):2:a2(2),a1(1):2:a2(1))>ThreshV);

    im2=f(a1(2):2:a2(2),a1(1):2:a2(1),:);
    im=f(a1(2):a2(2),a1(1):a2(1),:);
    imbw2=double(rgb2gray(im2));
    imbw=double(rgb2gray(im));
    
    while 1
        figure(10)
        subplot(2,2,1)
        ShowShad(im,imbw,sLevel,['Raw: Shadow level ' num2str(sLevel)])
        subplot(2,2,2)
        ShowShad(im2,imbw2,sLevel,['Raw 1/2 fr; Shad ' num2str(sLevel)])
        subplot(2,2,3)
        ShowShad(im,imbw,sLevel,...
            ['Raw*dif: thresh ' int2str(ThreshV) '; Shad ' num2str(sLevel)],dbw)
        subplot(2,2,4)
        ShowShad(im2,imbw2,sLevel,...
            ['Raw*dif 1/2: thresh ' int2str(ThreshV) '; Shad ' num2str(sLevel)],dbw2)
        
        ninp=ForceNumericInput(['Shadow level ' num2str(sLevel) '; enter new level or return: '],0,1);
        if(isempty(ninp)) break;
        else sLevel=ninp;
        end
    end
    save(AllN,'sLevel','aLevel','-append');
    if(aLevel<=max(Areas))
        if(live)
            GetShadData(AllN,ff,vObj,ThreshV);
        else
            disp('this may need debugging')
            save([ff 'ALev.mat'],'aLevel');
            return;
            GetShadData(AllN,ff,vObj,ThreshV);
        end
    end
else
    proc=0;
end


function ShowShad(im,imbw,sLevel,tistr,dbw)
if(nargin==5)
    BW=double(dbw.*(imbw<sLevel));
else
    BW=double(imbw<sLevel);
end
[B,L] = bwboundaries(BW,'noholes');
imagesc(im)
hold on
title(tistr)
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'g');
end
hold off


function GetShadData(AllN,ff,vObj,threshV)

AllN
load(AllN)
if(~exist('bigsmall'))
    bigsmall=[400 20]
    disp(['using area levels ' int2str(bigsmall)]);
end
% % reduce the 2nd bee size limit
% bigsmall(2)=0.75*bigsmall(2);

% ignore bees further than DLim cm away
DLim=4;

% Check Shadow Data
if(aLevel~=1e6)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.avi'],refim,vObj);
    sAdjusted=find(Areas>aLevel);
    co=1;
    for ind=sAdjusted
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead([ff '.avi'],fr,vObj);
        dif=imsubtract(refim,f);
        if(FullFrame==1)
            [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                FindBeeExpt2_Shadow(dif,-1,f,sLevel,threshV,0,bigsmall);
        else
            if(odev(ind))
                [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                    FindBeeExpt2_Shadow(dif(1:2:end,:,:),1,f(1:2:end,:,:),...
                    sLevel,threshV,0,bigsmall);
            else
                [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                    FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),...
                    sLevel,threshV,0,bigsmall);
            end
        end
        if(nb>=1)
            % find the nearest bee
            d2b=CartDist(c,Cents(ind,:));
            [mind,min_i]=min(d2b);
            % only update if not too far away

            if(mind<(DLim/cmPerPix))
                if 1
                    figure(11)
                    imagesc(f);
                    plotb(ind,Cents,EPt,elips,'w:')
                    hold on;
                    plotb(1,c(min_i,:),ep(min_i,:),el(min_i),'r')
                    hold off
                    drawnow;
                end
                Cents(ind,:)=c(min_i,:);
                area_e(ind)=ae(min_i);
                EPt(ind,:)=ep(min_i,:);
                elips(ind)=el(min_i);
                len_e(ind)=le(min_i);
                eccent(ind)=ec(min_i);
                oe=oe(min_i);
                d=abs(AngularDifference(ang_e(ind),oe));
                if(d>pi/2)
                    if(oe<0)
                        ang_e(ind)=oe+pi;
                    else
                        ang_e(ind)=oe-pi;
                    end
                    d=d-pi;
                else
                    ang_e(ind)=oe;
                end
                co=co+1;
                disp([int2str(co) '/' int2str(length(sAdjusted)) ': diff=' num2str(d*180/pi)])
            end
        end
    end
    save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
        'len_e','Cents','-append');
end


function GetShadDataWhole(AllN,ff,vObj)
load([ff 'ALev.mat'])
% Check Shadow Data
if(aLevel~=500)
    load(AllN)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.avi'],refim,vObj);
    sAdjusted=find(Areas>aLevel);
    AllN
    for ind=sAdjusted
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead([ff '.avi'],fr,vObj);
        dif=imsubtract(refim,f);
        [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]=FindBeeExpt2_WholeShadow(dif,f,sLevel);
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

function[interf]=CheckInterferingShadows(pn,vObj)
imagesc(MyAviRead(pn,1,vObj))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end
