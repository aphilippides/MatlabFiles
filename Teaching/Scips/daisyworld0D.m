% function daisyworld0D(lower,upper)
%
% 0-D model that shows life can influence global temperature, based on initial work by
% Watson and Lovelock (1983). By Mark Wittwer, 2005.
%
% Arguments: -lower- fraction of current insolation energy at the start of daisyworld.
% -upper- fraction of current insolation energy at the end of daisyworld.
%
% Note: There are constants that can also be changed within the m-file, including:
% -Black daisy albedo (black).
% -White daisy albedo (white).
% -Bare planet albedo (bare).
% -Horizontal heat flux (q).
% -Daisy death rate (death).
% -Present day solar luminosity (S).
% -Lower temperature limit for daisy growth (lowgrowthK).
% -Upper temperature limit for daisy growth (highgrowthK).
% -The minimum daisy area to start growth (startarea).
% -Size of each increment determined by (numba).
%
%
% e.g. daisyworld0D(0.6,1.8)
%
% Outputs: - Growth of each coloured daisy vs time.
% - Lifeless global temperature and daisyworld temperature vs time.
% - Planterary albedo vs time.
function daisyworld0D(lower,upper)
S=1000;
q=15;
black=.25;
bare=.5;
white=.75;
death=.1;
- 83 -
lowgrowthK=278;
highgrowthK=313;
startarea=0.01; %start area as a fraction of 1
numba=100; %number of time steps relative to insolation increase
%calculate number of time steps (numba per 3 billion years)
length=(upper-lower)*numba;
if length~=round(length)
length=round(length);
boof=abs(length);
else boof=abs(length);
end
if length>0
jump=(upper*S-lower*S)/(length-1);
E(1,1)=lower*S; %initialises the lower limit relative to todays insolation
for a=2:length
E(a,1)=E((a-1),1)+jump; %creates the column matrix of solar Energy
end
end
%allows the insolation to be decreasing throughout daisyworld
if length<0
jump=(lower*S-upper*S)/(boof+1);
E(1,1)=lower*S; %initialises the lower limit relative to todays insolation
for a=2:boof
E(a,1)=E((a-1),1)-jump; %creates the column matrix of solar Energy
end
end
if length<0
length=abs(length);
end
SB=5.669*10^-8; %sets the Stefan-Boltzman constant
%initialises the daisy area to 1% to allow growth to start
Ablack=startarea;
Awhite=startarea;
%begin iterations for each time step
for a=1:length
%calculates area of bare ground and planet albedo
Abare=1-Ablack-Awhite;
Ap=Abare*bare+Awhite*white+Ablack*black;
%calculate emission and local temperatures
Temission=((E(a,1)/SB)*(1-Ap))^0.25;
Trock=((E(a,1)/SB)*(1-bare))^0.25;
Tblack=q*(Ap-black)+Temission;
Twhite=q*(Ap-white)+Temission;
%calculate daisy growth- define growth and add previous daisy cover
growthb=Ablack*(beta(lowgrowthK,highgrowthK,Tblack)*Abare-death);
- 84 -
growthw=Awhite*(beta(lowgrowthK,highgrowthK,Twhite)*Abare-death);
Ablack=Ablack+growthb;
Awhite=Awhite+growthw;
%ensure that there is no negative/too much area (numerical procedure)
if Ablack<=startarea
Ablack=startarea;
end
if Ablack>1
Ablack=1;
end
if Awhite<=startarea
Awhite=startarea;
end
if Awhite>1
Awhite=1;
end
%store results
Temissionresults(1,a)=Temission;
Ablackresults(1,a)=Ablack;
Awhiteresults(1,a)=Awhite;
Trockresults(1,a)=Trock;
Apresults(1,a)=Ap;
growthbresults(1,a)=growthb;
growthwresults(1,a)=growthw;
end
%plot the results
figure(1)
plot(1:length,Ablackresults,'k-')
hold on;
plot(1:length,Awhiteresults,'y-')
hold on;
plot(1:length,Awhiteresults+Ablackresults,'g--')
xlabel('Time divisions')
ylabel('Daisy Area')
legend('Black daisies','White daisies','Total area',2)
title('Daisy area versus time')
axis([1 length 0 1])
figure(2)
subplot(2,1,1)
plot(1:length,Temissionresults,'g-')
hold on;
plot(1:length,Trockresults,'r--')
xlabel('Time divisions')
ylabel('Temperature (K)')
legend('Daisyworld','Lifeless world',2)
title('Temperature of Daisyworld versus time')
axis tight;
hold on;
subplot(2,1,2)
plot(1:length,Apresults,'m-')
axis([1 length black white]);
- 85 -
xlabel('Time divisions')
ylabel('Average albedo')
title('Planetary albedo versus time')