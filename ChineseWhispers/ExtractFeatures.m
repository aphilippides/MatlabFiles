function ExtractFeatures(imnums,seq)

dmat;
seq='h';
cd(['../../Current/ChineseWhispers/' seq '-file\'])

for imnum=imnums

    if(imnum<10) i=imread([seq '0' int2str(imnum) '.tif']);
    else i=imread([seq '' int2str(imnum) '.tif']);
    end

    bw=i<64000;
    % bw=-i+1;
    %  bw=i<250;
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

    if(imnum<10) f=['0' int2str(imnum) '.tif'];
    else f=[int2str(imnum) '.tif'];
    end
    imnum
    plot(MinAx,'k')
    print(gcf,'-dtiff','-r300',[seq '_Width_' f]);
    plot(Areas,'r')
    print(gcf,'-dtiff','-r300',[seq '_Areas_' f]);
    plot(Orients,'c')
    print(gcf,'-dtiff','-r300',[seq '_Orientation_' f]);
    plot(Eccents,'y')
    print(gcf,'-dtiff','-r300',[seq '_Roundness_' f]);
    plot(MajAx,'g')
    print(gcf,'-dtiff','-r300',[seq '_Length_' f]);
    plot(sum(bw))
    print(gcf,'-dtiff','-r300',[seq '_HowManyPixels_' f]);
    plot(min(i),'m')
    print(gcf,'-dtiff','-r300',[seq '_MinimumPixel_' f]);
end

% for i=1:n
%
%
%     imagesc(-bw);
%     hold on;
%     Cents(i,:)=[S(i).Centroid];
%     plot(Cents(i,1),Cents(i,2),'rx')
%     ps=S(i).PixelList;
%     plot(ps(:,1),ps(:,2),'g')
%     MyEllipse(MajAx(i),MinAx(i),Cents(i,:),Orients(i));
%     hold off;
%     pause
% end