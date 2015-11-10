% function PlotNestAndLMs(LM,LMWid,nest,biglm,rev,ppic)
%
% Plots nest and landmarks. LMs are 2d row vectors with widths in lmw
% nest is a 2d row vector
% if biglm is not 0 or empty (default) lms are plotted twice as wide (was
% useful for a  paper
%
% if rev is 1 (default), axes are reversed
%
% if ppic is one, lets you do non default colours (grey) for the LMs
function PlotNestAndLMs(LM,LMWid,nest,biglm,rev,ppic);
ho=ishold;
if(nargin<6) ppic=0; end;
if((nargin<5)||isempty(rev)) rev=1; end;
if((nargin<4)||isempty(biglm)) biglm=0; end;

if(ppic) 
    lcol=[[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5]];%;['r';'k';'y';'g'];
    lcol2=['k';'k';'k';'k'];
else
    lcol=['r';'k';'y';'g'];
    lcol2=['k';'w';'k';'k'];
end
lmo=LMOrder(LM);
lcol=lcol(lmo,:);
lcol2=lcol2(lmo,:);
if(biglm==1) 
    MyCircle(LM,LMWid,lcol,[],1);
else
    MyCircle(LM,LMWid*0.5,lcol,[],1);
end
hold on
ls=MyCircle(LM,LMWid*0.5,lcol2);
for i=1:length(ls) set(ls(i),'LineWidth',1.5); end
plot(nest(1),nest(2),'k+','MarkerSize',10,'LineWidth',3)
if(~ho) hold off; end;
if(rev) set(gca,'YDir','reverse'); end;