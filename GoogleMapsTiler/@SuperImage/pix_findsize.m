function [height,width] = pix_findsize(obj,i1,j1,i2,j2)
height = abs(obj.pix_finddist(i1,j1,i2,j1));
width  = abs(obj.pix_finddist(i1,j1,i1,j2));