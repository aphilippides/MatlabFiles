% function PruneNetwork().

function GasNetwork(Chems)

NumParams =6; 	%where first 'Numchem' is
NetworkFile='NetworkMatlab';		% data files
GridSize=20.0;
SymbolSize=18;
NumSize=13;
Offset=0.2;
eval(['load ' NetworkFile '.dat -ascii; ']);					% read in data
eval(['A=(' NetworkFile '(1,:));']);
NumNodes=A(1);				% set network data

for i=1:NumNodes			% set node data
   Node(i,:)= eval(['(' NetworkFile '(i+1,:))']);
end
figure;					% set up plot
hold on;					% keep plots
grid off;				% no grid
set(gca,'Box','off');	% no box
set(gca,'FontSize',12);	% default fontsize
axis([0 (GridSize) 0 GridSize]);	% calc axis
axis equal;																% set xy scale same
%axis off;										% no axis at all
for i=1:NumNodes
   x = Node(i,2);
   y = Node(i,3);
   recc = Node(i,4);
   type_emiss = Node(i,5);
   if (recc==1)		% positivie reccurrency
      plot(x,y,'bs','MarkerSize',SymbolSize);
      plot(x,y,'bs','MarkerSize',SymbolSize-2);
      text(x-Offset,y,int2str(i-1),'FontSize',NumSize);
   elseif(recc==2)
      plot(x,y,'ro','MarkerSize',SymbolSize);
      plot(x,y,'ro','MarkerSize',SymbolSize-2);
      text(x-Offset,y,int2str(i-1),'FontSize',NumSize);
   else
      plot(x,y,'gd','MarkerSize',SymbolSize);
      text(x-Offset,y,int2str(i-1),'FontSize',NumSize);
   end
   
   NumChem = Node(i,NumParams);
   NumPos = Node(i,NumParams+NumNodes+1);
   NumNeg = Node(i,NumParams+NumNodes*2+2);
   if(Chems == 1)
      for j=1:NumChem
         from = 1+Node(i,NumParams+j);
         if (Node(from,5)>=0)
            ChemLink(Node(from,2),Node(from,3),x,y,1.5);
         end
      end
   end
   %PosConnsFrom=Node(i,NumParams+NumNodes+2:NumParams+NumNodes+NumPos+1);
   %NegConnsFrom=Node(i,NumParams+2*NumNodes+3:NumParams+2*NumNodes+NumNeg+2);
   %Comm=intersect(PosConnsFrom,NegConnsFrom);
   %PosFrom=setdiff(PosConnsFrom,Comm);
   %NegFrom=setdiff(NegConnsFrom,Comm);
   for j=1:NumPos%(NumPos-length(Comm))
      %from=1+PosFrom(j);
      from = 1+Node(i,NumParams+j+(NumNodes+1));
      PosLink(Node(from,2),Node(from,3),x,y,1.5);
   end
   for j=1:NumNeg%(NumNeg-length(Comm))
		%from=1+NegFrom(j);
      from = 1+Node(i,NumParams+j+2*(NumNodes+1));
      NegLink(Node(from,2),Node(from,3),x,y,1.5);
   end
end  

hold off