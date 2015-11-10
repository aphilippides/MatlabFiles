% function Landscape1D().
% Plots fitness against loci value for each node (19 values per node)
% Saves eps/jpeg/matlab output as Fitness10.eps/jpg/m

function Landscape1D(Landscape, Individual)

PRINT_SCREEN = 1;								% PRINT_SCREEN - do we want onscreen version?
PRINT_EPS = 0;									% PRINT_EPS - do we want eps paper version?
PRINT_AI = 0;									% PRINT_AI - do we want ai poster version?

if (PRINT_EPS)
   PRINT_POSTER = 0;
   PRINT_TYPE = 'eps';
%   DoTheWork(Landscape, Individual, PRINT_POSTER, PRINT_TYPE);
   DoTheWork2(Landscape, PRINT_POSTER, PRINT_TYPE);
   close all;
end;
if (PRINT_AI)
   PRINT_POSTER = 1;
   PRINT_TYPE = 'ai';
%   DoTheWork(Landscape, Individual, PRINT_POSTER, PRINT_TYPE);
   DoTheWork2(Landscape, PRINT_POSTER, PRINT_TYPE);
   close all;
end;
if (PRINT_SCREEN)
   PRINT_POSTER = 0;
   PRINT_TYPE = 'None';
%   DoTheWork(Landscape, Individual, PRINT_POSTER, PRINT_TYPE);
   DoTheWork2(Landscape, PRINT_POSTER, PRINT_TYPE);
end;

%---------------------------------------------------------------------------
% Actually does the work. Calls to print all graphs
%---------------------------------------------------------------------------
function DoTheWork(Landscape, Individual, PRINT_POSTER, PRINT_TYPE);

% Set up the font sizes etc for poster / printing
if (PRINT_POSTER)
   GraphType{1} = 'r-';							% red/green/blue line graphs
   GraphType{2} = 'b-';
   GraphType{3} = 'y-';
   GraphType{4} = 'g--';
   GraphType{5} = 'm--';
   GraphType{6} = 'c--';
   GraphType{7} = 'k:';
   ChartType{1} = 'flag';								% red single bar charts
   ChartTypeN = 'flag';								% red/white/blue/black multiple bar charts
   PrintFontSize = 18;
   PrintFontName = 'Arial';
   PrintFaceColor = [1 0 0];
   PrintLineWidth = 3;
else
   GraphType{1} = 'k-';							% black solid/dashed/dotted line graphs
   GraphType{2} = 'k-.';
   GraphType{3} = 'k--';
   GraphType{4} = 'k:';
   GraphType{5} = 'k-';
   GraphType{6} = 'k-.';
   GraphType{7} = 'k--';
   ChartType{1} = 'gray';								% black single bar charts
   ChartTypeN = 'gray';								% black-grayscale-white multiple bar charts
   PrintFontSize = 16;
   PrintFontName = 'Arial';
   PrintFaceColor = [0.8 0.8 0.8];
   PrintLineWidth = 2;
end;

LociNames = {'X' 'Y' 'R^+' '\theta^+_1' '\theta^+_2' 'R^-' '\theta^-_1' '\theta^-_2' 'R^I' '\theta^I' 'T^I' '\Delta T' 'R^E' 'A^k' 'B' 'Rec' 'I_{on}' 'T_{em}' 'C_{em}'};

% load in landscape data file and set number of nodes
NodeLength = 19;
LandscapeData = load(Landscape);
NumNodes = size(LandscapeData,1) / NodeLength;

% load in individual data file, and set length
IndividualData = load(Individual);			
IndividualLength = length(IndividualData)-1;			% Take off TERM
count=1;

% check all read in Ok
if (IndividualLength ~= (NumNodes * NodeLength)) 'Data read in Ok';
else 'Data error';
end;

% Plot single node data
for node=1:NumNodes
   figure;
   for locus=1:NodeLength   
      subplot(10,2,locus);
      hold on;
      plot(0:99,LandscapeData((node-1)*NodeLength + locus,1:100),GraphType{1});
      plot([IndividualData(count) IndividualData(count)],[0.0 1.0],GraphType{1},'LineWidth',PrintLineWidth);
      count=count+1;
      
      grid on;
      set(gca,'ytick',[0 1]);
      set(gca,'FontSize',PrintFontSize);
      set(gca,'FontName',PrintFontName);
      if (locus<18) set(gca,'xticklabel',[]);
      else xlabel('Locus value');
      end;
      if (locus==9) ylabel('Fitness \in [0,1]');
      end;
      if (locus==1) 
         msg = ['Node ',num2str(node-1)];
         if (node==1) msg = 'RF motor node'; end;
         if (node==2) msg = 'LF motor node'; end;
         if (node==3) msg = 'RB motor node'; end;
         if (node==4) msg = 'LB motor node'; end;
         text(0,2.0,msg,'FontName',PrintFontName,'FontSize',PrintFontSize,'FontWeight','bold');
      end;
      text(102,0.5,LociNames{locus},'FontName',PrintFontName,'FontSize',PrintFontSize);
      ylim([-0.1 1.1]);
      xlim([0 100]);
   end
   
   FileNamePrefix = ['Landscape1D_Node' num2str(node-1)];
   if (strcmp(PRINT_TYPE, 'eps'))
      FileName = strcat(FileNamePrefix, '.eps');
      print(FileName, '-depsc');
   elseif (strcmp(PRINT_TYPE, 'ai'))
      FileName = strcat(FileNamePrefix, '.ai');
      print(FileName, '-dill');
   end;
end


%---------------------------------------------------------------------------
% Actually does the work. Calls to print all graphs
%---------------------------------------------------------------------------
function DoTheWork2(Landscape, PRINT_POSTER, PRINT_TYPE);

% Set up the font sizes etc for poster / printing
if (PRINT_POSTER)
   GraphType{1} = 'r-';							% red/green/blue line graphs
   GraphType{2} = 'b-';
   GraphType{3} = 'y-';
   GraphType{4} = 'g--';
   GraphType{5} = 'm--';
   GraphType{6} = 'c--';
   GraphType{7} = 'k:';
   ChartType{1} = 'flag';								% red single bar charts
   ChartTypeN = 'flag';								% red/white/blue/black multiple bar charts
   PrintFontSize = 18;
   PrintFontName = 'Arial';
   PrintFaceColor = [1 0 0];
   PrintLineWidth = 3;
else
   GraphType{1} = 'k-';							% black solid/dashed/dotted line graphs
   GraphType{2} = 'k-.';
   GraphType{3} = 'k--';
   GraphType{4} = 'k:';
   GraphType{5} = 'k-';
   GraphType{6} = 'k-.';
   GraphType{7} = 'k--';
   ChartType{1} = 'gray';								% black single bar charts
   ChartTypeN = 'gray';								% black-grayscale-white multiple bar charts
   PrintFontSize = 12;
   PrintFontName = 'Arial';
   PrintFaceColor = [0.8 0.8 0.8];
   PrintLineWidth = 2;
end;

LociNames = {'X' 'Y' 'R^+' '\theta^+_1' '\theta^+_2' 'R^-' '\theta^-_1' '\theta^-_2' 'R^I' '\theta^I' 'T^I' '\Delta T' 'R^E' 'Gas_X' 'Gas_Y' 'A^k' 'B' 'Rec' 'I_{on}' 'T_{em}' 'C_{em}'};

% load in landscape data file and set number of nodes
NodeLength = 21;
LandscapeData = load(Landscape);
NumNodes = LandscapeData(1,1);

% load in individual data file, and set length
inds = find(LandscapeData(2:end,4)==0);
IndividualData=LandscapeData(inds,3)

% Plot single node data
count=1;
for node=1:NumNodes
   figure;
   for locus=1:NodeLength   
      subplot(11,2,locus);
      hold on;
%      is=find((LandscapeData(2:end,1)==2)&(LandscapeData(2:end,2)==0));
      index=(node-1)*100+(locus-1)*100*NumNodes+2;
      plot(0:99,mean(LandscapeData(index:index+99,7:end)'),GraphType{1});
      plot([IndividualData(count) IndividualData(count)],[0.0 1.0],GraphType{1},'LineWidth',PrintLineWidth);
      count=count+1;
      
      grid on;
      set(gca,'ytick',[0 1]);
      set(gca,'FontSize',PrintFontSize);
      set(gca,'FontName',PrintFontName);
      if (locus<20) set(gca,'xticklabel',[]);
      else xlabel('Locus value');
      end;
      if (locus==9) ylabel('Fitness \in [0,1]');
      end;
      if (locus==1) 
         msg = ['Node ',num2str(node-1)];
         if (node==1) msg = 'RF motor node'; end;
         if (node==2) msg = 'LF motor node'; end;
         if (node==3) msg = 'RB motor node'; end;
         if (node==4) msg = 'LB motor node'; end;
         text(0,2.0,msg,'FontName',PrintFontName,'FontSize',PrintFontSize,'FontWeight','bold');
      end;
      text(102,0.5,LociNames{locus},'FontName',PrintFontName,'FontSize',PrintFontSize);
      ylim([-0.1 1.1]);
      xlim([0 100]);
   end
   
   FileNamePrefix = ['Landscape1D_Node' num2str(node-1)];
   if (strcmp(PRINT_TYPE, 'eps'))
      FileName = strcat(FileNamePrefix, '.eps');
      print(FileName, '-depsc');
   elseif (strcmp(PRINT_TYPE, 'ai'))
      FileName = strcat(FileNamePrefix, '.ai');
      print(FileName, '-dill');
   end;
end