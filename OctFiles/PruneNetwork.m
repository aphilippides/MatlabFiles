% function PruneNetwork().

function[Pruned]= PruneNetwork(Chems,Pos,Neg)

%Chems=Pos=Neg=1;
NumParams =6; 	%where first 'Numchem' is
NetworkFile='NetworkMatlab';		% data files
eval(['load ' NetworkFile '.dat -ascii; ']);					% read in data
eval(['A=(' NetworkFile '(1,:));']);
NumNodes=A(1);				% set network data
GConcs=LoadDataFile('GasConc');
[X,Y]=size(GConcs);
Emitted=sum(GConcs(2:X,2*NumNodes+1:Y))

for i=1:NumNodes			% set node data
   Node(i,:)= eval(['(' NetworkFile '(i+1,:))']);
end
for i=1:NumNodes
   NumChem = Node(i,NumParams);
   NumPos = Node(i,NumParams+NumNodes+1);
   NumNeg = Node(i,NumParams+NumNodes*2+2);
   if (Chems)
      ChemFrom=Node(i,NumParams+1:NumParams+NumChem);
      TakeOut=[];
      for j=1:NumChem
         %if (Node(ChemFrom(j)+1,5)==-1) 	% if the node is not an emittor
          %  TakeOut=[TakeOut,ChemFrom(j)];else
         if (Emitted(ChemFrom(j)+1)==0)
            TakeOut=[TakeOut,ChemFrom(j)];
         end
      end
      ChemFrom=setdiff(ChemFrom,TakeOut);
   else 
      ChemFrom = [];
   end
   
   PosConnsFrom=Node(i,NumParams+NumNodes+2:NumParams+NumNodes+NumPos+1);
   NegConnsFrom=Node(i,NumParams+2*NumNodes+3:NumParams+2*NumNodes+NumNeg+2);
   Comm=intersect(PosConnsFrom,NegConnsFrom);
   if Pos
      PosFrom=setdiff(PosConnsFrom,Comm);
   else
      PosFrom=[];
   end
   if Neg
      NegFrom=setdiff(NegConnsFrom,Comm);
   else
      NegFrom = [];
   end
   eval(['ConnsFrom' int2str(i-1) '=union(PosFrom,union(NegFrom,ChemFrom));']);
   Posit(i,:)=[length(PosFrom) PosFrom, ones(1,NumNodes-length(PosFrom))*-1];
   Negit(i,:)=[length(NegFrom) NegFrom, ones(1,NumNodes-length(NegFrom))*-1];
   Chemic(i,:)=[length(ChemFrom) ChemFrom, ones(1,NumNodes-length(ChemFrom))*-1];
end
reached=[0, ConnsFrom0];
TmpReached=reached;
X=length(reached);
while(X>0)
   NewReached=[];
   for i=1:X
      eval(['Conns=ConnsFrom' int2str(TmpReached(i)) ';']);
      NewReached=union(NewReached,Conns);
   end
   NewReached=setdiff(NewReached,intersect(NewReached,reached));
   X=length(NewReached);
   TmpReached=NewReached;
   reached=union(reached, NewReached);
end
for i=1:length(reached)
   NewPos(i,:)=Posit(reached(i)+1,:);
   NewNeg(i,:)=Negit(reached(i)+1,:);
   NewChem(i,:)=Chemic(reached(i)+1,:);
end
%Pruned = [reached ones(1,NumNodes-length(reached)+1)*-1;NewPos;NewNeg;NewChem];
Pruned=setdiff(0:1:NumNodes-1,reached)
