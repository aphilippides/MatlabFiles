function[out,bee,fnum]=ProcessBeeFilename(fn,out)

if(nargin<2)
    ind1=findstr(fn,'out');
    ind2=findstr(fn,'in');
    if(isempty(ind1))
        str='in';
        out=0;
    elseif(isempty(ind2))
        str='out';
        out=1;
    elseif(ind1<ind2)
        str='out';
        out=1;
    else
        str='in';
        out=0;
    end
else
    if(out==1)
        str='out';
    else
        str='in';
    end
end

ind=findstr(fn,str);
bee=str2double(fn(ind-3:ind-1));
% if(isempty(fnn)) 
%     bee =NaN;
% else
%     bee =fnn;
% end
lbit=strtrim(fn(ind+length(str):end));
c=1;
fnum=NaN;
while 1
    is=1:c;
    fn2=str2double(lbit(is));
    if(isnan(fn2)) 
        break;
    else
        fnum=fn2;
        c=c+1;
    end
end

if(isnan(fnum))
    fn
%     keyboard;
end
