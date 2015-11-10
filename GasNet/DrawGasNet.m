function DrawGasNet(gt,v)

function DecodeGasNet(gt,v)

if(nargin<2|v) NumPs=21; end;
% load GasNetParams

n=length(gt)/NumPs;
for i=1:n GArray(i,:)=gt(NumPs*(i-1)+1:i*NumPs); end;

PArray(:,1)=floor(GArray*XDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
PArray(:,2)=floor(GArray*YDim/MAXBITVAL);
        cells[i].y = YDIM * ((*gp++)/MAXBITVAL);
        cells[i].posr = MAXR * ((*gp++)/MAXBITVAL);
        cells[i].pos_thet1 = TWOPI * ((*gp++)/MAXBITVAL);
        cells[i].pos_thet2 = ForceAngleInCircle(TWOPI * ((*gp++)/MAXBITVAL)+
                            cells[i].pos_thet1);
        cells[i].negr = MAXR * ((*gp++)/MAXBITVAL);
        cells[i].neg_thet1 = TWOPI * ((*gp++)/MAXBITVAL);
        cells[i].neg_thet2 = ForceAngleInCircle(TWOPI * ((*gp++)/MAXBITVAL)+
                            cells[i].neg_thet1);

        cells[i].inputr = CAMERARADIUS * ((*gp++)/MAXBITVAL);
        cells[i].inputtheta = TWOPI * ((*gp++)/MAXBITVAL);
        cells[i].inputthresh = ((*gp++)/MAXBITVAL);
        cells[i].diff_tconst= (int) (DTCONST * ((*gp++)/MAXBITVAL)) + DTOFF;
		// instant rise decay of gas
		if(TestType==1) cells[i].diff_tconst= (int) (DTOFF); 
		
		cells[i].rad_emiss= (int) (REMISS * ((*gp++)/MAXBITVAL)) + REOFF;
		// gas affects every neuron: 30>sqrt(800)
		if(TestType==2) cells[i].rad_emiss= 30;		

		cells[i].cloud_x= XDIM * ((*gp++)/MAXBITVAL);
        cells[i].cloud_y = YDIM * ((*gp++)/MAXBITVAL);		
		if(ORIGINAL_NETWORK){
	        cells[i].cloud_x= cells[i].x;		
		    cells[i].cloud_y = cells[i].y; 
        }

		cells[i].a_def_ind= (int) (NUMPOW * ((*gp++)/MAXBITVAL));

        cells[i].bias = MAXBIAS*(2.0*((*gp++)/MAXBITVAL)-1.0);
        cells[i].ethresh = ETHRESH;
        cells[i].cthresh = CTHRESH;

        cells[i].rec = ((*gp++) % 3);               /* 0=not, 1=+ve,2=-ve */
        cells[i].input = ((*gp++) % 2);             /* yes/no */
        cells[i].type_emiss = ((*gp++) % (NCHEMS+2))-1;  /* -1 to NCHEM */
        cells[i].chem_emiss= ((*gp++) % NCHEMS) + 1;     /* 1 to NCHEM */

        cells[i].a=posspows[(cells[i].a_def_ind)];
        cells[i].inputtheta = ForceAngleInCircle(cells[i].inputtheta);
        cells[i].neg_thet1 = ForceAngleInCircle(cells[i].neg_thet1);
        cells[i].pos_thet1 = ForceAngleInCircle(cells[i].pos_thet1);
        cells[i].neg_thet2 = ForceAngleInCircle(cells[i].neg_thet2);
        cells[i].pos_thet2 = ForceAngleInCircle(cells[i].pos_thet2);
    }

            /* motors have fixed positions near corners */
    cells[0].input=cells[1].input=cells[2].input=cells[3].input=0;
    cells[0].x = 2.0; cells[0].y = 2.0;
    cells[1].x = 2.0; cells[1].y = YDIM - 2.0;
    cells[2].x = XDIM - 2.0; cells[2].y = YDIM - 2.0;
    cells[3].x = XDIM - 2.0; cells[3].y = 2.0;
	
	if(ORIGINAL_NETWORK){
		for(i=0;i<4;i++){
			cells[i].cloud_x= cells[i].x;		
			cells[i].cloud_y = cells[i].y;
		}
	}
}

    
    