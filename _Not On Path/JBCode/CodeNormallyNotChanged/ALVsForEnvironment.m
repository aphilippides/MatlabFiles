function[NObj,mx,my,snapx,snapy]=ALVsForEnvironment(X,Y,O,startpt)

[obc,obw]=PerfectVision(O,[startpt(1) startpt(2)]); %LincVision/EdgeVision/FacetVision/Perfect
[no,snap]=GetALVs(obc,obw);
snapx=snap(1);
snapy=snap(2);
for i=1:size(X,1)
    for j=1:length(X)
        [obc,obw]=PerfectVision(O,[X(i,j) Y(i,j)]); %LincVision/EdgeVision/FacetVision/Perfect
        [NObj(i,j),alv]=GetALVs(obc,obw);
        mx(i,j)=alv(1);
        my(i,j)=alv(2);
    end
end