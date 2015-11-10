function GetSPSSWidth3dData
%GetPointStats
GetVolStats

function GetPointStats(Timee)
if(nargin<1)
   Timee=1;
end
VersNums=[1:35]
GroupNum=[1 4];
Pt=150;
d3dmm;
T=Timee*1000;
Concs=[];
for i=1:2
   wid = GroupNum(i);
	fn=['MaxW'x2str(wid) 'Rho100/TreeSst1OneDSlicesGr300X100Z100Sq1Sp10T'x2str(T) '.mat'];
	load(fn);
   Concs=[Concs; Slices(:,Pt)]
	Groups=[Groups;ones(size(VersNums')).*GroupNum(i)]
end
M=[Concs Groups]
fn=['SPSS_1DSliceWidth3dData.dat'];
save(fn,'M','-ascii','-tabs');


function GetVolStats
VersNums=[1:35]
%GroupNums=[1 4];
GroupNums=[5];
T=1;
M=zeros(length(VersNums)*2,4); % 4 columns:NumOver, Max, Min, group num
for Sl=0:5
   for k=1:2
	   for i=1:length(VersNums)
   	   [Ov,Maxi,Mini]=GetMMOData(VersNums(i),T,Sl,GroupNums(k));
      	M(i+(k-1)*length(VersNums),:)=[Ov,Maxi,Mini,GroupNums(k)];
      end
   end
   fn=['SPSS_MMOWidth3dDataSl' int2str(Sl) 'T1.dat'];
   save(fn,'M','-ascii','-tabs');
end

function[Ov,Maxi,Mini]=GetMMOData(V,T,Sl,Wid)
d3dmm;
fn=['MaxW' int2str(Wid) 'Rho100/TreeSSt1V'int2str(V) 'MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.dat'];
if (IsFile(fn))
   M=load(fn);
   ind=find(M(:,1)==T);
   Ov=M(2,4)-M(ind,4);
   Maxi=M(ind,2);
   Mini=M(ind,3);
else
   Ov=[];
   Maxi=[];
   Mini=[];
end


