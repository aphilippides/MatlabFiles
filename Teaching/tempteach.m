for t=0:0.1:20
    x=0:0.01:2*pi;
    subplot(2,1,1)
    plot(x,sin(x-t),x,sin(x+t),'r','Linewidth',2)
    axis([0 2*pi -1.05 1.05])
    grid
    subplot(2,1,2)
        plot(x,sin(x-t)-sin(x+t),'g','Linewidth',2)
    axis([0 2*pi -2.05 2.05])
    grid
end