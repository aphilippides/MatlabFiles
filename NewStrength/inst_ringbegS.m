% Function which calculates the concentration at a distance D_FROM_RING from a
% ring of radius 'radius' source of NO for t<=0.001

function[Inst_ringbe] = inst_ringbeg(t,Dist,a,b)

global D_FROM_RING;
global STRENGTH_VOLSEC;
GLOBE

NUM_PTS = length(Dist);

for i=1:NUM_PTS
conc_t(i) = 0;
fmax(i)=0;
fmin(i)=0;
end

TUBESM_TIME = 0.0001;

for i=1:NUM_PTS

if Dist(i)==a
     fmin(i) = STRENGTH_VOLSEC./2.0;
elseif Dist(i)==b
     fmin(i) = STRENGTH_VOLSEC./2.0;
elseif((a<Dist(i))&(Dist(i)<b))
     fmin(i) = STRENGTH_VOLSEC;
end
end

for i=1:NUM_PTS
D_FROM_RING = Dist(i);

if t<TUBESM_TIME
fmax(i) = quad8('inst_ringrad',a,b,[],[],t);

if(isinf(fmax(i))|isnan(fmax(i)))
     fmax(i) = 0;
     if Dist(i)>b
          break;
     end
end 
conc_t(i) = (fmin(i)+fmax(i)).*t./2.0;
else 
fmax(i) = quad8('inst_ringrad',a,b,[],[],TUBESM_TIME);

if(isinf(fmax(i))|isnan(fmax(i)))
     fmax(i) = 0;
     if Dist(i)>b
          break;
     end
end
conc_t(i) = (fmin(i)+fmax(i)).*TUBESM_TIME./2.0;
end
end

for i=1:NUM_PTS
D_FROM_RING = Dist(i);

if((t>0.0001)&(t<0.001))
	bit = dblquad('inst_ringrad',a,b,TUBESM_TIME,t,[],'quad8');
	if(bit<1e-10)
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end	
	if(isinf(bit)|isnan(bit))
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end
	conc_t(i) = conc_t(i) + bit;
else          
	bit = dblquad('inst_ringrad',a,b,0.0001,0.001,[],'quad8');
	if(bit<1e-10)
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end	
	if(isinf(bit)|isnan(bit))
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end
	conc_t(i) = conc_t(i) + bit;
end           
end

for i=1:NUM_PTS
D_FROM_RING = Dist(i);

if((t>0.001)&(t<0.01))
	bit = dblquad('inst_ringrad',a,b,0.001,t,[],'quad8');
	if(bit<1e-10)
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end	
	if(isinf(bit)|isnan(bit))
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end
	conc_t(i) = conc_t(i) + bit;
else 
	bit = dblquad('inst_ringrad',a,b,0.001,0.01,[],'quad8');
	if(bit<1e-10)
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end	
	if(isinf(bit)|isnan(bit))
		if(Dist(i)<=b)
			bit=0;
		else
			bit =0;
			break;
		end
	end
	conc_t(i) = conc_t(i) + bit;
end
end


Inst_ringbe = conc_t;
