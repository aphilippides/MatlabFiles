% Function which plots the time course of the diffusion of NO from a pt source
% in 3D vs that from a tube structure. Measurements at distance d from source 
% Time in seconds, distance in microns. 

function PtvsTubeS(n)

MAX_TIME = 8;
NUM_PTS = 400;
RADI = 10;
RADO = 20;


global SPHE_INN;
global SPHE_OUT;
global NUM_SPIKES;
NUM_SPIKES = n;
BURST_LENGTH = 1.05.*n;
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
Distance =[eps,30,40,50,75,100,125,150,200,300] %=[eps,10,20,50,80,100,40,200,400,600]
for index = 1:8
D_FROM_RING =Distance(index) 


D_FROM_SOURCE = Distance(index);
d = Distance(index);
pt(1) = inst_3d(eps,d);
for i =1:(NUM_PTS)
	temp = i.*MAX_TIME./NUM_PTS
	
	if temp <= BURST_LENGTH
	
		time(i+1) = temp;

                if temp <TUBE_SMT
 %                       tube_conc(i+1) = inst_ringbeg(temp,d,RADI,RADO);
                else
	%		tube_conc(i+1) = inst_ringbeg(TUBE_SMT,d,RADI,RADO)+dblquad('inst_ringrad',RADI,RADO,TUBE_SMT,temp,[],'quad8');	
                end

		if temp <PT_SMTIME
		         sphere_conc(i+1) = hol_spheintS(temp,d,SPHE_INN, SPHE_OUT,temp,BURST_LENGTH);
		else		
			sphere_conc(i+1) = quad8('inst_holsphereS',PT_SMTIME,temp,[],[],d,temp,BURST_LENGTH)+hol_spheintS(PT_SMTIME,d,SPHE_INN, SPHE_OUT,temp,BURST_LENGTH);
		end

	else
	
		temp2 = temp - BURST_LENGTH;
  		
		time(i+1) = temp;        
               	
		if temp2 <TUBE_SMT
%                        tube_conc(i+1) =inst_ringbeg(TUBE_SMT,d,RADI,RADO)-inst_ringbeg(temp2,d,RADI,RADO)+dblquad('inst_ringrad',RADI,RADO,TUBE_SMT,temp,[],'quad8');

		else
%          tube_conc(i+1)=dblquad('inst_ringrad',RADI,RADO,temp2,temp,[],'quad8');
		end

                if temp2 <PT_SMTIME

			sphere_conc(i+1) = hol_spheintS(PT_SMTIME,d,SPHE_INN, SPHE_OUT,temp,BURST_LENGTH)-hol_spheintS(temp2,d,SPHE_INN,SPHE_OUT,temp,BURST_LENGTH)+quad8('inst_holsphereS',PT_SMTIME,temp,[],[],d,temp,BURST_LENGTH);
		else
		         sphere_conc(i+1)=quad8('inst_holsphereS',temp2,temp,[],[],d,temp,BURST_LENGTH);
		end
	end
end


filename = ['S'  num2str(NUM_SPIKES) '_sp_' num2str(SPHE_OUT) 'burst_'num2str(BURST_LENGTH) 'd_'num2str(d) '.mat']
%filename = ['burst_'num2str(BURST_LENGTH) 'd_'num2str(d) '.mat']
  

eval(['save StructuresdataS/' filename ' sphere_conc time;']);

sphere_conc
plot(time,sphere_conc)
hold on
end

plot(time,sphere_conc)
xlabel('Time (seconds)')
ylabel('Concentration (M)')

hold off;
title('Concentration due to sphere and spike');
