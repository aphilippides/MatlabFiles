% Makes a movie of Diff equn plots

function DEmovie

M = moviein(77);
Skiprate=2;  		% How many pixels to look at for each pic ie 1 equals 
			% every one; 4 evry 4th etc
%Times=[0,50,100,150,250,300,500,750];
Times=-10:10:750
L=length(Times);


for  i=1:L
	DE_3dplot(Times(i),200,600,50,350,Skiprate,Skiprate);
 	M(:,i) = getframe;
	i
 	save S1_100_3dMovie.mat M;
end 
