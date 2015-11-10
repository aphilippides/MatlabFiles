function arrowplot(x,y,th,d,col,h)
% plot arrows of length d at x,y in direction th
% optionally determine col and relative size of head

hold on
if nargin<5
    col='k';
end
if nargin<6
    h=d/6;
end
for i=1:length(x)
    % plot shaft
    plot([x(i) x(i)+d*cos(th(i))],[y(i) y(i)+d*sin(th(i))],strcat(col,'-'))
    % plot head
    plot([x(i)+d*cos(th(i)),x(i)+d*cos(th(i))+(h)*cos(th(i)+0.9*pi)],...
        [y(i)+d*sin(th(i)),y(i)+d*sin(th(i))+(h)*sin(th(i)+0.9*pi)],strcat(col,'-'));
    plot([x(i)+d*cos(th(i)),x(i)+d*cos(th(i))+(h)*cos(th(i)-0.9*pi)],...
        [y(i)+d*sin(th(i)),y(i)+d*sin(th(i))+(h)*sin(th(i)-0.9*pi)],strcat(col,'-'));
end
hold off
axis equal