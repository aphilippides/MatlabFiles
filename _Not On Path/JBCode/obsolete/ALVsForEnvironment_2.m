function[NObj,mx,my]=ALVsForEnvironment_2(X,Y,O,startpt,Plotting)
if(nargin<5) Plotting=0; end;

[obc,obw]=EdgeVision(O,[startpt(1) startpt(2)]); %Grey
[no,snap]=GetALVs(obc,obw); %_2
snapx=snap(1);
snapy=snap(2);
for i=1:size(X,1)
    for j=1:length(X)
        [obc,obw]=EdgeVision(O,[X(i,j) Y(i,j)]); %Grey
        [NObj(i,j),alv]=GetALVs(obc,obw);%_2
        mx(i,j)=alv(1);
        my(i,j)=alv(2);
    end
end
if(Plotting==1)
    % ###### WARNING ###### plotting seems to change the output for
    % mx and my are no longer the ALV vectors but the homing vectors
    
    mx=mx-snapx;
    my=my-snapy;
    
    % Average the vectors with the 8 neighbours so as to smooth the little
    % fluctuations
    % AND Normalize the vectors so that we can see them better. Unnecessary for
    % the computation of the catchment area. Warning : if Norm=1 and if mx
    % and my are zero, they will become NaN
    NumAverage = 0 ;
    Norm = 1;
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
    

        
    
    
    Angle = ( (mx.*(startpt(1)-X) + my.*(startpt(2)-Y) )./(sqrt((mx.^2 + my.^2).*( (X-startpt(1)).^2 +(Y-startpt(2)).^2)) ));
    
    figure(4)
    hold on ;
    quiver(X,Y,mx,my)
%    contour(X,Y,Angle), colorbar ;
    hold off ;
    
    figure(5)
    hold off ;
    DrawEnvironment(O, startpt) ;
%    axis tight
    axis([X(1)  X(end)  Y(1)  Y(end)]) ;
    hold on ;
    pcolor(X,Y,Angle) ;
%    colorbar ;
    shading interp;
%    hold on ;
%    [c h]=contour(X,Y,NObj./max(max(NObj)));
%    colorbar
%    axis tight
    hold off 
end

% if(Plotting==2)
%     % ###### WARNING ###### same as above
%     mx=mx-snapx;
%     my=my-snapy;
%     figure(4)
%     hold on;
%     quiver(X,Y,mx,my)
%     Angle = ( (mx.*(startpt(1)-X) + my.*(startpt(2)-Y) )./(sqrt((mx.^2 + my.^2).*( (X-startpt(1)).^2 +(Y-startpt(2)).^2)) ));
%     contour(X,Y,Angle), colorbar ;
%     hold off;
%     
%     figure(5)
%     hold off ;
%     DrawEnvironment(O, startpt) ;
% %    axis tight
%     hold on ;
%     pcolor(X,Y,Angle), colorbar, shading interp;
%     hold off
%       
%     figure(5)
%     hold on ;
% %    pcolor(NObj),shading interp
% %    hold on
% %    [c h]=contour(X,Y,NObj,[-1:max(max(NObj))]);%clabel(c,h)
%     [c h]=contour(X,Y,NObj./max(max(NObj)));
%     colorbar
% %    axis tight
%     hold off 
% end