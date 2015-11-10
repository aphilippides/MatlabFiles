function[nb]=NumBToNB(NumBees)
nb=[];
for n=NumBees
    for i=1:n 
        nb=[nb n]; 
    end
end