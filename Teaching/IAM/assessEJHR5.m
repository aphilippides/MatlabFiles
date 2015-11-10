function[times, preqtimes, discovers, preqdiscovers, visits, preqvisits, accepts, preqaccepts] = ...
    assessEJHR5(n, quals, probs, threshold_mean, threshold_stddev, qual_stddev, time_means, time_stddevs, quora)
%   n = number of replicates (>=1)
%   quals = row vector of m site qualities 
%		(quals(1) = home site
%     	quality: -Inf for no effect of home site quality on searching)
%   discovery_probabilities = m * m matrix of discovery probabilities from
%     column site to row site (N.B. columns should sum to 1)
%   threshold_mean: mean population threshold for site acceptability
%   threshold_stddev: standard deviation in population thresholds
%   qual_stddev: standard deviation in quality assessments: **AOP**
%   time_means: m * m matrix of mean travel times from column site to row
%     site (N.B. should probably be symmetric)
%   time_stddevs: m * m matrix of travel time standard deviations, from
%     column site to row site (N.B. should probably be symmetric)
%   quora: 1 * m matrix of quorum times for each nest site
%
%   times = row vector of times to first recruitment (i.e. nest acceptance)
%   discovers = matrix (m x i) of times of first visit to each site
%   visits = matrix (m x i) of numbers of visits to each site
%   accepts = row vector of ids of accepted sites (indexed from 1 (for home nest) to m)
%   the equivalents prefixed 'preq' are the pre-quorum equivalents of these

% set the random number generator to a new random state **AOP**

rng('shuffle');

% for each ant (or a single ant multiple times)
for i=1:n
    % Monte Carlo simulation of one ant
    times(i) = 0;
    preqtimes(i) = 0;
    accepts(i) = 1; % ant is in home site
    preqaccepts(i) = 1;
    discovers(1,i) = -1; % ant is already in home site
    preqdiscovers(1,i) = -1;
    visits(1,i)=1; % ant is already in home site
    preqvisits(1,i)=1;
    
    for j=2:(size(quals,2))
        discovers(j,i) = 0; % ant has not discovered or visited other sites
        visits(j,i) = 0;
        preqdiscovers(j,i) = 0;
        preqvisits(j,i) = 0;
    end
    % sample ant's acceptance threshold
    thresh = normrnd(threshold_mean, threshold_stddev); 
    % if sampled quakity of the current site is below the threshold
    while thresh > normrnd(quals(accepts(i)), qual_stddev)
       % probablistically pick on of the new sites to go to
       ran = unifrnd(0,1);
       newsite = 1;
       while ran > probs(newsite, accepts(i))   
           ran = ran - probs(newsite, accepts(i));
           newsite = newsite + 1;
       end
       
       % update the time taken with normally-distributed time-step size
       % (>=1) **AOP** 
       delta = max(1, normrnd(time_means(newsite, accepts(i)), time_stddevs(newsite, accepts(i)))); 
       times(i) = times(i) + delta;
       
       % update ant's current site, accepts, the 1st time it was discovered,
       % discovers, and the number of times it has been visited, visits **AOP** 
       accepts(i) = newsite;
       if discovers(newsite,i)== 0
           discovers(newsite,i)= times(i);
       end
       visits(newsite,i)=visits(newsite,i)+1;
       
       % this is to do with quorum sensing 
       % this doesn't necessarily need using and could be adapted **AOP** 
%        if times(i) > quora (1, newsite)    %if past pre-quorum period, then no new nests can be added
%             preqtimes(i) = NaN;
%             preqaccepts(i) = preqaccepts(i);
%                    if preqdiscovers(newsite,i)== 0
%                         preqdiscovers(newsite,i)= NaN;
%                    end
%            preqvisits(newsite,i)=preqvisits(newsite,i);
%        else
%            preqtimes(i)=times(i);
%            preqaccepts(i) = newsite;
%                    if preqdiscovers(newsite,i)== 0
%                         preqdiscovers(newsite,i)= times(i);
%                    end
%            preqvisits(newsite,i)=preqvisits(newsite,i)+1;
%        end
       
    end
    % recruit / accept nest
end
end
