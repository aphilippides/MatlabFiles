function[Loop]=PerceptronCheck(l,outs,Act,Order,NOISE)

%Ins=[0 0;0 1; 1 0; 1 1];
x=[1 0 0;1 0 1;1 1 0;1 1 1];
x=x(Order,:);
outs=outs(Order);
Loop=0;
w=[0 0 0];
MisC=1;
a='a';
NOISE=0
for i=1:4
   %x(i,:)= x(i,:)+sqrt(abs(x(i,:))).*[0 randn(size( x(i,2:end)))]
end

while((Loop<100)&(MisC==1))
    MisC=0;
    for i=1:size(x,1)
         if(NOISE)
            g=w*(x(i,:)+sqrt(abs(x(i,:))).*[0 randn(size( x(i,2:end)))])';
         else
            g=w*x(i,:)';
         end
        y=feval(Act,g);
        [g y outs(i) ];
         if((MyStep(g))~=outs(i))
            w=w+l*(outs(i)-y)*x(i,:);
            [(outs(i)-y)*x(i,:); w; x(i,:)];
            outs(i);
            MisC=1;
        end
        a='C';
        if(a~='C')
 %          DrawStuff(x,outs,w);a=input('Press return','s');

        end
    end
    
    Loop=Loop+1;
end
%figure


function[a]=MyThresh(x)
a=x>=0;
i=find(x==0);
a(i)=0.5;

function[a]=MyStep(x)
a=x>0;
 
function[a]=MySigmoid(x)
b=1;
a=1./(1+exp(-b.*x));
if(x<=-4.5) a=0;
elseif(x>=4.5) a=1;
else a=1./(1+exp(-b.*x));
end

function[a]=MyPLin(x)
b=0.5;
m=0.5;
if(x<=-1) a=0;
elseif(x>=1) a=1;
else a=m*x+b;
end
    
function[a]=MyGauss(x)
s=10;
m=0;
if(x<=-4.5) a=0;
elseif(x>=4.5) a=0;
else a=exp(-((x-m).^2)./(2*s^2))./sqrt(2*pi*s*s);
end

function[a]=MyID(x)

a=x;

function DrawStuff(x,outs,w);

i=find(outs==1);
plot(x(i,2),x(i,3),'g o');
hold on
j=find(outs==0);
plot(x(j,2),x(j,3),'r x');
if(w(3)==0)
    if(w(2)==0) return; end;
    plot(-[w(1) w(1)]/w(2),[0 1],'b-')
else 
    plot([0 1],-[w(1) w(2)+w(1)]/w(3),'b-')
end
hold off
