function[Loop]=PerceptronCheck(l,outs,Act,Order)

%Ins=[0 0;0 1; 1 0; 1 1];
x=[1 0 0;1 0 1;1 1 0;1 1 1];
x=x(Order,:);
outs=outs(Order);
Loop=0;
w=[0 0 0];
MisC=1;
while((Loop<300)&(MisC==1))
    MisC=0;
    for i=1:size(x,1)
        g=w*x(i,:)';
        y=feval(Act,g);
        if(abs(y-outs(i))>0.0000)
%        if(abs(y-outs(i))>0.01)
            MisC=1;        
            w=w+l*(outs(i)-y)*x(i,:);
           %[(outs(i)-y)*x(i,:); w; x(i,:)]
            %DrawStuff(x,outs,w);a=input('Press return','s');
        end
       % w
   % a=input('Press return');
    end
    Loop=Loop+1;
end
%figure
DrawStuff(x,outs,w);

function[a]=MyStep(x)
a=x>=0;
 
function[a]=MySigmoid(x)
b=1;
a=1./(1+exp(-b.*x));
if(x<=-4.5) a=0;
elseif(x>=4.5) a=1;
else a=1./(1+exp(-b.*x));
end

function[a]=MyPLin(x)
b=0.5;
m=0.1;
if(x<=-5) a=0;
elseif(x>=5) a=1;
else a=m*x+b;
end
    
function[a]=MyGauss(x)
s=1.5;
m=0;
if(x<=-4.5) a=0;
elseif(x>=4.5) a=0;
else a=exp(-((x-m).^2)./(2*s^2));%./sqrt(2*pi*s);
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
