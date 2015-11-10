function[bs]=CombineProfs(bs1,bs2)
bs=[bs1;bs2];
if(isempty(bs)) return; end;
[s,is]=sort(bs(:,1));
bs=bs(is,:);
ToKeep=1;
for i=2:size(bs,1)
    if(~isequal(bs(i-1,:),bs(i,:)))
        ToKeep=[ToKeep i];
%     else
%         a=10;
    end
end
bs=bs(ToKeep,:);