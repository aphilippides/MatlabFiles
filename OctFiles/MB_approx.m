% function MB_approx(b, offset, power]).
% Andy's code to produce modified Maxwell-Boltzmann distribution,
% normalised to [0.0,1.0] range
% Saves graph as 'MB_approx.eps'

function MB_approx(b,offset,power);

x=0:0.1:10; 
cut1=0.54;
cut2=5.4;
r=10; 
ht = 1;
x2 = x+offset;
a2 = (b./power).^power;
for i =1:length(x)
	y(i) = ht.*a2.*(x(i).^power).*(exp(-b.*x(i)+power));
end 
plot(x2, y);
hold on;
plot([0.0 cut1 power+offset cut2],[0.0 0.0 1.0 0.0], 'r--');
plot([0 10], [0.1 0.1], 'g:');
plot([cut1 cut1],[0 0.1], 'g:');
plot([cut2 cut2],[0 0.1], 'g:');
axis([0 10 -0.1 1.01*ht]);

legend('Maxwell-Boltzmann','Linear approximation');
set(gca,'FontSize',10);
xlabel('Time Step');
ylabel('Concentration\in [0.0,1.0]');
hold off;

print -deps 'MB_approx.eps'
