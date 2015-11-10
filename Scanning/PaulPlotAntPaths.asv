%PaulPlotAntPaths
s=dir('*_ProgWhole*');js=[1:length(s)];
for j=js
    f=s(j).name
    load(f)
    mf=[f(1:end-14) '.mov'];
%     im=MyAviRead(mf,1,1);
%     im=MyAviRead(mf,FrameNum(end),1);
    [inf,nf]=MyAviInfo(mf);
        dat(j,:)=[length(NumBees) nf];

%     figure(1)
%     imagesc(im),axis equal
%     hold on
%     FrameNum([1 end])
%     LMfn=[f(1:end-14) 'NestLMData.mat'];load(LMfn);
%     blist=unique(WhichB)
%     sqx=[-10 -10 10 10];sqy=[-7.5 7.5 7.5 -7.5];
%     TFORM = cp2tform([LM(:,1) LM(:,2)],[sqx' sqy'],'projective');
% 
%     for i = blist
%         % for each label get the indices and plot their centroids
%         is=find(WhichB==i);
%         nis=length(is);
%         if(nis>1)
%             disp(['Path ' int2str(i) ' is ' int2str(nis) ' frames.'])
% 			[newX,newY] = tformfwd(TFORM,Cents(is,1),Cents(is,2));
% 			newX=Cents(is,1); newY=Cents(is,2);
%             plot(newX,newY)
%             text(newX(1),newY(1),int2str(i))
% %             axis equal;axis([-14 14 -12 11])
% %             plot([sqx -10],[sqy -7.5])
%             title([int2str(j) ': ' f(1:end-14)])
%         end%if nis>1
%     end%i blist
%     hold off
%      figure(2), 
%      plot(1:length(NumBees),NumBees,nf,0.5,'gs'),axis tight
%     goodf(j,:)=0;
%      BestAnt=input('type number of best ant (0 for no good ant)');
%      if(isequal(BestAnt,1))
%          keyboard;
%      elseif(isempty(BestAnt))
%          goodf(j)=1;
%      end
%      save(f,'BestAnt','-append');
     
end%j files
