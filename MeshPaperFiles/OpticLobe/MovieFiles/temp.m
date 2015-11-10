function temp

Square=3;
Space=10;
NumSources=[4,9,16,25,36,49]
%NumSources=[64,81,100,121,144,169]
for i=1:length(NumSources)
subplot(3,2,i)
LobeRange(Square,Space,NumSources(i));
hold on
title(['Diam ' num2str(NumSources(i))])
xlabel('Time')
ylabel('Thresh Radius')
Y=(sqrt(NumSources(i))-1)*Space+sqrt(NumSources(i))*Square;
plot([0 5],[Y Y],'r:')
end
hold off
