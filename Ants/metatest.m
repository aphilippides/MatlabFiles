function[d2,bad]= metatest(in,i2,ba,i,num)
load 90_21_RefsAndPointsV1

d2=[];
bad=[];
count=0;
while(count<20)
    for i=bigs
        r=randperm(10);
        n=[setdiff(bigs,i) others(r(1:num))];
        d=AlignCameras(in,i2,ba,i,n,refpoints,0);
        d2=[d2;d]
        bad=[bad length(find(d>0.2))]
    end
    count=count+1;
end
subplot(2,1,1)
pcolor(d2)
subplot(2,1,2)
plot(bad)

bigs = [3,   7, 11, 16]
hts  = [12, 23, 15,  8]
others=[1 2 5 6 8:10 12:14]
bads=[4 15];