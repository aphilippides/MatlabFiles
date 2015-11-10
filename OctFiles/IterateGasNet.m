function[Outs] = IterateGasNet(Iter, NodesIn, Ins, Danger)

A=LoadDataFile('NetworkMatlab');
NumNodes=A(1,1);	
Nodes=A(2:NumNodes+1,:); 	%Nodes contains activities starting from iter 0
NumParams=6;
Recc = Nodes(:,4);
PosFrom=Nodes(:,NumParams+NumNodes+2:NumParams+2*NumNodes+1);
NegFrom=Nodes(:,NumParams+2*NumNodes+3:NumParams+3*NumNodes+2);
for i=1:length(Recc)
   if Recc(i)==0
      PosFrom(i,NumNodes+1)=-1;
      NegFrom(i,NumNodes+1)=-1;
   elseif Recc(i)==1
      PosFrom(i,NumNodes+1)=i-1;
      NegFrom(i,NumNodes+1)=-1;
   else     
      PosFrom(i,NumNodes+1)=-1;
      NegFrom(i,NumNodes+1)=i-1;
   end
end
TransDat=LoadDataFile('TransferActivity'); 
[x y]=size(TransDat);
Trans=TransDat(2:x,:);	% biases in first row, then slopes starting with slope
								%  used to calculate outputs for that iteration i.e. 
						% first slope used to calculate 2nd set (iter 1) of outputs
Outs=IterateNet(Ins,NodesIn,PosFrom,NegFrom,NumNodes,Trans,Iter,Danger);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Outs]= IterateNet(Inputs,NodeList,PosFroms,NegFroms,NumNodes, ...
						TransStuff,Iter,Danger)

AllNodes=0:1:NumNodes-1;
for i=1:NumNodes
   PosMat(i,:)=ismember(AllNodes,PosFroms(i,:));
   NegMat(i,:)=ismember(AllNodes,NegFroms(i,:));
end
LiveNodes=ismember(AllNodes,NodeList);
Inputs=Inputs.*LiveNodes';
Out=Activs(PosMat,NegMat,Inputs);
if(Danger(Iter))
   Out(3)=Out(3)+1;
end
Out=TransferFunc(TransStuff,Out,Iter);
Outs=Out.*LiveNodes';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Outs]=TransferFunc(TransferArgs,Ins,Iteration)

Bias=TransferArgs(1,:);
Slope=TransferArgs(Iteration+1,:);
Outs=tanh(Ins.*Slope'+Bias');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Outputs] = Activs(PosFroms,NegFroms,Inputs)
PosOuts = PosFroms*Inputs;
NegOuts = NegFroms*Inputs;
Outputs=PosOuts-NegOuts;

