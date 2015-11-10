function PlotLLNRoute(out)
cs=['bs';'rs';'gs';'ks'];
plot(out.x,out.y)
hold on;
for i=1:size(out.wpts,1)
    plot(out.wpts(i,4),out.wpts(i,5),cs(1+mod(i,4),:)); 
end
hold off