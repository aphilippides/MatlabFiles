% function choicecoords

FList12=dir('*.MP4');
% FList12=dir('PIC_0434.MP4');
is=[1:length(FList12)];

FullFrame=1;
for i=is
    %     d=ProcessBeeFileName2012(FList12(i).name);
    %  fn=[s(i).name(1:end-4) '_ProgWhole.mat'];
    fn=[FList12(i).name(1:end-4) '_Prog.mat'];
    vidfn=[FList12(i).name]
    maskfn=[vidfn(1:end-4) 'NestLMData.mat'];
    
    %(1:end-4) '.avi'];
    if (~isfile(fn))
        [v,vobj]=VideoReaderType(vidfn);
        if(~isfile(maskfn))
            GetMaskChoice(vidfn,vobj,maskfn,i+1);
            drawnow;
        end
        figure(1)
        [inf,NumFrames]=MyAviInfo(vidfn);
        frs=1:(NumFrames-10);%1000;
        Threshes=175;%[180 175:5:190];%120:20:220;
        sm_opts=[5 2];%;7 2;8 4;9 4];
        for j=1:size(sm_opts,1)
            for thr=Threshes
                %             thr=180;
                sm_opt=sm_opts(j,:);
                if(sm_opt(1)==0)
                    sfn=[fn(1:end-4) 'Thresh' int2str(thr) '.mat']
                else
                    sfn=[fn(1:end-4) 'Thresh' int2str(thr) 'S' int2str(sm_opt(1)) ...
                        'W' x2str(sm_opt(2)) '.mat']
                end
                if(~isfile(sfn))
                    TrackAntChoice(vidfn,FullFrame,vobj,thr,frs,0,sm_opt);
                end
%                 figure
%                 load(sfn)
%                 subplot(2,1,1)
%                 plot(NumBees)
%                 title(['Thresh' int2str(thr) 'S' int2str(sm_opt(1)) 'W' x2str(sm_opt(2))])
%                 subplot(2,1,2)
%                 plot(Areas,MeanCol,'o')
%                 title(['Num Bad = ' int2str(sum(NumBees~=3))])
%                 drawnow
                
            end
        end
        % This bit tests different thresholds
        %          for th=[8 10 12]%Ts
        %              TrackAntPathInt(vidfn,FullFrame,th);
        %          end
    end
end

% % s=dir('PIC_0434_ProgThresh*.mat');
% for i=1:length(s)
%     load(s(i).name);
%     subplot(2,1,1)
%     plot(NumBees)
%     title(s(i).name(10:end));
%     subplot(2,1,2)
%     plot(Areas,MeanCol,'o')
%     nb(i)=sum(NumBees~=3);
%     title(['Num Bad = ' int2str(sum(NumBees~=3))])
%     pause
% end
% nb
% s.name