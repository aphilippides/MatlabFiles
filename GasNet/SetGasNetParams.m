function SetGasNetParams

XDIM=20.0        % Node Grid Size
YDIM=20.0        % Node Grid Size
MAXR=10.0        % max rad of connection

#define INPUTNODE               0
#define HIDDENNODE              1
#define LEFTMOTORNODE           2
#define RIGHTMOTORNODE          3
#define ETHRESH 0.5     // elec output thresh to start emitt chem
#define CTHRESH 0.1     // like wise for chem conc in vicinity
#define INPUTPROB 0.25      // chance of node being input
#define CAMERARADIUS 20.0   // radius of input vision camera
#define MAXPATCHR 5.0       // max radius of sample patch
#define DTCONST 10          // max diff time const. changed 19/2/98
#define DTOFF 1             // offset for same. changed 19/2/98
#define REMISS 10           // max rad of emiss
#define REOFF 2             // offset for same
#define NUMPOW 11   // changed back from 15 for seeding 11/5