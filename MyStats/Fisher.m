% Fisher Linear disriminant function for 2 classes
% Returns normalised vector

function[v]=Fisher(c1,c2)

m1 = mean(c1,2);
m2=mean(c2,2);

Sw=0;
for i=1:size(c1,2)
    Sw=Sw+(c1(:,i)-m1)*(c1(:,i)-m1)';
end
for i=1:size(c2,2)
    Sw=Sw+(c2(:,i)-m2)*(c2(:,i)-m2)';
end

v=Sw^(-1)*(m2-m1);
v=Normalise(v);