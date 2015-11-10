function dtube

if(isfile('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\Tubedata'))
   cd('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\Tubedata')
elseif(isfile('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\Tubedata'))
   cd('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\Tubedata')
else
   dWork
    cd('TubeData')
end