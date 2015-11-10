function hol_sphere2S(n)

GLOBES;
global NUM_SPIKES;
global D_FROM_SOURCE;
global D_FROM_RING;
global DIFF;
global SPHE_INN;
global SPHE_OUT;
SPHE_INN = 15;
SPHE_OUT = 30;
MAX_X = 250;
RADI = 10;
RADO = 20;
NUM_PTS =50;
PT_SMTIME = 0.001;
TUBE_SMT = 0.01;
NR_O1 = eps;
%NR_O2 = 1.25;
%NR_O1 = eps
NR_O2 = MAX_X./(NUM_PTS.*4);
Dist(1)=NR_O1;
Dist(2)=NR_O2;
NUM_SPIKES = n;
BURST_LENGTH = 1.05.*NUM_SPIKES;

%Times =[0.0025,0.005, .0075,0.01,0.0125,0.015,0.02,0.025, 0.05 ,0.1, 0.15,0.20,0.3,0.4,0.5,1,2]
Times =[2.08,2.1, 2.06, 0.05, 0.0625, 0.075, 0.0875, 0.1, 0.125, 0.15, 0.2, 0.25, 0.3, 0.5, 1, 2, 4, 8]
Distance =[ .001,.01, .1, 0.25,0.5,0.75,1,2,5,10,15,20,25,50,75,100, 50, 52,55, 60,100, 150, 200]
  
for i = 3:(NUM_PTS+2) 
    Dist(i) = (i-2).*MAX_X./NUM_PTS;
end
    
for i = 1:(NUM_PTS+2)
    % tube_beg(i) = inst_ringbegS(TUBE_SMT,Dist(i),RADI,RADO);
 %    sphere_beg(i)= hol_spheintS(PT_SMTIME,Dist(i),SPHE_INN, SPHE_OUT);   
%	sphere_beg2(i)= sphere_beg(i)-hol_spheint(PT_SMTIME,Dist(i),SPHE_INN, SPHE_OUT);
end

for index = 1:3
%SPHE_OUT = Distance(index);
%temp = 0.5;
%SPHE_OUT = n;
temp = Times(index)

if temp <= BURST_LENGTH    

    for i = 1:(NUM_PTS +2)
    D_FROM_RING =Dist(i)
         if temp <=TUBE_SMT
%               tube_conc(i) = inst_ringbegS(temp,Dist(i),RADI,RADO);
         else
%		tube_conc(i)=tube_beg(i)+dblquad('inst_ringrad',RADI,RADO,TUBE_SMT,temp,[],'quad8');
	 end

	if temp <PT_SMTIME
         	sphere_conc(i) = hol_spheintS(temp,Dist(i),SPHE_INN, SPHE_OUT,temp,BURST_LENGTH);
	else
		sphere_conc(i) = quad8('inst_holsphereS',PT_SMTIME,temp,[],[],Dist(i),temp,BURST_LENGTH)+hol_spheintS(PT_SMTIME,Dist(i),SPHE_INN, SPHE_OUT,temp,BURST_LENGTH);
	end
    end
else

    temp2 = temp - BURST_LENGTH;
    for i = 1:(NUM_PTS+2)

         D_FROM_RING = Dist(i);
         if temp2 <TUBE_SMT
%               tube_conc(i) = tube_beg(i)-inst_ringbegS(temp2,Dist(i),RADI,RADO)+dblquad('inst_ringrad',RADI,RADO,TUBE_SMT,temp,[],'quad8');
         else
	%      tube_conc(i)=dblquad('inst_ringrad',RADI,RADO,temp2,temp,[],'quad8');
	 end
	
         if temp2 <PT_SMTIME
		sphere_conc(i) = hol_spheintS(PT_SMTIME,Dist(i),SPHE_INN, SPHE_OUT,temp,BURST_LENGTH)-hol_spheintS(temp2,Dist(i),SPHE_INN,SPHE_OUT,temp,BURST_LENGTH)+quad8('inst_holsphereS',PT_SMTIME,temp,[],[],Dist(i),temp,BURST_LENGTH);
	else
		sphere_conc(i)=quad8('inst_holsphereS',temp2,temp,[],[],Dist(i),temp,BURST_LENGTH);
	end
    end
end


Dist
sphere_conc
%tube_conc
plot(Dist,sphere_conc)
hold on;
%filename = ['burst' num2str(BURST_LENGTH) 't_'num2str(Times(index)) '.mat'];

filename = ['S' num2str(NUM_SPIKES) '_sp_' num2str(SPHE_OUT) 'burst_' num2str(BURST_LENGTH) 't_' num2str(temp) '.mat']
eval(['save StructuresdataS/' filename ' sphere_conc Dist;']);
end
 
