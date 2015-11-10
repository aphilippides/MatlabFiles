% function choicecoords

FList12=dir('PIC*.MP4');
% FList12=dir('PIC_0434.MP4');
is=[1:length(FList12)];

FullFrame=1;
for i=is
    %     d=ProcessBeeFileName2012(FList12(i).name);
    %  fn=[s(i).name(1:end-4) '_ProgWhole.mat'];
    fn=[FList12(i).name(1:end-4) '_Prog.mat'];
    vidfn=[FList12(i).name]
    maskfn=[vidfn(1:end-4) 'NestLMData.mat'];
    
    %(1:end-4) '.avi'];    
    if(~isfile(maskfn))
        [v,vobj]=VideoReaderType(vidfn);
        GetMaskChoice(vidfn,vobj,maskfn,i);
        drawnow;
    end
end