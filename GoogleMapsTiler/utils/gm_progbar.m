function gm_progbar
global PB_LOOP PB_INT PB_COUNT

PB_COUNT = PB_COUNT+1;
if PB_COUNT==PB_LOOP || ~mod(PB_COUNT,PB_INT)
    fr = PB_COUNT/PB_LOOP;

    t = (PB_LOOP-PB_COUNT)*toc/PB_COUNT;
    totmin = ceil(t/60);
    tmin = mod(totmin,60);
    thour = (totmin-tmin)/60;

    ws = get(0,'CommandWindowSize');
    ndone = round(fr*(ws(1)-2));
    fprintf('[%s%s]\n %2.3f%% ~%dh %dm remains\n',char(ones(1,ndone)*'='),char(ones(1,(ws(1)-2-ndone))*'-'),fr*100,thour,tmin);
end