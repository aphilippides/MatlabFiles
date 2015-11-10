function[t]=TimeFromFn(fn)

[ns,s,e]=ReadNumbersFromString(fn);
i=find(ns>99,1);
if(isempty(i)) t=GardenTFromFn(fn);
else 
    v=ns(i);
    tt=v/100;
    hr=floor(tt);
    mins=round(v-100*hr);
    t=[hr mins]*[1 1/60]';
end

function[t]=GardenTFromFn(fn)
pos=strfind(fn,'-');
if(length(pos)<3)
    disp(['Filename not read is ' fn]);
    hr=[];%input('type number of hours; return to skip:  ');
    if(isempty(hr)) 
        t=NaN;
        return;
    end
    mins=input('type number of minutes; return to skip:  ');
    if(isempty(mins)) 
        t=NaN;
        return;
    end
elseif((pos(1)<=3)&&(length(pos)>3))
    m=pos(4);
    hr=round(str2num(fn(m-2:m-1)));
    mins=round(str2num(fn(m+1:m+2)));
else
    m=pos(3);
    hr=round(str2num(fn(m-2:m-1)));
    mins=round(str2num(fn(m+1:m+2)));
end
t=[hr mins]*[1 1/60]';