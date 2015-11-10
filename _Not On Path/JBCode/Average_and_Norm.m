%%%%%Average the vectors with the 8 neighbours so as to smooth the little
% fluctuations
% AND Normalize the vectors so that we can see them better. Unnecessary for
% the computation of the catchment area. 
% ###### WARNING ###### if Norm=1 and if mx and my are zero, they will become NaN
% ###### WARNING ###### The meshgrid is here expected to be square
function[mx,my]=Average_and_Norm(NumAverage,Norm,X,mx,my)

if(NumAverage==1)
    for i=2:size(X,1)-1
        for j=2:length(X)-1
            newmx(i-1,j-1)=mean(mean(mx(i-1:i+1,j-1:j+1)));
            newmy(i-1,j-1)=mean(mean(my(i-1:i+1,j-1:j+1)));
        end
    end
    if (Norm)
        mx(2:size(X,1)-1,2:length(X)-1)=newmx./sqrt(newmx.^2+newmy.^2);
        my(2:size(X,1)-1,2:length(X)-1)=newmy./sqrt(newmx.^2+newmy.^2);
    else
        mx(2:size(X,1)-1,2:length(X)-1)=newmx ;
        my(2:size(X,1)-1,2:length(X)-1)=newmy ;
    end
elseif(NumAverage==2)
    for i=2:size(X,1)-1
        for j=2:length(X)-1
            newnewmx(i-1,j-1)=mean(mean(mx(i-1:i+1,j-1:j+1)));
            newnewmy(i-1,j-1)=mean(mean(my(i-1:i+1,j-1:j+1)));
        end
    end
    for i=2:size(X,1)-3
        for j=2:length(X)-3
            newmx(i-1,j-1)=mean(mean(newnewmx(i-1:i+1,j-1:j+1)));
            newmy(i-1,j-1)=mean(mean(newnewmy(i-1:i+1,j-1:j+1)));
        end
    end
    if (Norm)
        mx(3:size(X,1)-2,3:length(X)-2)=newmx./sqrt(newmx.^2+newmy.^2);
        my(3:size(X,1)-2,3:length(X)-2)=newmy./sqrt(newmx.^2+newmy.^2);
    else
        mx(3:size(X,1)-2,3:length(X)-2)=newmx ;
        my(3:size(X,1)-2,3:length(X)-2)=newmy ;
    end
else
    if (Norm)
        newmx=mx;
        newmy=my;
        mx=newmx./sqrt(newmx.^2+newmy.^2);
        my=newmy./sqrt(newmx.^2+newmy.^2);
    end
end