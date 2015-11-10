function[buysell] = CloseOut(t,sell,buy,timez,buysell,fout,bs)
if(nargin<7) 
    addsell=0;
    addbuy=0;
elseif(bs==2)
    addsell=6;
    addbuy=4;
else
    addsell=8;
    addbuy=6;
end
if(isempty(buysell))
elseif(buysell(end,2)==1)
    WriteLogData(sell,timez,1+addsell,fout);
    buysell=[buysell;t -2 sell];
elseif(buysell(end,2)==0)
    WriteLogData(buy,timez,4+addbuy,fout);
    buysell=[buysell;t -1 buy];
end