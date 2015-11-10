function CentreIms(s,RS)

if(nargin<1) 
    s=dir('*.jpg'); 
% s=dir('*Centred.mat')
end;

% RS=GetRS(s);
% load MidPoints

if(exist('RS'))
    rsf=1;
    RS=RS(1:2);
else rsf=0;
end;

j=1;
len=length(s);
while(j<=length(s))
    j
    fn=s(j).name;
    %     i=imread(fn);
    load(fn);
    im=frame;
    il=rgb2gray(im);
    %     il=frame(end:-1:1,:,:);
    %     RS=[748,2795];
    if(rsf)
        il=imresize(il,RS);
        im=imresize(im,RS);
    end
    imagesc(im);
    if(j>1) 
        hold on;
        plot(x,y,'rx');
        hold off
    end;
    axis image;
    title([int2str(j) '/' int2str(len) '; ' fn])
    xlabel('Press r to redo this frame, u to go back, return = done')
    %     colormap(gray)
    while 1
        [x,y,b]=ginput(1);
        if(isempty(x))
            j=j+1;
            break;
        elseif(isequal(b,'u'))
            j=max(1,j-1);
            break;
        else
            imagesc(im);
            hold on;
            plot(x,y,'rx')
            hold off
            xold=round(x);y=round(y);
            axis image;
%             xlim([xold-200 xold+200])
            axis([xold-100 xold+100 y-50 y+100])
            title([int2str(j) '/' int2str(len) '; ' fn])
            xlabel('Press r to redo this frame, u to go back, return = done')
        end
    end
    newim=il(:,[xold:end 1:xold-1]);
    newimall=im(:,[xold:end 1:xold-1],:);
    mpts(j)=xold;
    save([fn(1:end-4) 'Centred.mat'],'newim','newimall','xold')
    if(rsf) save('MidPoints','mpts','RS');
    else save('MidPoints','mpts');
    end
end

function[RS]=GetRS(s)

% for j=1:length(s)
%     i=imread(s(j).name);
%     sizes(j,:)=size(i);
% %     load(s(j).name);
% %     sizes(j,:)=size(newim);
% end
% RS=mode(sizes)
% keyboard