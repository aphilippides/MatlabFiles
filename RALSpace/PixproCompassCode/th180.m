function th=th180(th)
th = mod(th,360);
sel = th>180;
th(sel) = th(sel)-360;
