function plots

subplot(2,1,1)
load_structsd(eps)
axis([0 5 0 0.75e-5])
title('Distance = 0')
xlabel('')
subplot(2,1,2)
load_structsd(225)
axis([0 10 0 0.25e-6])
title('Distance = 225')
