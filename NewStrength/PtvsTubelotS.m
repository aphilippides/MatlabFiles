% Function which plots the time course of the diffusion of NO from a pt source
% in 3D vs that from a tube structure. Measurements at distance d from source 
% Time in seconds, distance in microns. 

function PtvsTubelotS(n)

MAX_TIME = 8.4;
 NUM_PTS= 840;   		% *** MUST BE  A No. S.T. MAX_TIME/NUM_PTS = 1.05/K
RADI = 10;
RADO = 20;


global SPHE_INN;
global SPHE_OUT;
global NUM_SPIKES;
NUM_SPIKES = 1;

BURST_LENGTH2 = 1.05
SMALL_TIME = eps;
GLOBES;
PT_SMTIME = 0.001;
TUBE_SMT =   0.01;
global D_FROM_RING;
global D_FROM_SOURCE;
SPHE_INN = 15;
SPHE_OUT = 30;
time(1)=eps;
tube_conc(1)=0;
pt(1)=0;

sphere_conc(1)=0;
%SPHE_OUT = n;
%Distance =[40,60, 80,100,120]
Distance =[eps,30,40,50,75,100,125,150,200,300,900] %=[eps,10,20,50,80,100,40,200,400,600]
for index = 1:10
D_FROM_RING =Distance(index) 
sphere_conc1(1)=0;

D_FROM_SOURCE = Distance(index);
d = Distance(index);
pt(1) = inst_3d(eps,d);
for i =1:(NUM_PTS)
	temp = i.*MAX_TIME./NUM_PTS
	
	if temp <= BURST_LENGTH2
	
		time(i+1) = temp;

		if temp <PT_SMTIME
		         	sphere_conc1(i+1) = hol_spheintS(temp,d,SPHE_INN, SPHE_OU,temp,BURST_LENGTH2);
		else		
			sphere_conc1(i+1) = quad8('inst_holsphereS',PT_SMTIME,temp,[],[],d,temp,BURST_LENGTH2)+hol_spheintS(PT_SMTIME,d,SPHE_INN, SPHE_OUT,temp,BURST_LENGTH2);
		end

	else
	
		temp2 = temp - BURST_LENGTH2;
  		
		time(i+1) = temp;        
                	if temp2 <PT_SMTIME

			sphere_conc1(i+1) = hol_spheintS(PT_SMTIME,d,SPHE_INN, SPHE_OUT,temp,BURST_LENGTH2)-hol_spheintS(temp2,d,SPHE_INN,SPHE_OUT,temp,BURST_LENGTH2)+quad8('inst_holsphereS',PT_SMTIME,temp,[],[],d,temp,BURST_LENGTH2);
		else
		         	sphere_conc1(i+1)=quad8('inst_holsphereS',temp2,temp,[],[],d,temp,BURST_LENGTH2);
		end
	end
end

for NUM_SPKES = 2:4
sphere_conc(1)=0;
BURST_LENGTH = BURST_LENGTH2.*NUM_SPKES;
for i =1:(NUM_PTS)
	temp = i.*MAX_TIME./NUM_PTS
	sphere_conc(i+1)=0;
	if temp <= BURST_LENGTH
		bit = mod(temp,BURST_LENGTH2);
		ind1=1+(bit.*NUM_PTS./MAX_TIME);
		if bit>0
			sphere_conc(i+1)=sphere_conc(i+1)+sphere_conc1(ind1);
		end
		numb = floor(temp./BURST_LENGTH2);
		for j=1:numb
			bit2 = bit + j.*BURST_LENGTH2;
			ind2=1+(bit2.*NUM_PTS./MAX_TIME);
			sphere_conc(i+1)=sphere_conc(i+1)+sphere_conc1(ind2);
		end
		time(i+1) = temp;
	else
	
		temp2 = temp - BURST_LENGTH;
  		for j=1:NUM_SPKES
			bit2 = temp2+ j.*BURST_LENGTH2;
			ind2=1+(bit2.*NUM_PTS./MAX_TIME);
			sphere_conc(i+1)=sphere_conc(i+1)+sphere_conc1(ind2);
		end
		time(i+1) = temp;        
 	end
end

filename = ['SP'  num2str(NUM_SPKES) '_sp_' num2str(SPHE_OUT) 'burst_'num2str(BURST_LENGTH) 'd_'num2str(d) '.mat']
%filename = ['burst_'num2str(BURST_LENGTH) 'd_'num2str(d) '.mat']
  

eval(['save StructuresdataS/' filename ' sphere_conc time;']);

sphere_conc
plot(time,sphere_conc)
hold on
end
filename = ['SP1_sp_' num2str(SPHE_OUT) 'burst_'num2str(BURST_LENGTH2) 'd_'num2str(d) '.mat']
sphere_conc =sphere_conc1;
eval(['save StructuresdataS/' filename ' sphere_conc time;']);
sphere_conc = sphere_conc*0;
end

plot(time,sphere_conc)
xlabel('Time (seconds)')
ylabel('Concentration (M)')

hold off;
title('Concentration due to sphere and spike');
