% function CentralLimitTheoryEg(NumVars,NumEgs,NumBins)
% NumVars holds the number of random variables that are to be averaged 
% It can be a vector so that we can see what happens for several values
% NumEGs holds the number of instances (cf 'throws') of each random
% variable. NumBins holds the number of bins in which we can place the
% averaged random variables  

function CentralLimitTheoryEg(NumVars,NumEgs,NumBins)

% Generate some random variables
% the dimensions of the data are determined by the maximum number of
% variables to be averaged and the number of instances of each variable
RandomVariables=rand(max(NumVars),NumEgs);

% Generate the centre of the bins that will hold the frequencies of the data
% As we know the data is between 0 and 1 we know the bins must be between 
% 0 and 1. The increment is 1/NumBins which generates NumBins bins 
BinCents=0:1/NumBins:1;

% Step through NumVars
for i=1:length(NumVars)
    % As we may have several NumVars to examine, we can either have a 
    % separate figure for each one or we can use subplot. Initially try using
    % figure then comment this out and use subplot as explained below
    figure

    % subplot splits the axis into m by n mini-graphs and lets you plot in
    % each. Uncomment this line if you want to plot several graphs at once
    % Make sure that you have enough mini-axes to hold all the averages ie 
    % m*n < length(NumVars)
    % subplot(3,2,i)
    
    % get the average of the 1 to NumVars(i) variables
    means=mean(RandomVariables(1:NumVars(i),:),1);
    
    % Get the frequencies of the data in the bins specified by BinCents
    Freqs=hist(means,BinCents);
    
    % Transform the frequencies into probabilities by making sure the sum 
    % of the area of the bins is 1 by dividing each frequency by the number
    % of examples and the bin width
    Probs=Freqs/(NumEgs*1/NumBins);
    
    % Plot the probabilities as a bar chart in the current figure window
    bar(BinCents,Probs);
    % Or try the stairs function
%     stairs(BinCents,Probs);
    
    % 'hold' the graph so that the next curve can be seen
    hold on;
    
    % Plot the normal curve that theory predicts we should get 
    PlotNormal(NumVars(i))
    
    % release the graph so that when you next call the function the graph
    % clears
    hold off
    
    % Label the axes
    xlabel('Mean scores')
    ylabel('Probability distribution of the means')
    
    % Put a title on the graph
    title(['Mean of ' int2str(NumVars(i)) ' Variables'])
end

% Subfunction which plots the probability distribution which theory
% predicts as the distribution of a mean of N random variables
function PlotNormal(N)

% Specify the mean of the distribution. As each of our random variables has a 
% mean of 0.5, the average mean is also 0.5
mu=0.5;

% Calculate the variance of the ditribution. Each random variable has a
% variance of 1/12 and var(nX) = (1/n)var(X) (don't worry of you don't understand this) 
sigSquared=1/(12*N);

% generate a vector of points between 0 and 1
x=0:0.001:1;

% Calculate the corresponding points with the equation for a normal
NormVar=(1/sqrt(sigSquared*2*pi))*exp(-((x-mu).^2)/(2*sigSquared));

% plot the distribution in red
plot(x,NormVar,'r')