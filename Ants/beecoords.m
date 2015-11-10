UseAvi=1;
if((~UseAvi)&&isfile('FileList.mat'))
    load FileList.mat;
else
    FList12=dir('*.avi');
    disp('**** using avis not FileList ****')
end
is=[1:length(FList12)];
% is=[7 13 14 4 3];
% Ts=30:10:50;

% FullFrame=1 means do full frames, Fullframe =0 means use half-frames.
% This is the default. The issue is when analysing data if one looks at
% frequencies of points, we need to use frequencies x FRAMELEN
FullFrame=3;
while(~ismember(FullFrame,0:1))
    FullFrame=input('enter 1 for full frames; 0 half-frames: ');
end
if(FullFrame)
    input('USING FULL FRAMES; return continue');
else
    input('USING HALF FRAMES; return continue');
end

for i=is
    d=ProcessBeeFileName2012(FList12(i).name);
   %  fn=[s(i).name(1:end-4) '_ProgWhole.mat'];
    fn=[FList12(i).name(1:end-4) '_Prog.mat'];    
    
    if((d.ftype~=1)&&(~isfile(fn)))
        % This works for a particular threshold
         TrackBee2012(FList12(i).name,FullFrame);
        % This bit tests different thresholds
%          for th=49%Ts
%             TrackBee2012(s(i).name,FullFrame,th,47:3:60);
%          end

% this bit is what we did for the old version: now defunct
%          TrackBeeExpt2(s(i).name);
 %       TrackBeeExpt2_Whole(s(i).name);
    end
end    