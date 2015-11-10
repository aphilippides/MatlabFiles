function[Labels]=GetLabelsEq(F,Equal,ClassLabels)

Labels=ones(1,length(F))*-100;
Is=find(F==Equal);
Labels(Is)=ClassLabels(1);
Is=find(F~=Equal);
Labels(Is)=ClassLabels(end);
