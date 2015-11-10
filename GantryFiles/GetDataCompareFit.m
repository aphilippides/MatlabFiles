function GetDataCompareFit(Opt,DirName,RunNum)

if(nargin<3) RunNum=1:20;end		% default action

if(Opt==0)
   dvolsig1;
else
    %ddelay;
end

for i=1:length(RunNum)
    fn=['Data/' DirName '/Run' int2str(RunNum(i)) '/pop.dat']; 
    if(IsFile(fn))
        M=load(fn);
        M(end,1)
        if((M(end,2)<1.0)&(M(end,1)<9999))
            RunLength(i)=10001;
        else
            RunLength(i)=M(end,1);
        end
    else
        RunLength(i)=nan;
    end
end
M2=[RunNum', RunLength'];
plot(RunNum, sort(RunLength));
fn=['Data/' DirName '/RunLengths.dat']
save(fn,'M2','-ascii')
axis tight