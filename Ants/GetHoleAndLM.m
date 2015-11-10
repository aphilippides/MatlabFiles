function GetHoleAndLM(fn,nums)
dwork;
cd GantryProj\Bees
fi=aviinfo(fn);

f=aviread(fn,1);
d=rgb2gray(f.cdata);
e=d<0.5;

% Get nest hole
tbig=50;
bigs=bwareaopen(e,tbig,8);
tlil=10;%15??
lils=bwareaopen(e,tlil,8);
bwclean=imsubtract(lils,bigs);

