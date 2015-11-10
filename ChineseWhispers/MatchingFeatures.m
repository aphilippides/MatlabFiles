function MatchingFeatures(orig)

dmat
cd(['../../Current/ChineseWhispers/match/'])
o=1-imread([orig '15.tif']);
[on,oa,oo,oe,omin,omax]=GetFeatures(o);
on=1:on;
lets={'g';'h';'m';'t';'u'};
% lets={'g';'h';'m'};
Printing=1;
for i=1:5
    im=1-imread([char(lets(i)) '01.tif']);
    [in,ia,io,ie,imin,imax]=GetFeatures(im);
    in=1:in;

    fn=[orig '15_vs_' char(lets(i)) '1_Features_']
%    figure(1),
    plot(on,oa,in,ia,'r');title('Areas')
    if(Printing) print(gcf,'-dtiff','-r300',[fn 'Areas.tif']); end;
%    figure(2),
%     plot(on,oo,in,io,'r');title('Orientations')
%     if(Printing) print(gcf,'-dtiff','-r300',[fn 'Widths.tif']); end;
%    figure(3),
%     plot(on,oe,in,ie,'r');title('Eccentricity')
%     if(Printing) print(gcf,'-dtiff','-r300',[fn 'Widths.tif']); end;
%    figure(4),
    plot(on,omax,in,imax,'r');title('Lengths')
    if(Printing) print(gcf,'-dtiff','-r300',[fn 'Lengths.tif']); end;
%    figure(5),
    plot(on,omin,in,imin,'r');title('Widths')
    if(Printing) print(gcf,'-dtiff','-r300',[fn 'Widths.tif']); end;
%    figure(6),
    plot(sum(o)),hold on;
    plot(sum(im),'r'),hold off,title('Pixels in column')
    if(Printing) print(gcf,'-dtiff','-r300',[fn 'Pixels.tif']); end;
    pause
end

function[NumObjects,Areas,Orients,Eccents,MajAx,MinAx]=GetFeatures(bw)
tlil=100;
nosmall=bwareaopen(bw,tlil,8);

[L,n] = bwlabeln(nosmall, 8);
NumObjects=n;
S = regionprops(L,'Area','Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength','BoundingBox','PixelList');

Areas=[S.Area];
Orients=-[S.Orientation]*pi/180;
Eccents=[S.Eccentricity];
MajAx=[S.MajorAxisLength]/2;
MinAx=[S.MinorAxisLength]/2;
