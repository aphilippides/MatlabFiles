function[X]=DrawBeeBox(im,c,e,wid,ht)
if(nargin<4) wid=50; end 
if(nargin<5) ht=wid; end 
[mh mw]=size(im(:,:,1));
X([1,3])=max([1,1],round(c-[wid,ht]));
X([2,4])=min([mw,mh],round(c+[wid,ht]));
imagesc(im);
hold on;
plot(e(1),e(2),'b.')
plot([c(1) e(1)]',[c(2) e(2)]','b')
axis equal
axis(X);
hold off