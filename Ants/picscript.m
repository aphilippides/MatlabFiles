figure(1)
% cos=[];cis=[];
cos=zeros(1,36);cis=zeros(1,36);
for i=1:length(outs)
%     cos=[cos;outs(i).rl.Cents];
%     cis=[cis;ins(i).rl.Cents];

    cos=[cos+outs(i).rl.fos];
    cis=[cis+ins(i).rl.fos];
%     cos=[cos+outs(i).rl.frns];
%     cis=[cis+ins(i).rl.frns];
%     cos=[cos+outs(i).rl.frls(1,:)];
%     cis=[cis+ins(i).rl.frls(1,:)];
end
x=-170:ndiv:180;
kk=([19:36 1:18]);
% kk=([1:36]);
plot(x,cos(kk)/sum(cos),x,cis(kk)/sum(cis),'r','LineWidth',2)
axis tight;
set(gca,'FontSize',14),
title('Learning (blue) vs Return (red) flights'),
xlabel('Body orientation (N=0)'),ylabel('Frequency'),Setbox
return
% 
m=2;
gr=[-50:m:50];
[den,a,b,x,y]=Density2D(cos(:,1),cos(:,2),gr,gr);
pcolor(x,y,log(den+1)),shading interp,
% pcolor(x,y,(den+1)),shading interp,
hold on
PlotNestAndLMs(mouts.LM,mouts.LMWid,mouts.nest);
CompassAndLine('w',[],[],0)
hold off
figure(2)
[den,a,b,x,y]=Density2D(cis(:,1),cis(:,2),gr,gr);
pcolor(x,y,log(den+1)),shading interp,
hold on
PlotNestAndLMs(mouts.LM,mouts.LMWid,mouts.nest);
CompassAndLine('w',[],[],0)
hold off