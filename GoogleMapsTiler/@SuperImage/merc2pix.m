function [i,j] = merc2pix(obj,mlat,mlong)
[mtoplat,mleftlong]  = gps2merc(obj.TopLatitude,obj.LeftLongitude);
[mbotlat,mrightlong] = gps2merc(obj.BottomLatitude,obj.RightLongitude);

if mlat <= mtoplat || mlong <= mleftlong || mlat >= mbotlat || mlong >= mrightlong
    error('Coordinates not within range of superimage')
end

mercperpix = 1.25*2^(1-obj.Zoom)/640;
i = round((mlat - mtoplat) / mercperpix);
j = round((mlong - mrightlat) / mercperpix);