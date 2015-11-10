function [p,t]=triangles(node)

[node,edge,face,hdata] = checkgeometry(node,[],[],[]);
[p,t] = mycdt(node,node,edge);

end

function [p,t] = mycdt(p,node,edge)

% Approximate geometry-constrained Delaunay triangulation.

t = mydelaunayn(p);                                                        % Delaunay triangulation via QHULL

% Impose geometry constraints
i = inpoly(tricentre(t,p),node,edge);                                      % Take triangles with internal centroids
t = t(i,:);

end   

function fc = tricentre(t,f)

% Interpolate nodal F to the centroid of the triangles T.

fc = (f(t(:,1),:)+f(t(:,2),:)+f(t(:,3),:))/3.0;

end      % tricentre()

function [node,edge,face,hdata] = checkgeometry(node,edge,face,hdata)

% CHECKGEOMETRY: Check a geometry input for MESH2D.
%  
%  node  : Nx2 array of XY geometry nodes
%  edge  : Mx2 array of connections between nodes in NODE. (Optional)
%  face  : cell array of edges in each face
%  hdata : Structure array defining size function data. 
%
% The following checks are performed:
%
%  1. Unique edges in EDGE.
%  2. Only nodes referenced in EDGE are kept.
%  3. Unique nodes in NODE.
%  4. No "hanging" nodes and no "T-junctions".
%
% Checks for self-intersecting geometry are NOT done because this can be 
% expensive for big inputs.
%
% HDATA and FACE may be re-indexed to maintain consistency.

% Darren Engwirda - 2007.

if (nargin<3)
   face = [];
   if (nargin<2)
      edge = [];
      if (nargin<1)
         error('Insufficient inputs');
      end
   end
elseif (nargin>4)
   error('Wrong number of inputs');
end
if (nargout>4)
   error('Wrong number of outputs');
end
nNode = size(node,1);
if isempty(edge)                                                           % Build edge if not passed
   edge = [(1:nNode-1)',(2:nNode)'; nNode,1];
end
if isempty(face)                                                           % Build face if not passed
   face{1} = 1:size(edge,1);
end
if numel(node)~=2*nNode                                                    % Check inputs
   error('NODE must be an Nx2 array');
end
if numel(edge)~=2*size(edge,1)
   error('EDGE must be an Mx2 array');
end
if (max(edge(:))>nNode)||(min(edge(:))<=0)                                 % Check geometry indexing
   error('Invalid EDGE');
end
for k = 1:length(face)
   if isempty(face{k}) || any((face{k}<1) | (face{k}>size(edge,1)))
      error(['Invalid FACE{',num2str(k),'}']);
   end
end
if isfield(hdata,'edgeh') && ~isempty(hdata.edgeh)                         % Check if we've got size data attached to edges
   edgeh = true;
else
   edgeh = false;
end

i = unique(edge(:));                                                       % Remove un-used nodes and re-index
del = nNode-i(end);
if del>0
   node = node(i,:);
   j = zeros(size(node,1),1);
   j(i) = 1;
   j = cumsum(j);
   edge = j(edge);
   i = edge(:,1)~=edge(:,2);
   j = zeros(size(edge,1),1);
   j(i) = 1;
   j = cumsum(j);
   edge = edge(i,:);
   for k = 1:length(face)
      face{k} = unique(j(face{k}));
   end
   disp(['WARNING: ',num2str(del),' un-used node(s) removed']);
   nNode = size(node,1);
end

[i,i,j] = unique(node,'rows');                                             % Remove duplicate nodes and re-index
del = nNode-length(i);
if del>0
   node = node(i,:);
   edge = j(edge);
   i = edge(:,1)~=edge(:,2);
   j = zeros(size(edge,1),1);
   j(i) = 1;
   j = cumsum(j);
   edge = edge(i,:);
   for k = 1:length(face)
      face{k} = unique(j(face{k}));
   end
   disp(['WARNING: ',num2str(del),' duplicate node(s) removed']);
   nNode = size(node,1);
end

nEdge = size(edge,1);
[i,i,j] = unique(sort(edge,2),'rows');                                     % Remove duplicate edges
if edgeh
   hdata.edgeh(:,1) = j(hdata.edgeh(:,1));
   j = zeros(size(edge,1),1);
   j(i) = 1;
   j = cumsum(j);
   edge = edge(i,:);
   for k = 1:length(face)
      face{k} = unique(j(face{k}));
   end
end
del = nEdge-size(edge,1);
if del>0
   disp(['WARNING: ',num2str(del),' duplicate edge(s) removed']);
   nEdge = size(edge,1);
end

nEdge = size(edge,1);
S = sparse(edge(:), [1:nEdge,1:nEdge], 1, nNode, nEdge);                   % Sparse node-to-edge connectivity matrix
i = find(sum(S,2)<2);
if ~isempty(i)                                                             % Check for closed geometry loops
   error(['Open geometry contours detected at node(s): ',num2str(i')]);
end

% i = find(sum(S,2)>2);                                                      % Check for geometry T-junctions
% if ~isempty(i)
%    error(['Multiple geometry branches detected at node(s): ',num2str(i')]);
% end

end      % checkgeometry()

function [cn, on] = inpoly(p, node, edge, reltol)

%  INPOLY: Point-in-polygon testing.
%
% Determine whether a series of points lie within the bounds of a polygon
% in the 2D plane. General non-convex, multiply-connected polygonal
% regions can be handled.
%
% SHORT SYNTAX:
%
%   in = inpoly(p, node);
%
%   p   : The points to be tested as an Nx2 array [x1 y1; x2 y2; etc].
%   node: The vertices of the polygon as an Mx2 array [X1 Y1; X2 Y2; etc].
%         The standard syntax assumes that the vertices are specified in
%         consecutive order.
%
%   in  : An Nx1 logical array with IN(i) = TRUE if P(i,:) lies within the
%         region.
%
% LONG SYNTAX:
%
%  [in, on] = inpoly(p, node, edge, tol);
%
%  edge: An Mx2 array of polygon edges, specified as connections between
%        the vertices in NODE: [n1 n2; n3 n4; etc]. The vertices in NODE
%        do not need to be specified in connsecutive order when using the
%        extended syntax.
%
%  on  : An Nx1 logical array with ON(i) = TRUE if P(i,:) lies on a
%        polygon edge. (A tolerance is used to deal with numerical
%        precision, so that points within a distance of
%        reltol*min(bbox(node)) from a polygon edge are considered "on" the 
%        edge.
%
% EXAMPLE:
%
%   polydemo;       % Will run a few examples
%
% See also INPOLYGON

% The algorithm is based on the crossing number test, which counts the
% number of times a line that extends from each point past the right-most
% region of the polygon intersects with a polygon edge. Points with odd
% counts are inside. A simple implementation of this method requires each
% wall intersection be checked for each point, resulting in an O(N*M)
% operation count.
%
% This implementation does better in 2 ways:
%
%   1. The test points are sorted by y-value and a binary search is used to
%      find the first point in the list that has a chance of intersecting
%      with a given wall. The sorted list is also used to determine when we
%      have reached the last point in the list that has a chance of
%      intersection. This means that in general only a small portion of
%      points are checked for each wall, rather than the whole set.
%
%   2. The intersection test is simplified by first checking against the
%      bounding box for a given wall segment. Checking against the bbox is
%      an inexpensive alternative to the full intersection test and allows
%      us to take a number of shortcuts, minimising the number of times the
%      full test needs to be done.
%
%   Darren Engwirda: 2005-2009
%   Email          : d_engwirda@hotmail.com
%   Last updated   : 28/03/2009 with MATLAB 7.0
%
% Problems or suggestions? Email me.

%% ERROR CHECKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<4
   reltol = 1.0e-12;
   if nargin<3
      edge = [];
      if nargin<2
         error('Insufficient inputs');
      end
   end
end
nnode = size(node,1);
if isempty(edge)                                                           % Build edge if not passed
   edge = [(1:nnode-1)' (2:nnode)'; nnode 1];
end
if size(p,2)~=2
   error('P must be an Nx2 array.');
end
if size(node,2)~=2
   error('NODE must be an Mx2 array.');
end
if size(edge,2)~=2
   error('EDGE must be an Mx2 array.');
end
if max(edge(:))>nnode || any(edge(:)<1)
   error('Invalid EDGE.');
end

%% PRE-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n  = size(p,1);
nc = size(edge,1);

% Choose the direction with the biggest range as the "y-coordinate" for the
% test. This should ensure that the sorting is done along the best
% direction for long and skinny problems wrt either the x or y axes.
dxy = max(p,[],1)-min(p,[],1);
if dxy(1)>dxy(2)
   % Flip co-ords if x range is bigger
   p = p(:,[2,1]);
   node = node(:,[2,1]);
end

% Polygon bounding-box
dxy = max(node,[],1)-min(node,[],1);
tol = reltol*min(dxy);
if tol==0.0
   tol = reltol;
end

% Sort test points by y-value
[y,i] = sort(p(:,2));
x = p(i,1);

%% MAIN LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cn = false(n,1);     % Because we're dealing with mod(cn,2) we don't have
                     % to actually increment the crossing number, we can
                     % just flip a logical at each intersection (faster!)
on = cn;
for k = 1:nc         % Loop through edges

   % Nodes in current edge
   n1 = edge(k,1);
   n2 = edge(k,2);

   % Endpoints - sorted so that [x1,y1] & [x2,y2] has y1<=y2
   %           - also get xmin = min(x1,x2), xmax = max(x1,x2)
   y1 = node(n1,2);
   y2 = node(n2,2);
   if y1<y2
      x1 = node(n1,1);
      x2 = node(n2,1);
   else
      yt = y1;
      y1 = y2;
      y2 = yt;
      x1 = node(n2,1);
      x2 = node(n1,1);
   end
   if x1>x2
      xmin = x2;
      xmax = x1;
   else
      xmin = x1;
      xmax = x2;
   end

   % Binary search to find first point with y<=y1 for current edge
   if y(1)>=y1
      start = 1;
   elseif y(n)<y1
      start = n+1;       
   else
      lower = 1;
      upper = n;
      for j = 1:n
         start = round(0.5*(lower+upper));
         if y(start)<y1
            lower = start+1;
         elseif y(start-1)<y1
            break;
         else
            upper = start-1;
         end
      end
   end

   % Loop through points
   for j = start:n
      % Check the bounding-box for the edge before doing the intersection
      % test. Take shortcuts wherever possible!

      Y = y(j);   % Do the array look-up once & make a temp scalar
      if Y<=y2
         X = x(j);   % Do the array look-up once & make a temp scalar
         if X>=xmin
            if X<=xmax

               % Check if we're "on" the edge
               on(j) = on(j) || (abs((y2-Y)*(x1-X)-(y1-Y)*(x2-X))<=tol);

               % Do the actual intersection test
               if (Y<y2) && ((y2-y1)*(X-x1)<(Y-y1)*(x2-x1))
                  cn(j) = ~cn(j);
               end

            end
         elseif Y<y2   % Deal with points exactly at vertices
            % Has to cross edge
            cn(j) = ~cn(j);
         end
      else
         % Due to the sorting, no points with >y
         % value need to be checked
         break
      end
   end

end

% Re-index to undo the sorting
cn(i) = cn|on;
on(i) = on;

end      % inpoly()

function t = mydelaunayn(p)

% My version of the MATLAB delaunayn function that attempts to deal with
% some of the compatibility and robustness problems.
%
% Darren Engwirda - 2007

% Translate to the origin and scale the min xy range onto [-1,1]
% This is absolutely critical to avoid precision issues for large problems!
maxxy = max(p);
minxy = min(p);
p(:,1) = p(:,1)-0.5*(minxy(1)+maxxy(1));
p(:,2) = p(:,2)-0.5*(minxy(2)+maxxy(2));
p = p/(0.5*min(maxxy-minxy));

try
   % Use the default settings. This will be 'Joggled Input' prior to
   % MATLAB 7.0 or 'Triangulated Output' in newer versions
   t = delaunayn(p);
catch
   if ~(str2double(version('-release'))<=13)
      % 'Triangulated Output' is generally more accurate, but less robust.
      % If Qhull crashes with 'Triangulated Output', redo with 'Joggled
      % Input'
      t = delaunayn(p,{'QJ','Pp'});
   end
end

end      % mydelaunayn()