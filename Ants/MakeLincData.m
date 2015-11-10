function MakeLincData

dmat
cd Ants
load AntEyeData

[lbs,rts,w,h,a]=DoMappingSimple;
CentPos=[0,0,0];

Heading =ccarts(1,:)+CentPos;
n=size(ccarts,1);
%RelCents=[s_es' ones(n,1)*ccarts(1,:)-ccarts lbs rts]';
RelCents=[s_es'*360/pi ccarts-ones(n,1)*ccarts(1,:) lbs w h a]';

fid=fopen('EyeData.txt','w');
fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',RelCents);
fclose(fid)


function[lbs,rts,w,hts,asp]=DoMappingSimple
load AntEyeData
[th,el,rs]=cart2sph(ccarts(:,1),ccarts(:,2),ccarts(:,3));
ws=s_es'./(pi*cos(el));
cx_s=-th/pi;  
%cy_s=el*2/pi;
% cy_s=el*2/pi;
h=1/length(RowCount);
hs=0:h:1-h;
rc=[0 cumsum(RowCount)];
for i=1:length(RowCount)
    cy_s(rc(i)+1:rc(i+1))=hs(i);
end
cy_s=cy_s';
cx_s=0.5*(cx_s+1);
ws=0.5*ws;
lbs=[cx_s-ws cy_s];
rts=[cx_s+ws cy_s+h];

x_s=[cx_s-ws cx_s-ws cx_s+ws cx_s+ws cx_s-ws];
y_s=[cy_s cy_s+h cy_s+h cy_s cy_s];
hts=ones(size(ws))*h;
w=2*ws;
asp=w/h;

for i=1:length(ws)
    plot(x_s(i,:),y_s(i,:))
    hold on;
end
hold off;
