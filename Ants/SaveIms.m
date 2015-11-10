function SaveIms(fn,n)

s=dir('*All.mat');
cs=[];cts=[];
for j=1:length(s)
    load(s(j).name)
    if(j~=4) c=CleanOrients(Orients);
    else c=CleanOrients(Orients,1);
    end
    figure(2),rose(c,36)
    figure(1),plot(t,AngleWithoutFlip(c))
    if(j~=5)     [th,r]=rose(c,36);
    r=r/length(c);
    cs=[cs;r];
    end;
    cts=[cts; Cents];
end
save LM4Data cs cts th
cs=cs+pi;
rose(cs,36)

% fi=aviinfo(fn);
% NumFrames=fi.NumFrames
% nums=1:n:NumFrames; 
% k=strfind(fn,'.avi');
% 
% for num=nums
%     f=aviread(fn,num);
%     im=double(rgb2gray(f.cdata));
%     sfn=[fn(1:k-1) 'ImDataFr' int2str(num) '.mat']
%     save(sfn,'im');
% end