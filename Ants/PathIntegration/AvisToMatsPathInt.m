function AvisToMatsRAL
% vO=1 means use videoReader, 0 = use mmread (slow)
% vO=1;

FList12=dir('*.mp4');

% % check all the file names are ok
% ch_out=CheckAviNames2012(FList12);
% if(ch_out==0)
%     return;
% end

is=[1:length(FList12)];
for i=is
    dn=[FList12(i).name(1:end-4)];
    if(~isdir(dn))
        mkdir(dn);
    end
    cd(dn)
    avitomats(FList12(i).name);
    cd ..
end
save('FileList.mat','FList12')

function avitomats(fn)
infn=['../' fn];
minrow=297;
maxrow=784;
xb=50;
inf=MyAviInfo('Route1_trav2_Pano.mp4');
StartEnd=[1 -inf.nrFramesTotal];
for i=StartEnd(1):xb:StartEnd(2)
    ep=min(StartEnd(2),i+xb-1);
    is=i:ep;
    outf=[fn(1:end-4) 'Fr' int2str(ep) '.mat']
    if(~isfile(outf))
        c=mmread(infn,is);
        for j=1:length(is)
            outf=[fn(1:end-4) 'Fr' int2str(is(j)) '.mat'];
            im=c.frames(j).cdata;
            im2=im;%rgb2gray(im);
            im=im2(minrow:maxrow,:,:);
            save(outf,'im');
        end
    end
end
save AviFileData.mat infn chanfn StartEnd