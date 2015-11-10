function[as,ts,ks] = CheckKBCheck
disp('press any key to start')
pause;
while KbCheck end; 

tstart=getsecs;
tend=tstart+10;
ind=1;
ts=[];as=[];ks=[];
while(getsecs<tend)
    [a,b,c]=KbCheck;
    if(a)
        as=[as a];
        ts=[ts b-tstart];
        ks=[ks c];
        KBName(c)
        return
    end
    t(ind)=getsecs;
    ind=ind+1;
end
t=t-tstart;

%     if(KbCheck);
%         if(NotStillPressed);            	
%             NotStillPressed=0;
%             out(count)=getsecs;
%             count=count+1;
%         end;
%     else;
%         NotStillPressed=1;
%     end;
