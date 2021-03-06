function objOut = rotateX(objIn,a)
%hierarchical rotate function for structs and cell arrays
a=a/57.29;  %degrees to radians
if (iscell(objIn)) %a list of structs
   for i=1:length(objIn)
      objOut{i}=objIn{i};
      V=objOut{i}.vertices;
      V=[V(:,1), ...
            cos(a)*V(:,2)-sin(a)*V(:,3), ...
            sin(a)*V(:,2)+cos(a)*V(:,3)];
      objOut{i}.vertices=V;   
   end      
 elseif (isstruct(objIn)) %must be a single struct   
    V=objIn.vertices;
    V=[V(:,1), ...
            cos(a)*V(:,2)-sin(a)*V(:,3), ...
            sin(a)*V(:,2)+cos(a)*V(:,3)];
    objOut=objIn;
    objOut.vertices=V; 
 else
    error('input must be s struct or cell array')
 end %if   