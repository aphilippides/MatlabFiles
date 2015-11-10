function[sp,t]=GetSpikes1(fout,tlev,smlen)%,is)
if(nargin>1)
    load(fout,'t','dat','Chan*','A_*','B_*','C_*')
    fn2=['Spike' fout(1:end-4) '.mat'];
elseif(isstruct(fout))
    t=fout.t;
    dat=fout.dat;
    tlev=fout.tlev;
    smlen=fout.smlen;
    load(fout.fn,'Chan*','A_*','B_*','C_*')
    fn2=fout.spfn;
else
    load(fout)
    fn2=['Spike' fout(1:end-4) '.mat'];
end
% sdat=dat;
nch=(size(dat,2));
for i=1:nch
    disp(['Extracting spikes from channel ' int2str(i) '/' int2str(nch)])
    a=dat(:,i);
    as=SmoothVec(a,smlen)';
%     sdat(:,i)=as;
    sp(i).v=iqr(a-as)*tlev;
%     sp(i).v=iqr(a(is)-as(is))*tlev;
    sp(i).med=median(a);
    sp(i).sp=ExtractSpikes(a,as,sp(i).v);
end
% fn=[fout(1:end-4) 'Smooth.mat'];
% save(fn,'sdat');
save(fn2,'sp','t','tlev','smlen','Chan*','A_*','B_*','C_*');%,'is'