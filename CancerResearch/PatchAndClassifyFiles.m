function PatchAndClassifyFiles

% make the random number generator be random: might need updatig for newer
% matlab
rand('twister',sum(100*clock));

% this is legacy
% fn_starts={'DMSO_e';'SMIFH2_e'};
opt=0;
% fn_starts=[''];

disp(' ')
disp('enter 1 to mask and patch files in the folder');
disp('enter 2 to hand classify: ');
disp('enter 3 to show hand classify results: ');
disp('enter 4 to reconstruct the images: ');
disp('enter 5 to Pick Thresholds for the auto classification');
disp('enter 6 to auto classify');
disp('enter 7 to see results from auto classification');
disp('enter 8 to show coloc data and reconstruct coloc image');
inp=input('enter 9 to combine hand classify results: ');

% get the list of files
if(~ismember(inp,[3,7,9]))
    fend=input('enter the last 3 letters of the files you want to process: ','s');
    all=dir(['*.' fend]);
end
if(isequal(inp,1))
    GetSliceMasksIms(all);
%     clf
%     hmdir=cd;
%     ClassifyPatchesRandomIm(all);
%     cd(hmdir);
%     ShowClassifyPatches;
elseif(isequal(inp,2))
    clf
    hmdir=cd;
    ClassifyPatchesRandomIm(all);
    cd(hmdir);
    ShowClassifyPatches;%(fn_starts,all);
elseif(isequal(inp,3))
    ShowClassifyPatches;
elseif(isequal(inp,4))
    Reconstruct_Images(all,1);
elseif(isequal(inp,8))
    Reconstruct_Images(all,2);
elseif(isequal(inp,9))
    
    disp(' ');
    disp('enter 1 to get files for combining hand class data');
    opt=input('enter 2 to combine hand class data: ');
    if(opt==1)
        fend=input('enter the last 3 letters of the files you want to process: ','s');
        all=dir(['*.' fend]);
        ShowClassifyPatchesFiles(all);
    else
        CombineClassifyPatches;
    end
    
elseif(isequal(inp,5))
    % to run the automatic classification, one
    % needs a threshold for objects based on the s.d. level or the image.
    %
    % This is got via PickThreshes and is held in file
    % ..._StdThreshV3.mat  or ..._StdThreshImage.mat depending whther the 
    % filter is done on the std filtered or raw image respectively
    % 
    % opt=1 is thrsholding on std-image. opt=2 is thrsholding on image

    disp(' ');
    disp('enter 1 to auto-class based on std deviation filter');
    opt=input('enter 2 to auto-class based on raw image: ');
    disp(' ')
    if(opt==2)
        disp('THRESHOLDING BASED ON IMAGE');
    else
        disp('THRESHOLDING BASED ON STD FILTER');
    end
    PickThreshes(all,opt,[]);

elseif(isequal(inp,6))
    disp(' ');
    disp('enter 1 to auto-class based on std deviation filter');
    opt=input('enter 2 to auto-class based on raw image: ');
    disp(' ')
    if(opt==2)
        disp('THRESHOLDING BASED ON IMAGE');
    else
        disp('THRESHOLDING BASED ON STD FILTER');
    end
    AutoClassifyIm(all,opt);
elseif(isequal(inp,7))
    disp(' ');
    disp('enter 1 to show results based on std deviation filter');
    disp('enter 2 to show results based on raw image: ');
    opt=input('enter 3 to combine data from multiple files: ');
    disp(' ')
    if(opt==2)
        disp('THRESHOLDING BASED ON IMAGE');
    elseif(opt==3)
        disp('Combining data from multiple files');
    else
        disp('THRESHOLDING BASED ON STD FILTER');
    end
    ShowAutoClassifyIm([],opt);
else
    disp('please re-run and enter a valid number')
end




% this function takes all, a list of files and outputs a structure with the 
% starts of filenames in fn_starts which allows you to group your image 
% files etc into different groups for comparison
%
% it defaults to using: fn_starts={'ctrl';'mutant'}
% to not use this, you send in different values 
function[fn_starts]=GetFileStarts(all,fn_starts)
% use default file-starts
WriteFileOnScreen(all,1);
disp(' ');
if(nargin<2)
    fn_starts={'ctrl';'mutant'};
end
disp('starts of files are:');
disp(fn_starts);
inp=input('For different file-starts/all files enter 0: '); 
if(inp==0)
    fn_starts={};
end
while(inp==0)
    WriteFileOnScreen(all,1);
    if(isempty(fn_starts))
        disp('input a file-start. Return to finish'); 
        fs=input('return on its own gets all files: ','s'); 
    else
        fs=input('input a file-start. Return to finish: ','s');
    end
    if(isempty(fs))
        disp(' ');
        break;
    else
        fn_starts=strvcat(fn_starts,fs);
        disp('starts of files are:');
        disp(fn_starts);
    end
end
fn_starts=cellstr(fn_starts);

function[fn_starts]=GetFileStartsV2(all)
% use default file-starts
WriteFileOnScreen(all,1);
disp(' ');
fn_starts=[];
ngroups=input('enter number of groups; return = all files in 1 group: '); 
if(~isempty(ngroups))
    for i=1:ngroups
        fn_s=[];
        while 1
            WriteFileOnScreen(all,1);
            disp(' ')
            disp(['Group ' int2str(i) ' files currently: '])
            if(isempty(fn_s))
                disp(' ')
            else
                disp(cellstr(fn_s));
            end
            disp(['Pick files by no. or vector eg [1 3] or 2:4']);
            inp=input('Enter return when done: ');
            if(isempty(inp))
                if(~isempty(fn_s))
                    break;
                end
            end
            fn_s=strvcat(fn_s,all(inp).name);
            % get rid of .mat/.tif bit etc if it exists and add to the list
%             for j=1:length(inp)
%                 fn_s=strvcat(fn_s,RemoveFileEnd(all(inp(j)).name));
%             end
        end
        fn_starts(i).flist=cellstr(fn_s);
        disp(' ')
        disp(['Group ' int2str(i) ': '])
        disp(fn_starts(i).flist);
%         tmp=input('press return to continue;');
        disp(' ')
    end
end

% This gets rid of .mat/.tif bit etc if it exists
function[fn_wo_end]=RemoveFileEnd(fn_with_end)

ind=strfind(fn_with_end,'.');
% check if it has a .xxx at the end and

fn_wo_end=fn_with_end;
if(~isempty(ind))
    % check that it's not a spurious . somewhere in the middle
    if(ind(end)>=(length(fn_with_end)-4))
        fn_wo_end=fn_with_end(1:(ind(end)-1));
    end
end


function[imnames]=GetImageNameFromImName(names)
imnames=names;
for i=1:length(names)
    imn=char(names(i));
    % does it contain sl#.mat
    ind=regexp(imn,'_sl\d*.mat','once');
    if(~isempty(ind))
        imnames(i)={[imn(1:ind-1) imn(end-3:end)]};
    end 
end


% this combines the data from multiple hand classified files
function CombineClassifyPatches
astrall={'strong';'medium';'weak';'weak';'medium';'strong'};%;'empty'};
clf
sbit='RndHandClassData';
all=dir('RndHandClassData*');
for i=1:length(all)
    a(i).name=all(i).name(17:end);
end

fns=GetFileStartsV2(a);

if(isempty(fns))
    % do all the files as one
    Fsall=zeros(1,6);
    for i=1:length(all)
        load(all(i).name,'Fs')
        Fsall=Fsall+Fs;
    end
    bar([-3:-1 1:3],100*Fsall/sum(Fsall))
    SetXLabs(gca,astrall);
    title('all data')
    disp(' ')
    disp('# of patches (strongly active to strongly inhibited) and total:')
    disp([Fsall sum(Fsall)])
    disp('% of patches (strongly active to strongly inhibited):')
    disp(round(100*Fsall/sum(Fsall)))
else
    ngr=length(fns);
    for i=1:ngr
        subplot(ngr,1,i)
        Fsall=zeros(1,6);
        for j=1:length(fns(i).flist)
            load([sbit char(fns(i).flist(j))],'Fs')
            Fsall=Fsall+Fs;
        end
        bar([-3:-1 1:3],100*Fsall/sum(Fsall))
        SetXLabs(gca,astrall);
        title(char(fns(i).flist(1)))
        disp(' ')
        disp('# of patches (strongly active to strongly inhibited) and total:')
        disp([Fsall sum(Fsall)])
        disp('% of patches (strongly active to strongly inhibited):')
        disp(round(100*Fsall/sum(Fsall)))
    end
end

% this saves the hand class data for each image file
function ShowClassifyPatchesFiles(fn_starts)

cd HandClassified
for i=1:length(fn_starts)
    fn=fn_starts(i).name(1:end-4);
    subplot(length(fn_starts),1,i)
    [Fs,out]=GetFreqs(fn);
    save(['RndHandClassData' fn '.mat'])
end
cd ..


function ShowClassifyPatches(all,fn_starts)

if(nargin<1)
    cd HandClassified
    all=dir('*HandClassRnd.mat');
end

% get the start of the files which should be grouped together
if(nargin<2)
    [fn_starts]=GetFileStarts(all);
else
    [fn_starts]=GetFileStarts(all,fn_starts);
end

% if you want to show all the data together, you will have entered an empty string
% so call GetFreqs with no arguments
if(isempty(fn_starts))
    clf
    [Fs,out]=GetFreqs('');
else
    % if you want to group the data, get the data from GetFreqs
    % according to the start of the file
    for i=1:length(fn_starts)
        subplot(length(fn_starts),1,i)
        [Fs(i,:),out(i,:)]=GetFreqs(char(fn_starts(i)));
    end
end
save('RndHandClassDataAll.mat')
disp('Rows are:')
for i=1:length(fn_starts)
    disp(fn_starts(i));
end
disp('# of patches (strongly active to strongly inhibited):')
disp(out(:,1:6))
disp('% of patches (strongly active to strongly inhibited):')
disp(out(:,7:12))
disp('# non-empty patches; total # patches:')
disp(out(:,13:14))
cd ..

function[Fs,out]=GetFreqs(fn_starts)
flist=dir([fn_starts '*HandClassRnd.mat']);
c=[-3 -2 -1 3 2 1 4 5 6];
for i=1:length(flist)
    fno=flist(i).name;
    load(fno)
    flist(i).ptype=ptype;
    flist(i).strens=strens;
    flist(i).mclass=[NaN;NaN];
    flist(i).class=[NaN];
    if(ptype==3)
        flist(i).mclass=c([strens(1),strens(2)+3])';
    elseif(ismember(ptype,1:2))
        flist(i).class=c(strens+3*(ptype-1));
    else
        [ptype strens]
    end
end
if(isempty(flist))
    Fs=zeros(1,6);
    out=[Fs Fs 0 0];
    title(char(fn_starts))
    return
else
    cl=[flist.class];
    m=[flist.mclass];
end
% get the frequencies of the active/inhibited classes and add 50% of the
% mixed inhibted and active classes to the frequencies
Fs=Frequencies(cl,[-3:-1 1:3])+ ...
    0.5*(Frequencies(m(1,:),[-3:-1 1:3])+...
    Frequencies(m(2,:),[-3:-1 1:3]));

% npl=size(Fs,1);
% for i=1:npl
%     subplot(npl,1,i)
i=1;
bar([-3:-1 1:3],100*Fs(i,:)/sum(Fs(i,:)))
if(isempty(fn_starts))
    title('all files');
else
    title(char(fn_starts))
end
npat=sum(Fs(i,:));
out(i,:)=[Fs(i,:) round(100*Fs(i,:)/npat) npat length(cl)];
% end


function[patchlist]=GetAllPatches(flist)

% check if it's an lsm
if(isequal(flist(1).name(end-2:end),'lsm'))
    lsmflag=1;
else
    lsmflag=0;
end

patchlist=[];
for i=1:length(flist)
    if(lsmflag)
        im=tiffread29(flist(i).name);
        nl=im(1).lsm.DimensionZ;
    else
        nl=1;
    end
    
    for sl=1:nl
        % get first part of filename
        if(lsmflag)
            fn=[flist(i).name(1:end-4) '_sl' int2str(sl)];
        else
            fn=flist(i).name(1:end-4);
        end
        plist=dir([fn '_Patch*.mat']);

        % load the mask file and get the maxes and mins for plotting
        fno=[fn '_Mask.mat'];
        load(fno)
        if(~isequal(mask,-1))
            for j=1:length(plist)
                plist(j).mmax=mmax;
                plist(j).mmin=mmin;
            end
            patchlist=[patchlist;plist];
        end
    end
end


function ClassifyPatchesRandomIm(flist)

% get a list of all the patches
patchlist=GetAllPatches(flist);

% read in mask files, make a joint list, remove small ones
for i=1:length(patchlist)
    load(patchlist(i).name);
    areas(i)=pat.area;
end
patchlist=patchlist(areas>10);

% now randomise the order
np=length(patchlist);
patchlist=patchlist(randperm(np));

% these are the classification strings and colours
cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
cols=['w--';'r--';'y--';'c--';'k--';'g--'];

% this sets up a matrix of zeros which is going to hold all the
% classifications so we can tell when all files have been classified
ptypes=zeros(1,np);

% This instantiates all the ptypes if they have already been classified
if(~isdir('HandClassified'))
    mkdir('HandClassified')
end
cd HandClassified
for i=1:length(patchlist)
    fno=[patchlist(i).name(1:end-4) 'HandClassRnd.mat'];
    if(isfile(fno))
        load(fno)
        ptypes(i)=ptype;
    end
end

% start classifiying from the first patch that hasn't already been
% classified
i=find(ptypes==0,1);
if(isempty(i))
    i=1;
end

% go round the loop classifiying all patches until you're happy
% this is in a while loop to enable one to go back up a patch if a mistake
% has been made
while 1
    fno=[patchlist(i).name(1:end-4) 'HandClassRnd.mat'];

    if(isfile(fno))
        load(fno)
        ptypes(i)=ptype;
    else
        ptype=0;
        strens=0;
    end

    % load up the file: Need to do an overloaded function if these are to
    % be tiffs of individual patches
    cd ..
    load(patchlist(i).name);
    cd HandClassified
    
    % plot the patch: 
    %  Do we plot the masked image or original?
    imagesc(im_patch)
%     imagesc(im_patch.*mask_patch)
    caxis([patchlist(i).mmin patchlist(i).mmax])
    axis equal
    axis tight
    
    while 1
        % set the string and color type from current classification
        if(ismember(ptype,1:3))
            str=[char(cstrs(ptype+1)) ' strength ' p_str];
        else
            str=char(cstrs(ptype+1));
        end
        col=cols(ptype+1,1);
        if(sum(ptypes==0)==0)
            alldone=1;
            title(['ALL PATCHES CLASSIFIED: patch ' int2str(i) '/' int2str(np)],'Color','r');
        else
            alldone=0;
            title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
        end
        xlabel(str,'Color',col);

        % classify
        disp(' ')
        disp(['currently ' str '; Enter: '])
        disp('1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure;')
%         inp=ForceNumericInput('-1 end classifying; return done; 0 go back one: ',0,1);
        inp=ForceNumericInput('-1 end classifying; 0 go back one: ',1,1);
        if(isempty(inp))
            % uncomment this option to force pressing return
%             break;
        elseif(isequal(inp,-1))
            if(alldone)
                cd ..
                return
            else
                disp('not all patches classified yet; ctrl c to quit')
            end;
            break;
        elseif(ismember(inp,[1:5]))
            ptype=inp;
            ptypes(i)=inp;
            if(ismember(inp,1:2))
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=ForceNumericInput('enter strength, 1=high, 2=med,  3=low: ',1,1);
                end
                strens=tempr;
            elseif(inp==3)
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=ForceNumericInput('enter active strength, 1=high, 2=med,  3=low: ',1,1);
                end
                strens(1)=tempr;
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=ForceNumericInput('enter inhibited strength, 1=high, 2=med,  3=low: ',1,1);
                end
                strens(2)=tempr;
            else
                strens=0;
            end
            p_str=num2str(strens);
            save(fno,'ptype','strens','p_str');
            
            % comment this break out to force a return to be pressed after
            % patch classfication
            break
        elseif(isequal(inp,0))
            i=i-2;
            break
        end
    end
    %move round 1
    i=mod(i+1,np);
    if(i==0)
        i=np; 
    end;
end
            

function ShowAutoClassifyIm(flist,opt)
strs={'dens small';'dens lines';'dens bigs';'m wigg big';...
    'm ecc big';'m area big';'max area big';'sum area big';...
    'mean green';'% over thresh';'m area all';'#lines';'#big';'#med';...
    'all big';'big*wigg';'wigg nz';'ecc nz';...
    'class';'# patches'};

if(opt==1)     % this is the file for object thresholds based on std filter picking
    endbit='_StdThreshV3.mat';
    outf=['AutoClassify' endbit];
    load(outf)
elseif(opt==2)    % this is the file for object threshold based on the Image
    endbit='_StdThreshImage.mat';
    outf=['AutoClassify' endbit];
    load(outf)
else
    % if combining files, see if a combined file exists
    % if not, generate it and load 
    cfile='AutoClassify_StdThreshCombinedData.mat';
    if(isfile(cfile))
        icf=input([cfile ' exists; 1 to overwrite; enter use it: ']);
        if(isequal(icf,1))
            dat=CombineManyAutoClassifiedResults;
        else
            load(cfile);
        end
    else
        dat=CombineManyAutoClassifiedResults;
    end
end

vs=GetVsForClustering(dat);

% these are the things that I'm going to plot
i_pl=[13 14 4 5];% 4 17 5 18 15 16];

% these are the colours for the 2nd fig
cols=['g-*';'k  ';'r: ';'b--'];

% get a cell array of the image names

% if it's a version where I haven't stored the image name, get the image
% name
if(~isfield(dat,'imagename'))
    allns={dat.imname}';
    imnames=GetImageNameFromImName(allns);
    allns=imnames;
else
    allns={dat.imagename}';
end
% now get a list without repeats
tmpa=unique(allns);

for i=1:length(tmpa)    
    flist(i).name=char(tmpa(i));
end

% get the start of the files which should be grouped together
% if you want to show all the data together, you will have entered an 
% empty string

% decide whether to specify files by strings, fnopt=1, 
% or by numbers , fnopt=2, 
fnopt=2;
if(fnopt==1)
    fn_starts=GetFileStarts(flist);
else
    fn_starts=GetFileStartsV2(flist);    
end

% set some axis labels
if(isempty(fn_starts))
    xstr={'all data'};
else
    if(fnopt==2)
        for k=1:length(fn_starts)
            xstr(k,1)=fn_starts(k).flist(1);
%             xstr(k,1)={['Group ' int2str(k)]};
        end
    else
        xstr=fn_starts;
    end
end

% Now get a list of all the elements of dat that match each file start
fn_startlist=MatchFileStarts(fn_starts,allns,fnopt);

% clear the figures
for i=1:3
    figure(i)
    clf
end

for i=1:length(i_pl)
    % if fn_starts is empty, plot all the data as one
    if(isempty(fn_startlist))
        v1=vs(:,i_pl(i));
        me(i)=mean(v1);
        s(i)=std(v1);
        [y,x]=hist(v1,10);
        ningroup=length(dat);
        outdat(i).v=v1;
    else
        % then plot the data divided according to fn_starts
        for j=1:length(fn_startlist)
            % get all the files that match the filestart entered           
            i1=fn_startlist(j).is;
            
            % analyse the data
            ningroup(j)=length(i1);
            v1=vs(i1,i_pl(i));
            me(j,i)=mean(v1);
            s(j,i)=std(v1);
            [y(j,:),x(j,:)]=hist(v1,linspace(0,max(vs(:,i_pl(i))),20));
            outdat(i).group(j).v=v1;
        end
    end
    figure(1)
    subplot(2,2,i)
    BarErrorBarTiff(1:size(me,1),me(:,i),s(:,i));
    title(char(strs(i_pl(i))))
    SetXLabs(gca,xstr);

    figure(2)
    subplot(2,2,i)
    if(isempty(fn_startlist))
        plot(x,y/sum(y),'k')
        xodat=[x;y/sum(y)];
    else
        xodat=[y;y;y];
        for j=1:length(fn_startlist)
            plot(x(j,:),y(j,:)/sum(y(j,:)),cols(mod(j,4)+1,:))
            xodat(((j-1)*3+1):j*3,:)=[x(j,:);y(j,:)/sum(y(j,:));NaN*x(j,:)];
            hold on
        end
    end
    hold off
    title(char(strs(i_pl(i))))
    legend(xstr);
    
    % write output data
    xoutf=[char(strs(i_pl(i))) 'HistData.xls'];
%     xlswrite(xoutf,xodat);
%     groupstr=[];
%     for j=1:length(fn_startlist)
%         groupstr=strvcat(groupstr,['group ' int2str(j) ' x']); 
%         groupstr=strvcat(groupstr,['group ' int2str(j) ' y']); 
%         groupstr=strvcat(groupstr,[' ']); 
%     end
%     [nc,nr]=size(xodat);
%     arrstr=['A1:A' int2str(nc)];
%     xlswrite(xoutf,cellstr(groupstr),arrstr);
%     arrstr=['A1:A' int2str(nc)];
%     xlswrite(xoutf,xodat,'B1');
    xlswrite(xoutf,xodat);
end
bbb=strs(i_pl);
save tempoutdat outdat xstr bbb

if(sum(ningroup)~=length(dat))
    disp(' ')
    disp('****WARNING! some patches missed or repeated***')
end


% now if it exists, first line the data up with the hand classified data
% specify which classes to match and strings for bar chart labels 
classes=[-3:-1 1:3];
astrall={'strong';'medium';'weak';'weak';'medium';'strong'};%;'empty'};

if(opt==3)   % if using combined files
    
    % first remove any data that haven't been classified
    keep=[];
    for i=1:length(dat)
        if(~isempty(dat(i).class))
            keep=[keep i];
        end
    end
    % display some warning
    disp(' ')
    if(sum(keep)==0)
        disp('***WARNING: NO DATA hand classified***')
        disp('Re run option 7 in individual folders if this is a mistake')
        return
    elseif(sum(keep)<length(dat))
        disp('WARNING: some data not hand classified.')
        disp('Re run option 7 in individual folders if this is a mistake')
        input('press return to continue');
    end

    % then limit the data to those that have been hand classified
    dat=dat(keep);
    vs=vs(keep,:);
    allns={dat.imname}';
    fn_startlist=MatchFileStarts(fn_starts,allns,fnopt);
    
elseif(isdir('HandClassified')) % if the hand classified data exists

    cd HandClassified
    for i=1:length(dat)
        % get the hand classified fielname
        fn=[dat(i).name];
        fn2=[fn(1:end-4) 'HandClassRnd.mat'];
        % assign a class to patch based on Hand Classified data
        [clas,ptype,stren]=GetClassFromAttributes(fn2,dat(i).area);
        dat(i).ptype=ptype;
        dat(i).stren=stren;
        dat(i).class=clas;
    end
    cd ..

    % save the hand classification data with the other data
    save(outf,'dat','-append')
end

% now plot the object properties lined up with hand class data 
if((opt==3)||(isdir('HandClassified')))   
    % get all the classes
    cl=[dat.class];
    
    % plot the distribution of the variables i_pl for all the data
    PlotAutoClassDistributions(classes,i_pl,vs,cl,strs,astrall,'all',3)
    % then repeat above but split the data according to fn_starts
    for i=1:length(fn_startlist)
        % find rows mathcing the fn_starts
        i1=fn_startlist(i).is;
        % split the data according to the fn_starts
        cf=cl(i1);
        vf=vs(i1,:);
        % pot the distributions
        PlotAutoClassDistributions(classes,i_pl,vf,cf,strs,astrall,...
            xstr(i),3+i)
    end
    disp('this shows the # big objects not including lines: is this ok??')
end

%This function plots the distribution of the aut =o classifeid features
%according to the classes they've been put in. Essentially allows you to
%ssee what patterns there might be. The classes are in cl, and data in vs
% the classes they will be dicuided into are in clas, i_pl says which
% attributes to look at, strs, tstr and astrall have plot labels for figure
% fignum
function PlotAutoClassDistributions(clas,i_pl,vs,cl,strs,astrall,tstr,fignum)
% for each of the autoclass variables to be looked at
figure(fignum)
for i=1:length(i_pl)

    %  split the data according to classes, get means and save them to be
    %  plotted
    for j=1:length(clas)
        i1=(cl==clas(j));
        ninclas(j)=sum(i1);
        v1=vs(i1,i_pl(i));
        me2(j,i)=mean(v1);
        s2(j,i)=std(v1);
        %             [y(j,:),x(j,:)]=hist(v1,10);
    end
    subplot(2,2,i)
    BarErrorBarTiff(1:length(clas),me2(:,i),s2(:,i));
    title([char(tstr) ': ' char(strs(i_pl(i))) ' Hand classed'])
    SetXLabs(gca,astrall);
    MeanAcrossClasses=me2(:,i)'
    STDAcrossClasses=s2(:,i)'
    NuminClass=[ninclas sum(ninclas)]
end

% this funcion returns a list of the indices in allns that matches
% fn_starts. Couple of options hre
function[fns]=MatchFileStarts(fn_starts,allns,opt)
if(isempty(fn_starts))
    fns=[];
elseif(opt==1)
    % old version using start of file names
    for j=1:length(fn_starts)
        fns(j).is=strmatch(fn_starts(j),allns);
    end
else
    % use a structure with multiple names in it
    for j=1:length(fn_starts)
        
        fns(j).is=strmatch(fn_starts(j).flist(1),allns);
        for k=2:length(fn_starts(j).flist)
            fns(j).is=[fns(j).is;strmatch(fn_starts(j).flist(k),allns)];
        end
    end
end
    


% this function is a helper function that combines data from several
% auto-classified experiments together. 
% 
% currently, this should be run after you've run option 7
% ie to show the auto-classified results as this gets the 
% Hand Classified data which is in different folders
function[dat]=CombineManyAutoClassifiedResults
% get a list of all potential files and set an output file
AutoFileList=dir('AutoClassify_StdThresh*.mat');
outf='AutoClassify_StdThreshCombinedData.mat';

% remove the output file from the list
is=strmatch(outf,{AutoFileList.name}');
AutoFileList=AutoFileList(setdiff(1:length(AutoFileList),is));

% pick which fiels to combine
WriteFileOnScreen(AutoFileList,1);
disp('input a file-start. Return to finish');
fs=input('enter which files to combine or return for all: ');

% load each file and combine the data
if(isempty(fs))
    fs=1:length(AutoFileList);    
end
alldat=[];
for i=fs
    load(AutoFileList(i).name);
    if(~isfield(dat,'class'))
        dat(1).class=[];
        dat(1).ptype=[];
        dat(1).stren=[];
    end
    alldat=[alldat dat];
end
dat=alldat;
save(outf,'dat');
 

% this function gets the maximum and minimum value across sets of images
% it currently needs a bit of re-writing and isn't used
function[outf,mamax,mimin]=GetMaxMin(flist,fbit)

outf=[fbit '_Maxes.mat'];
for i=1:length(flist)
    im=imread(flist(i).name);
    v=im(:);
    maxes(i)=max(v);
    mins(i)=min(v);
    si(i,:)=size(im);
    ar(i)=length(v);
end
mamax=max(maxes);
mimin=min(mins);
save(outf,'fbit','maxes','mamax','mins','mimin','ar','si','flist');


% this function picks the thresholds for the auto classification then does
% the auto classification. It takes a list of files but it also takes
% fn_starts which does the max and minimum across a set of images so that
% when you are picking the threshold, the prog displays the data max-ed and
% min-ed across the set of images. I'm not entirely sure this is useful but
% it was for the lsm version so I'll implement it next
% 
% if one wanted to auto-classify coloc or another channel would need to
% change which image is passed into the plotting function
function PickThreshes(fl,opt,fn_starts)

% % get maxes and mins across whole data set
% % the max and min is used for display purposes only. 
% % I think it might be better to get the data for each image but one could
% % do it for the while set here
% % Alternatively, one could divide the images into 2 sets and get a maxmin
% % for each set via fn_starts but this is currently not programmed in
% GetMaxMin(flist)

% randomise the order of presentation of each image
flist=fl(randperm(length(fl)));

% if it's an lsm then get the list for each slice. 
[flist]=GetLsmSliceMaskList(flist,0);

% % Could also randomise the order here either within lsm ...
% [flist]=GetLsmSliceMaskList(flist,1);
% 
% % ... or completely
% flist=flist(randperm(length(flist)));
 
sThresh=-1;
for i=1:length(flist)

    fn=flist(i).name;
    if(opt==2)
        fno2=[fn(1:end-4) '_StdThreshImage.mat'];
    else
        fno2=[fn(1:end-4) '_StdThreshV3.mat'];
    end

    % load the mask file which contains the image and patches
    load([fn(1:end-4) '_Mask.mat']);
    
% don't need this stuff: this is aide memoire to see what's in mask files    
% % mim=mask.*vim;
% % save(fno,'thresh','rim','vim','colim','mask','patches',...
% %                 'maskchan','claschan','colchan','mmin','mmax','params');

    % now get thresholds for each image if they exist
    if(isfile(fno2))
        load(fno2)
    end
    oldt=sThresh;
    %     oldt=max(1,round(var*rand(1)-0.5*var)+sThresh);
    % % stdThreshMultPlots is in TextureAnalysisTiff and will probably need editing 
    % % it shows multiple patches in one go
    %     [sthresh]=stdThreshMultPlots(flist,oldt,numpatches,[mimin,mamax],opt); 
    [sThresh]=stdThreshSingPatch(vim,patches,oldt,opt);%,[mimin,mamax]
    save(fno2,'sThresh');

    % 1 is for std filter, 2 the image
    % this is kind of redundant but is needed for individual thresholds
    %     GetStdThresh(flist,fbit,1)
    %    GetStdThresh(flist,flist(is(1)).fstart,2)
end
AutoClassifyIm(fl,opt);


% this does the thresholding one patch at a time
function[thresh]=stdThreshSingPatch(im,patches,thresh,opt)

nh=ones(3);

% std filter the image
stdim=Mystdfilt(im,nh);

% this loads all the data into s structure. It's not the most elegant way
% of doing things but will allow flexibility to a) have alist of images not
% from the same dingle imaage b) change the size of the patch shown

% only check patches that are big enough and randomise the order
patches=patches([patches.area]>100);
patches=patches(randperm(length(patches)));
for i=1:length(patches)
    rs=patches(i).rs;
    cs=patches(i).cs;
    
    ims(i).im=im(rs,cs);
    ims(i).stdim=stdim(rs,cs);
%     v=[v;ims(i).im(:)];
%     sv=[sv;ims(i).stdim(:)];
end

% get the appropriate maxes and mins. This could be done above if we only
% want to look at a certain set of images. Or it could be passed in as an
% argument to the function
v=im(:);
% v=v(v>0);
s=sort(v);
ind=round(0.9999*length(v));
mmax=s(ind);
imax=[min(v) mmax];

sv=stdim(:);
s=sort(sv);
ind=round(0.9999*length(sv));
mmax=s(ind);
stdax=[min(sv) mmax];

% set the appropriate threshold as a percentage of the difference between 
% max and min
pcadd=0.01;
if(opt==2)
    lims=imax;
    tadd=round(pcadd*diff(lims));
else
    lims=stdax;
    tadd=pcadd*diff(lims);
end

% auto threshold
if((nargin<2)||thresh<0)
    if(opt==2)
        thresh=round(1.5*median(v));
    else
        thresh=1.5*median(sv);
    end
end

% these set the sizes of what are big/small objects.
% these should be set as parameters somewhere
threshB=50;
threshM=10;

% start with first figure
figure(1)
clf
i=1;
while 1

    if(opt==2)
        % do the threshold on the standard image
        s2im=double(ims(i).im>thresh);
    else
        s2im=double(ims(i).stdim>thresh);
    end
    % this is old and only gives a rough idea of what's going on
    %     s2im=double(sim_mask>(sf*s_lev));
    %     [L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);
    [L,num] = bwlabeln(s2im);
    s=regionprops(L,'Area');%,'Perimeter');
    ar=[s.Area];
    ms=find((ar>=threshM));%&(ar<threshB));
    bs=find(ar>=threshB);
    numbig=length(bs);
    numsmall=length(ms)-numbig;
    bwm = ismember(L,ms);
    bwb = ismember(L,bs);
    tpl=s2im+bwm+bwb;

    stdThreshPlotPatchesSing(ims,i,tpl,L,imax,stdax,opt)
    disp([' threshold, currently ' int2str(thresh)]);
    %         text(-800,-150,'up/down arrow to change threshold; return end' ...
    %         ,'FontSize',14);
    subplot(2,2,2)
    xlabel([int2str(numbig) ' big objects; ' int2str(numsmall) ' mediums']);
    subplot(2,2,4)
    xlabel('up/down arrow to change threshold; n next patch; return end');

    [x,y,b]=ginput(1);

    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    if(isempty(x))
        break;
    elseif(b==30)
        %         Increase threshold
        thresh=min(thresh+tadd,lims(2));
    elseif(b==31)
        %         decrease threshold;
        thresh=max(lims(1),thresh-tadd);
    elseif(b==110)
        % get a new patch
        i=i+1;
        if(i>length(patches))
            i=1;
        end
    end
end

function[thresh]=stdThreshSingPatchImages(flist,thresh,imax,opt)

% get patches
rp=randperm(length(flist));
flist=flist(rp);
sp=1;
nh=ones(3);

v=[];
sv=[];

% this gets maxes and mins across the fish
for i=1:length(flist)
    ims(i).im=imread(flist(i).name);
    ims(i).stdim=Mystdfilt(ims(i).im,nh);
    v=[v;ims(i).im(:)];
    sv=[sv;ims(i).stdim(:)];
end

% comment this out to show relative to all the patches
% not just the fish; slight reducndacney here as this is passsed in but
% it adds elxibility if I want to use a sacling across all fish
imax=[min(v) max(v)];
stdax=[min(sv) max(sv)];
if(opt==2)
    lims=imax;
    tadd=100;
else
    lims=stdax;
    tadd=20;
end

% auto threshold
if((nargin<2)||thresh<0)
    if(opt==2)
        thresh=1.5*median(v);
    else
        thresh=1.5*median(sv);
    end
end

threshB=50;
threshM=10;

% start with first figure
figure(1)
clf
i=1;

while 1

    if(opt==2)
        % do the threshold on the standard image
        s2im=double(ims(i).im>thresh);
    else
        s2im=double(ims(i).stdim>thresh);
    end
    % this is old and only gives a rough idea of what's going on
    %     s2im=double(sim_mask>(sf*s_lev));
    %     [L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);
    [L,num] = bwlabeln(s2im);
    s=regionprops(L,'Area');%,'Perimeter');
    ar=[s.Area];
    ms=find((ar>=threshM));%&(ar<threshB));
    bs=find(ar>=threshB);
    numbig=length(bs);
    numsmall=length(ms)-numbig;
    bwm = ismember(L,ms);
    bwb = ismember(L,bs);
    tpl=s2im+bwm+bwb;

    stdThreshPlotPatchesSing(ims,i,tpl,L,imax,stdax,opt)
    disp([' threshold, currently ' int2str(thresh)]);
    %         text(-800,-150,'up/down arrow to change threshold; return end' ...
    %         ,'FontSize',14);
    subplot(2,2,2)
    xlabel([int2str(numbig) ' big objects; ' int2str(numsmall) ' mediums']);
    subplot(2,2,4)
    xlabel('up/down arrow to change threshold; n next patch; return end');

    [x,y,b]=ginput(1);

    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    if(isempty(x))
        break;
    elseif(b==30)
        %         Increase threshold
        thresh=min(thresh+tadd,lims(2));
    elseif(b==31)
        %         decrease threshold;
        thresh=max(lims(1),thresh-tadd);
    elseif(b==110)
        % get a new images
        i=i+1;
        if(i>length(flist))
            i=1;
        end
    end
end


function stdThreshPlotPatchesSing(ims,i,tpl,L,imax,stdax,opt)

if(opt==2)
    s1='; THRESHOLDING THIS';
    s2='';
else
    s2='; THRESHOLDING THIS';
    s1='';
end

subplot(2,2,1)
imagesc(ims(i).im)
axis equal; axis tight
caxis(imax)
title(['original; patch ' int2str(i) '/' int2str(length(ims)) s1])

subplot(2,2,3)
imagesc(ims(i).stdim)
axis equal; axis tight;
caxis(stdax)
title(['std filtered image' s2])

subplot(2,2,2)
imagesc(tpl);caxis([0 3])
axis equal; axis tight;
title('objects (blue), smalls (orange) bigs (red)')

subplot(2,2,4)
imagesc(L)
axis equal; axis tight;
title('all objects, 1 colour per object')

% this function is a helper function which gets round the issue of the lsms
% being in slices and having a filename per slice while the images do not
% 
% given an flist it checks if it's an lsm then returns a list of all the
% slices with a .mat at the end of them. It also returns a flag saying if
% it's an lsm file or not
%
% if randflag=1 then randomise the order within the lsm
function[flist,lsmflag]=GetLsmSliceMaskList(fl,randflag)

% if it's an lsm then get the list for each slice. 
if(isequal(fl(1).name(end-2:end),'lsm'))
    lsmflag=1;
    flist=[];
    for i=1:length(fl)
        fn=fl(i).name(1:end-4);
        out=dir([fn '_sl*Mask.mat']);
        % randomise the order within the lsm if randflag is selected but  
        if(randflag)
            out=out(randperm(length(out)));
        end
        flist=[flist;out];
    end
    % get rid of the _Mask from the filenames
    for i=1:length(flist)
        flist(i).name=flist(i).name([1:end-9 end-3:end]);
        % use this if I want to include the overall filename.
        % should do but can't be bothered to debug now
%         fn_nomask=flist(i).name([1:end-9 end-3:end]);
%         flist(i).name=fn_nomask;
    end    
else
    flist=fl;
    lsmflag=0;
%     imflist=fl;
%     sliceNum=zeros(1,length(flist));
end

function AutoClassifyIm(flist,opt)

% thfs=[1.25 1.5 2 2.5 3 4];
% sfs=[1.5:0.2:2.5];

% these are different options to the lsm version
if(opt==1)
    % this is the file for object thresholds based on std filter picking
    endbit='_StdThreshV3.mat';
elseif(opt==2)
    % this is the file for object threshold based on the Image
    endbit='_StdThreshImage.mat';
elseif(opt==3)
    % not used - but you could use this to do thresholding at a standard
    % value
    sfs=[1000:500:3000];
end

% set up some files
outf=['AutoClassify' endbit];
outftxt=['AutoClassify' endbit(1:end-4) '.csv'];
nh=ones(3);
dat=[];

% if it's an lsm then get the list for each slice. 
[flist]=GetLsmSliceMaskList(flist,0);

lenflist=length(flist);
for j=1:lenflist
    % load correct threshold file
    fn=flist(j).name;
    fno2=[fn(1:end-4) endbit];
    load(fno2)
    
    clear patchlist;
    % get a list of all the patches
    patchlist=GetAllPatches(flist(j));
    lenpatch=length(patchlist);
    
    for i=1:lenpatch
        
        % processing prompt
        disp(['processing patch ' int2str(i) '/' int2str(lenpatch) ', file ' ...
            int2str(j) '/' int2str(lenflist)]);
        % load the patch
        fno=patchlist(i).name;
        load(fno)
        
        % don't process small ones
        if(pat.area>10)
            % mask the patch and std filter if necessary
            im=im_patch.*mask_patch;
            if(opt==1)
                im=Mystdfilt(im,nh);
            end

            % threshold it
            t_im=double(im>sThresh);

            % now classify each patch
            v=t_im(:);
            da=AnalysePatchIm(t_im,im);
            da.area=length(v);
            da.nover=length(v(v>0));
            da.pcs=round(100*da.nover/da.area);
            da.name=fno;
            da.imname=fn;
            da.patchnum=i;
            %         da.which_start=j;
            da.fnThresh=fno2;
            da.th=sThresh;
            %         da.th_im=t_im;
            %         da.im=im;
            dat=[dat da];
            save(outf,'dat')%,'goods','patches','goods')
        end
    end
end
ShowAutoClassifyIm(flist,opt)

% this get's the objects and various properties. Not entirely sure im is
% needed but it was in AutoClassifyLSM.m so I've kept it in
function[out]=AnalysePatchIm(threshim,im)

threshB=50;
threshM=10;

v_im=threshim(:);
% get objects based on thresholds or std filter
[L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(threshim,im,threshB);
% out.s_lev=s_lev;
% out.t1=t1;
% out.sf=sf;
out.g=MyPrctile(v_im(v_im>0),[50 25 75])';
out.n_s=num_s;
out.L_s=L_s;
out.isline_s=isline_s;
out.bigs_s=find(ar_s>threshB);
out.nbig_s=sum(ar_s>threshB);
out.nline_s=length(isline_s);
out.nmeds_s=sum(ar_s>threshM);
out.meds_s=find(ar_s>threshM);
out.ecc_s=ecc_s;
[out.wig_s,out.l_s,out.wid_s]=objWiggliness(objIm_s,L_s,out.bigs_s);

function[s,L,num,ar,isline,lineim,ecc]=GetObjects(t2im,im,threshB)
[L,num] = bwlabeln(t2im);
s=regionprops(L,im,'Area','Eccentricity',...
    'MajorAxisLength','MinorAxisLength',...
    'Perimeter','MeanIntensity','Solidity','Orientation');
minax=[s.MinorAxisLength];
majax=[s.MajorAxisLength];
meanint=[s.MeanIntensity];
ecc=[s.MajorAxisLength]./minax;
per=2*([s.MajorAxisLength]+minax);
ar=[s.Area];
arovlength=ar./majax;
sol=[s.Solidity];

isline=find((ecc>3)&([s.Area]>threshB));
lineim=zeros(size(im));
for j=1:length(isline)
    lineim=lineim+double(L==isline(j))*j;
end

function[w,l,mw]=objWiggliness(im,S,is)
w=[];
l=[];
mw=[];
for i=1:length(is)
    num=is(i);
    nim=(im==num);
    [w(i),l(i),mw(i)]=Wiggliness(nim,S(num).Orientation);
end

function[w,l,mw] = Wiggliness(im,ang)
newim=imrotate(im,90-ang);
rs=sum(newim,2);
r1=find(rs,1,'first');
r2=find(rs(r1:end),1,'last')+r1-1;
rows=r1:r2;
for i=1:length(rows)
    wid(i)=sum(newim(rows(i),:));
end
w=iqr(wid);
l=std(wid);%r2-r1+1;
mw=median(wid);


function[vs,clasl]=GetVsForClustering(da)
ar=[da.area];%1;%
[o,eccObj,wigg,nlines,mwObj,meObj,maObj,maxaObj,saObj,mallObj]=text_getbigs(da);
% [o,eccObj,wigg,nlines,mwObj,meObj]=text_getbigs(da);
dls=1e4*nlines./ar;
saObj=100*saObj./ar;
nmed=[da.nmeds_s]-[da.nbig_s];
nbig=[da.nbig_s]-nlines;
dmed=1e4*([da.nmeds_s]-[da.nbig_s])./ar;
dbigo=1e4*([da.nbig_s]-nlines)./ar;
pcover=[da.pcs]';
g=[da.g];
mg=g(1,:)';
vs=[dmed' dls' dbigo' mwObj' meObj' maObj' maxaObj' saObj' mg pcover mallObj' nlines' nbig' nmed'];
% vs=[dmed' dls' dbigo' mwObj' meObj'];
clasl=[];%[da.class];


function[o,eccObj,wigg,nlines,mwObj,meObj,maObj,maxObj,saObj,mallObj]...
    =text_getbigs(da)
wigg=[da.wig_s];
[y,x]=hist(wigg,0:15);
o.x1=x;
o.y1=y/sum(y);

eccObj=[];solObj=[];%arObj=[];
for i=1:length(da)
    b=[da(i).bigs_s];
    eccb=[da(i).ecc_s(b)];
    nlines(i)=sum(eccb>=2);
    eccObj=[eccObj eccb];
    solObj=[solObj [da(i).L_s(b).Solidity]];

%     arObj=[arObj [da(i).L_s(b).Area]];
    arObj=[da(i).L_s(b).Area];
    a_all=[da(i).L_s(b).Area];
    saObj(i)=sum([da(i).L_s(b).Area]);
    if(isempty(a_all))
        mallObj(i)=0;
    else
        mallObj(i)=mean(a_all);
    end
   
    if(isempty(b))
        mwObj(i)=0;
        meObj(i)=0;
        maObj(i)=0;
        maxObj(i)=0;
    else
        mwObj(i)=mean([da(i).wig_s]);
        meObj(i)=mean(eccb);
        maObj(i)=mean(arObj);
        maxObj(i)=max(arObj);
    end
end

function SetXLabs(AxHdl,TickLabs)
TickPos=get(AxHdl,'XTick');
set(AxHdl,'XTick',TickPos,'XTickLabel',TickLabs);

function[h]=BarErrorBarTiff(X,Y,E,BarWidth,ErrWidth,col)
if(nargin<6) col='b' ; end
if((nargin<5)||isempty(ErrWidth)) ErrWidth=0 ; end
if((nargin<4)||isempty(BarWidth)) BarWidth=0.8 ; end
if(isempty(X)) X=1:length(Y); end
ph=bar(X,Y,BarWidth);
h=gca;
YUp=Y+E;
hold on;
for i=1:length(ph)
    x=get(get(ph(i),'Children'),'XData');
    if(size(col,1)>1)
        set(ph(i),'FaceColor',col(2,:));
    end
    xs=mean(x);%([1 3],:));
    if(ErrWidth==0) Wid=0.33*mean(x(3,:)-x(1,:));
    else Wid=0.5*ErrWidth;
    end
    for j=1:length(xs)
        % vertical lines
        plot([xs(j) xs(j)],[Y(j,i) YUp(j,i)],col(1,:));
        % horizontal lines
        plot([xs(j)-Wid xs(j)+Wid],[YUp(j,i) YUp(j,i)],col(1,:));
    end
end
hold off