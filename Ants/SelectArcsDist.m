function[Arcs,ma,mi,ma2mi,mi2ma]=SelectArcs(os,t,Othresh,Tthresh,Plotting)
if(nargin<3) Othresh=0.05; end;
% if(nargin<3) Othresh=0.0873; end;
% if(nargin<3) Othresh=0.1745; end;
if(nargin<4) Tthresh=0.05; end;
% if(nargin<4) Tthresh=0.1; end;
if(nargin<5) Plotting=1; end;

if(size(os,1)>size(os,2)) os=os'; end;
[ma_t,ma_s,mi_t,mi_s]=GetArcsD(os,t,Othresh,Tthresh,Plotting);
ma=[ma_t' ma_s'];
mi=[mi_t' mi_s'];
for i=1:size(ma,1) ma(i,3)=find(t==ma_t(i),1); end
for i=1:size(mi,1) mi(i,3)=find(t==mi_t(i),1); end


ma2mi=[];mi2ma=[];Arcs=[];
mami=[ma;mi];
if(~isempty(mami))
    [ot is]=sort(mami(:,1));
    Arcs=mami(is,:);
    n=size(Arcs,1);
    if(n>1)
        if(Arcs(1,2)<Arcs(2,2)) st=2;st2=1;
        else st=1;st2=2;
        end
        if(Arcs(n,2)>Arcs(n-1,2)) en=n-1;en2=n;
        else en=n;en2=n-1;
        end
        ma2mi=[Arcs(st:2:en-1,:) Arcs(st+1:2:en,:)];
        mi2ma=[Arcs(st2:2:en2-1,:) Arcs(st2+1:2:en2,:)];
    end
end

% function[ma_t,ma_s,mi_t,mi_s]=GetArcs(o,t)
%
% function[ma_t,ma_s,mi_t,mi_s]=GetArcs(o,t,thresh_s,thresh_t)
%
% This function takes orientation data in o and time data in t and returns
% the times and values of maxima (ma_t and ma_s respectively)
% and  the times and values of minima (mi_t and mi_s respectively)
%
% These points could define the arcs
%
% I also discount maxima where arc length is less than thresh_s degrees or 
% thresh_t in t. Defaults are 2.5 degrees and 25 ms (gets most 'real' ones)

function[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetArcsD(o,t,thresh_s,thresh_t,Plotting)

if(nargin<3) thresh_s=0.05; end;
if(nargin<4) thresh_t=0.1; end;
if(nargin<5) Plotting=1; end;

% [n,ni,b,g]=DeSpike(a,0.175);
% t=t(g);
s=o;%SmoothVec(n,5);
[ma,mi]=findextrema(s);

% **** This messes up. Need to do something cleverer... 
% add in end points. Should really check for equality but ...
% if(s(1)<s(2)) mi=[1 mi];
% else ma=[1 ma];
% end
% if(s(end)<s(end-1)) mi=[mi length(s)];
% else ma=[ma length(s)];
% end

i=1;
while(i<=length(ma))
    ma_t=t(round(ma));
    mi_t=t(round(mi));
    ma_s=s(round(ma));
    mi_s=s(round(mi));
    %     plot(t,s);
    %     hold on; plot(ma_t,ma_s,'ro'); plot(mi_t,mi_s,'gs'); hold off;
    [close_is,close_as]=GetClosePoints(mi_s,mi_t,i,ma_s,ma_t,thresh_s,thresh_t);
    if(~isempty(close_is))
        if(length(close_as)==length(close_is))
            ma=setdiff(ma,ma(close_as));
            mi=setdiff(mi,mi(close_is));
        elseif(length(close_as)>length(close_is))
            mi=setdiff(mi,mi(close_is));
            [m,ind]=max(ma_s(close_as));
            close_as=close_as([1:ind-1, ind+1:end]);
            ma=setdiff(ma,ma(close_as));
        else
            ma=setdiff(ma,ma(close_as));
            [m,ind]=min(mi_s(close_is));
            close_is=close_is([1:ind-1, ind+1:end]);
            mi=setdiff(mi,mi(close_is));
        end
        %i=1;
    else i=i+1;
    end
end
ma_t=t(round(ma));
mi_t=t(round(mi));
ma_s=s(round(ma));
mi_s=s(round(mi));
if(Plotting) plot(t,s,ma_t,ma_s,'ro',mi_t,mi_s,'gs'); end;
ma=round(ma);
mi=round(mi);

function[close_is,close_as]=GetClosePoints(s,t,i,si,ti,s_s,t_s)
close_is=[];
close_as=i;
%Check ones before it
if(i>length(s))
    j=i;
    % Check ones before
    while(((j-1)>=1)&(isclose(s(j-1),t(j-1),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j-1];
        if(isclose(s(j-1),t(j-1),si(j-1),ti(j-1),s_s,t_s))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
elseif(t(i)<ti(i))
    j=i;
    % Check ones before
    while(isclose(s(j),t(j),si(j),ti(j),s_s,t_s))
        close_is=[close_is j];
        if(((j-1)>=1)&(isclose(s(j),t(j),si(j-1),ti(j-1),s_s,t_s)))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
    % Check ones after
    j=i+1;
    while((j<=length(s))&(isclose(s(j),t(j),si(j-1),ti(j-1),s_s,t_s)))
        close_is=[close_is j];
        if((j<=length(si))&(isclose(s(j),t(j),si(j),ti(j),s_s,t_s)))
            close_as=[close_as j];
        else break;
        end
        j=j+1;
    end
else
    j=i;
    % Check ones before
    while(((j-1)>=1)&(isclose(s(j-1),t(j-1),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j-1];
        if(isclose(s(j-1),t(j-1),si(j-1),ti(j-1),s_s,t_s))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
    % Check ones after
    j=i;
    while((j<=length(s))&(isclose(s(j),t(j),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j];
        if(((j+1)<=length(si))&(isclose(s(j),t(j),si(j+1),ti(j+1),s_s,t_s)))
            close_as=[close_as j+1];
        else break;
        end
        j=j+1;
    end
end

function[isc]=isclose(s,t,si,ti,pc_s,t_s)
s_s=min(pc_s*s, 5);
s_s=max(s_s,1);
if(abs(s-si)<s_s) isc=1;
elseif(abs(t-ti)<t_s) isc=2;
else isc=0;
end