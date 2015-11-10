%% load in the data from a file called daylognew.xls
[mat,txt] = xlsread('daylognew.xls');

% I had to save your original file into Excel format (which is why I ran
% this on daylognew, and not daylog.xls). You should be able to do this by
% opening up your daylog files, ans using "File->Save As"

%% Take out a subset of the data
% This will run for specified points of the dataseries, and only uses three
% columns of the data - the first we ignore, as it's time.
startPoint = 1;
endPoint = 7200;
mat = mat(startPoint:endPoint,2:end);

%% plot the data
figure; %Open up a MATLAB figure
plot(mat); %Plot the signal
hold on; %Append any plots
set(gca , 'ylim' , [-1 1]); %Force the y limit of the signal

%% now, go and build a series of straight lines through the middle point

%% Take out the signal we want to fit a line to.
sig = mat(:,3);

%% Perform a moving average filter of this signal
sig = movavg(sig , 3, 20 , 1);

%% Some parameters

% How many points do we use to fit the line
nPoints = 300;

% How many points will we extend the line to? In this case, we will have
% 200 predicted points.
nPredict = 500;

%% Now, run the model
for i = 1:length(sig)-nPoints
    
    %Delete the line
    delete(findobj('tag' , 'myline'));
    
    %Fit a linear polynomial to a subset of the data (i.e. a straight line)
    p = polyfit(1:nPoints,sig(i:i+nPoints-1)',1);
    
    %Evaluate the model using polyval
    y = polyval(p,1:nPredict);
    
    %Plot the results
    l = line(i:i+nPredict-1,y);
    set(l , 'tag' , 'myline' , 'color' , 'k' , 'linewidth' , 2);
    l = line(i:i+nPoints-1,y(1:nPoints));
    set(l , 'tag' , 'myline' , 'color' , 'm' , 'linewidth' , 2);
    drawnow;    
end
    