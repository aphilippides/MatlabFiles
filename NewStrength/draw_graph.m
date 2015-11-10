% file which loads data created by PtvsTube.m and kept in Structuresdata/
% has data for pt tube and sphere

 function draw_graph
NR_O1 = 0.00001;
NR_O2 = 1.25;
Dists = [0.025,eps,75,300,150,40,80,100,50,200,400,600,800,1000]; 
%, 0.25,0.5,0.75,1,2,5,10,15,20,25,50,75,100];
 BURST_LENGTH = 0.1;

for k=1:1
	d=Dists(k);
	filename = ['../Structuresdata/burst0.1t_'num2str(Dists(k)) '.mat']
	eval(['load ' filename ]);
	NUM_PT = length(Dist);
for ind = 1:NUM_PT
	ref_Dist(ind) = -Dist(NUM_PT+1-ind);
	ref_tube_conc(ind) = tube_conc(NUM_PT+1-ind);
end
for ind = 1:NUM_PT
	ref_Dist(NUM_PT+ind) = Dist(ind);
	ref_tube_conc(NUM_PT+ind) = tube_conc(ind);
end
plot(ref_Dist, ref_tube_conc);

	hold on;
end	
filename = ['../Structuresdata/burst0.1t_0.05.mat']
eval(['load ' filename ]);	NUM_PT = length(Dist);
for ind = 1:NUM_PT
	ref_Dist(ind) = -Dist(NUM_PT+1-ind);
	ref_tube_conc(ind) = tube_conc(NUM_PT+1-ind);
end
for ind = 1:NUM_PT
	ref_Dist(NUM_PT+ind) = Dist(ind);
	ref_tube_conc(NUM_PT+ind) = tube_conc(ind);
end
plot(ref_Dist, ref_tube_conc,':');

filename = ['../Structuresdata/burst0.1t_0.1.mat']
eval(['load ' filename ]);	NUM_PT = length(Dist);
for ind = 1:NUM_PT
	ref_Dist(ind) = -Dist(NUM_PT+1-ind);
	ref_tube_conc(ind) = tube_conc(NUM_PT+1-ind);
end
for ind = 1:NUM_PT
	ref_Dist(NUM_PT+ind) = Dist(ind);
	ref_tube_conc(NUM_PT+ind) = tube_conc(ind);
end
plot(ref_Dist, ref_tube_conc,'--');


hold off;
legend('t=25ms','t=50ms','t=100ms')
xlabel('Distance from centre of source (\mum)');
ylabel('Concentration (M)');
axis([-75 75 0 1.4e-3])
