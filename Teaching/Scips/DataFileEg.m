% function to analyse some data files
function DataFileEg

% First Generate random reaction time data
GenerateData;

for i=1:7
    % Generate each file name
    fname=['DataFileSubject' int2str(i) '.dat'];
    
    % Use the functional form of load as the filename is variable
    % Assign the data in the file to the variable h
    h=load(fname,'-ascii');
    
    % find the indices of responses in the 1st column equal to 1
    is=find(h(:,1)==1);
    
    % Use 'length' to get the number that are correct (ie 1's)
    NumCorrect(i)=length(is);
    
    % find the mean and standard deviation of values in column 2 
    % which have an index in 'is' ie where the response was a 1
    MeanReactions(i)=mean(h(is,2))
    SDReactions(i)=std(h(is,2))
end

% use 'subplot' to split the figure window into a 1x2 array of axes
% and  make the 1st axis active
subplot(1,2,1) 

% plot a bar chart of the number of correct responses
bar(NumCorrect)

% make the 2nd axis active
subplot(1,2,2)

% plot the means with error bars (here indicating the s.d.'s)
errorbar([1:7],MeanReactions,SDReactions)

% save the data to a tab-delimited text file. Note that the file names are
% lost but there is a carriage return between each variable.
save OutputData.dat NumCorrect MeanReactions SDReactions -ascii -tabs

% perform a 2 sample t-test on the data from individuals 1 and 3
% First get the data into 2 vectors x an y, then perform the test

h1=load('DataFileSubject1.dat','-ascii');
is = find(h1(:,1)==1);
x=h1(is,2);

h3=load('DataFileSubject3.dat','-ascii');
is = find(h3(:,1)==1);
y=h3(is,2);

[h,p]=ttest2(x,y)


% function to generate 7 reaction time data files. 
% The data files consist of 2 columns of 30 responses:
% the 1st column holds the response (either 0, 1, or 2);
% the 2nd column holds the reaction time (a random value);
% Artificially, we ensure that reaction times in the 3rd file are long
% and that there are no '1' responses in the 7th file
function GenerateData

for i=1:7    
    % Generate a matrix with 30 rows and 2 columns of random values between 0 and 1 
    RandData=rand(30,2);
    
    % Generate random response data, 0, 1 or 2 from the 1st column
    % First multiply the 1st column by 3 (making the data between 0 and 2.9999
    % Then use 'floor' to round down to the nearest integer. Then copy the data
    % back into the matrix. Note the order of brackets
    RandData(:,1)=floor(3*RandData(:,1));
    
    % Multiply the reaction times of the 3rd data file by 10
    if(i==3)       
        % Multiply the 2nd column of RandData by 10 and re-assign
        RandData(:,2)=10*RandData(:,2);

    % for the 7th data file, make sure there are no '1' responses
    elseif(i==7)
        % find indices of the 1st column that are 1
        is=find(RandData(:,1)==1);
        % Make these values 2's
        RandData(is,1)=2;
    end

    % Finally generate the data file name
    fname=['DataFileSubject' int2str(i) '.dat'];
    
    % and save. Note that as the filename is a variable, the 'functional'
    % form of save must be used. This means variable names etc must be 
    % strings ie put quotes round them
    save(fname,'RandData','-ascii');
end