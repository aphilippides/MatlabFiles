function[NMax,LMaxes,NNeuts,NhoodSize]=CountLocalMinima(nD,nM,Neut,Draw)
if(nargin<3); Neut = 0; end;
if(nargin<4); Draw = 0; end;
% rand('state',0);
%L=GenRandLandscape(nD,nM,1/Neut);
n=nM^nD;
L=GenRandStepscape(nD,nM,Neut);
if(nD~=2) Draw = 0; end;
if(Draw)
    subplot(2,1,1);
    DrawLScape(L,nM,[],[]);
end;

% LMaxes=struct('position',{},'ht',{},'nhood',{});
LMaxes=0;
NMax=0;

NNeuts=zeros(1,n,'int8');
NhoodSize=zeros(1,n,'int8');
GMax=max(L);
vals=1:n;
num=1;
while(num<=n)
    i=vals(num);
    if(i>0)
        f=L(i);
        ns=GetNHood(i,nM,nD);
        [allns,neuts]=GetNeutHood(ns,L,f,i,nM,nD);
%         if(isempty(allns))
%             NMax=-1;
%             NNeuts(:)=n;
%             NhoodSize(:)=n-1;
%             %             LMaxes(1).position=neuts;
%             %             LMaxes(1).nhood=0;%allns;
%             %             LMaxes(1).ht=f;
%             break;
%         end
        if(Draw)
            subplot(2,1,2);
            DrawLScape(L,nM,neuts,allns);
        end
        if(Draw)
            subplot(2,1,2);
            DrawLScape(L,nM,neuts,allns);
        end
        NNeuts(neuts)=length(neuts);
        NhoodSize(neuts)=length(allns);%+length(neuts)-1;
        if(all(L(allns)<f))
            NMax=NMax+1;
            if(f<GMax); LMaxes=LMaxes+1; end
            %             LMaxes(NMax).position=neuts;
            %             LMaxes(NMax).nhood=allns;
            %             LMaxes(NMax).ht=f;
            if(Draw) PlotLMaxes(neuts,nM); end;
        end;
        vals(neuts)=0;
        % if nhood info unwanted add allns to dontcheck here
    end
    num=num+1;
end

function[ns,neuts] = GetNeutHood(ns,L,f,i,nM,nD)
neuts=i;
[eqs ns]=FindNewNeutral(ns,L(ns),f);
while(~isempty(eqs))
%    neuts=union(neuts,eqs);
    neuts=[neuts eqs];
%    neuts=unique(neuts);
    newns=[];
    for i=eqs
        newns=[newns GetNHood(i,nM,nD)];
        newns=unique(newns);
    end;
    newns=setdiff(newns,[ns neuts]);
    [eqs,n]=FindNewNeutral(newns,L(newns),f);
    ns=[ns n];
neuts=unique(neuts);
ns=unique(ns);
end

function[eqs,neqs]=FindNewNeutral(ns,fs,f)
eqs=ns(find(fs==f));
neqs=ns(find(fs~=f));

function[ns] = GetNHood(n,nM,nD)
ns=zeros(1,2^nD);
num=0;
% as=nM.^(0:nD-1);
% xs=mod(ceil(n./as),nM);
% xs==0
mn=(nM^nD);
for i=0:nD-1
    a=nM^i;
    x=mod(ceil(n/a),nM);
    if(x==1) 
        if((n+a)<=mn) 
            num=num+1;
            ns(num)=n+a; 
        end;
    elseif(x==0) 
        if((n-a)>0) 
            num=num+1;
            ns(num)=n-a; 
        end;
    else
        if((n+a)<=mn) 
            num=num+1;
            ns(num)=n+a; 
        end;
        if((n-a)>0) 
            num=num+1;
            ns(num)=n-a; 
        end;
    end;
end
ns=ns(1:num);
% ns=ns(find((ns>0)&(ns<=(nM^nD))));

function[L] = GenRandLandscape(nD,nM,neut)
n=nM^nD;
L=rand(1,n);
rs=randperm(n);
num=round(neut*n);
for i=1:num
    r=rs(i)
    j=ceil(rand*(n-1));
    if(j>=r) j=j+1; end;
    L(r) = L(j);
end

function[L] = GenRandStepscape(nD,nM,NSteps)
n=nM^nD;
if((NSteps==0)|(nargin<3)) L=10*rand(1,n);
else L=ceil(NSteps*(rand(1,n)));
end;

function DrawLScape(L,nM,neuts,neighbs)
ma=max(L)*1.5;
L(neuts)=max(L)*1.25;
L(neighbs)=ma;
for i=1:nM
    m(i,:)=L(1+(i-1)*nM:i*nM);
end;
m = [m m(:,end)];
m=[m; m(end,:)];
pcolor(m);
caxis([1 ma])

function PlotLMaxes(maxes,nM)
ys = ceil(maxes/nM)+0.5;
xs=rem(maxes,nM)+0.5;
xs(find(xs==0.5))=nM+0.5;
hold on;
plot(xs,ys,'k*')
hold off