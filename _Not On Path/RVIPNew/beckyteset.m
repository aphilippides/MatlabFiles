

whichs=0;
window=Screen(whichs, 'OpenWindow');

white=WhiteIndex(window);
black=BlackIndex(window);

gray=(white+black)/2;

inc=white-gray;


Screen(window, 'FillRect', gray);

[x,y]=meshgrid(-100:100, -100:100);

m=exp(-((x/50).^2)-((y/50).^2)) .* sin(0.03*2*pi*x);

Screen(window,'PutImage', gray+inc*m);

Screen(window, 'Flip');

KbWait;

Screen('CloseAll');

