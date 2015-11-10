function IntelImTest

is=0:20;
js=0:12;
goal=GetImage(is(10),js(5));


for i=1:length(is)
    i
    for j=1:length(js)
        im=GetImage(is(i),js(j),goal);
%         imagesc(uint8(im));
        pim=ProcessImage(im);
        d(i,j)=ImDiff(im,goal);
    end
end
figure(1)
imagesc(is,js,d)
figure(2);
surf(js,is,d)
% keyboard;

function[im]=GetImage(i,j,goal)

fn=[int2str(i) '_' int2str(j) 'UnW.mat'];
if(IsFileLocal(fn))
    load(fn);
    im=unw_im;
%     im=unw_bw;
else
    im=goal;
end

function[pim]=ProcessImage(im)
% % use the raw image
pim=im;

% % histigram equalisation for grey-scale
% pim=histeq(im);

% % picking out one colour channel only. r=1, g=2, b=3;
% pim=im(:,:,1);

% % resizing/subsampling
% % imresize resizes all the images (a nice sort of smoothing and subsampling
% % currently each pixel is 0.5 degrees per side and so is 720 columns (=360)
% % and 80 rows (=40 degrees)
% % 
% % the following command makes a new image which will be 10 x 90 so each
% % pixel will be 4 degrees

% pim=imresize(im,[10 90]);

function[e]=ImDiff(im,goal)

d=im(:)-goal(:);
d=d(~isnan(d));
e=sqrt(sum(d.^2));



% [Out,fn]=IsFile(fname,DName) 
% Out = 1 if file exists, 0 otherwise
% filename returned in fn (so wild cards can be used)
% If DName is specified it will get stuff from that directory

function[Out,fn]=IsFileLocal(fname,DName)

fname=char(fname);
if(nargin<2)
	s=dir(fname);
	if(length(s)==0)
		Out=0;
		fn=[];
	else
		Out=1;
		fn=char(s.name);
	end
else
    if(computer=='PCWIN') Sep='/';
    else Sep=':';
    end
    dstr=[DName Sep fname];
	s=dir(dstr);
	if(length(s)==0)
		Out=0;
		fn=[];
	else
		Out=1;
		Ds=[];
		for i=1:length(s)
			Ds=[Ds; [DName Sep]];
		end		
		fn=[Ds [char(s.name)]];
	end
end
