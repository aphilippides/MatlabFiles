function[SumIm]= RealSlicePic(Thresh)

load ImageRed.mat;

ImRed=double(Image1Red(601:800,201:400));
ImThresh=(ImRed>Thresh);
for i=1:100
   for j=1:100
      SumIm(i,j)=ImThresh(i,j)+ImThresh(i+1,j)+ImThresh(i,j+1)+ImThresh(i+1,j+1);
   end
end

pcolor(SumIm>=3);
