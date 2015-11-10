function gm_makesuperim(start_lat,start_long,varargin) % d_south,d_east,gm_zoom,data_label)

%% default values for params
gm_zoom         = 12;
maptype         = 'satellite';
grayscale       = true;
verbose         = true;
subims_per_file = 3;

d_south         = NaN;
d_east          = NaN;
end_lat         = NaN;
end_long        = NaN;
data_label      = '';

%% constants
COUNT_INT       = 3; % interval (number of images) between showing progress bar
TRIM_SUBIM_PIX  = [610 640]; % size of image returned by Google Maps (after trimming)
TRIM_ADJ        = 610/640;

%% parse params
for i = 1:2:numel(varargin)
    switch varargin{i}
        case 'zoom'
            gm_zoom = varargin{i+1};
            if gm_zoom < 1 || gm_zoom > 21 || gm_zoom ~= ceil(gm_zoom)
                error('Zoom must be an integer between 1 and 21')
            end
        case 'maptype'
            maptype = varargin{i+1};
            if ~any([strcmp(maptype,'roadmap') strcmp(maptype,'satellite')...
                    strcmp(maptype,'terrain') strcmp(maptype,'hybrid')])
                error('"%s" is not a valid map type',maptype);
            end
        case 'grayscale'
            grayscale = logical(varargin{i+1});
        case 'verbose'
            verbose = varargin{i+1};
        case 'subimsperfile'
            subims_per_file = varargin{i+1};
            if subims_per_file ~= ceil(subims_per_file)
                error('"subimsperfile" must be an integer')
            end
        case 'distance'
            if ~isnan(end_lat)
                error('Cannot set both "distance" and "endcoords"')
            end
            if numel(varargin{i+1}) ~= 2
                error('Value for "distance" should be an array of 2 values')
            end
            d_south = varargin{i+1}(1);
            d_east = varargin{i+1}(2);
            [end_lat,end_long] = gps_adddist(start_lat,start_long,-d_south,d_east);
        case 'endcoords'
            if ~isnan(end_lat)
                error('Cannot set both "distance" and "endcoords"')
            end
            if numel(varargin{i+1}) ~= 2
                error('Value for "endcoords" should be an array of 2 values')
            end
            end_lat = varargin{i+1}(1);
            end_long = varargin{i+1}(2);
            d_south = -gps_finddist(start_lat,start_long,end_lat,start_long);
            d_east  =  gps_finddist(start_lat,start_long,start_lat,end_long);
        case 'label'
            data_label = varargin{i+1};
        otherwise
            error('"%s" is not a valid parameter',varargin{i});
    end
end

if isnan(end_lat)
    error('One of "distance" or "endcoords" must be set')
end

% generate data label if not provided
if isempty(data_label)
    dind = 1;
    while true
        data_label = num2str(dind,'%03d');
        if ~exist([gm_datadir '/' data_label '_params.mat'],'file')
            break;
        end
        dind = dind+1;
    end
end

colorinds = 3-2.*grayscale;

%% calculate coordinates for superim and num of images to get etc.
mframe = 1.25*2^(1-gm_zoom).*[TRIM_ADJ 1]; % height & width of image in "mercator" units

% calculate coordinates (merc+gps) for corners of superim
if d_south < 0
    top_lat = end_lat;
    bot_lat = start_lat;
else
    top_lat = start_lat;
    bot_lat = end_lat;
end

if d_east < 0
    left_long  = end_long;
    right_long = start_long;
else
    left_long  = start_long;
    right_long = end_long;
end

[mtop_lat,mleft_long]  = gps2merc(top_lat,left_long);
[mbot_lat,mright_long] = gps2merc(bot_lat,right_long);

% number of frames for all subims
subim_frames = [(mbot_lat-mtop_lat),(mright_long-mleft_long)]./mframe;

% total number of subims needed (vert,horz)
nsubim_tot = ceil(subim_frames);

% pixels in superim
superim_pix = ceil(subim_frames.*TRIM_SUBIM_PIX);

% number of ims (i.e. files) needed (horz+vert)
superim_units = ceil(nsubim_tot./subims_per_file);

% "leftover" pixels and image-grabs for "edge" files
subim_ends = mod(superim_pix,TRIM_SUBIM_PIX);
if subim_ends(1)==0
    subim_ends(1) = TRIM_SUBIM_PIX(1);
end
if subim_ends(2)==0;
    subim_ends(2) = TRIM_SUBIM_PIX(2);
end
im_ends = mod(nsubim_tot,subims_per_file);
im_ends(im_ends==0) = subims_per_file;

% print info
if verbose
    fprintf(['Image will be %dx%d pixels in %d files (label=%s).\n' ...
             'Surveying an area of %.2fkm^2. %d images to grab.\n\n'], ...
             superim_pix(1),superim_pix(2),prod(superim_units), ...
             data_label,prod(abs([d_south d_east]))./1e6,prod(nsubim_tot));
end
if prod(nsubim_tot) > 25000
    error('daily allowance of images is only 25000')
end

%% save superim params to file
% if data directory doesn't exist, create it
data_dir = gm_datadir;
if ~exist(data_dir,'dir')
    mkdir(data_dir);
end
owd = pwd;
cd(data_dir)

if exist([data_label '_params.mat'],'file')
    error('superimage with label "%s" already exists',data_label)
else
    % if superim doesn't already exist then we can proceed, saving params
    
    % save username and hostname
    if isunix
        [~,savecomp] = system('hostname');
        owner = [getenv('USER') '@' strtrim(savecomp)];
    else
        owner = [getenv('USERNAME') '@' getenv('COMPUTERNAME')];
    end
    
    % save date
    savedate = datestr(now);
    
    % pixels per file
    im_pix = subims_per_file.*TRIM_SUBIM_PIX;
    
    save([data_label '_params'],'top_lat','left_long','bot_lat','right_long',...
        'd_south','d_east','gm_zoom','superim_pix','superim_units','im_pix',...
        'grayscale','maptype','subims_per_file','owner','savedate');
end

%% grab images
if verbose
    gm_startprogbar(COUNT_INT,prod(nsubim_tot));
end

im_units = [subims_per_file NaN];
for i = 1:superim_units(1) % superim row
    if i==superim_units(1)
        im_units(1) = im_ends(1);
        imsz = [(im_units(1)-1).*TRIM_SUBIM_PIX(1)+subim_ends(1) NaN];
    else
        imsz = [im_units(1).*TRIM_SUBIM_PIX(1) NaN];
    end
    
    im_units(2) = subims_per_file;
    for j = 1:superim_units(2) % superim col
        if j==superim_units(2)
            im_units(2) = im_ends(2);
            imsz(2) = (im_units(2)-1).*TRIM_SUBIM_PIX(2)+subim_ends(2);
        else
            imsz(2) = im_units(2).*TRIM_SUBIM_PIX(2);
        end
        im = zeros([imsz colorinds],'uint8'); % im for current file
        
        subim_pix(1) = TRIM_SUBIM_PIX(1);
        for k = 1:im_units(1) % im row
            if i==superim_units(1) && k==im_units(1)
                subim_pix(1) = subim_ends(1);
            end
            lat = merc2gps(mtop_lat + (k-1+(i-1)*subims_per_file)*mframe(1) + mframe(2)/2);
            startr = (k-1)*TRIM_SUBIM_PIX(1);
            
            subim_pix(2) = TRIM_SUBIM_PIX(2);
            for l = 1:im_units(2) % im col
                if j==superim_units(2) && l==im_units(2)
                    subim_pix(2) = subim_ends(2);
                end
                long = left_long+360*mframe(2)*(l-0.5+(j-1)*subims_per_file);
                startc = (l-1)*TRIM_SUBIM_PIX(2);
                
%                 if verbose
%                     fprintf('Getting image %d,%d (%04d,%04d)\n',k,l,i,j);
%                     fprintf('lat: %f; long; %f\n',lat,long);
%                 end
                
                subim = gm_getimage(lat,long,'zoom',gm_zoom,'maptype',maptype,'grayscale',grayscale);
                im(startr+1:startr+subim_pix(1), ...
                    startc+1:startc+subim_pix(2),:) = subim(1:subim_pix(1),1:subim_pix(2),:);
                
                if verbose
                    gm_progbar;
                end
            end
        end
        
        fname = sprintf('%s_%04d,%04d.mat',data_label,i,j);
%         if verbose
%             fprintf('Writing to %s...\n',fname);
%         end
        save(fname,'im')
    end
end

cd(owd)

% catch ex
%     save(sprintf('emergency_%f.mat',rand));
%     rethrow(ex);
% end