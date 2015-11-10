function MatlabForDummies
%ddocs
%cd ALife03\
PhilsData
% figure
%Distributions

function PhilsData
MeanFits=[0.56 0.59 0.81]; % Mean Receptor Fits [Both elec chem]
SdFits = [0.3 0.3 0.15];   % SD Receptor Fits [Both elec chem]

MeanNums=[0.044,0.12,0.063]; % Mean numbers of Mutations [Both elec chem]
SdNums = [0.11,0.08,0.02];  % Sd of numbers of mutants [Both elec chem]

figure,Singplot,set(gca,'FontSize',16)
barerrorbar([],MeanFits,SdFits),setbox
ylabel('Mean fitness');

figure,Singplot,set(gca,'FontSize',16)
barerrorbar([],MeanNums,SdNums),setbox,YLim([0,0.2])
ylabel('Proportion of total mutations')

function Distributions
DataIn=[];
FileNumList=[1:10];      % Numbers of the files
for i=1:length(FileNumList)
    h=load(['ipntmutants/mutant' int2str(i) '.dat']);       % load file
    DataIn=[DataIn; h];                                 % Put in one long column
end

Fitnesses = DataIn(:,1);        % Get fitnesses
NumMutants = length(Fitnesses);         % Get number of mutants
MutantTypes= DataIn(:,2);               % Get mutant types

ElecIndices=find(MutantTypes == 1);  % find indices of elec only
ChemIndices=find(MutantTypes == 2);  % find indices of chem only
BothIndices = find(MutantTypes==3);  % indices of both

ElecFits=Fitnesses(ElecIndices);     % Get Elec only fitnesses: NB should really do above as
                                      % ElecFits =DataIn(find(DataIn(:,2)),1) for brevity
                                      % but have gone long
                                      % winded for clarity
                                      
ChemFits=Fitnesses(ChemIndices);    %Same for chem and both mutants
BothFits=Fitnesses(BothIndices);

figure,set(gca,'FontSize',16)
[y,x]=hist(ElecFits,50);    % Bin Elec only fitnesses into 50 bins: note that if you 
                            % want to plot bars with x values you've got to get them
                            % returned fro hist and for some reason hist returns
                            % them in the reverse order

bar(x,y/NumMutants)         % bar chart of data as a proportion of total number of mutants
                            % might not want to do this as proportios are very low

%YLim([0 0.01])               % Set the y-axis - if you want them all on the same scale 
xlabel('Fitness')
SetYTicks(gca,[],1e3)        % this is one of my functions which scales the Tick labels 
                             % for graphs with low/high values
ylabel('Proportion of all mutants (x10^{-3})'),SetBox

% repeat for other distributions
figure,set(gca,'FontSize',16)
[y,x]=hist(ChemFits,50);     
bar(x,y/NumMutants)        
%YLim([0 0.01])               
xlabel('Fitness')
SetYTicks(gca,[],1e3)         
ylabel('Proportion of all mutants (x10^{-3})'),SetBox

figure,set(gca,'FontSize',16)
[y,x]=hist(BothFits,50);     
bar(x,y/NumMutants)        
%YLim([0 0.01])               
xlabel('Fitness')
SetYTicks(gca,[],1e3)         
ylabel('Proportion of all mutants (x10^{-3})'),SetBox
