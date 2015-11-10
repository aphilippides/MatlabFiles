% function to play DEmovie. Arguments: rate, num_times, pause_len
% which set args for movie and set the pause after the first frame

function DEmovie_go(rate, num_times, pause_len )

load  S1_100_3dMovie.mat
Skiprate = 2;

DE_3dplot(-1,200,600,50,350,Skiprate,Skiprate);
pause(pause_len);
movie(M,num_times,rate)

