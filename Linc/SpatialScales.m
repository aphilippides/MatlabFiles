function SpatialScales(n,sn)
dwork
cd ../Current/Linc/WithoutWalls
s=dir('*.bmp');
if(nargin<2) sn=30; end;%floor(length(s)/2);
% fn=s(sn).name;
% load([fn(1:end-3) 'mat'])
ns=[2,4,8,16,32,45,90,180,360];
for i=1:length(s)
    i
    fn=s(i).name;
    fm=[fn(1:end-3) 'mat'];
    StoreData(fm,ns)
%     load([fn(1:end-3) 'mat']);
%     d=snap-ss;
%     absdiff(i)=sqrt(sum(sum(d.^2)));
end

function StoreData(fn,ns)
load(fn);
im=unw(end:-1:1,:);
for n=ns
    ss=SubSampleMean(im,n);
    save(['SS/' fn(1:end-4) 'SS' int2str(n) '.mat'],'ss')
end