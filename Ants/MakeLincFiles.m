function MakeLincFiles(n,is)
% (3525:3:3762)
% 3300:4:3500
% dwork;
% cd GantryProj\Bees
cd F:/
load(['HiSpeedData' int2str(n)]);
Orients=CleanOrients(Orients);
fid=fopen(['BeePosData_HiSpeed_' int2str(n) '_2.txt'],'w'); 
fprintf(fid,'%% X Y Heading\n');
fprintf(fid,'%f %f %f\n',[Cents(is,:) Orients(is)']');
fclose(fid);