function UnwrapImages
s=dir('*.jpg');
for i=1:(length(s))
    i
    fn=s(i).name;
    [unw,cs(i,:)]=UnwrapPan(fn,2542,220,10,360,46,115);
    save([fn(1:end-3) 'mat'],'unw');
    save cents cs
%     load([fn(1:end-3) 'mat'])
%     imagesc(unw);
end