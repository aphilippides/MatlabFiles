function RushTest% RushTest measures the variation in speed of a simple loop over time, and% assesses the effectiveness of the Rush MEX function in minimizing the% Mac OS and device driver interruptions that cause the variation. Rush% runs the Matlab loop as a deferred task or at raised processor priority% to prevent most of the interruptions. RushTest revealed that the Iomega% 5.03 driver installed by Mac OS 7.6.1 to support Zip and Jaz drives is a% particularly bad offender, stealing 2 ms every 3 seconds, which wreaks% havok in any attempt to control a real-time process, or display a% real-time movie. (The Zip and Jaz interrupts can be eliminated simply by% stuffing disks into the empty drives to eliminate the endless scanning% of empty drives.) LoopTest.m is a minimal version of this file, using% only standard Matlab functions.% % See Rush and Priority.%% ANALYSIS% In the absence of the Iomega 5.03 driver, most of the activity at % priorityLevel 0.5 seems to be due to a roughly 0.6 ms interrupt that % occurs about once per 2 ms. % % The histogram of durations of a nominally 1 ms interval is log-linear:% Frequency falls off by a decade per 0.3 ms. The histogram of nominally% 10 ms interval durations falls off by a decade per 0.6 ms. With my% current bin size of about 0.25 ms, the mode is at the nominal duration% and has about 50% of the intervals, the max is in a bin at 1.2 ms longer% and holds about 0.2% (not far below 0.5 10^-2) of the intervals.% Extrapolating, going out six times 0.6 ms, we'd expect only 0.5 10^-6 of% the intervals to be 3.6 ms longer than the nominal. In the course of a 1% s stimulus we'd expect a probability of 100*0.5 10^-6=1/5000 of% exceeding a nominal 10 ms interval by 3.6 ms or more. That's probably% rare enough to be negligible.% % CONCLUSION% At priorityLevel 0.5 you should allow about 3.6 ms of slack in any 10 ms % loop synchronized to an external event to be confident of never missing % a beat. I.e. if you're synchronizing to a 100 Hz display, you'll need % to move few enough pixels to remain idle for about 1/3 of the time.% 4/12/97 dgp Wrote it.% 4/23/97 dgp Updated. Offers choice of using Rush.% 4/24/97 dgp Renamed from LoopTest to RushTest% 5/1/97  dgp Updated comments. Added histogram. Subsample, to provide%				data for 10 ms intervals.% 5/2/97  dgp Changed line 83 use of index to use the FIND function, for %				compatibility with Matlab 4.% 5/2/97  dgp Changed line 83 again, as suggested by dhb, for Matlab 4 compatibility.% 5/31/97 dgp Polished.% 6/3/97  dgp Warn that patching GetMenuBar breaks the Matlab debugger.% 2/8/98  dgp priorityLevel 0.5.% 3/31/99 dgp reduce 20000 to 16000 for compatiblity with Matlab Student.% 2/4/00  dgp don't rely on pci to check for busHz.% 2/4/00  dgp Updated comments for Mac OS 9.% 2/18/02 dgp Cosmetic.% 2/19/02 dgp Report range. Close old figures.% 2/21/02 dgp Prettier printout.% 4/24/02 awi Exit on PC with message.if strcmp('PCWIN',computer)    error('Win: RushTest not yet supported.');endsubsample=0;		% optional. Set to 1 for statistics of ten-iteration interval.plothistogram=0;	% optional.close all;% figuresfprintf('RushTest');%fprintf('\nWhich test: 1. Matlab loop with PRIORITY, 2. Rush of Matlab loop, 3. Rush of C loop?.\n');%test=input('Choose one (1,2,3)?: ');test=2;fprintf('\n');DescribeComputer;fprintf('\n');if sscanf(version,'%f',1)==5.0 & exist('PatchTrap')	PatchTrap('GetMenuBar',10000); % patch needed only for Matlab 5.0	fprintf('(Patched GetMenuBar to speed up MEX access. WARNING: this patch breaks the debugger!)\n')endif FileShare ~= -3	fprintf('(FileSharing is on, which may slow things down.)\n');endn=140000;fprintf('Will now measure time per iteration of a loop, for %d iterations,\n',n);fprintf('and then plot the variation in loop time over time.\n');switch(test);case(1),	fprintf('\nTesting Matlab loop\n');case(2),	fprintf('\nTesting Rush of Matlab loop\n');case(3),	fprintf('\nTesting Rush of C loop\n');endfor p=[0 0.5 1 7]	i=0;t=zeros(1,n);GetSecs;cputime;	if p>MaxPriority('GetSecs')		break	end	condition=sprintf('priority %3g',p);% 	fprintf('priority %3g, ',p);	switch(test);	case(1),		priority(p);		for i=1:n;GetSecs(t,i);end		priority(0);	case(2),		GetSecs; % Make sure all Rushed functions are in memory.		Rush('for i=1:n;GetSecs(t,i);end',p)	case(3),		t=Rush(n,p);	end	if t(1)~=0		dt=diff(t);		% When processor priority is raised, the Time Manager is impaired. CPUTIME		% (on all Macs) and GETSECS (on 68K Macs or Mac OS older than 8.6) still 		% advance at the correct		% rate, but in coarse steps, and periodically overflow. Their interval		% measurements are still useful though, so we check for and discard any		% overflows. On PowerMacs running Mac OS 8.6 or better, GETSECS is immune to priority-raising.		index = find(dt<0);		if ~isempty(index)		  dt(index) = zeros(size(index));	% remove overflows		end		clear t;		t=cumsum(dt);		dt=1000*dt;		dt=1000*dt;		dev=[min(dt) max(dt)]-mean(dt);		sds=sprintf('mean %5.0f �s, standard deviation %4.1f �s, range %5.0f,%5.0f �s',mean(dt),std(dt),dev);			fprintf('%s, %s\n',condition,sds);		% plot duration over time		figure;		plot(t-t(1),dt)		title(sprintf('Priority %.1g: Variation in duration (of one iteration) over time',p))		xlabel('Time (s)');		ylabel('Duration (�s)');		text(1,-2.5,sds,'Units','characters');		figure(gcf)		drawnow		if plothistogram			% plot histogram of durations			figure;			[h,x]=hist(dt);	%		plot(x,(h)/sum(h));			semilogy(x,(h+1)/sum(h));% add 1 to make plot prettier			s=axis;			s(3)=min((h+1)/sum(h));			axis(s);			title(sprintf('Priority %.1g: Histogram of durations (of one iteration)',p))			xlabel('Duration (ms)');			ylabel('Proportion of intervals');			figure(gcf)			drawnow		end			if subsample			% subsample			clear tt;			tt=t(1:10:size(t,2));			dt=diff(tt);			clear t;			t=cumsum(dt);			dt=1000*dt;			fprintf('min %.2f ms, mean %.2f�%.2f ms, max %.2f ms.\n',min(dt),mean(dt),std(dt),max(dt));				% plot duration over time			figure;			plot(t-t(1),dt)			title(sprintf('Priority %.1g: Variation in duration (of ten-iteration interval) over time',p))			xlabel('Time (s)');			ylabel('Duration (ms)');			figure(gcf)			drawnow				% plot histogram of durations			figure;			[h,x]=hist(dt);			semilogy(x,(h+1)/sum(h));% add 1 to make plot prettier			title(sprintf('Priority %.1g: Histogram of durations (of ten-iteration interval)',p))			xlabel('Duration (ms)');			ylabel('Proportion of intervals');			drawnow		end	endend%FileShare(fsWasOn,0);%AfterDark(adWasOn);if sscanf(version,'%f',1)==5.0 & exist('PatchTrap')	PatchTrap('GetMenuBar',0);end