classdef SuperImage
    properties
        DataLabel
        Units
        SubImsPerFile
        ImPix
        TopLatitude
        BottomLatitude
        LeftLongitude
        RightLongitude
        MapType
        Grayscale
        dSouth
        dEast
        Zoom
        UmweltSize = [101 101]; % diameter of field of view for umwelt in pixels
    end
    properties (SetAccess = protected)
        pix
    end
    
    methods
        function obj=SuperImage(data_label)
            obj.DataLabel = data_label;
            load(sprintf('%s/%s_params',gm_datadir,data_label));
            obj.TopLatitude = top_lat;
            obj.BottomLatitude = bot_lat;
            obj.LeftLongitude = left_long;
            obj.RightLongitude = right_long;
            obj.dSouth = d_south;
            obj.dEast = d_east;
            obj.Zoom = gm_zoom;
            obj.Units = superim_units;
            obj.SubImsPerFile = subims_per_file;
            obj.ImPix = im_pix;
            obj.MapType = maptype;
            obj.Grayscale = grayscale;
            obj.pix = superim_pix;
        end
    end
    
end

