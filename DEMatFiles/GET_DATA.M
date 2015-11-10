% function to get data from ascii big file
function[M] = get_data(Time,x,y) 

filename = ['twod7S_L1_' int2str(Time)]
%filename = ['twod5S_L1_-100']
fid = fopen(filename,'r');
DEdat=fscanf(fid,'%f',[x y]);
%M=fscanf(fid,'%f');
eval(['save ' filename '.mat DEdat -double']); 
s=fclose(fid);
%M=dlmread(filename,'\t',0,0,[x1 x2 y1 y2])
