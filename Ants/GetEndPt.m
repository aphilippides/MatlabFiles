function[e] = GetEndPt(im,o,l,c)
print('GETENDPT DOESN@T WORK')
return
% make sure no holes
im=imfill(im,'holes');
% increment size for stepping to end
st=0.5;
% get end pt
e=round(pol2cart(o,l)+c);     % get new point
% if inside step outwards
if(im(e(2),e(1)))
    count=0;
    newe=e;
    while(count<1000)
        count=count+1;
        e=newe;                 % save old point
        l=l+st;                 % get new distance
        newe=round(pol2cart(o,l)+c);     % get new point
        % if now outside return. End point is previous e
        if(~im(newe(2),newe(1))) return; end; 
    end
    % if something's gone wrong (no 1's)
    disp('couldn''t find an end\n')
    e=[-1000 -1000];

% if outside step inwards   
else
    count=0;
    while(count<1000)
        count=count+1;
        l=l-st;                 % get new distance
        e=round(pol2cart(o,l)+c);     % get new point        
        % if inside carry on for some steps to check its not dodgy bit
        if(im(e(2),e(1)))
            dodgy=0;
            for nl=l:-st:l-4
                newe=round(pol2cart(o,l)+c);    % get new point
                if(~im(newe(2),newe(1)));       % if goes out again
                    dodgy=1;                    % set flag and break
                    break;
                end
            end
            if(~dodgy) return; end; 
        end; 
    end
    % if something's gone wrong (no 1's) or not thick enough
    disp('couldn''t find an end\n')
    e=[-1000 -1000];
end