function CropPixProForRotating
load snapshots
load snapshotsCentroidEtc
outer=round(out);
ma=cent+outer;
ma=round(ma);
mi=cent-outer;
mi=round(mi);
for i=1:length(snaps)
    snapsCrop(i).im=snaps(i).im(mi(2):ma(2),mi(1):ma(1),:);
end
clear i
save snapshotsAll