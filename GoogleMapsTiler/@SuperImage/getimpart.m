function impart = getimpart(obj,s1,s2)
impart = NaN([length(s1),length(s2),3-2*obj.Grayscale]);

dd = gm_datadir;
im_pix = obj.ImPix;
nsubim_tot = obj.Units*obj.SubImsPerFile;
rowoff = im_pix(1)*(0:nsubim_tot(1));
coloff = im_pix(2)*(0:nsubim_tot(2));
for i = 1:obj.Units(1) % rows
    rowsel = s1 > rowoff(i) & s1 <= rowoff(i+1);
    if any(rowsel)
        for j = 1:obj.Units(2) % columns
            colsel = s2 > coloff(j) & s2 <= coloff(j+1);
            if any(colsel)
                fname = sprintf('%s/%s_%04d,%04d',dd,obj.DataLabel,i,j);
                load(fname,'im');

                impart(rowsel,colsel,:) = im2double(im(s1(rowsel)-rowoff(i),s2(colsel)-coloff(j),:));
            end
        end
    end
end