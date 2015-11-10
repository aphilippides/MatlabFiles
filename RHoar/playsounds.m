function playsounds

buysound=wavread('buy.wav');
down2sound=wavread('down 2.wav');
tbuy=wavread('mid1.wav');
tsell=wavread('mid2.wav');
wavplay(tbuy,9000)
wavplay(tsell,9000)
downsound=wavread('down.wav');
mid1sound=wavread('trend up.wav');
mid2sound=wavread('trend down.wav');
sellsound=wavread('sell.wav');
up2sound=wavread('up1.wav');
upsound=wavread('up.wav');
% hi2=wavread('hi 2.wav');
% low1=wavread('low 1.wav');
hi2day=wavread('Hi 2 Day.wav');
low1day=wavread('Low1 Day.wav');
e_down=wavread('eTrend Down.wav');
e_up=wavread('eTrend Up.wav');
vol_buy=wavread('Volume Buy.wav');
vol_sell=wavread('Volume Sell.wav');
trend_buy=wavread('Trend Buy.wav');
trend_sell=wavread('Trend Sell.wav');
cbuy=wavread('cover buy.wav');
csell=wavread('cover sell.wav');
mbuy=wavread('Mid Buy.wav');
msell=wavread('Mid Sell.wav');
mup=wavread('Mid Up.wav');
mdown=wavread('Mid Down.wav');
dbuy=wavread('Diagonal Buy.wav');
dsell=wavread('Diagonal Sell.wav');

wavplay(cbuy,24050);
wavplay(csell,24050);
wavplay(buysound);
wavplay(sellsound);
wavplay(downsound,8000);
wavplay(upsound,8000);
wavplay(down2sound,44100);
wavplay(up2sound,44100);
wavplay(mid1sound,44100);
wavplay(mid2sound,44100);
wavplay(hi2,44100);
wavplay(low1,44100);
wavplay(e_down,24050);
wavplay(e_up,24050);
wavplay(vol_buy,24050);
wavplay(tbuy,9000)
wavplay(tsell,9000)
wavplay(vol_sell,24050,'async');
wavplay(trend_buy,24050,'async');
wavplay(trend_sell,24050,'async');