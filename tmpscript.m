ts=GetSecs;
for i=1:5
%     MyAviRead(s(1).name,i);
    g=aviread(s(1).name,i);
    jj(i)=GetSecs-ts
end
