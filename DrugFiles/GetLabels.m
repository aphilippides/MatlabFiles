function[Labels]=GetLabels(F,Classes,ClassLabels)

Labels=ones(1,length(F))*-100;
Is=find(F<Classes(1));
Labels(Is)=ClassLabels(1);
for i=2:length(Classes)
	Is=find((F>=Classes(i-1))&(F<Classes(i)));
   Labels(Is)=ClassLabels(i);
end
Is=find(F>=Classes(end));
Labels(Is)=ClassLabels(end);
