function dthesis

if(isfile('C:\Documents and Settings\andrewop\My Documents\Documents\Thesis\Figures'))
   cd('C:\Documents and Settings\andrewop\My Documents\Documents\Thesis\Figures')
elseif(isfile('C:\Documents and Settings\administrator\My Documents\Documents\Thesis\Figures'))
   cd('C:\Documents and Settings\administrator\My Documents\Documents\Thesis\Figures')
else
   cd('C:\My Documents\Documents\Thesis\Figures')
end

