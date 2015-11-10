classdef PixProCompass < handle
%     PIXPROCOMPASS Creates PixProCompass object to use the PixPro as a
%     "visual compass". IMPORTANT: Don't forget to delete the object when
%     you're done, otherwise the connection to the camera will stay open
%     and you'll have to turn it off and on again.
%
%       ppc = PIXPROCOMPASS(ANGLESEP,IMSCALE) connects to the camera over WiFi,
%       and returns an object for using the camera to obtain a heading.
%       ANGLESEP is the gap between the angles used for rotation (e.g.
%       ANGLESEP of 1 gives the range 0:360 degrees). IMSCALE is the size
%       to which you want the images obtained from the camera to be resized
%       to ([] means no resizing).
%
%       ppc = PIXPROCOMPASS(ANGLESEP,IMSCALE,false,ORIGINALIMAGESIZE)
%       allows the class to be run offline without the camera. The extra
%       parameter indicates the size of images, before resizing, that will
%       be input.
%
%       Example:
%           % create object and connect to camera
%           ppc = PixProCompass(1,[50 50]);
%
%           % get new snapshot for the current location, optionally return the image
%           snap = newsnapshot(ppc);
%
%           % get current heading + goodness of match + current view
%           [head,qmatch,lastim] = getheading(ppc);
%
%           % use this image as a new snapshot, if you like
%           newsnapshot(ppc,lastim);
%
%           % close connection to camera, delete object
%           delete(ppc);
    
    properties
        angles
        cam
        imscale
        pxsel
        trimv
        rsnaps
        origimsz
    end
    methods
        function obj=PixProCompass(anglesep,imscale,usecamera,origimsz)
            if nargin < 3
                usecamera = true;
            end
            if nargin < 4 && usecamera
                origimsz = [1024 1024];
            end
            if nargin < 2
                imscale = [];
            end
            obj.origimsz = origimsz;
            obj.imscale = imscale;
            
            th = th180(0:anglesep:360-eps(360));
            obj.angles = th;
            
            [obj.pxsel,obj.trimv] = ral_getimparams(imscale,origimsz);
            if usecamera
                obj.cam = ipcam('http://172.16.0.254:9176');
            end
        end
        
        function snap=newsnapshot(obj,snap)
            if nargin < 2 && ~isempty(obj.cam)
                snap = snapshot(obj.cam);
            end
            if ~isempty(obj.origimsz) && ~all([size(snap,1),size(snap,2)]==obj.origimsz)
                error('image size should be %dx%d',obj.origimsz(1),obj.origimsz(2))
            end
            obj.rsnaps = ral_getrotsnaps(snap,obj.angles,obj.pxsel,obj.trimv,obj.imscale); %obj.pxsel,obj.padv,obj.imscale
        end
        
        function [head,diff,lastim,ridf]=getheading(obj,lastim)
            if nargin < 2 && ~isempty(obj.cam)
                lastim = snapshot(obj.cam);
            end
            if ~isempty(obj.origimsz) && ~all([size(lastim,1),size(lastim,2)]==obj.origimsz)
                error('image size should be %dx%d',obj.origimsz(1),obj.origimsz(2))
            end
            [head,diff,ridf] = ral_getheading(lastim,obj.rsnaps,obj.angles,obj.pxsel,obj.trimv,obj.imscale); %obj.pxsel,obj.padv,obj.imscale
        end
        
        function delete(obj)
            if ~isempty(obj.cam)
                delete(obj.cam);
            end
        end
    end
end