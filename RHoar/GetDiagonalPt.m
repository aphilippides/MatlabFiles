function[newx,newt]=GetDiagonalPt(g,len,x,t)
% [et,ex]=pol2cart(atan(g),len);
et=len;
ex=g*len;
newx=x+ex;
newt=t+et;