function[newo,head,tail,neck,mneck,neckwid] = GetHeadTail(im,o,c)

% get widths along body axis (NOTE -ve of angle cos of image coords
[r,xp]=radon(im,-o*180/pi);
is=find(r);
rn=r(is);
xn=xp(is);
neck_p=0.85;

% get the mean widths at the tips
np=10;
l=length(rn);
w1=max(rn(1:min(np,l)));
w2=max(rn(max(1,l+1-np):l));

% do a slice along axis of bee through the centroid
l2=size(im,2)/2;
s=l2*[cos(o) sin(o)];
pts=[c-s;c+s];
[cx,cy,c]=improfile(im,pts(:,1),pts(:,2));

% Get end points
js=find(c==1);
e1=[cx(js(1)) cy(js(1))];
e2=[cx(js(end)) cy(js(end))];

% assign head and tail to thin/thick ends
if(w1<w2)
    head=e1;
    tail=e2;
    
    %flip orinetation
    if(o<0) newo=o+pi;
    else newo=o-pi;
    end
else
    head=e2;
    tail=e1;
    newo=o;
end
neck=neck_p*head+(1-neck_p)*tail;

% do a slice perpendicular to axis of bee through neck
s=l2*[cos(o+pi/2) sin(o+pi/2)];
pts=[neck-s;neck+s];
[cx,cy,c]=improfile(im,pts(:,1),pts(:,2));

% Get width, end points and mid-point
js=find(c==1);
neckwid=length(js);
e1=[cx(js(1)) cy(js(1))];
e2=[cx(js(end)) cy(js(end))];
mneck=0.5*(e1+e2);

% imagesc(im)
% hold on;
% plot(head(1),head(2),'rx')
% plot(tail(1),tail(2),'gx')
% plot(neck(1),neck(2),'yx')
% plot(mneck(1),mneck(2),'wx')
% neck-mneck
% hold off