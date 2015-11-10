function MetaPerceptron(l)

Os=perms(1:4)'
for i=1:length(Os)
    NumLoops(i)=PerceptronCheck2(1,[1 0 1 0],'MyID',Os(:,i));
end
NumLoops
[mean(NumLoops) std(NumLoops)]