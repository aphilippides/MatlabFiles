function im=gm_getimage(latitude,longitude,varargin)
% function im=gm_getimage(latitude,longitude,param1,value1,...)
%
% latitude:  between -90 and 90
% longitude: between -180 and 180
%
% parameters:
% 'zoom': between 0 (whole world) and 21 (really close up). Default=12
%         (Images usually not available for high levels of zoom though!)
%
% 'maptype': Must be one of the following:
%            'roadmap'
%            'satellite' (default)
%            'terrain'
%            'hybrid'
%
% 'scale': 1 (small) or 2 (big). Default is 1.
%
% 'size': image size before trimming [height,width] (cannot be >640x640)
%
% 'format': image format. Must be one of following values:
%           'png'/'png8' (default)
%           'png32'
%           'gif'
%           'jpg'
%           'jpg-baseline'
%
% More info on these params can be found at:
%        http://developers.google.com/maps/documentation/staticmaps
%
% 'grayscale': Whether to get images in color/grayscale. True or false. Default is true.
%
% 'trim': Whether to trim logo from bottom of images. True or false.
%         Default is true.

%% check lat/long OK
latitude = latitude(:);
longitude = longitude(:);

if latitude > 90 || latitude < -90
    error('latitude must be between -90 and 90')
end
if longitude > 180 || longitude < -180
    error('longitude must be between -180 and 180')
end

%% constants (at present)
% my own api key!
key = 'AIzaSyCl9fdZ9Tvhr2JbjYlxGQ6xl36wILfo_2Q';

%% parse parameters

% default values
maptype = 'satellite';
imzoom = 12;
imsize = [640 640];
imformat = 'png32';
imscale = 1;

imgrayscale = true;
imtrim = true;

% get params
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'zoom'
            imzoom = varargin{i+1};
            if imzoom < 0 || imzoom > 21
                error('bad value for zoom')
            end
        case 'maptype'
            maptype = varargin{i+1};
            if ~any([strcmp(maptype,'roadmap') strcmp(maptype,'satellite')...
                    strcmp(maptype,'terrain') strcmp(maptype,'hybrid')])
                error('"%s" is not a valid map type',maptype);
            end
        case 'scale'
            imscale = varargin{i+1};
            if imscale ~= 1 && imscale ~= 2
                error('scale can only be 1 or 2')
            end
        case 'size'
            imsize = varargin{i+1};
            if numel(imsize) ~= 2 && any(imsize)>640
                error('image size cannot be greater than 640x640 or have more than 2 elements')
            end
        case 'format'
            imformat = varargin{i+1};
            if ~any([strcmp(imformat,'png') strcmp(imformat,'png8') strcmp(imformat,'png32')...
                    strcmp(imformat,'gif') strcmp(imformat,'jpg') strcmp(imformat,'jpg-baseline')])
                error('"%s" is not a valid image format',imformat);
            end
        case 'trim'
            imtrim = varargin{i+1};
        case 'grayscale'
            imgrayscale = varargin{i+1};
        otherwise
            error('"%s" is not a valid parameter',varargin{i})
    end
end

%% get image
    
im = imread(sprintf(['http://maps.googleapis.com/maps/api/staticmap?'...
    'center=%.6f,%.6f&zoom=%d&scale=%d&size=%dx%d&maptype=%s&format=%s&key=%s&sensor=false'],...
    latitude,longitude,imzoom,imscale,imsize(2),imsize(1),maptype,imformat,key));
% fprintf(['http://maps.googleapis.com/maps/api/staticmap?'...
%      'center=%.6f,%.6f&zoom=%d&scale=%d&size=%dx%d&maptype=%s&format=%s&key=%s&sensor=false\n'],...
%      latitude,longitude,imzoom,imscale,imsize(1),imsize(2),maptype,imformat,key);
% im = rand([imsize 3]);
if imgrayscale && ~strcmp(imformat,'png') && ~strcmp(imformat,'png8')
    im = rgb2gray(im);
    if mean(im(:)==227) > 0.99 % then we've been given an "error" image
        error('Image with these specs not available.\nLocation: %fN %fE\nZoom: %d',latitude,longitude,imzoom)
    end
end

if imtrim
    if imscale==1
        npixtrim = 30;
    else
        npixtrim = 50; % number of pixels to trim from bottom (if turned on)
    end
else
    npixtrim = 0;
end
im = im(1:end-npixtrim,:,:);
