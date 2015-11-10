function CRUK_Stats

% generates the stats for exp1(VR2 overtaking rate)
 dostats(1)

% generates the stats for exp 2 (VEGFR1 overtaking rate)
% dostats(2)


function dostats(o)

% dwork
% cd CRUK\Paper\

if(nargin==0)
    o=1;
end
if(o==1)
    strs={'VR2Chimera.xls';'CtrlBVR2.xls';'CtrlAVR2.xls'};
else
    strs={'VR1Chimera.xls';'CtrlBVR1.xls';'CtrlAVR1.xls'};
end

c=1;
% this bit just gets all the data
me=zeros(50,9)*NaN;
n=me;
for j=1:3
    [a,b]=xlsread(char(strs(j)));
    % cols = AQ CG A
    cs=[26+17 78+7 1];
    for i=1:3
        v=a(:,cs(i));
        e=a(:,cs(i)+10);
        ep=find(~isnan(e));
        %     ep=[0;ep(1:end-2)];
        if(length(ep)<50)
                    ep=[0;ep];
        else
        ep=[0;ep(1:50)];
        end
        [tot_m(c),me(:,c),n(:,c)]=getdat(v,ep);
        c=c+1;
    end
end

% This is a comparison of the total mean that Kate reported
% vs the mean I get, just to check it is the right data (which it is)
% M1aM2c	M1aM2b	M2bM1b	M2cM1b	M2cM1c	M2bM1c	M1(a)M2(a)	M1(b)M2(a)	M1(c)M2(a)
if(o==1)
d=[1.98	    2.74	3.7	     3.4	3.08	3.45	2.2	        2.5	        2.35];
else
d=[5.4	5.75	4.17	6.77	6.9	4.64	9.49	15.11	15.81];    
end
check=[d;tot_m([7 4 5 6 9 8 1 2 3])]


% this shows the order of the models in the multcompare graphs
% ie 1 is M1aM2a etc
ls={'M1aM2a.xls';'M1bM2a.xls';'M1cM2a.xls';...
     'M1aM2b.xls';'M1bM2b.xls';'M1cM2b.xls';...
     'M1aM2c.xls';'M1bM2c.xls';'M1cM2c.xls'};


% this compares medians
[p,a,st]=kruskalwallis(me);
multcompare(st,'ctype','bonferroni');
% the above does the multiple comparion with bonferroni correction for the
% number of comparisons. You can do it with 'least-significant differences'
% via but I'm ot sure how valid this is
%multcompare(st,'ctype','lsd')

% this compares means
[p,a,st]=anova1(me);
multcompare(st,'ctype','bonferroni');




% [a,b]=xlsread('M1cM2a.xls');
% ep=[0;ep(1:end-1)];


function[tot_m,me,n]=getdat(v,ep)
me=zeros(1,50)*NaN;
n=zeros(1,50)*NaN;

tot_m=mean(v(~isnan(v)));
for i=1:(length(ep)-1)
    vt=v((ep(i)+1):ep(i+1));
    n(i)=sum(~isnan(vt));
    me(i)=mean(vt(~isnan(vt)));
end 