% function[n]=ForceNumericInput(str,notempty,oneval,vals)
%
% function uses input but forces the user to put a numeric value or vector
%
% if notempty =1 (default 0) make sure input is not empty
% if oneval =1 (default 0) make sure input is a single value not a vector
% if vals is used (default not, ie vals =[]) the input must be a 
% single number and a member of vals which is a vector. Thus if vals is
% specified,  notempty=1 and oneval = 1 
% 
% only issue is what to do about i/j ie imaginary; currently not a number

function[n]=ForceNumericInput(str,notempty,oneval,vals)

if(nargin<2)
    notempty=0;
end
if(nargin<3)
    oneval=0;
end
if(nargin<4)
    vals=[];
elseif(~isempty(vals))
    notempty=1;
    oneval=1;
end

while 1
    s=input(str,'s');
    if(isempty(s))
        if(notempty==1)
            disp('empty input not accepted')
        else
            n=[];
            break;
        end
    elseif(isequal(s,'i'))
        disp('letter i not accepted')
        % ignore i
    elseif(isequal(s,'j'))
        disp('letter j not accepted')
        % ignore i
    else
        n=str2num(s);
        if(isempty(n))
            if(oneval)              
                disp('enter single numbers only')
            else
                disp('enter numbers vectors/matrices only eg 1, 1:3, [1 4], [1;7]')
            end
        else
            if(oneval) 
                if(isequal(size(n),[1,1]))
                    if(isempty(vals))
                        break;
                    elseif(ismember(n,vals))
                        break;
                    end
                else
                    disp('enter single numbers only')
                end
            else
                break;
            end
        end
    end
end