% function[ObjC,ObjW] = ObjectsFromFacets(ons,OPT_FAC)
%
% function returns centres and widths of objects from binary array 
% assumes that the array wraps round ie is panoramic
%
% Centres is returned as the average of left and right edges (so can get
% fractional centres) Use OPT_FAC = 1 to round these to whole facets

function[ObjC,ObjW] = ObjectsFromFacets(ons,OPT_FAC)

[objL,objR]=SimpleEdges(ons);
nfac=length(ons);
if(nargin==1) OPT_FAC=0; end;
% If object wraps, shift lefts so always after right
if(isempty(objL))
    ObjC=[];
    ObjW=[];
else
    if(objL(1)<objR(1)) objL=[objL(2:end) objL(1)+nfac]; end;
    ObjW=objL-objR;
    % This gives centres as average position as in LLN
    ObjC=0.5*(objR+objL-1);
    % Use this if you want a central facet
    if(OPT_FAC) ObjC=round(ObjC); end;
    if(ObjC(end)>nfac) ObjC(end)=ObjC(end)-nfac; end;
end

function[objL,objR]=SimpleEdges(ons)
% Calc edges of objects
lr=ons-[ons(end) ons(1:end-1)];
objL=find(lr==-1);
objR=find(lr==1);