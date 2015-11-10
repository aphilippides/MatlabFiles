dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
for i=1:11
    figure,h=load(['mask' int2str(i) '.txt']);imshow(h)
end
    
% figure,h=load('mask6.txt');imshow(h)
% figure,h=load('mask10.txt');imshow(h)
% figure,h=load('mask3.txt');imshow(h)
% figure,h=load('mask4.txt');imshow(h)
% figure,h=load('mask8.txt');imshow(h)
% figure,h=load('mask8.txt');imshow(h)