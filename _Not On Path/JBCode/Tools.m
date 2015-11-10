% function test
% 
% Agent=[300 300] ;
% nest=[Agent 5] ;
% %Obj = RndEnvironment(10,[1 600],10,nest,1)
% Obj = [500 300 10 ;
%        450 450 10 ;
%        300 500 10 ;
%        250 300 10 ;
%        510 90 10 ]
% 
% BigestObject = max(Obj(:,3)) ;
% fac_awidth = 2*pi/90;
% SideEffectWidth = BigestObject/sin(0.5*fac_awidth) ;
% figure(10)
% hold off ;
% DrawEnvironment(Obj,nest) ;
% hold on ;
% MyCircle(Agent,SideEffectWidth,'k') ;
% hold off ;
% 
% DrawVectors(300, 300 , Obj)
% 


####% %     %###########
% %     %###########
%
% %     figure(9) ;
% %     hold off ;
% %     DrawEnvironment(obj,nest) ;
% %     hold on ;
% %     Tools(nest(1),nest(2),obj) ;
% %     [U,V]=meshgrid([X(1,97):5:X(1,end-92)],[Y(97,1):5:Y(end-92,1)]);
% %     Tools(U,V,obj) ;
% %     axis([X(1)  X(end)  Y(1)  Y(end)]) ;
% %     hold off ;
%     
%     %##############
%     %##############
#####

function Tools(U,V,Obj)
DrawVectorsForGrid(U,V,Obj)


###%Normalize


function DrawVectorsForGrid(U,V,Obj)
for i=1:size(U,1)
   for j=1:size(V,1)
       DrawVectors(U(i,j),V(i,j),Obj)      
   end
end


function DrawVectors(u,v,Obj)

[ons,lr,ons3,obc3,vectors2,vectors,alv,homvect,vectors3]=ComputeVectors(u,v,Obj);

DrawBars(ons,lr,ons3,obc3,vectors2);

% resize vectors
vectors2=10*vectors2 ;
alv=10*alv ;
vectors=10*vectors ;
homvect=10*homvect;

n_ob = size(vectors,1);
n_ob2 = size(vectors2,1);
n_ob3 = size(vectors3,1);

%Draw vectors
figure(9)
hold on;
%quiver(u*ones(n_ob,1),v*ones(n_ob,1),vectors(:,1),vectors(:,2))
hold on;
quiver(u*ones(n_ob2,1),v*ones(n_ob2,1),vectors2(:,1),vectors2(:,2),'b')
hold on ;
%quiver(u*ones(n_ob,1),v*ones(n_ob,1),vectors_norm(:,1),vectors_norm(:,2))
hold on ;
quiver(u*ones(n_ob3,1),v*ones(n_ob3,1),vectors3(:,1),vectors3(:,2))
hold on ;
quiver([u;u],[v;v],[alv(1);alv(1)],[alv(2);alv(2)],'g')
hold on ;
quiver([u;u],[v;v],[homvect(1);homvect(1)],[homvect(2);homvect(2)],'xr')
%axis([470  530  475  535]);
hold off ;


function DrawBars(onsRaw,ChosenGEV,onsLV,obcLV,GEVvectors)

% ons bruts
figure(10);
hold off ;
set(gcf,'Name','ons brut');       
bar(onsRaw);
axis([0  90  0  1.1]) ;
hold off ;

% retenus GreyEdgeVision
figure(11);
hold off ;
set(gcf,'Name','retenus GreyEdgeVision');
bar(ChosenGEV);
axis([0  90  0  1.1]) ;
hold off ;

% ons seuillé LincVision
figure(12);
hold off ;
set(gcf,'Name','ons seuillé LincVision');
bar([1:90] , onsLV);
axis([0  90  0  1.1]) ;
hold off ;

% objets retenus LincVision
figure(13);
hold off ;
set(gcf,'Name','objets retenus LincVision');
if (~isempty(obcLV))
   bar(obcLV,ones(size(obcLV)),0.15);
end
axis([0  90  0  1.1]) ;
hold off ;

% retenus GreyEdgeVision rassemblé
figure(14);
hold off ;
set(gcf,'Name','retenus GreyEdgeVision rassemblé');
coef1 = zeros( size(GEVvectors,1) , 1 ) ;
coef1( find(GEVvectors(:,1)<0) ) = pi ;
coef2 = zeros( size(GEVvectors,1) , 1 ) ;
coef2( find( GEVvectors(:,1)>=0 & GEVvectors(:,2)<0 ) ) = 2*pi ;
barres = zeros(1,90);
barres(round((atan( GEVvectors(:,2)./GEVvectors(:,1) ) + coef1 + coef2 )' / (pi/45))) = sqrt( GEVvectors(:,1).^2+GEVvectors(:,2).^2)';
bar(barres) ;
axis([0 90 0 3]) ;
hold off ;


function[ons,lr,ons3,obc3,vectors2,vectors,alv,homvect,vectors3]=ComputeVectors(u,v,Obj)
%~~~~~
[obchom,obwhom,onshom,lrhom]=GreyEdgeVision(Obj,[500 500]);
angshom=obchom*pi/45;
alvhom=[sum(cos(angshom).*obwhom) sum(sin(angshom).*obwhom)];
%~~~~~

[obc,obw,ons,lr]=GreyEdgeVision(Obj,[u v]);
angs=obc*pi/45;

[obc3,obw3,ons3]=LincVision(Obj,[u v]);
obc3=obc3+1;

if(obw~=-1)
    vectors=[cos(angs').*obw' sin(angs').*obw'];
    %vectors_norm=vectors(:,1)./sqrt(vectors(:,1).^2+vectors(:,2).^2);
    %vectors_norm=50*[vectors_norm vectors(:,2)./sqrt(vectors(:,1).^2+vectors(:,2).^2)];

    alv=[sum(cos(angs).*obw) sum(sin(angs).*obw)];

    homvect=alv-alvhom;

    obc2=obc;
    obw2=obw;

    k=0;
    vectors2=zeros(length(obc3),2);
    pond=zeros(length(obc3),1);

    if(~isempty(obc3))

        while length(obc2)>0
            for l=1:length(obc3)
                if (obc3(l)-k<=0)
                    s=obc3(l)-k+90;
                else
                    s=obc3(l)-k;
                end
                q=find(obc2==s);
                if (~isempty(q))
                    vectors2(l,:)=vectors2(l,:)+[cos(obc2(q)*pi/45).*obw2(q) sin(obc2(q)*pi/45).*obw2(q)];
                    pond(l)=pond(l)+1;
                    obc2(q)=[];
                    obw2(q)=[];
                end
            end

            for l=1:length(obc3)
                if (obc3(l)+k>90)
                    s=obc3(l)+k+90;
                else
                    s=obc3(l)+k;
                end
                q=find(obc2==s);
                if (~isempty(q))
                    vectors2(l,:)=vectors2(l,:)+[cos(obc2(q)*pi/45).*obw2(q) sin(obc2(q)*pi/45).*obw2(q)];
                    obc2(q)=[];
                    obw2(q)=[];
                end
            end
            k=k+1;
        end
    else
        vectors2=vectors;
    end
else
    vectors2=[NaN NaN];
    vectors=[NaN NaN];
    alv=[NaN NaN];
end

if(obw3==-1)
    n_ob3=-1;
    alv3=[NaN NaN];
    vectors3=[NaN NaN];
else n_ob3=length(obc3);
    if(n_ob3>0)
        angs3=obc3*pi/45;
        vectors3=30*[cos(angs3') sin(angs3')];
    else
        vectors3=[NaN NaN];
    end
end