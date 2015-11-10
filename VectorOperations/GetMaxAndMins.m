function[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(o,t,thresh_s,thresh_t,Plotting)

if(nargin<5) Plotting=1; end;
s=o;

% if doing this again, need to check the functions below...
[ma,mi]=findextrema_FlatBitsDoesntwork(s);
% [ma,mi]=findextrema(s);

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

function[isc]=isclose(s,t,si,ti,s_s,t_s)
if(abs(s-si)<s_s) isc=1;
elseif(abs(t-ti)<t_s) isc=2;
else isc=0;
end