% function SetRefPoints(ins)
%
%Function to set up the reference points for use with the various
%calibration images. Idea is to get the points from ginput, sned them in as
%ins and store them together with the reference points got from the
%landmark files here.

function SetRefPoints(ins)
refpoints = zeros(12,3);

% get the data from the LM file
LMs=load('Landmarks.txt','-ascii');
refpoints(1:8,:) = LMs([2 3 5:7 9 12:13],2:4);

% adjust any that are different
% refpoints(1,3)=11.75;
refpoints(2,1)=20;
refpoints(3,[1 2])=[23.9 39.2];
refpoints(4,[1 2])=LMs(6,[2 3])-[0.2 0.3];
refpoints(5,[1 2])=[52.5 57.5];
refpoints(6,[1 2])=[47.5 37.5];
refpoints(7,[1 2])=[33.6 23.6];
refpoints(8,[1 2])=[30 30];

% add in any floor ones
refpoints(9,:) = [25,50,0];       
refpoints(10,:) = [50,50,0];       
refpoints(11,:) = [50,15,0];       
refpoints(12,:) = [25,15,0];       

% Set up ones and save
refpoints=[refpoints ones(size(refpoints,1),1)];
save 90_21_RefsAndPointsV1 refpoints ins

% refpoints for the original test stuff
% refpoints=[0 0 0; 0 5 0;0 10 11.6;0 15 0;0 25 0; 0 30 0;...
%            11.1 25 22.6; 20.5 29.9 0; 20.5 25 0;20.5 14.8 0; ...
%            15 14.85 5.8; 20.5 10 0; 20.5 5 0; 20.5 0 0; ...
%            10 0 0; 10 -5 8.4];
%        
% refpoints=[refpoints ones(size(refpoints,1),1)];
% save RefsAndPointsV1 refpoints -append