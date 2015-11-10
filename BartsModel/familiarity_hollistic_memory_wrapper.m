function [best_Dec, Weights] =  familiarity_hollistic_memory_wrapper (Im_test, Im_tr,nb_neurons,training_step,nb_training_trials)
%Dec correspond to the unfamiliarity
%Weights = weights of the neural ntwks after training


% load ('Pics');
% [Dec_5m2] = familiarity_hollistic_memory_wrapper (Im_test, Im_tr_5m,300,2,1);
% [Dec_5m] = familiarity_hollistic_memory_wrapper (Im_test, Im_tr_5m, 800,2,10);
% [Dec_15m] = familiarity_hollistic_memory_wrapper (Im_test, Im_tr_15m, 800,2,10);

% [Dec_10m] = familiarity_hollistic_memory_wrapper (Im_test_smaller_area, Im_tr_10m, 300,2);


%save ('hollistic_memory_fam');

visual_field = 176/4; %/4 to get the number of horizontal pixels was 272
one_side_blind_area = (90-visual_field)/2;
%------------PREPARE PICS FOR TRAINING------------------------
nb_pics = length(Im_tr(1,1,:));
nb_pixels = 17*visual_field; %360 visual field = 90 horiz pixels
D=zeros(nb_pics,nb_pixels);
c=0;
for i=nb_pics:-training_step: 1; %start at the feeder!
        
        v360 = Im_tr (:,:,i);
        v = v360 (:,one_side_blind_area+1: one_side_blind_area+visual_field);
        
  %EDGE DETECTOR--------
%         edge_v = double(edge(v));
%         v = (edge_v-1)*-1;
        
        
    if sum(v(:))~=0
        c=c+1;
        D(c,:)=double(v(:)');
    end
end
% remove any empty entries in D
D=D(1:c,:);

%     if nb_training_trials >1;
%     Dall =D;
%     for trial = 2: nb_training_trials;
%         Dall = [Dall;D];
%     end
%     D = Dall;
%     end

nb_pics_trained = length (D(:,1))
save('pics_for_infomax','D')%,'x','y','th')

%---------TRAIN INFOMAX WITH THE PICS ------------------

%load ('pics_for_infomax');
[Weights]= TrainInfomax(nb_neurons,'pics_for_infomax');

 if nb_training_trials >1;
     for cur_trial = 2: nb_training_trials;
         cur_trial
[Weights]= TrainInfomax(nb_neurons,'pics_for_infomax', Weights);
     end
 else [Weights]= TrainInfomax(nb_neurons,'pics_for_infomax');
 end
%---------TEST INFOMAX FOR EACH TEST PICS

nb_test_pics = length (Im_test (1,1,:));
       
for cur = 1:nb_test_pics;
    im= Im_test (:,:,cur);
    Dec =[];
    
    for i=1:length (im) %Pixel comparison will be done for each possible orientation of the tested image
        RotIm=im(:,[(i+1):end,1:i]);
        CutIm = RotIm (:,one_side_blind_area+1: one_side_blind_area+visual_field);
        
        %EDGE DETECOTOR----------------------
%         edge_CutIm = double(edge(CutIm));
%         CutIm = (edge_CutIm-1)*-1;
        
        
        Dec (i)= infomax_decision(Weights,CutIm(:));
    end
    best_Dec (cur) = min (Dec); 
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INFOMAX FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function decs = infomax_decision(weights,patts)
% Infomax decision function, using the sum of the absolute values of
% membrane potentials

result = weights*patts;
decs = sum(abs(result));