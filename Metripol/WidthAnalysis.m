dmat;
cd ../AlignmentSamples/xtal5

[f,s]=isfile('*Int.ssf');
for i=1:size(s,1)
    fn=s(i,1:end-11);
    load([s(i,1:end-11) 'Widths.mat']);
    rs(i,:)=r;
    [m,j]=max(r);
    lens(i)=j-min(find(r>0));
    widest(i)=m;
    [ma,mi]=findextrema(r);
    rnz=r(j:floor(ma(end)));
    [ma,mi]=findextrema(rnz);
    is=find(rnz(round(mi))<50);
    m=min(mi(is));
    lens2(i)=m+j-min(find(r>0));
    figure
    plot(rnz); hold on; plot(round(ma),rnz(round(ma)),'ro'); 
    plot(round(mi),rnz(round(mi)),'gs'); 
    d=abs(diff(rnz));
    MaxWireWidth(i)=rnz(end);
    EndPt(i)=length(rnz);
    LoopEndPt(i)=min(find(rnz<MaxWireWidth(i)));
    plot(LoopEndPt(i),rnz(LoopEndPt(i)),'k*')
    lens3(i)=j-min(find(r>0))+LoopEndPt(i);
    [mini,mind]=min(rnz);
    lens4(i)=j-min(find(r>0))+mind;    
end