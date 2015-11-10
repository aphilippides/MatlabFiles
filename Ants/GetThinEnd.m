function[newo] = GetThinEnd(im,o,c,ma,len)
%Get end points
e1 = GetEndPt(im,o,ma,c);
e2 = GetEndPt(im,o-pi,ma,c);

% Get list of points from end point 1 towards centre
l=floor(sqrt(sum((e1-c).^2)));
[l1 l2]=pol2cart(o,l:-1:l-len);
x1=round(l1+c(1));
y1=round(l2+c(2));

% Get list of points from end point 2 towards centre
l=floor(sqrt(sum((e2-c).^2)));
[l1 l2]=pol2cart(o-pi,l:-1:l-len);
x2=round(l1+c(1));
y2=round(l2+c(2));

% Get list of widths
o_perp=o+pi/2;
for i=1:length(x1)
    wid1(i)=GetWidthAtPt(im,[x1(i) y1(i)],o_perp,ma);
    wid2(i)=GetWidthAtPt(im,[x2(i) y2(i)],o_perp,ma);
end

% if thin end at bottom, flip angle
if(sum(wid2)<sum(wid1)) newo=o-pi;
else newo=o;
end

function[w,w1,w2] = GetWidthAtPt(im,p,o,mw)
% make sure no holes
im=imfill(im,'holes');
% generate vector of points to check
[l1 l2]=pol2cart(o,0.5:0.5,mw);
x=round(l1+p(1));
y=round(l2+p(2));
% Step through and get the end point
for i=1:length(x)
    if(~im(y(i),x(i))) break; end;
end
w1=[x(i-1) y(i-1)];
% Repeat for vector of points going other way
[l1 l2]=pol2cart(o+pi,0.5:0.5,mw);
x=round(l1+p(1));
y=round(l2+p(2));
% Step through and get the end point
for i=1:length(x)
    if(~im(y(i),x(i))) break; end;
end
w2=[x(i-1) y(i-1)];
w=sqrt(sum((w1-w2).^2));