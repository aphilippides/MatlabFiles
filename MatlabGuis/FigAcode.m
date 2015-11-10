function FigAcode(action)

switch(action)
   
case 'LoadA'
   fhdl=findobj(gcbf,'Tag','edtxtFilen');
   dirhdl=findobj(gcbf,'Tag','edtxtDir');
   fname=get(fhdl,'String')
   pathname=get(dirhdl,'String')
   newfile=load([pathname fname])   
   M=get(gcf,'Userdata')
   if (~isempty(M))
   	Files=M(:,1);
      Paths=M(:,2);
   else
      Files={''};
      Paths={''};
   end
   Files=cellstr(strvcat(char(Files),fname))
   Paths =cellstr(strvcat(char(Paths), pathname))
   set(gcf,'Userdata',[Files Paths])
   Xflisthdl=findobj(gcbf,'Tag','listXfiles')
   Yflisthdl=findobj(gcbf,'Tag','listYfiles')
   set(Xflisthdl,'String',Files);
	set(Yflisthdl,'String',Files);
   X=get(gca,'XLim');
   Y=get(gca,'YLim');
   Z=[X Y];
   set(gcbo,'UserData',Z)
   
case 'Clear'
   a=1
   
case 'ClearAll'
   cla;
   x1hdl=findobj(gcbf,'Tag','EtxtX1');
   x2hdl=findobj(gcbf,'Tag','EtxtX2');
   y1hdl=findobj(gcbf,'Tag','EtxtY1');
   y2hdl=findobj(gcbf,'Tag','EtxtY2');
	set(x1hdl,'String','');
	set(x2hdl,'String','');
	set(y1hdl,'String','');
	set(y2hdl,'String','');
   
case 'Reset'
   hndl=findobj(gcbf,'Tag','ButLoad');
   z=get(hndl,'Userdata');
   axis(z);
   
case 'Set'
   X=get(gca,'XLim');
   Y=get(gca,'YLim');
   olda=X(1);
   oldb=X(2);
   oldc=Y(1);
   oldd=Y(2);
   x1hdl=findobj(gcbf,'Tag','EtxtX1');
   x2hdl=findobj(gcbf,'Tag','EtxtX2');
   y1hdl=findobj(gcbf,'Tag','EtxtY1');
   y2hdl=findobj(gcbf,'Tag','EtxtY2');
   a=get(x1hdl,'String');
   if(~isempty(a))
      olda=eval(a);
   end
   b=get(x2hdl,'String');
   if(~isempty(b))
      oldb=eval(b);
   end
	c=get(y1hdl,'String');
   if(~isempty(c))
      oldc=eval(c);
   end
	d=get(y2hdl,'String');
   if(~isempty(d))
      oldd=eval(d);
   end
   X=[olda oldb];
   Y=[oldc oldd];
   set(gca,'XLim',X);
   set(gca,'YLim',Y);   
case 'GridOn'
   gridhdl = findobj(gcbf, 'Tag','GridTag');
   if get(gridhdl,'Value')
      grid on;
   else 
      grid off;
   end
case 'Browse'
   val=get(gcbo,'Value');
   names=get(gcbo,'String');
   filehdl=findobj(gcf,'Tag','edtxtFilen');
   direcs=get(gcbo,'UserData');
   if (direcs(val))
      cd(names{val})
      FigAcode ListMat;   
   else
    	newstr=[names{val}];
   	set(filehdl,'String',newstr)
   end
case 'ListMat'
   lhdl=findobj(gcf,'Tag','listLoad');
   filehdl=findobj(gcf,'Tag','edtxtFilen');   
   dirhdl=findobj(gcf,'Tag','edtxtDir');
   s=[pwd '\'];					% Get all files (NB reverse slashe for UNix
   set(dirhdl,'String',s);
   flist=dir(pwd);
   [numfiles,X]=size(flist);
   x=struct2cell(flist); 
   fnames=x(1,2:numfiles)';
   names=[fnames{1} '\'];  %Get all filenames: if dir put slash and include
   direcs(1)=1;				% set up directory flags
   for i=3:(numfiles)
      if (flist(i).isdir)
         names=strvcat(names,[fnames{i-1} '\']);
         direcs=[direcs 1];
      end
   end
   Mats=struct2cell(dir([pwd '/*.mat'])); 	%get .mat files
   if(~isempty(Mats))
      Fmats=char(Mats(1,:)');
      [X,Y]=size(Fmats);
      direcs=[direcs zeros(1,X)];
      names=strvcat(names,Fmats);
   end
   names=cellstr(names);
   set(lhdl,'Value',1)
   set(lhdl,'UserData',direcs)
   set(lhdl,'String',names)
case 'ChDir'
   direc = get(gcbo,'String')
   cd(direc);
   FigAcode ListMat;
end

