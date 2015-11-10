function ICA1calls(input);

switch(input)
   
case 'loadim';
   % load images of morphed fish
   cd d:\zip100\originalfish\
   
   % define image list by searching for mod files
   d=dir;
   ImageList={};
   index=1;
   for loop=1:size(d,1);
      fname=char(d(loop).name);
      if length(fname)>7;
         if fname(length(fname)-6:length(fname))=='Mod.tif';
            ImageList(index)=cellstr(fname);
            index=index+1;
         end;
      end;
   end;
   set(findobj('tag','FileNameList'),'string',ImageList);
   set(findobj('tag','DisplayPanel'),'string',[1:size(ImageList,2)]);
   
   
case 'DisplayRawImages';
   figure(findobj('tag','RawImages'));
   namestr=get(findobj('tag','FileNameList'),'string');
   NumImages=size(namestr,1);
      
   for index=1:NumImages;
      subplot(ceil(sqrt(NumImages)),ceil(sqrt(NumImages)),index);
      loadname=char(namestr(index));
      image=imread(loadname,'tif');
      
      imagesc(image);
      colormap gray;
      axis off;
      drawnow;
   end;
   
case 'Filter';
   WindSize=str2num(get(findobj('tag','EditText1'),'string'));
   DnRatio=str2num(get(findobj('tag','EditText2'),'string'));
   
   FilterType='average';
   h=fspecial(FilterType,WindSize);
   CropBorder=WindSize;   
   namestr=get(findobj('tag','FileNameList'),'string');
   NumImages=size(namestr,1);
   
   FilterAr=[];
   
   % find handles of all axes containing data
   AxesHandles=get(findobj('tag','RawImages'),'Children');
   figure(findobj('tag','FilteredImages'));
   for index=1:NumImages;
      % collect data from axis
      CurrAxes=get(AxesHandles(index),'Children');
      
      Im=get(CurrAxes,'Cdata');
      
      % filter and resize if necessary
      
      if WindSize~=0;
         Im=uint8(round(filter2(h,Im)));       
         Im=imcrop(Im,[CropBorder,CropBorder,size(Im,2)-CropBorder*2,size(Im,1)-CropBorder*2]);
      end;
     
      Im=imresize(Im,DnRatio);
   
      % place data back in filtered image figure
      
      subplot(ceil(sqrt(NumImages)),ceil(sqrt(NumImages)),index);
      imagesc(Im);
      colormap gray;
      axis off;
      drawnow;
   end;
   
case 'ShowFigure';
   list=get(gcbo,'string');
   figure(findobj('tag',char(list(get(gcbo,'value')))));
   
case 'CaptureDisplay';
   % find out panel number
   PanelIndex=get((findobj('tag','DisplayPanel')),'value');
   
   % find out display type
   displaytypes=get(findobj('tag','GraphType'),'string');
   Gindex=get(findobj('tag','GraphType'),'value');
   plottype=char(displaytypes(Gindex));
      
   % find data window and axes holding data
   wintypes=get(findobj('tag','DisplayFigure'),'string');
   index=get(findobj('tag','DisplayFigure'),'value');
   wintype=char(wintypes(index));
   
   AxesHandles=get(findobj('tag',wintype),'Children');
   CurrAxes=get(AxesHandles(PanelIndex),'Children');
   
   % collect image data
   Im=double(get(CurrAxes,'Cdata'));
   
   % check to see if invert
   if get(findobj('tag','Checkbox3'),'value')==1;
      Im=255-Im;
   end;   
    
   % select and display on axes in main window
   axes(findobj('tag','mainaxes'));
   
   
   if (Gindex==1) | (Gindex==2) | (Gindex==3);
      eval([plottype '(Im)']);
      shading interp;
      colormap gray;
      if (Gindex==1);
         set(gca,'CameraPosition',[-207 -321 3411]);
         rotate3d; 
      end;
      
      drawnow;
   end;
   
   if (Gindex==4);
      imagesc(Im);
      colormap gray;
      drawnow;
   end;
   
   
   set(gca,'tag','mainaxes');
   
   
case 'maincalc';
   FirstEigenVector=str2num(get(findobj('tag','EditText3'),'string'));
   LastEigenVector=str2num(get(findobj('tag','EditText4'),'string'));
   NumberIC=str2num(get(findobj('tag','EditText5'),'string'));

   
   
   echo on;
   
   % building normalised mixed signal matrix
   % from filtered images
   
   MixedSigArray=[];
   
   figure(findobj('tag','FilteredImages'));
   namestr=get(findobj('tag','FileNameList'),'string');
   NumImages=size(namestr,1);
  
   AxesHandles=get(gcf,'Children');
   
   
   
   for index=1:NumImages;
      CurrAxes=get(AxesHandles(index),'Children');
      ImageArray=double(get(CurrAxes,'CData'));
      
      xsize=size(ImageArray,1);
      ysize=size(ImageArray,2);
      
      LengthVector=xsize*ysize;
      
      ImageVector=reshape(ImageArray,1,LengthVector);
      
      MeanIntensity=mean(ImageVector);
      SDIntensity=std(ImageVector);
      
      ImageVector=(ImageVector-MeanIntensity)./SDIntensity;
      MixedSigArray=[MixedSigArray;ImageVector];
   end;
   
   %
   % Doing ICA
   %
   
   icasigs=fastica(MixedSigArray,'displayMode','off',...
      'numOfIC',NumberIC,...
      'firstEig',FirstEigenVector,'lastEig',LastEigenVector);
   
   figure(findobj('tag','ICImages'));
   
   for lp=1:NumberIC;
      subplot(ceil(sqrt(NumberIC)),ceil(sqrt(NumberIC)),lp);
      

      
      icasigs(lp,:)=icasigs(lp,:)-min(icasigs(lp,:));
      icasigs(lp,:)=icasigs(lp,:).*(255/max(icasigs(lp,:)));
      image=reshape(icasigs(lp,:),xsize,ysize);
      imagesc(image);
      colormap gray;
      
   end;

case 'Threshold'; 
   % initialise second parent figure;
   icagui2;
   
   
   
end;

