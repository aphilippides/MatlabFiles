function ShowTrackit(d,t)

dwork;
cd GantryProj\Trackit\
if(d<14) cd trackit1-13;
elseif(d<21) cd trackit14-20;
else cd trackit21-24;
end

s=dir(['XYZ_OF_' int2str(d) '*' int2str(t) '*.dat']);

for i=1:length(s)
    fn = s(i).name;
    h= dlmread(fn,'\t',1,0);
    os=CleanOrients(cart2pol(h(:,4),h(:,5),h(:,6)));
    td=diff(h(:,7));
    heads=h(:,1:3)+h(:,4:6)*0.02;
    vel=diff([h(:,1),h(:,2),h(:,3)])./[td,td,td];
    sp=sqrt(sum(vel.^2,2));
    figure %subplot(2,2,1)
%     plot3(h(:,1),h(:,2),h(:,3))
    plot(h(:,1),h(:,2))
    figure %subplot(2,2,2)
    plot(heads(:,1),heads(:,2),'.')
    hold on
    plot([h(:,1) heads(:,1)]',[h(:,2) heads(:,2)]','b')
    hold off
    text(h(1,1),h(1,2),'S')
    text(h(end,1),h(end,2),'F')

    figure %subplot(2,2,3)
    plot(h(:,7),os)
    figure %subplot(2,2,4)
    plot(sp,h(2:end,3),'x')
    
    if (length(s)>1) input('press to continue'); end;
end
