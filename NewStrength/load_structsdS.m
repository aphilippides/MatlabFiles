% file which loads data created by PtvsTube.m and kept in Structuresdata/
% has data for pt tube and sphere

function load_structsdS(d)

Dists =[eps,75,150,225,300]
%Dists =[40,60,80,100,120]
%, 0.25,0.5,0.75,1,2,5,10,15,20,25,50,75,100];
NUM_SPKES = d;
%d=150;

nin =[''];
for k=1:4

NUM_SPKES = k;
%BURST_LENGTH = 0.55.*NUM_SPKES;
BURST_LENGTH = 0.55
%d=Dists(k);

filename = ['StructuresdataS/SP2' num2str(NUM_SPKES) '_sp_30burst_'num2str(BURST_LENGTH) 'd_'num2str(d) '.mat']
eval(['load ' filename ]);

sphere_conc = sphere_conc*0.00331*1e9;

plot(time, sphere_conc)
hold on;
newn =[ num2str(Dists(k))];
%nin = [nin ', ' newn];
nin =[num2str(d)]
end

%x=0:0.005:5;
%y=(strengthlots(x,4.2)*10e-6)-1e-5;
%plot(x,y,'r:')
hold off;
axis([0 8 0 15])
xlabel('Time (seconds)');
ylabel('Conc (nM)');
titl = ['sphere + spike burst ' num2str(BURST_LENGTH) ', d= ' nin];
%title(titl);

