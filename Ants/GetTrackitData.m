function[cs,os,sp,vel,ht,t] = GetTrackitData(b,day)
% 
% dwork;
% cd GantryProj\Trackit\
% if(d<14) cd trackit1-13;
% elseif(d<21) cd trackit14-20;
% else cd trackit21-24;
% end
cd Trackit\Markedflights_16-18\
s=dir(['*_out_bee' int2str(b) '_' int2str(day) '*.dat']);

for i=1:length(s)
    fn = s(i).name;
    h= dlmread(fn,'\t',1,0);
    os=CleanOrients(cart2pol(h(:,4),h(:,5),h(:,6)));
    t=h(:,7);
    heads=h(:,1:3)+h(:,4:6)*0.02;
    cs=[h(:,1:2)];
    ht=h(:,3);
    vel=diff([h(:,1),h(:,2),h(:,3)])./diff([t,t,t]);
    sp=sqrt(sum(vel.^2,2));
    
    if (length(s)>1) input('press to continue'); end;
end

cd ../../
