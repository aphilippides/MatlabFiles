clear all
cd ('D:\Experiment\Bee2011\hm-32-top-030811')
load('D:\Experiment\Bee2011\hm-32-top-030811\hm-32-top-030811-total.mat')
pref=input('Enter the file name prefix: ','s');
N=17; %half of the side of the square around the clicked points
arr=20;

area_n=[80]; 
orient=[];
perim=[];
majorax=[];
minorax=[]; 
ecc=[];
cent=[];
oAnt_pr=[];
isClicked_pr=[]; 

Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
[oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

for k=2:length(isClicked)
    i=isClicked(k)
    x1=round(AntennaeBase(k*2-1,1));
    y1=round(AntennaeBase(k*2-1,2));
    
    % 25b-080811 - i*2
    % hm29-top-030811 - i*2-1 
    %Hm24-080811  - i*2
    % HM19-0808  i*2
    % Hm5-0708_750_1305.mat   k*2-1, level=0.37
    % hm-27-top-030811 seg1 level*1.5, k*2-1
    % HM12-0808, k*2, level aut
    
%     x2=AntennaeBase(i*2,1)
%     y2=AntennaeBase(i*2,2)
  

    if(i<10) sn=['000' int2str(i) '.jpeg'];
    elseif(i<100) sn=['00' int2str(i) '.jpeg'];
    elseif (i<1000) sn=['0' int2str(i) '.jpeg'];    
    elseif (i<10000) sn=['' int2str(i) '.jpeg']; 
    else sn=[int2str(i) '.jpeg'];
    end
    
    im=imread(sn);
    im=im(y1-N:y1+N,x1-N:x1+N);
    im=imadjust(im, [0.15 0.4], []);
    level =graythresh(im)
    bw=im2bw(im, level);
    
%     
%     imshow(bw)
    
    
    spots= bwconncomp(bw,4);
    params=regionprops(spots, 'Area', 'Orientation', 'Perimeter', 'Centroid', ...
        'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');
    
    % We are trying to discriminate between the two cases. In one, the
    % spots would rotate during saccades/slopy pauses, and it's area,
    % length of the axes and centroid won't change. In the other, it will
    % morph instead of rotating as a solid body, i.e. the Orientation
    % parameter will change unpredictably, as well as the area, axis length
    % and centroid params. Orientation may be not a good parameter for
    % round spots, i.e. with Centroid close to 0.
    
%     spots_areas=[params.Area];
% keyboard
%     [min_d, idx]=min(
%     [max_ar,idx]=max(spots_areas);
    coords=[params.Centroid];
    
    dist=(size(bw,1)/2-coords(1:2:end)).^2+(size(bw,2)/2-coords(2:2:end)).^2;
    
    ar=[params.Area];
    
    ind_ar=find(ar>20 & ar<100);
    dist_c=dist(ind_ar);
%     arr=(area_n-ar).^2;
    
%     [v_d,~]=sortrows(dist');
%     [v_a,~]=sortrows(arr');
     
%     rank_d=[]; rank_a=[];
%     
%     for j=1:length(v_d)
%         rank_d=[rank_d; min(find(v_d==dist(j)))];
%         rank_a=[rank_a; min(find(v_a==arr(j)))];
%     end;
    
  
    
%     keyboard
    
%     idx=find(dist==min(dist_c));
    
% if (isempty(ind_ar) )
%     idx=min(find(dist==min(dist)));
% else idx=min(find(dist==min(dist_c)));
% end;

hold on
%    
    
   if (~isempty(ind_ar) )
       
       idx=min(find(dist==min(dist_c)));
       
%         plot(coords(idx*2-1), coords(idx*2), 'or')
        
        
    params=params(idx);
    arr=ar(idx);    
    
    area(k)=[params.Area]
    orient(k)=[params.Orientation];
    perim(k)=[params.Perimeter];
    majorax(k)=[params.MajorAxisLength];
    minorax(k)=[params.MinorAxisLength];
    ecc(k)=[params.Eccentricity];
    cent(k,:)=sqrt(params.Centroid(1)^2+params.Centroid(2)^2);
%     oAnt_pr=[oAnt_pr; oAnt(k)];
%     isClicked_pr=[isClicked_pr; i];
   end;

% % %      
%       keyboard 
end;
area=area';
% orientation of the line that connects spots
% Ant=AntennaeBase(1:2:end, :)-AntennaeBase(2:2:end, :);
% [oAnt, dAnt]=cart2pol(Ant(:,1), Ant(:,2));

cd ('D:\Experiment\Bee2011\Clicked\Spots')
save ([pref '_SpotsAnalysis.mat'], 'oAnt', 'isClicked', 'area', 'orient',...
    'perim', 'majorax', 'minorax', 'ecc', 'cent')

figure
plot(oAnt*180/pi, 'r')
hold on
plot(orient, 'b')
plot(ecc, 'g')
plot(area, 'k')