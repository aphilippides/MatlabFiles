function soundtestsarah

% read file. y is the song, Fs how fast to play it
NumSongs=1;%size(xlsfile)
for i=1:NumSongs
    [y,Fs]=wavread('Sound 3 Heavy rain (1).wav');
    ts=GetSecs;
    wavplay(y,Fs,'async');
    t2=GetSecs-ts
    for i=1:10
    pause(1)
    imagesc(rand(20))
    end
    GetSecs-ts
end