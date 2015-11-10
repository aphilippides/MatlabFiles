% function PruneNetwork().

function GasNetSpread(Chems,OutNodes)

OutNodes
NumParams =6; 	%where first 'Numchem' is
NetworkFile='NetworkMatlab';		% data files
SymbolSize=18;
NumSize=13;
Offset=0.05;
eval(['load ' NetworkFile '.dat -ascii; ']);					% read in data
eval(['A=(' NetworkFile '(1,:));']);
NumNodes=A(1);				% set network data
for i=1:NumNodes			% set node data
   Node(i,:)= eval(['(' NetworkFile '(i+1,:))']);
end
GConcs=LoadDataFile('GasConc');
[X,Y]=size(GConcs);
Emitted=sum(GConcs(2:X,2*NumNodes+1:Y))
OutNodes=union(PruneNetwork(1,1,1),OutNodes);

NodeList=setdiff(0:1:NumNodes-1,OutNodes)+1;
NumNodes=length(NodeList);
figure;					% set up plot
hold on;					% keep plots
grid off;				% no grid
set(gca,'Box','off');	% no box
set(gca,'FontSize',12);	% default fontsize
GridSize=ceil(sqrt(NumNodes))		%Set Grid size
axis([-1 (GridSize) -1 GridSize]);	% calc axis
for i=1:NumNodes
   %x = Node(i,2);
   %y = Node(i,3);
   x=mod(NodeList(i),GridSize);
   y=floor(NodeList(i)./GridSize);
   recc = Node(NodeList(i),4);
   type_emiss = Node(NodeList(i),5);
   if (recc==1)		% positivie reccurrency
      plot(x,y,'bs','MarkerSize',SymbolSize);
      plot(x,y,'bs','MarkerSize',SymbolSize-2);
      text(x-Offset,y,int2str(NodeList(i)-1),'FontSize',NumSize);
   elseif(recc==2)
      plot(x,y,'ro','MarkerSize',SymbolSize);
      plot(x,y,'ro','MarkerSize',SymbolSize-2);
      text(x-Offset,y,int2str(NodeList(i)-1),'FontSize',NumSize);
   else
      plot(x,y,'gd','MarkerSize',SymbolSize);
      text(x-Offset,y,int2str(NodeList(i)-1),'FontSize',NumSize);
   end
   
   NumChem = Node(NodeList(i),NumParams);
   NumPos = Node(NodeList(i),NumParams+A(1)+1);
   NumNeg = Node(NodeList(i),NumParams+A(1)*2+2);
   if(Chems == 1)
      ChemFrom=Node(NodeList(i),NumParams+1:NumParams+NumChem);
      TakeOut=[];
      for j=1:NumChem
         if (Emitted(ChemFrom(j)+1)==0)
            TakeOut=[TakeOut,ChemFrom(j)];
         end
      end
      ChemFrom=setdiff(ChemFrom,TakeOut);
      for j=1:length(ChemFrom)
         from = 1+ChemFrom(j);
         if(sum(ismember(OutNodes,(from-1)))==0)
            xfrom=mod(from,GridSize);
            yfrom=floor(from./GridSize);
            ChemLink(xfrom,yfrom,x,y,1.5);
         end
      end
   end
   PosConnsFrom=Node(NodeList(i),NumParams+A(1)+2:NumParams+A(1)+NumPos+1);
   NegConnsFrom=Node(NodeList(i),NumParams+2*A(1)+3:NumParams+2*A(1)+NumNeg+2);
   Comm=intersect(PosConnsFrom,NegConnsFrom)
   PosFrom=setdiff(PosConnsFrom,Comm);
   NegFrom=setdiff(NegConnsFrom,Comm);
   for j=1:(NumPos-length(Comm))
      from=1+PosFrom(j);
      %from = 1+Node(NodeList(i),NumParams+j+(NumNodes+1));
      if(sum(ismember(OutNodes,(from-1)))==0)
         xfrom=mod(from,GridSize);
         yfrom=floor(from./GridSize);
         PosLink(xfrom,yfrom,x,y,1.5);
      end
   end
   NegFrom=setdiff(NegFrom,OutNodes)
   for j=1:length(NegFrom)      
      from=1+NegFrom(j);
      %from = 1+Node(NodeList(i),NumParams+j+2*(NumNodes+1));
      %if(sum(ismember(OutNodes,(from-1)))==0)
         xfrom=mod(from,GridSize);
         yfrom=floor(from./GridSize);
         NegLink(xfrom,yfrom,x,y,1.5);
      %end
   end
end  
hold off