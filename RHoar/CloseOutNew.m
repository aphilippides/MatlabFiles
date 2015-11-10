function[buysell,b] = CloseOutNew(t,sell,buy,timez,buysell,fout,vals)
if(isempty(buysell)|(buysell(end,2)<0)) b=[];
elseif(buysell(end,2)==1)
    WriteLogData(sell,timez,vals(1),fout);
    buysell=[buysell;t -2 sell];
    b=size(buysell,1);
elseif(buysell(end,2)==0)
    WriteLogData(buy,timez,vals(2),fout);
    buysell=[buysell;t -1 buy];
    b=size(buysell,1);
end