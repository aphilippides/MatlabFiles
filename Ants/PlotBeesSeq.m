function[dofl]=PlotBeesSeq(vfn,AllN,ang_e,len_e,WhichB,EPt,Cents,LM,LMWid,...
    nest,NestWid,EndPt,elips,FrameNum,FRLEN,vObj,x)
disp('  ')
disp('Now put the cursor over the figure to look for flips') 

dofl=0;

figure(1);
clf;
f=MyAviRead(vfn,1,vObj);
imagesc(f);
hold on;
MyCircle(nest,NestWid/2,'g');
MyCircle(LM,LMWid/2,'r');
axis equal

cs = ['b';'g';'r';'w';'c'];
ilist=unique(WhichB);
% str=[];strL=[];
i=1;
while(i<=length(ilist))
    ks = find(WhichB==ilist(i));
    is=ks(1:x(1):end);
    col=cs(mod(i,5)+1,:);
    figure(1);
    title(vfn)
    hold on;
    plot(EPt(is,1),EPt(is,2),[col '.'])
    plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
    
    % get the string together
%     sbit=[int2str(i) ': ' col ' ' int2str(length(is)) ' ' num2str(FrameNum(is(1))*FRLEN)];
%     sbit=[int2str(i) ': ' col ' ' int2str(length(is)) ' ' int2str(FrameNum(is(1)))];
%     str=[str sbit '; '];
%     strL=strvcat(strL,  sbit);
%     text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)

    k=1;
    flipS=0;
    fstr=' start of flip';
    while 1
        figure(1)
        h=plot(EPt(is(1:k),1),EPt(is(1:k),2),'k.');
        if(flipS~=0)
            h=[h;plot(EPt(flipS:x(1):is(k),1),EPt(flipS:x(1):is(k),2),'ko')];
        end
        figure(2)
        fr=floor(0.5*(FrameNum(is(k))+1));
        f=MyAviRead(vfn,fr,vObj);
        figure(2)
        imagesc(f);
        plotb(is(k),Cents,EPt,elips,col)
%         title([ vfn ': return fwd; up back; 0 next bee; x end; a flip all; f ' fstr])
        title([': return fwd; up back; 0 next bee; x end; a flip all; f ' fstr])
        ylabel('o''s show bees to flip')
        xlabel(['fr ' int2str(FrameNum(is(k))) '; showing every ' int2str(x(2)*x(1)) ' frames; number to change']);
        [dum,dum,b]=ginput(1);
        %  inp=input(['t = ' num2str(FrameNum(is(k))*FRLEN) '; return to continue; 0 to stop; -1 to end']);
        delete(h)
        if(isempty(b))  % return go on
            k=k+x(2);
        elseif(b==30)  % up cursor: go back
            k=k-x(2);
        elseif(b==97)  % a: flip all or all from flipS
            if(flipS==0)
                [ang_e,EPt]=FlipAngs(ks,ang_e,len_e,Cents,AllN);
            else
                [ang_e,EPt]=FlipAngs(flipS:ks(end),ang_e,len_e,Cents,AllN);
            end
            k=1;
            flipS=0;
            fstr=' start of flip';
        elseif(b==102)  % f: mark start or end of flip
            if(flipS==0)
                flipS=is(k);
                k=k+x(2);
                fstr=' end of flip';
            else
                figure(1)
                h=[h;plot(EPt(flipS:x(1):is(k),1),EPt(flipS:x(1):is(k),2),'ko')];
                xlabel('enter p to flip')
                [dum,dum,c]=ginput(1);
                if(c==112)
                    [ang_e,EPt]=FlipAngs(flipS:is(k),ang_e,len_e,Cents,AllN);
                    flipS=0;
                    fstr=' start of flip';
                end
            end
        elseif(ismember(b,49:57)) % 1:9: change how many one increments
            x(2)=b-48;
        elseif(b==48)   % 0: go to the next bee
            i = i + 1;
            break;
        elseif(b==120)   % x: end the whole process
            figure(1)
            hold off;
            return;
        end
        k=mod(k,length(is));
        if(k==0)
            k=length(is);
        end
    end
end
figure(1)
% xlabel(str)
hold off;
% WriteFileNames(strL,3)

function[ang_e,EPt]=FlipAngs(is,ang_e,len_e,Cents,AllN)
ang_e(is)=ang_e(is)+pi;
ang_e(ang_e>pi)=ang_e(ang_e>pi)-2*pi;
[EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
EPt=EPt+Cents;
save(AllN,'ang_e','EPt','-append')