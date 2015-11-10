function dsmall

if(isfile('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\DiffEqun\MeshTube\Small'))
   cd('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\DiffEqun\MeshTube\Small')
elseif(isfile('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\DiffEqun\MeshTube\Small'))
   cd('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\DiffEqun\MeshTube\Small')
else
    dwork;
    cd('DiffEqun\MeshTube\Small')
end

