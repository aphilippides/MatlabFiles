function backProp

WOld=randomweights
Err=1
while  (Err>0.01)

    % generate a random ordering of vectors
    randorder=randperm(25)
    % test i and do different things depending on its value
    for i=1:25
        randinput=X(:,randorder(i));
        % calculate D for that vector based on old weights and target
        
        % update weights based on oputput and vector
         Wnew=WOld+learningrate*D;
         
        % calc error and plot    
        Err=Sumsquerror(target, inputs, Wnew)
        
        % update old weights 
        WOld=Wnew;
    end  
end

function[Err]=Sumsquerror(target, inputs, Wnew)