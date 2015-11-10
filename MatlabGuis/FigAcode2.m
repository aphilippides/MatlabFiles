function FigAcode2(action)

switch(action)
   
case 'LoadA'
   fhdl=findobj(gcbf,'Tag','edFile');	% get handles
   dirhdl=findobj(gcbf,'Tag','edDir');
   Xfhdl=findobj(gcbf,'Tag','popXfile');
   Yfhdl=findobj(gcbf,'Tag','popYfile');
   
   fname=get(fhdl,'String');				% get new file and loaded files
   pathname=get(dirhdl,'String');
   newfile=load([pathname fname]);
   Files=get(Xfhdl,'String');
   Paths=get(Xfhdl,'Userdata')
   Files=cellstr(strvcat(fname,char(Files)))
   Paths =strvcat(pathname,Paths)
   set(Xfhdl,'Userdata',Paths)
   set(Xfhdl,'String',Files);
	set(Yfhdl,'String',Files);
 	set(Xfhdl,'Value',1);
   set(Yfhdl,'Value',1);
   
   FigAcode2 ListXVar; 
   FigAcode2 ListYVar; 
   
case 'ListXVar'
   Xfhdl=findobj(gcbf,'Tag','popXfile');
   Xvhdl=findobj(gcbf,'Tag','popXvar');
   Xdhdl=findobj(gcbf,'Tag','edXdir');
   
   val=get(Xfhdl,'Value');
   Files=get(Xfhdl,'String');
   Paths=cellstr(get(Xfhdl,'UserData'));
   Vars=who('-file',[Paths{val} Files{val}]);
   Vars=cellstr(strvcat('none',char(Vars)));
   set(Xvhdl,'Value',1);
   set(Xvhdl,'String',Vars);
   set(Xdhdl,'String',Paths{val});
   
case 'ListYVar'
   Yfhdl=findobj(gcbf,'Tag','popYfile');       
   Xfhdl=findobj(gcbf,'Tag','popXfile');   
   Yvhdl=findobj(gcbf,'Tag','popYvar');
	Ydhdl=findobj(gcbf,'Tag','edYdir');
   
   val=get(Yfhdl,'Value');
   Files=get(Yfhdl,'String');
   Paths=cellstr(get(Xfhdl,'UserData'));
   Vars=who('-file',[Paths{val} Files{val}]);  
   set(Yvhdl,'Value',1);
   set(Yvhdl,'String',Vars);
   set(Ydhdl,'String',Paths{val});
   
case 'PlotA'
   Xfhdl=findobj(gcbf,'Tag','popXfile');
   Xvhdl=findobj(gcbf,'Tag','popXvar');
   Yfhdl=findobj(gcbf,'Tag','popYfile');       
   Yvhdl=findobj(gcbf,'Tag','popYvar');
   
	valfx=get(Xfhdl,'Value');		% get x variable and path
   Files=get(Xfhdl,'String');
   Paths=cellstr(get(Xfhdl,'UserData'));
   xpath=[Paths{valfx} Files{valfx}];
   load(xpath);
   xvars=get(Xvhdl,'String');
   valvx=get(Xvhdl,'Value');
   if (xvars{valvx}=='none')
      xvar=-100;
   else
      xvar=eval([xvars{valvx}]);
   end
   
   valfy=get(Yfhdl,'Value');		% get y-var and path
   Files=get(Yfhdl,'String');
   Paths=cellstr(get(Xfhdl,'UserData'));
   ypath=[Paths{valfy} Files{valfy}];
   load(ypath);
   yvars=get(Yvhdl,'String');
   valvy=get(Yvhdl,'Value');
   yvar=eval([yvars{valvy}]);
   
   styles=get(gca,'Userdata');
   numlines=mod(get(gcbo,'Userdata'),length(styles))+1;	%plot line
   style=styles{numlines};
   if (xvar==-100)
      lhdl=plot(yvar,style);
      xvar=='none';
   else
   	lhdl=plot(xvar,yvar,style);	% Maybe put axis option in here
   end
   
   Pathl=cellstr(strvcat(xpath,ypath));
   set(lhdl,'Userdata',Pathl);
   set(gcbo,'Userdata',numlines);	% Update Values
   NewLine=[xvars{valvx} '-' yvars{valvy} ' ' style];
   listhdl=findobj(gcbf,'Tag','listLines');
   Lines=get(listhdl,'String');
   HndlList=get(listhdl,'Userdata');
   Lines=cellstr(strvcat(char(Lines),NewLine));
   HndlList=[HndlList lhdl];
   set(listhdl,'String',Lines);
   set(listhdl,'Userdata',HndlList);

   X=get(gca,'XLim');			% Get values for reset
   Y=get(gca,'YLim');
   resethdl = findobj(gcbf,'Tag','butReset');
   set(resethdl,'Userdata',[X Y]);
   
case 'ListDirec'
   xdirhdl=findobj(gcbf,'Tag','edXdir');
   ydirhdl=findobj(gcbf,'Tag','edYdir');
   Hndls=get(gcbo,'Userdata')		% get line handle
   val=get(gcbo,'Value')
   lhdl=Hndls(val)				
   direcs=get(lhdl,'Userdata')	% get/set path and filename	
   set(xdirhdl,'String',direcs(1));
   set(ydirhdl,'String',direcs(2));
   
case 'ClearLine'
   listhdl=findobj(gcbf,'Tag','listLines');	%get line data
   Lines=char(get(listhdl,'String'));
   [X,Y]=size(Lines);
   HndlList=get(listhdl,'Userdata');
   val=get(listhdl,'Value');
   lhdl=HndlList(val);
   
   delete(lhdl);		% delete line and update data
   NewLines=cellstr(strvcat(Lines(1:(val-1),1:Y),Lines((val+1):X,1:Y)));
   NewHndls=[HndlList(1:val-1) HndlList(val+1:length(HndlList))];
   set(listhdl,'String',NewLines);
   set(listhdl,'Userdata',NewHndls);
   set(listhdl,'Value',1);

case 'ClearAll'
   close;
   FigA2;
   
case 'Reset'
   z=get(gcbo,'Userdata');
   axis(z);
   
case 'Set'
   X=get(gca,'XLim');
   Y=get(gca,'YLim');
   olda=X(1);
   oldb=X(2);
   oldc=Y(1);
   oldd=Y(2);
   x1hdl=findobj(gcbf,'Tag','edX1');
   x2hdl=findobj(gcbf,'Tag','edX2');
   y1hdl=findobj(gcbf,'Tag','edY1');
   y2hdl=findobj(gcbf,'Tag','edY2');
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
   if get(gcbo,'Value')
      grid on;
   else 
      grid off;
   end
   
case 'Browse'
   val=get(gcbo,'Value');
   names=get(gcbo,'String');
   filehdl=findobj(gcf,'Tag','edFile');
   dirhdl=findobj(gcf,'Tag','edDir')
   direcs=get(gcbo,'UserData');
   if (direcs(val))
      s_old=pwd;
      s_new=get(dirhdl,'String');
      pathn=[s_new names{val}];
      cd(pathn);
      s=pwd;
      N=length(s);
		if ((s(N)~='\')&(s(N)~='/'))
   		s=[s '\'];
		end
      set(dirhdl,'String',s);
      cd(s_old);
      FigAcode2 ListMat;   
   else
    	newstr=[names{val}];
   	set(filehdl,'String',newstr)
   end
case 'ListMat'
   lhdl=findobj(gcf,'Tag','listFiles');
   filehdl=findobj(gcf,'Tag','edFile') ;  
   dirhdl=findobj(gcf,'Tag','edDir');
   	% Get all files (NB reverse slashe for UNix
   s=get(dirhdl,'String');
   flist=dir(s);
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
   Mats=struct2cell(dir([s '\*.mat'])); 	%get .mat files
   if(~isempty(Mats))
      Fmats=char(Mats(1,:)');
      [X,Y]=size(Fmats);
      direcs=[direcs zeros(1,X)];
      names=strvcat(names,Fmats);
   end
   names=cellstr(names);
   set(lhdl,'Value',1);
   set(lhdl,'UserData',direcs);
   set(lhdl,'String',names);
   
end

