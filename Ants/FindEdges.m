function FindEdges(i,i2)
s=ones(5,1);
%s=ones(5);
t=0.08;
load PicsSubSampled4
js=[1:13]
for j=js
    eval(['i=im' int2str(j) ';']);
    if(exist(['im' int2str(100+j)],'var'))
        eval(['ic=im' int2str(100+j) ';']);
        e=mat2gray(rangefilt2files(i,ic,s));
    else
        e=mat2gray(rangefilt(i,s));
    end
% t=median(median(e));
% t=mean(mean(e))/2;
et=e<t;
oer=imerode(et,ones(3));
orem=bwareaopen(oer,100);
oremf=imfill(orem,'holes');
newi=imdilate(oremf,ones(3));
figure;
subplot(1,2,1),imshow(i,[]);
subplot(1,2,2),imshow(newi);
end

function[f] = rangefilt2files(i1,i2,s)
mins=min(imerode(i1,s),imerode(i2,s));
maxes=max(imdilate(i1,s),imdilate(i2,s));
f=maxes-mins;

function houghstuff
[H,T,R] = hough(bw);%,'RhoResolution',0.5,'ThetaResolution',0.5);
P  = houghpeaks(H,10);%,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(bw,T,R,P)%,'FillGap',5,'MinLength',7);
imshow(bw,[]), hold on
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%     % determine the endpoints of the longest line segment
%     len = norm(lines(k).point1 - lines(k).point2);
%     if ( len > max_len)
%         max_len = len;
%         xy_long = xy;
%     end
end
hold off
