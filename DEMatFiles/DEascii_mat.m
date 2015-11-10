% File which takes a lot of DE ascii files and makes them into mat files

function DEascii_mat

for i=7:8
   eval(['get_data(' int2str(i*25) ',600,600);']);
end	
