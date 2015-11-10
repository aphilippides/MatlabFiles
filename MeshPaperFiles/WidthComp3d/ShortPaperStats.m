function ShortPaperStats(T)
if(nargin<1) T=1; end;

d3dmm
wid=[1,2,3,4,5];
Vers=100:130;
Sl=3;
T2Rise=[];
for j=1:length(wid)
%     if(j==2) Vers=51:70;
%     elseif(j==3) Vers=51:70;
%     else Vers=50:79; 
%     end
    for i=1:length(Vers)			% Get average data
        % filename=['MinW' int2str(wid(j)) 'Rho100/TreeSst1V' int2str(Vers(i)) 'MaxGr200X100Z100Sq1Sp10Sl' num2str(Sl) '.dat'];
        filename=['MaxW' int2str(wid(j)) 'Rho100/TreeSst1V' int2str(Vers(i)) 'MaxGr200X100Z100Sq1Sp10Sl' num2str(Sl) '.dat'];
        M=load(filename);
        GrSize=(M(1,3)-M(1,2)).^3;
        Is=find(M(2:end,4)~=GrSize);
        if(~isempty(Is)) T2Rise(i,j)=M(Is(1)+1,1);
        else T2Rise(i,j)=-100;
        end
        T2Rise;
    end
end
AvgT= mean(T2Rise)
SDT=std(T2Rise)
% save Times2RiseV50_79SSt1Gr300X100Sq1Wids1_5.dat T2Rise -ascii 
% save Times2RiseV50_79SSt1Gr300X100Sq1Wids1_5.mat T2Rise AvgT SDT  wid
save Times2RiseV100_130SSt1Gr200X100Sq1Wids1_5_100nM.mat T2Rise AvgT SDT  wid

