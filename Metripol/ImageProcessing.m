%function ImageProcessing

dmat;
cd ../AlignmentSamples/xtal5

[f,s]=isfile('*Int.ssf');
mov = avifile('IntensityLoop.avi','fps',3,'compression','None')
for i=1:size(s,1)
    fn=s(i,1:end-7)
    t1=min(strfind(fn,'.'));
    t2=max(strfind(fn,'_'));
    ab=sscanf(fn(t1+1:t2-1),'%d,%d');
    ang(i)=60*ab(1)+ab(2);
    %fn=['14may_lys5c134d12.59,04s_550.mpl'];
%    [f,c]=ReadSSF(fn,1);
    f=ReadSSFOld(fn,1);
    im=1;
   %  if(im) figure;end;
    [x,Centroids(i,:),areas(i),bounds,WPt,XPt,minXPt,CrossPts,LoopAx,LBound,WBound,CutOff]=GetLoop(f,im);
    F = getframe(gca);
    mov = addframe(mov,F);
    WireSizes(i,:)=[VecNorm(WPt(1,:)-WPt(2,:)) VecNorm(WPt(2,:)-WPt(3,:)) VecNorm(XPt(1,:)-XPt(3,:)) VecNorm(minXPt(1,:)-minXPt(3,:))];
    WirePtsAx(i,:)=[minXPt(2,:) WPt(2,:) CrossPts' WPt(1,:) CutOff WPt(3,2)];
    WirePtsX(i,:)=[XPt(1,:) XPt(2,:) XPt(3,:) minXPt(1,:) minXPt(2,:) minXPt(3,:)];
    EndPt(i,:)=LoopAx(2,:);
    BBox=[min(LBound(:,2))-1 min(LBound(:,1))-1 max(LBound(:,2))-min(LBound(:,2))+2 max(LBound(:,1))-min(LBound(:,1))+2];
    BBoxLoop(i,:)=BBox;
    [lpt,lptind]=min(LBound(:,2));
    LeftPt(i,:)=[lpt,LBound(lptind,1)];    
    %save WireStatsT0Sm0DeB0.mat Centroids areas WireSizes WirePtsAx WirePtsX EndPt BBoxLoop

    loop=ImposeBBox(x,BBox);
    cent=Centroids(i,:);
    %save([fn(1:end-4) 'Loop.mat'],'cent','BBox','loop');
    sind=ReadSSFOld(fn,3);
    sind=imposeBBox(sind,BBox);
    sind=SetToColMask(sind,imcomplement(loop),0);
    crys_adj=imadjust(sind,stretchlim(sind,0),[]);
    %save([fn(1:end-4) 'Crystal.mat'],'cent','BBox','crys_adj','loop','sind');
end
mov = close(mov);
% %xnew=ImposeBBox(x,BBox);
% %save IntData.mat cents areas BBox xnew
% load IntData
% fn=['14may_lys5c134d12.59,04s_550.mpl'];
% s=ReadSSFOld(fn,3);
% s=imposeBBox(s,BBox);
% SetToColMask(s,imcomplement(xnew),0);
% sn=imadjust(s,stretchlim(s,0),[]);
% for i=8:11%size(s,1)
% %    crys_adj=ImposeBBox(crys_adj,BBox([1 );
%     fn=[s(i,1:end-11) 'Crystal.mat'];
%     load(fn);
%     sn=AdjustGamMask(crys_adj,loop,0.25);
%     figure, imshow(sn);
%     ShowTom(sn);
% end
