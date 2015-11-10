function DoScatter

GenNums=[0:100:5000]; 
traitCount = 2;

for i=1:length(GenNums)
    
    filename=['generation_1000.txt']; 
    GenData=load(filename,'-ascii');
    
    for i=1:traitCount
		x{i} = GenData(:,i+1);
	end
        
 	   
	
end

scatter (x{1}, x{2});




