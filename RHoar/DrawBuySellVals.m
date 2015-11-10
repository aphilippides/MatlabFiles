function DrawBuySellVals(buysell,m1m2,p1p2,updown,ud2,s1s2,e1e2,d1d2, ...
    tr,trs,chanBS,retBS,c1c2)
fs=10;
% xpos=1.01;
xpos=-2.3;
xpos2=1.025;
fpos=get(gcf,'Position');
fht=fpos(4);
ycm=0.1*fht;
aht=fht*0.825;

% if(nargin==12)
%     if(~isempty(chanBS))
%         lastb=find(chanBS(:,2)==1,1,'last');
%         if(~isempty(lastb))
%             str=['CHBUY: ' num2str(chanBS(lastb,3))];
%             text(xpos2,0.075,str,'Units','normalized', ...
%                 'Color','b','FontSize',fs);
%         end
%         lastb=find(chanBS(:,2)==0,1,'last');
%         if(~isempty(lastb))
%             str=['CHSEL: ' num2str(chanBS(lastb,3))];
%             text(xpos2,0,str,'Units','normalized', ...
%                 'Color','r','FontSize',fs);
%         end
%     end
%     if(~isempty(retBS))
%         lastb=find(retBS(:,2)==1,1,'last');
%         if(~isempty(lastb))
%             str=['RBUY: ' num2str(retBS(lastb,3))];
%             text(xpos2,1.075*aht+ycm,str,'Units','normalized', ...
%                 'Color','b','FontSize',fs);
%         end
%         lastb=find(retBS(:,2)==0,1,'last');
%         if(~isempty(lastb))
%             str=['RSEL: ' num2str(d1d2(lastb,3))];
%             text(xpos2,1.0*aht+ycm,str,'Units','normalized', ...
%                 'Color','r','FontSize',fs);
%         end
%     end
% end

if(~isempty(buysell))
    lastb=find(buysell(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['BUY:  ' num2str(buysell(lastb,3))];
        text(xpos,0.85*aht+ycm,str,'Units','centimeters', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(buysell(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['SELL: ' num2str(buysell(lastb,3))];
        text(xpos,0.8*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(m1m2))
    lastb=find(m1m2(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['MUP:  ' num2str(m1m2(lastb,3))];
        text(xpos,0.7*aht+ycm,str,'Units','centimeter', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(m1m2(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['MDN:  ' num2str(m1m2(lastb,3))];
        text(xpos,0.65*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(p1p2))
    lastb=find(p1p2(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['eTU:  ' num2str(p1p2(lastb,3))];
        text(xpos,0.55*aht+ycm,str,'Units','centimeter', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(p1p2(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['eTD:  ' num2str(p1p2(lastb,3))];
        text(xpos,0.5*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(updown))
    lastb=find(updown(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['UP:   ' num2str(updown(lastb,3))];
        text(xpos,0.4*aht+ycm,str,'Units','centimeter', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(updown(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['DOWN: ' num2str(updown(lastb,3))];
        text(xpos,0.35*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(ud2))
    lastb=find((ud2(:,2)==1)|(ud2(:,2)==-1),1,'last');
    if(~isempty(lastb))
        str=['UP1:  ' num2str(ud2(lastb,3))];
        text(xpos,0.25*aht+ycm,str,'Units','centimeter', ...
            'Color','b','FontSize',fs);
    end
    lastb=find((ud2(:,2)==0)|(ud2(:,2)==-2),1,'last');
    if(~isempty(lastb))
        str=['DWN2: ' num2str(ud2(lastb,3))];
        text(xpos,0.2*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(c1c2))
    lastb=find((c1c2(:,2)==1)|(c1c2(:,2)==-1),1,'last');
    if(~isempty(lastb))
        str=['CBUY:  ' num2str(c1c2(lastb,3))];
        text(xpos,0.1*aht+ycm,str,'Units','centimeter', ...
            'Color','b','FontSize',fs);
    end
    lastb=find((c1c2(:,2)==0)|(c1c2(:,2)==-2),1,'last');
    if(~isempty(lastb))
        str=['CSEL: ' num2str(c1c2(lastb,3))];
        text(xpos,0.05*aht+ycm,str,'Units','centimeter', ...
            'Color','r','FontSize',fs);
    end
end

% second column
if(~isempty(s1s2))
    lastb=find(s1s2(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['HI 2: ' num2str(s1s2(lastb,3))];
        text(xpos2,0.675,str,'Units','normalized', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(s1s2(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['LOW1: ' num2str(s1s2(lastb,3))];
        text(xpos2,0.6,str,'Units','normalized', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(e1e2))
    lastb=find(e1e2(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['DBUY: ' num2str(e1e2(lastb,3))];
        text(xpos2,0.475,str,'Units','normalized', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(e1e2(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['DSEL: ' num2str(e1e2(lastb,3))];
        text(xpos2,0.4,str,'Units','normalized', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(d1d2))
    lastb=find(d1d2(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['TBUY: ' num2str(d1d2(lastb,3))];
        text(xpos2,0.275,str,'Units','normalized', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(d1d2(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['TSEL: ' num2str(d1d2(lastb,3))];
        text(xpos2,0.2,str,'Units','normalized', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(chanBS))
    lastb=find(chanBS(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['CHBUY: ' num2str(chanBS(lastb,3))];
        text(xpos2,0.075,str,'Units','normalized', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(chanBS(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['CHSEL: ' num2str(chanBS(lastb,3))];
        text(xpos2,0,str,'Units','normalized', ...
            'Color','r','FontSize',fs);
    end
end
if(~isempty(retBS))
    lastb=find(retBS(:,2)==1,1,'last');
    if(~isempty(lastb))
        str=['RBUY: ' num2str(retBS(lastb,3))];
        text(xpos2,0.875,str,'Units','normalized', ...
            'Color','b','FontSize',fs);
    end
    lastb=find(retBS(:,2)==0,1,'last');
    if(~isempty(lastb))
        str=['RSEL: ' num2str(retBS(lastb,3))];
        text(xpos2,0.8,str,'Units','normalized', ...
            'Color','r','FontSize',fs);
    end
end
if(tr==1) text(xpos2,0.95,trs,'FontSize',14,'Color','b','Units','normalized');
elseif(tr==0) text(xpos2,0.95,trs,'FontSize',14,'Color','r','Units','normalized');
end
