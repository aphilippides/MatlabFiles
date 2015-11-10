function[newm,newc] = AdjustColours(m,c,mult,addto)

if(nargin<4) addto =1; end;

newm=log(mult*m+addto);
newc=log(mult*c+addto);