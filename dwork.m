function dwork

if(isfile('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\'))
   cd('C:\Documents and Settings\andrewop\My Documents\WorkPrograms\')
elseif(isfile('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\'))
   cd('C:\Documents and Settings\Administrator\My Documents\WorkPrograms\')
% elseif(isfile('\\home-fileserver\andrewop\WindowsProfile\My Documents\WorkPrograms'))
%     cd('\\home-fileserver\andrewop\WindowsProfile\My Documents\WorkPrograms')
else
   cd('C:\_MyDocuments\WorkPrograms')
end