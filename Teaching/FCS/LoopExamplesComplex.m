% function to try out various loops 
% Some of these loops can be adapted to your needs in later problem sheets
% I will also introduce some new functions along the way. 
% Do help function_name at any point for more details

function LoopExamplesComplex
% LoopEg1
LoopEg2
% NonLoopEg

function LoopEg1
%generate random test matrix
testmatrix=rand(10,15) 
% define a as the empty matrix
a=[];
% Extract columns 3 to 6 and put them in a
for i=3:6
    i
    a=[a testmatrix(:,i)]
end

function LoopEg2
testmatrix=rand(10,15); 

% Make a target vector of all 1's
TargetVec=ones(10,1);

% make sure targets are in testmatrix
testmatrix(:,6)=TargetVec;
a=[];

% now go through the columns of testmatrix in a random order
for i=randperm(size(testmatrix,2))
    i
    if(isequal(TargetVec,testmatrix(:,i)))
        break;
    else
        a=[a testmatrix(:,i)];
    end
end
a

function NonLoopEg
testmatrix=rand(5,7)
% find the indices of elements in the 1st row which are < 0.5 
is=find(testmatrix(1,:)<0.5)
% Put the columns in is into the matrix a
a=testmatrix(:,is)