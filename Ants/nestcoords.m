s=dir('*.avi')
is=[1:length(s)];
for j=is
    f=s(j).name(1:end-4)
    lmn=GetNestAndLMData(f);
    while 1
        inp=input('type 0 to continue')
    if(inp==0) break; end;
    end
end

%To change zoom GetNestAndLMData.m

%The size of the axis is set by line 16:

 %       AxX=[400 1000 300 700];
