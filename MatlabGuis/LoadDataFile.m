function[Loaded] = LoadDataFile(filename)

%filename=['NetActivity'];
eval(['load ' filename '.dat -ascii;']);
eval(['Loaded=' filename ';']);
