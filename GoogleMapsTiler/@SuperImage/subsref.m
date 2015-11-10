function output=subsref(obj,a)
if numel(a)>1 || ~strcmp(a.type,'()')
    output=builtin('subsref',obj,a);
else

    s1 = a.subs{1}(:);
    s2 = a.subs{2}(:);
    if strcmp(s1,':')
        s1 = 1:obj.pix(1);
    end
    if strcmp(s2,':')
        s2 = 1:obj.pix(2);
    end
    if any(s1>obj.pix(1)) || any(s2>obj.pix(2)) || any([s1(:);s2(:)]<1)
        error('index out of range')
    end
    
    output = obj.getimpart(s1,s2);
end