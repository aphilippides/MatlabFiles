% function to get data from matlab big file
function[Get_datam] = get_datam(Time,F) 

if (Time < 0)
   filename = ['d:/mydocuments/Diffequn/DE/twodXS_L1_-100.mat']
else
   filename = ['twod7S_L1_' int2str(Time) '.mat']
end
load(filename);
Get_datam=DEdat;

