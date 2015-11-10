function ddocs

if(IsFile('C:\Documents and Settings\andrewop\My Documents\Documents'))
   cd('C:\Documents and Settings\andrewop\My Documents\Documents')
elseif(IsFile('C:\Documents and Settings\Administrator\My Documents\Documents'))
   cd('C:\Documents and Settings\Administrator\My Documents\Documents')
else
    dWork;
   cd('../Documents')
end

