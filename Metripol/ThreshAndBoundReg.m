function[b]=ThreshAndBoundReg(x,Show,t,col)
if(nargin<2) Show = 0; end;
if(nargin<3) t=graythresh(x);end;
if(nargin<4) col='b';end;

bw=im2bw(x,t);
for i=1:size(Points,1)
if(Show) 
    imshow(bw,'notruesize'); 
    hold on; 
    b=ShowBoundaries(bw,col); 
    hold off;
else
    b=ShowBoundaries(bw,col);
end;