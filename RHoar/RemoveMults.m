function[bs]=RemoveMults(buysell)
bs=[];
if(isempty(buysell)) return; end;
sig=buysell(1,2);
bs=[bs;buysell(1,:)];
for i=2:size(buysell,1)
    if(sig~=buysell(i,2)) 
        bs=[bs;buysell(i,:)];
        sig=buysell(i,2);
    end
end