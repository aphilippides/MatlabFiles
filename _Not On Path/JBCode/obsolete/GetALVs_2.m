function[n_ob,alv]=GetALVs_2(obc,obw);
if(obw==-1)
    n_ob=-1;
    alv=[NaN NaN];

else n_ob=length(obc);
    if(n_ob>0)
        angs=obc*pi/45;
        alv=[sum(cos(angs).*obw) sum(sin(angs).*obw)];
    else
        alv=[NaN NaN];
    end
end

% function[n_ob,alv]=GetALVs_2(obc,obw);
% if(obw==-1)
%     n_ob=-1;
%     alv=[NaN NaN];
% 
% else n_ob=length(obc);
%     if(n_ob>0)
%         angs=[];
%         for i=1:n_ob
%             for j=1:obw(i)
%                 angs=[angs obc(i)*pi/45];
%             end
%         end        
%         alv=[mean(cos(angs)) mean(sin(angs))];
%     else
%         alv=[NaN NaN];
%     end
% end
