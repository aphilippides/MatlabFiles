% this is a helper function which allows quick renaming of images to speed
% exporting single images form pixpro

function TiltTest

% Images taken on 9/6/2015 in ti tes
% Order of images
% Images from 19: 90
% 72 images, 3 sets of 24
% pictures are taken at 3 tilts, 0, 10 and 20. We do 3 sets of 8 at one ti
% Each set is at 0, 1, 2 and 4m from a starting position going towards a target tree at 2 orientations. 
% one picture taken heading to the tree, Set1_Tilt20_D2_0, one picture taken at 90 degrees CCW, Set1_Tilt20_D2_90, so 2 pics at each of the  location
% Set 1: cluttered. Order: 0, 10, 20

Tilts=[0 10 20];
dists=[0 1 2 4];
csd=cumsum(dists);
heads=[0 90];
minrow=297;
maxrow=784;
rs=minrow:maxrow;
Set=1;
dat=[];
% pick which rows to match. 1:80 is the whole image
rs2=1:80;
for ti=Tilts
    for j=1:length(dists)
        d=dists(j);
        for h=heads
            goal=GetIm(Set,ti,d,h,rs,rs2);
            gdat=[Set ti csd(j) h];
            dat=[dat TestSetVsGoal(Set,Tilts,dists,heads,csd,goal,rs,rs2,gdat)];
        end
    end
end
keyboard
return;
% Set 2: cluttered. Order: 20, 10, 0
for ti=[20 10 0]
    for d=[0 1 2 4]
        for h=[0 90]
            unw=imread(['100_00' int2str(imn) '(1).jpg']);
            of=['Set2_Tilt' int2str(ti) '_D' int2str(d) '_' int2str(h) '.mat'];
            save(of,'unw');
            imn=imn+1;
        end
    end
end

% Set 3: open. Order: 0, 10, 20
for ti=[0 10 20]
    for d=[0 1 2 4]
        for h=[0 90]
            unw=imread(['100_00' int2str(imn) '(1).jpg']);
            of=['Set3_Tilt' int2str(ti) '_D' int2str(d) '_' int2str(h) '.mat'];
            save(of,'unw');
            imn=imn+1;
        end
    end
end
    
function[dat]=TestSetVsGoal(Set,Tilts,dists,heads,csd,goal,rs,rs2,gdat)
c=1;
for ti=Tilts
    for j=1:length(dists)
        d=dists(j);
        for f=1:length(heads)
            h=heads(f);
            figure(f)
            subplot(2,2,j)
            im=GetIm(Set,ti,d,h,rs,rs2);
            disp([Set ti d h])
            [mini,rim,imin,mind,d3]=VisualCompass(goal,im);
            mini=mod(mini-1+gdat(4)-h,360);
            dat(c).err=mini-(mini>180)*360;
            dat(c).d=d3;
            dat(c).test=[Set ti-gdat(2) abs(csd(j)-gdat(3)) h]';
            dat(c).goal=gdat';
            plot(-179:180,d3([181:360 1:180]))
            hold on
            c=c+1;
        end
    end
end
x=[0 0;90 90]-gdat(4);
for i=1:2;
    figure(i); 
    for j=1:4
        subplot(2,2,j)
        axis tight
        a=ylim;
        plot(x(i,:),[0 a(2)],'k--')
        ylow(40);
        hold off; 
    end;
end

function[im]=GetIm(s,ti,d,h,rs,rs2)
if(nargin<6)
    rs2=1:80;
end
of=['Set' int2str(s) '_Tilt' int2str(ti) '_D' int2str(d) '_' int2str(h) '.mat'];
load(of)
im=double(rgb2gray(unw(rs,:,:)));
im=imresize(im,[80 360]);
im=im(rs2,:);