function[ms,MLines] = CheckBoxMids(MLines,l1,l2,l3,ind,buy,sell,...
    lbuy,lsell,boxbuy,boxsell,fout,ts)
ms=[];
for i=1:size(MLines,1)
    val=MLines(i,2);
    sig=MLines(i,4);
    boxsig=MLines(i,5);
    % Test for linebuy 
    if(sig~=1) 
        if(l2>val)
            wavplay(lbuy,44100);
            ms=[ms;ind 1 buy];
            WriteLogData(buy,ts,36,fout);
            MLines(i,4)=1;
        end
    end
    % Test for boxbuy 
    if(sig~=1) 
        if(l2>val)
            wavplay(lbuy,44100);
            ms=[ms;ind 1 buy];
            WriteLogData(buy,ts,36,fout);
            MLines(i,4)=1;
        end
    end
    % Test for linesell 
    if(sig~=0) 
        if(l1<val)
            wavplay(lsell,44100);
            ms=[ms;ind 0 sell];
            WriteLogData(sell,ts,35,fout);
            MLines(i,4)=0;
        end
    end
end