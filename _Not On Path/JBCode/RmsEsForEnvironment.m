%%%%%% Function computing the square error between the view from the nest
% and the current view
function[rms,mx,my]=RmsEsForEnvironment(X,Y,O,startpt)

% Compute the view from the nest
[obc,obw,Ons]=LincVision(O,[startpt(1) startpt(2)]);

% Initialization of the rms error array
rms = NaN((size(X,1)+2),(length(X)+2)) ;

% Compute the view from each point and the rms error with the nest
for i=1:size(X,1) 
    for j=1:length(X)
        [obc,obw,ObjOns]=LincVision(O,[X(i,j) Y(i,j)]);
        if (obw ~= -1)
            rms(i+1,j+1) = sum((Ons-ObjOns).^2) ;
        end
    end
end

% Average the error with the 8 neighbours so as to smooth the little
% fluctuations
for i=2:size(X,1)+1
    for j=2:length(X)+1
%         MeanRmsE(i-1,j-1)=rms(i,j);    %%% No averaging %%%
        MeanRmsE(i-1,j-1)=mean(mean(rms(i-1:i+1,j-1:j+1)));
    end
end

rms(2:size(X,1)+1,2:length(X)+1)=MeanRmsE;

% %%% test the behaviour of the model, wanted to see why there is so few
% % straight arrows and so much diagonal arrows
% ones=0;
% straight=0;
% diag=0;
% two=0;
% three=0;
% others=0;
% %%%

% Compute the best direction. When there are several possibilities, the mean vector is computed. 
for i=1:size(X,1)
    for j=1:length(X)
        if (isnan(rms(i+1,j+1)))
            mx(i,j) = NaN ;
            my(i,j) = NaN ;
        else
            Aim=[];
            ErrMin=Inf;
            for k=-1:1
                for l=-1:1
                    % remove the possibility to stay at the same place 
                    if (k~=0 | l~=0)
                        % normalize the vectors so that a mean value is not
                        % biased
                        if ((k*l)~= 0)
                            kn = k/sqrt(2);
                            ln = l/sqrt(2);
                        else
                            kn = k;
                            ln = l;
                        end
                        if rms(i+1+k,j+1+l)<ErrMin
                            ErrMin=rms(i+1+k,j+1+l);            
                            Aim=[kn ln];
                        elseif rms(i+1+k,j+1+l)==ErrMin
                            Aim=[Aim ; [kn ln]];
                        end
                    end
                end
            end

%             %%% tests
%             if (size(Aim,1)==1)
%                 ones=ones+1; 
%                 if (Aim(1)*Aim(2)==0)
%                     straight=straight+1;
%                 else
%                     diag=diag+1;   
%                 end
%             end
%             if (size(Aim,1)==2) two=two+1; end
%             if (size(Aim,1)==3) three=three+1; end
%             if (size(Aim,1)>3) others=others+1; end
%             %%%
            
            if (size(Aim,1)==0)
                my(i,j) =  0 ;
                mx(i,j) =  0 ;
            else
                my(i,j) =  mean(Aim(:,1)) ;
                mx(i,j) =  mean(Aim(:,2)) ;
            end
        end
    end
end

rms([1 end],:)=[];
rms(:, [1 end])=[];

% %%% display results of the test
% ones
% straight
% diag
% two
% three
% others
% %%%