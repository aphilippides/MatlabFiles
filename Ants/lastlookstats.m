function lastlookstats(fn,th)%,fs,ts,ns,ls)

if(nargin<1) fn=[]; end;
if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end

    last1=0;

if(nargin<2) th=10;
    %input('enter n where n=0 for last look, 1 for penultimate etc; return for last look');
%     dtoN=input('enter distance to limit starting point within:  ');
end
for i=1:length(fn)
    i
    load(fn(i).name);
    [meanC,meanT,meanTInd,len,in,ils] = LookingPtsExpt2(fn(i).name,th);
    nLM=size(LM,1);
    if(length(meanT)<=last1) 
        tn(i)=NaN;
        for j=1:nLM TToL(j,i)=NaN; end
    else 
        tn(i)=t(end)-meanT(end-last1);
        for j=1:nLM 
            if(isempty(ils(j).meanT)) TToL(j,i)=NaN;
            else TToL(j,i)=meanT(end-last1)-ils(j).meanT(end);
            end
        end
    end
    for j=1:nLM 
        if(isempty(ils(j).meanT)) tl(j,i)=NaN;
        else tl(j,i)=t(end)-ils(j).meanT(end);
        end
    end   
end
figure(4);
subplot(nLM+1,1,1),hist(tn,[0:0.1:10]),
axis tight,title('Time before end last looked at nest','Color','b')
ylabel(['n=' int2str(sum(~isnan(tn)))])
for j=1:nLM
    subplot(nLM+1,1,j+1),hist(tl(j,:),[0:0.1:10])
    [lst,lc]=LMStr(j,[0 0;0 1]);axis tight
    title(['Time before end last looked at ' lst ' LM'],'Color',lc)
    ylabel(['n=' int2str(sum(~isnan(tl(j,:))))])
end
figure(5);
for j=1:nLM
    subplot(nLM,1,j)
    [lst,lc]=LMStr(j,[0 0;0 1]);
    hist(TToL(j,:),[-1:0.2:10]),axis tight
    title(['Time between last nest and last ' lst ' LM looks'],'Color',lc)
    ylabel(['n=' int2str(sum(~isnan(TToL(j,:))))])
end