function Matching

s=dir('*.tif');
nlist=GetNums(s);
orig=-1;
imn=-1;
thresh=0;
subsamp=1;
portlan=[' portrait';'landscape'];
port=2;
figh=gcf;
colmap='gray';
colormap(colmap);
while 1
    disp(' ')
    disp('1: Select Original')
    disp('2: Select Matching')
    disp(['3: Select sub-sampling. Currently ' int2str(subsamp)])
%     disp(['4: Select threshold. Currently ' num2str(thresh)])
    disp(['4: Select Colormap. Currently: ' colmap])
    disp(['5: Switch portrait or landscape. Currently ' portlan(port,:)])
    disp('6: Print figure')
    disp('Return to end')
    disp(' ')
    opt=input('Enter choice:   ');
    if(isempty(opt)) break;
    elseif(opt==6)
        fn=input('Enter filename to print to:   ','s');
        print(figh,'-dtiff','-r300',fn);
    elseif(opt==5)
        if(port==1) port=2;
        else port=1;
        end
%     elseif(opt==4) thresh = input('Enter threshold value (0 for no threshold:   ');
    elseif(opt==4)
        ColorMaps;
        disp(' ');
        colmap = input('Enter name of colormap:   ','s');
        colormap(colmap)
    elseif(opt==3) subsamp = input('Enter sub-sampling:   ');
    elseif((opt==1)|(opt==2))
%         nums=
        WriteFileScreen(s,1);
        Picked=input('enter number of file you want:   ');
        Picked=find(nlist==Picked,1);
        if(opt==1) orig=Picked;
        else imn=Picked;
        end
    end

    if(orig>0)
        o=imread(s(orig).name);
        if(ndims(o)==3) o=rgb2gray(o); end;
%         o=-o;
        if(subsamp>1) o=SubSampleMean(o,subsamp,subsamp); end;
        if(thresh>0) o=double(o>(thresh*max(max(o))));end;
    else o=[];
    end
    if(imn>0)
        im=imread(s(imn).name);
        if(ndims(im)==3) im=rgb2gray(im); end;
%         im=-im;
%         im=1-imread(s(imn).name);
        if(subsamp>1) im=SubSampleMean(im,subsamp,subsamp); end;
        if(thresh>0) im=double(im>(thresh*max(max(im))));end;
    else im=[];
    end
    if(isempty(o)|isempty(im)) d=[];diffs=0;
    elseif(opt<5) [d,diffs]=BestMatch(o,im); 
    end;
    if(port==1)
        subplot(1,3,1)
        if(~isempty(o))
            imagesc(o);
            axis image
        end
        subplot(1,3,2)
        if(~isempty(im)) 
            imagesc(im);
            axis image 
        end;
        subplot(1,3,3)
        if(~isempty(d))
            imagesc(d);
            axis image
        end
    else
        subplot(3,1,1)
        imagesc(o),axis image
        subplot(3,1,2)
        if(~isempty(im)) 
            imagesc(im);
            axis image 
        end;
        subplot(3,1,3)
        if(~isempty(d))
            imagesc(d);
            axis image
        end
    end
end

function WriteFileScreen(fns, NumOnLine)
if isempty(fns) return; end
L=size(fns,1);
N=fix(L/NumOnLine)-1;
M=rem(L,NumOnLine);
for i=0:N
    for j=1:NumOnLine
        fn=i*NumOnLine+j;
        fprintf('%s        ',fns(fn).name);
    end
    fprintf('\n');
end
for i=1:M
    fn=(N+1)*NumOnLine+i;
    fprintf('%s ',fns(fn).name);
end

function[nums]=GetNums(s)
for i=1:length(s)
    str=s(i).name;
    ns=regexp(str,'\d');
    if(isempty(ns)) nums(i)=1000;
    else
        d=diff(ns);
        ep=find(d~=1,1);
        if(isempty(ep)) nums(i)=str2num(str(ns));
        else nums(i)=str2num(str(ns(1:ep)));
        end
    end
end
    
function[e,es]=BestMatch(a,b)
[xa,ya]=size(a);
[xb,yb]=size(b);

if(xa<=xb)
    for i=1:(xb-xa+1)
        bs=b(i:(i+xa-1),:);
        as=a;
        if(ya<=yb)
            for j=1:(yb-ya+1)
                bl=bs(:,j:(j+ya-1));
                al=as;
                e(i,j)=MatchDiff(al,bl);
            end
        else
            for j=1:(ya-yb+1)
                bl=bs;
                al=a(:,j:(j+yb-1));
                e(i,j)=MatchDiff(al,bl);
            end
        end
    end
else
    for i=1:(xa-xb+1)
        bs=b;
        as=a(i:(i+xb-1),:);
        if(ya<=yb)
            for j=1:(yb-ya+1)
                bl=bs(:,j:(j+ya-1));
                al=as;
                e(i,j)=MatchDiff(al,bl);
            end
        else
            for j=1:(ya-yb+1)
                bl=bs;
                al=a(:,j:(j+yb-1));
                e(i,j)=MatchDiff(al,bl);
            end
        end
    end
end
[rowm,rowi]=max(e,[],1);
[es,col]=max(rowm);
row=rowi(col);
if(xa<=xb)
    bs=b(row:(row+xa-1),:);
    as=a;
else
    bs=b;
    as=a(row:(row+xb-1),:);
end
if(ya<=yb)
    bl=bs(:,col:(col+ya-1));
    al=as;
else
    bl=bs;
    al=as(:,col:(col+yb-1));
end
[es,e]=MatchDiff(al,bl);

function[es,e]=MatchDiff(a,b)
ma=mean(mean(a));
mb=mean(mean(b));
e=(a-ma).*(b-mb);
es=mean(mean(e));

function ColorMaps
disp('  Color maps.')
disp('    hsv        - Hue-saturation-value color map.')
disp('    hot        - Black-red-yellow-white color map.')
disp('    gray       - Linear gray-scale color map.')
disp('    bone       - Gray-scale with tinge of blue color map.')
disp('    copper     - Linear copper-tone color map.')
disp('    pink       - Pastel shades of pink color map.')
disp('    white      - All white color map.')
disp('    flag       - Alternating red, white, blue, and black color map.')
disp('    lines      - Color map with the line colors.')
disp('    colorcube  - Enhanced color-cube color map.')
disp('    vga        - Windows colormap for 16 colors.')
disp('    jet        - Variant of HSV.')
disp('    prism      - Prism color map.')
disp('    cool       - Shades of cyan and magenta color map.')
disp('    autumn     - Shades of red and yellow color map.')
disp('    spring     - Shades of magenta and yellow color map.')
disp('    winter     - Shades of blue and green color map.')
disp('    summer     - Shades of green and yellow color map.')