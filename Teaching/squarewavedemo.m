function squarewavedemo
t = 0:.02:3.14;
y = zeros(10,length(t));
x = zeros(size(t));
for k=1:2:39
    z=sin(k*t)/k;
    oldx=x;
    x = x + z;
    y((k+1)/2,:) = x;
    subplot(3,1,1)
    plot(t,oldx),axis([0 pi,-1 1]),grid
    subplot(3,1,2)
    plot(t,z),axis([0 pi,-1 1]),grid
    subplot(3,1,3)
    plot(t,x),axis([0 pi,-1 1]),grid
    pause
end
plot(y(1:2:9,:)')
title('The building of a square wave: Gibbs'' effect')