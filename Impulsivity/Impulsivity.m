function Impulsivity
% you need this in to reset the random number geneator in matlab
rng('shuffle');

% this is the size of the array ie 5x5 boxes
s=5;

% set up the colour matrix, 1st element is grey, 2nd is blue 3rd is red
cmap=[0.5 0.5 0.5; 0 0 0.5; 0.5 0 0];

% sets up %ages of red/blue boxes
pcs=25:5:45;
% this loop just runs the test 5 times with different percentages of
% red/blue squares
for i=1:5
    [out(i),numclicks(i)]=RunTest(s,cmap,pcs(i));
    % pause for between 0.5 and 1.5 s
    pause(rand+0.5)
end

plot(pcs,numclicks,'b',pcs(out==0),numclicks(out==0),'rs')
    

function[out,numclicks]=RunTest(s,cmap,pc)
% make a random matrix with 30% 2's in it. These are the 3rd colour s
% so 70% are the 2nd colour 
% m is a matrix with 1 for each blue square and 2 for each red square
m=GenerateRandomArray(pc,s);

% this sets up the random order with which to reveal the pattern
toPress=randperm(s^2);
toPress_col=ceil(toPress/5);
toPress_row=mod(toPress,5)+1;

out=0;

% set up the initial 'mask' matrix
Pressed=zeros(size(m));
% this runs the loop 16/25 times
for i=1:16%25 
% while 1
    title('click on any square or type r or b if more red/blue')
%     title('decide now')
    
    % draw grid with grey where Pressed==0
    newm=Pressed.*m;
    imagesc(1:s,1:s,newm);
    shading faceted;
    axis off
    axis equal
    % this bit forces you to use the 3 colours defined in cmap
    caxis([0 2])
    colormap(cmap);
    
%     % Cogent??
%     % is the nxet to be revealed red or blue
%     if(m(toPress_col(i),toPress_row(i))==1)
%         col='b';
%     else
%         col='r';
%     end
%     % draw a square of that colour
    
%    pause 0.5 s before revealing next square
    pause(0.5)
    
%     % or click any square. If input is r or b then stop
%     while 1
%         % asks for clicked input
%         [x,y,b]=ginput(1);
% 
%         % if an r is pressed
%         if(isequal(b,114))
%             title('you picked red. You are WRONG!!!')
%             out=0;
%             % break out of the while loop
%             break;
%         elseif(isequal(b,98))
%             % if a b is pressed
%             title('you picked blue. You are RIGHT!!!')
%             % break out of the while loop
%             out=1;
%             break;
%         elseif(~isempty(x))
%             % if anything other than return is pressed figure out the
%             % nearest square and reveal that one next
%             p=min(max(round(y),1),s);
%             q=min(max(round(x),1),s);
%             % set that masked square to a 1 so it will be revealed
%             Pressed(p,q)=1;
%         end
%     end
    
% this bit is if you want to print out bmps of the stimuli: saveas is
% probably easier
%     print('-dbmp',['Test' int2str(pc) 'Im' int2str(i) '.bmp'])
    Pressed(toPress_col(i),toPress_row(i))=1;
end
% force a choice at the end
title('decide now')
[x,y,b]=ginput(1);

% show the final matrix
imagesc(1:s,1:s,m);
shading faceted;
axis off
caxis([0 2])
numclicks=sum(Pressed(:));

function[m]=GenerateRandomArray(pc,s)

v=zeros(1,s^2);
t=length(v);

% this sets the number of red boxes: could do an absolute number instead
nc1=round(pc*t*.01);
rv=randperm(t);
v(rv(1:nc1))=1;
% this reshapes so it's a matrix
m=reshape(v,s,s)+1;
