% Tester code for Adaptive behaviour journal

A_plus_range= [ 0.11  ;  0.12  ;  0.13  ;  0.14  ;    0.15        ;  0.1375   ;  0.15        ;    0.1625   ;  0.175   ;  0.1875        ;  0.165    ;  0.18       ;  0.195         ;  0.21   ;  0.225  ];
A_minus_range=[-0.1   ; -0.1   ; -0.1   ; -0.1   ;   -0.1         ; -0.125    ; -0.125        ;   -0.125  ; -0.125  ; -0.125       ; -0.15   ;  -0.15      ; -0.15        ; -0.15  ; -0.15 ];
Pda_range=    [ 0.95  ;  0.95  ;  0.95  ;  0.95  ;    0.95        ;  0.95   ;  0.95        ;    0.95  ;  0.95  ; 0.95  ;  0.95    ;   0.95       ;  0.95         ;  0.95   ;  0.95  ];
Pdb_range=    [ 0.975 ;  0.975 ;  0.975 ;  0.975 ;    0.975       ;  0.975  ;  0.975       ;    0.975 ;  0.975 ;  0.975      ;  0.975  ;  0.975 ;  0.975  ;  0.975  ;  0.975 ];

taskname= ['unc'];
damping = ['nodamp'];
network = ['recc_60conn'];

for run=1:15

    % STDP VARIABLES    
    A_plus=A_plus_range(run);
    A_minus=A_minus_range(run);
    Pda=Pda_range(run);
    Pdb=Pdb_range(run);         

    % NETWORK VARIABLES
    Ni=20;                      % Number of neurons
    connectivity=0.6;
    connections=zeros(Ni,Ni);   % Fully connected recurrent network
    for i=1:Ni
        for j=1:Ni
            connections(i,j)=j;
            if i==j
                connections(i,j)=0;
            end
        end
    end
    
    i=(1-connectivity)*(Ni^2)-Ni;
    while i>0
        j=ceil(rand*Ni);
        k=ceil(rand*Ni);
        if connections(j,k)~=0
            connections(j,k)=0;
            i=i-1;
        end
    end
    
    D=20;    

    % SPIKING VARIABLES
    a=0.02; B=0.2; d=8;         % Spiking model variable        
    noise=0;                    % noise?
    
    % INPUT
    I=zeros(Ni,1);
    max_current=20;

    % TEST VARIABLES
    folder=[taskname '_' damping '_' network '_' int2str(run)];
    mkdir(folder);
    test_time=200;
    subjects=25;        
    
    % ANALYSIS VARIABLES
    step=200;   % moving average period in ms
    scale=1000/step;
    data=[];
    weights=[];
    rateses=[];
    spikerates=[];    

    for subject=1:subjects

        delays=[];
        for i=1:Ni
            delays=[delays ; ceil(D*rand)*ones(1,Ni)];
        end
        
        w_max=20;   w_min=0;        % Max and min synaptic weights
        w=round(w_max*rand(Ni,Ni));
        for i=1:Ni
            w(i,i)=0;
        end
        wstart=w;

        P_plus=[(A_plus/10)*ones(size(connections))];
        P_minus=[(A_minus/10)*ones(size(connections))];

        v = -65*ones(Ni,1);
        u = 0.2.*v;
        rates=zeros(Ni,1);  spikerate=[];  received=0;
        sd=zeros(Ni,Ni);

        for z=0:test_time-1
            for t=1:1000
                P_plus=Pda*P_plus;  P_minus=Pdb*P_minus;
                [spikes m]=find(sd==t);
                received=received+length(spikes);
                for i=1:size(spikes,1)
                    P_plus(spikes(i),:)=A_plus;
                    for l=1:Ni
                        if connections((spikes(i)),l)~=0
                            I(connections((spikes(i)),l))=I(connections((spikes(i)),l))+w(spikes(i),l);
                        end
                        if spikes(i)~=l
                            w(spikes(i),l)=w(spikes(i),l)+P_minus(spikes(i),l);
                        end
                        if w(spikes(i),l)<w_min
                            w(spikes(i),l)=w_min;
                        end
                    end
                    sd(spikes(i),m(i))=0;
                end
                clear m

                % Firing code
                fired = find(v>=30);
                v(fired)=-65;
                u(fired)=u(fired)+d;
                rates(fired)=rates(fired)+1;
                for i=1:Ni
                    v(i)=v(i)+0.5*((0.04*v(i)+5).*v(i)+140-u(i)+I(i));
                    v(i)=v(i)+0.5*((0.04*v(i)+5).*v(i)+140-u(i)+I(i));
                    u(i)=u(i)+ a*(B*v(i)-u(i));
                end
                spikerate=[spikerate ; (z*1000+t)*ones(length(fired),1),fired];

                % Input
                I=round(max_current*rand(Ni,1));

                % STDP part 2 - spiking neurons
                j=[];
                k=[];
                for i=1:size(fired,1)
                    [j k]=find(connections==fired(i));
                    if isempty(j)==0
                        for l=1:size(j,1)
                            P_minus(j(l),k(l))=A_minus;
                            if j(l)~=k(l)
                                w(j(l),k(l))=w(j(l),k(l))+P_plus(j(l),k(l));
                            end
                            if w(j(l),k(l))>w_max
                                w(j(l),k(l))=w_max;
                            end
                        end
                    end
                    j=[];
                    j=find(sd(fired(i),:)==0, 1, 'first');
                    sd(fired(i),j)=t+delays(fired(i));
                end
            end

            % End of second clean up operation!
            j=[]; k=[];
            [j k] = find(sd>1000);
            for l=1:length(j)
                sd(j(l),k(l))=sd(j(l),k(l))-1000;
            end
            clear j k
            string=['w' int2str(z) '=w;'];
            eval(string);
            clear string
        end
        
        filename=[folder '\subj' int2str(subject) '.mat'];
        save(filename);
        
        %save weights, spiketimes and rates in a results file as we go along
        for i=1:Ni
            weights=[weights ; w(:,i) ];
        end
        rateses=[rateses rates/test_time];
        % spikerates=[spikerates spikerate];
        
        for i=0:test_time-1
            string=['clear w' int2str(i)];
            eval(string);
        end
        
        markers=zeros(((z*scale)+1),1);
        markers(1)=1;
        moving_rates=zeros(z*scale,Ni);
        for i=1:(z*scale)
            markers(i+1)=find(spikerate(:,1)<(1000+250*i),1,'last');
            for j=1:Ni
                [k l]=find(spikerate((markers(i):markers(i+1)),2)==j);
                moving_rates(i,j)=length(k);
                clear k l
            end
        end
        moving_rates=moving_rates*scale;
        for i=1:Ni
            data=[data ; moving_rates(:,i)];
        end
        
        filename=[folder '\results.mat'];
        save(filename, 'weights', 'rateses', 'data');
    end
    
    clear A_minus A_plus B D I P_minus P_plus Pda Pdb a connections d
    clear delays filename fired i l max_current noise rates received
    clear run sd spikerate spikes subject t u v w wstart z

    % create and save figures of weight and rates and moving averages   
    hist(weights,0:w_max)
    filename=[folder 'weights.fig'];
    saveas(gcf,filename);
    clf
    rates=[];
    for i=1:subjects
        rates=[rates ; rateses(:,i)];
    end   
    hist(rates,0:100)
    filename=[folder 'rates.fig'];
    saveas(gcf,filename);
    clf
    hist(data,(0:max(data)));
    filename=[folder 'moving_averages.fig'];
    saveas(gcf,filename);
    clf
    
end