function MushBod(pcs,ts)
dmat
cd ..\DiffEqun\MeshTube\Mushroom\Mush
plotlines(pcs,ts)
% figure
% plotmaxes(pcs)

function plotmaxes(pcs)
for pc=pcs
    n=load(['Jitter0Pc' int2str(pc) 'SSt0_25B3MaxGr1000Inn60Out125.dat']);    
    n=n(2:end,:);
    subplot(2,1,1),hold on
%    errorbar(n(:,1),n(:,2),n(:,3))
    plot(n(:,1),n(:,2)./pc)
    subplot(2,1,2),hold on
    plot(n(:,1),n(:,4)./pc)
end
subplot(2,1,1),hold off
subplot(2,1,2),hold off

function plotlines(pcs,ts)
for pc=pcs
    m=load(['Jitter0Pc' int2str(pc) 'SSt0_25B3Gr1000Inn60Out125Line500.dat']);
    for t=ts
        plot(m(t,:))
        hold on;
    end
end
hold off