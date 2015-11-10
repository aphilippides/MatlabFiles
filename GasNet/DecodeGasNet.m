function DecodeGasNet(gt,v)

if(nargin<2|v) NumPs=21; end;
% load GasNetParams

n=length(gt)/NumPs;
for i=1:n GArray(i,:)=gt(NumPs*(i-1)+1:i*NumPs); end;

ScaleFacts=[XDIM YDIM MAXR 2*pi 2*pi MAXR 2*pi 2*pi CAMERARADIUS 2*pi 1 DTCONST REMISS XDIM YDIM NUMPOW 2*MAXBIAS];
PArray=floor(GArray(:,[1:17]).*(ScaleFacts*ones(1,n))/MAXBITVAL)

PArray(:,12)=DTOFF+PArray(:,12);
PArray(:,13)=REOFF+PArray(:,13);
PArray(:,17)=PArray(:,17)-MAXBIAS;


%		cells[i].a_def_ind= (int) (NUMPOW * ((*gp++)/MAXBITVAL));
%        cells[i].a=posspows[(cells[i].a_def_ind)];


%        cells[i].rec = ((*gp++) % 3);               /* 0=not, 1=+ve,2=-ve */
        cells[i].input = ((*gp++) % 2);             /* yes/no */
        cells[i].type_emiss = ((*gp++) % (NCHEMS+2))-1;  /* -1 to NCHEM */
        cells[i].chem_emiss= ((*gp++) % NCHEMS) + 1;     /* 1 to NCHEM */
%        cells[i].ethresh = ETHRESH;
%        cells[i].cthresh = CTHRESH;

    }



            /* motors have fixed positions near corners */
    cells[0].input=cells[1].input=cells[2].input=cells[3].input=0;
    cells[0].x = 2.0; cells[0].y = 2.0;
    cells[1].x = 2.0; cells[1].y = YDIM - 2.0;
    cells[2].x = XDIM - 2.0; cells[2].y = YDIM - 2.0;
    cells[3].x = XDIM - 2.0; cells[3].y = 2.0;
		
    % gas affects every neuron: 30>sqrt(800)
    if(TestType==2) cells[i].rad_emiss= 30;		
		if(ORIGINAL_NETWORK){
	        cells[i].cloud_x= cells[i].x;		
		    cells[i].cloud_y = cells[i].y; 
        }
    if(TestType==1) cells[i].diff_tconst= (int) (DTOFF); 

	if(ORIGINAL_NETWORK){
		for(i=0;i<4;i++){
			cells[i].cloud_x= cells[i].x;		
			cells[i].cloud_y = cells[i].y;
		}
	}
}
