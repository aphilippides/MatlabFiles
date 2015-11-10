function dvolsig

if(isfile('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\Gantry\VolSig1\Data'))
   cd('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\Gantry\VolSig1\Data')
elseif(isfile('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\Gantry\VolSig1\Data'))
   cd('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\Gantry\VolSig1\Data')
else
   cd('C:\My Documents\WorkPrograms\Gantry\VolSig1\Data')
end
