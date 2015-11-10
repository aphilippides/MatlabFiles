clear all;

figure(1);
clf;
axis([-1 1 -1 1]); 
axis image;
hold on;
set(gca,'xtick',-1:1,'ytick',-1:1);
title('Click to specify points, Enter to end');

pos = ginput;
plot(pos(:,1),pos(:,2),'o');

[trj, psg] = min_jerk(pos, 100, [], [], []);
plot(trj(:,1),trj(:,2));
title('Minimum-jerk trajectory');
disp('Optimal passage times:');
disp(psg');
