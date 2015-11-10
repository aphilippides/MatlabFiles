
MaxConcs=zeros(1,101);
T_maxC=zeros(1,101);
for i=100:-1:1;
    [MaxConcs(i+1), T_maxC(i+1)] = Tube_tmax(0.25,i+0.25, 0.05)
    save SingleKC_MaxConcData MaxConcs T_maxC
end
MaxConcs=MaxConcs*0.00331;
MaxConcs(1)=5.4515e-009;
T_maxC(1)=0.05;
save SingleKC_MaxConcData MaxConcs T_maxC
plot(0:100,MaxConcs)

% plot(0:100,T_maxC)
