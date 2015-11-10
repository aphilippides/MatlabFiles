function GetSPSSTreeData(Sl,Groups)

VersNums=[1:65 71:80 86:90]
GroupNums=floor((VersNums-1)/10)
T=2;
M=zeros(length(VersNums),4); % 4 columns:NumOver, Max, Min, group num
for Sl=0:5
   for i=1:length(VersNums)
      [Ov,Maxi,Mini]=GetMMOData(VersNums(i),T,Sl);
      M(i,:)=[Ov,Maxi,Mini,GroupNums(i)];
	end
   fn=['SPSS_MMOTreeDataSl' int2str(Sl) '.dat'];
   save(fn,'M','-ascii','-tabs');
end

function[Ov,Maxi,Mini]=GetMMOData(V,T,Sl)
d3dmm;
fn=['MaxTreeRho100/TreeSSt1V'int2str(V) 'MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.dat'];
M=load(fn);
ind=find(M(:,1)==T);
Ov=M(2,4)-M(ind,4);
Maxi=M(ind,2);
Mini=M(ind,3);

