function[NMax,LMaxes,NNeuts,NhoodSize]=CountLocalMinima_Old(nD,nM,Neut,Draw)
if(nargin<3) Neut = 0; end;
if(nargin<4) Draw = 0; end;
rand('state',0);
% L=GenRandLandscape(nD,nM,1/Neut);
n=nM^nD;
L=GenRandStepscape(nD,nM,Neut);
if(nD~=2) Draw = 0; end;
if(Draw) 
    subplot(2,1,1);
    DrawLScape(L,nM,[],[]); 
end;

% LMaxes=struct('position',{},'ht',{},'nhood',{});
NMax=0;
dontcheck=[];
NNeuts=zeros(1,n,'int8');
NhoodSize=zeros(1,n,'int8');
GMax=max(L)
LMaxes=0;

for i=1:n
    %i
    if(~ismember(i,dontcheck))
        f=L(i);
        ns=GetNHood(i,nM,nD);
        [allns,neuts]=GetNeutHood(ns,L,f,i,nM,nD);
        if(isempty(allns))
            NMax=-1;
            NNeuts=ones(1,n)*n;
            NhoodSize=ones(1,n)*(n-1);
            LMaxes(1).position=neuts;
            LMaxes(1).nhood=0;%allns;
            LMaxes(1).ht=f;
            break;
        end
        if(Draw)
            subplot(2,1,2);
            DrawLScape(L,nM,neuts,allns);
        end
        if(all(L(allns)<f))
            NMax=NMax+1;
            if(f<GMax) LMaxes=LMaxes+1; end
%             LMaxes(NMax).position=neuts;
%             LMaxes(NMax).nhood=allns;
%             LMaxes(NMax).ht=f;
            NNeuts(neuts)=length(neuts);
            NhoodSize(neuts)=length(allns);%+length(neuts)-1;
            if(Draw) PlotLMaxes(neuts,nM); end;
        else
            NNeuts(neuts)=length(neuts);
            NhoodSize(neuts)=length(allns);%+length(neuts)-1;
        end;
        dontcheck=[dontcheck neuts];
        % if nhood info unwanted add allns to dontcheck here
    end
end

function[newns,neuts] = GetNeutHood(ns,L,f,i,nM,nD)
neuts=[i];
eqs=FindNewNeutral(ns,L(ns),f,neuts);
ns=[ns i];
while(~isempty(eqs))
    neuts=union(neuts,eqs);
    newns=[];
    for i=eqs newns=union(newns,GetNHood(i,nM,nD)); end;
    newns=setdiff(newns,ns);
    ns=[ns newns];
    eqs=FindNewNeutral(newns,L(newns),f,neuts);
end
newns=setdiff(ns,neuts);

function[eqs]=FindNewNeutral(ns,fs,f,oldeqs);
i=find(fs==f);
eqs=setdiff(ns(i),oldeqs);

function[ns] = GetNHood(n,nM,nD)
ns=[];
for i=0:nD-1
    a=nM^i;
    if(mod(ceil(n/a),nM)==1) ns=[ns n+a];
    elseif(mod(ceil(n/a),nM)==0) ns=[ns n-a];
    else ns=[ns n-a n+a];
    end;
end
ns=ns(find((ns>0)&(ns<=(nM^nD))));

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