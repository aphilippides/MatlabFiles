function ShowBeePath(fnm,PrettyPic,x,NestLMfn)
% dwork;
% cd GantryProj\Bees
load(fnm);
i=strfind(fnm,'Path');
fi=fnm(1:i-1);
if(nargin<4) load([fi 'NestLMData.mat']);
else load(NestLMfn);
end

if(nargin < 2) x=1; end
if(nargin < 3) PrettyPic=1; end

    figure(1);
    hold off;
if(PrettyPic)
    fn=[fi '.avi'];
    f=aviread(fn,1);
    imagesc(f.cdata);
    hold on;
    MyCircle(nest,NestWid/2,'g');
    MyCircle(LM,LMWid/2,'r');
else
    MyCircle(nest,NestWid/2,'g');
    hold on;
    MyCircle(LM,LMWid/2,'r');
    axis equal
end
[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;

cs = ['b';'g';'r';'c';'y'];
ilist=unique(WhichB);
count=1;
str=[];
inp=[];
for i=ilist
    is=[];
    ks = find(WhichB==i);
    is=ks(1:x:end);
    col=cs(mod(count,5)+1,:);
    figure(1);
     hold on;
    %for is=1:n
    plot(EndPt(is,1),EndPt(is,2),[col '.'])
   plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]',col)
    str=[str int2str(i) ' ' col ' ' int2str(length(is)) '; '];
    text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
    %end
    %     for k=1:100:length(is)
    if(isempty(inp)|inp==0)
        figure(2)
        for k=1:4:length(is)
            fr=floor(0.5*(FrameNum(is(k))+1));
            f=aviread(fn,fr);
            imagesc(f.cdata);
            hold on;
            plot(EndPt(is(k),1),EndPt(is(k),2),[col '.'])
            plot([Cents(is(k),1) EndPt(is(k),1)]',[Cents(is(k),2) EndPt(is(k),2)]',col)
            axis(round([Cents(is(k),1)-50,Cents(is(k),1)+50,Cents(is(k),2)-50,Cents(is(k),2)+50]))
            hold off
            inp=input(['FNum=' int2str(FrameNum(is(k))) '; return to continue; 0 to stop; -1 to end']);
            if((inp==0)|(inp==-1)) break; end;
        end
    end

    count = count + 1;
end
figure(1)
xlabel(str)
hold off;
title(fi)
str