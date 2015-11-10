function BeePathHiSpeed(n,is)
dwork;
% cd GantryProj\HiSpeed\170106
cd E:/
load(['HiSpeedData' int2str(n)]);

if(nargin < 2) is=1; end
if(nargin < 3) PrettyPic=0; end

[EndPt(:,1) EndPt(:,2)]=pol2cart(CleanOrients(Orients),30);
EndPt=EndPt+Cents;
length(Orients)
if(length(is)<=1) is=1:is:length(Orients); end;

plot(EndPt(is,1),EndPt(is,2),'r.')
hold on;
plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','r')
text(Cents(is(1),1),Cents(is(1),2),'S')
text(Cents(is(end),1),Cents(is(end),2),'F')
hold off;


function LM
if(PrettyPic)
    f=aviread(fn,1);
    imagesc(f.cdata);
    hold on;
    MyEllipse(6,5,[384.5,264.5],80,'r');
    MyCircle(210,278,37.5,'r');
else
    MyEllipse(6,5,[384.5,264.5],80,'r');
    hold on;
    MyCircle(210,278,37.5,'r');
    axis equal
end