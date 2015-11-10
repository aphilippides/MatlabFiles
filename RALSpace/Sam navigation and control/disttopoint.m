function dist=disttopoint(currentnorthing,currenteasting,endnorthing,endeasting)
    dist=sqrt((endnorthing-currentnorthing)^2+(endeasting-currenteasting)^2);
end