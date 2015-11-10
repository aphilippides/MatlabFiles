% function plotdata(fn,fs,ts,ns,ls)
%
% plotdata plots data from files against time
%
% first argument is a string to filter which files are picked
% second argument is the variables you want to plot
% third argument is the range of times you want to use
% fourth argument is the range of retinal positions of nest you want
% fifth argument is the range of retinal positions of nest you want
%
% USAGE:
%
% to choose files and distances:                       >> plotdata
% to choose files with 'out' in their name:            >> plotdata('out')
% to choose files, plot vraiables 1 and 2 and data
% and data where nest is retinally -10:10 (degrees)    >> plotdata([],[1,2],[],[-10 10])

function plotdataZZ(fs,ns,ls)

load processzigzagsin

% if(nargin<1) fn=[]; end;
%     s=dir(['*' fn '*All.mat']);
    WriteFileOnScreenZZ(fltsec,1);
    Picked=input('select file numbers:   ');
    if(~isempty(Picked)) fltsec=fltsec(Picked);    end


if((nargin<2)|isempty(fs)) 
    disp('Variables are:\n') 
    disp('1: Dist To Nest;                   2: Body Orientation')
    disp('3: Angle relative to nest;         4: Speed')
    disp('5: Flight Direction;               6: Retinal nest position')
    disp('7: angular speed')    
    disp('8+num of LM: Retinal LM position   0: FlightDir - Body Orientation')    
    disp('12: body orientation rel 2 nest    13: FlightDir rel 2 nest')    
    disp('14: body orientation and flight direction rel 2 nest')    
    fs=input('\nSelect variables to plot:   ');
end;
% if(nargin<3) 
%     disp(' ')
%     disp(['input times to show in secs [t1 t2] between 0 and ' num2str(max(t))]);
%     ts=input('Enter t for [0 t] or return for all times:  ');
%     if(size(ts,2)==1) ts=[0 ts]; end
% end
% if(nargin<4)
%     disp(' ')
%     disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
%     ns=input('Enter just r for [-r r] or return to skip: ');
% end
if(nargin<3)
    disp(' ')
    disp('Enter range of retinal positions of LMs as [r1 r2] in degrees.');
    ls=input('Enter just r for [-r r] or return to skip: ');
end
ns=10;

n=length(fs);
lcol=['r';'k';'y';'g'];
for fnum=1:length(fltsec)
    nz=length(fltsec(fnum).fsec);
    if(nz>0) st=file2struct(fltsec(fnum).fn);
        [ins,ils]=LookingPts(ns,ls,st);
        lenils=length(ils);
        t=st.t;
    end
    for zn=1:nz
        is=fltsec(fnum).fsec(zn).is;
        for i=1:n
            subplot(n,1,i)
            [x,str,ang]=GetData(st,fs(i));
            % if angular data try to get it around 0 to 360
            if(ang==2)
                mang=mean(x(is));
                %             if(mang<0)
                %                 while(mean(x(is))<=-360) x(is)=x(is)+360; end
                %             else
                %                 while(mean(x(is))>=360) x(is)=x(is)-360; end
                %             end
                if(mang<0)
                    while(abs(mang)>abs(mean(x(is)+360)))
                        x(is)=x(is)+360;
                        mang=mean(x(is));
                    end
                else
                    while(abs(mang)>abs(mean(x(is)-360)))
                        x(is)=x(is)-360;
                        mang=mean(x(is));
                    end
                end
            end
            cst=['b ';'r:'];
            for k=1:size(x,1)
                plot(t(is),x(k,is),cst(k,:))
                hold on;
                PlotThicks(ins,t,x(k,:),'b')%,'LineWidth',2);
                for j=1:lenils
                    ks=ils(j).is;
                    PlotThicks(ks,t,x(k,:),lcol(j,:))%,'LineWidth',2);
                end
            end
            %         axis tight,
            title(str)
            xlim([t(is(1)) t(is(end))])
            xx=x(:,is);xx=xx(:);
            if(~ang) ylim([0 max(xx)]);
            else ylim([min(xx) max(xx)]);
            end;
            hold off;
        end
        xlabel(fltsec(fnum).fn)
        str2=[int2str(fnum) ': ' fltsec(fnum).fn ' ZZ ' ...
            int2str(zn) '/' int2str(nz) '; return to continue;'];
        disp(str2);
        pause;
    end
end


function PlotThicks(ins,t,x,c)
k=ishold(gca);
d=diff(ins);
ps=find(d>1);
ps=[0 ps' length(ins)];
for i=1:length(ps)-1;
    ss=ins(ps(i)+1:ps(i+1));
    if(length(ss)==1) 
        if(ss<length(t)) ss=[ss ss+1]; end
    end
    plot(t(ss),x(ss),c,'LineWidth',3)
    hold on
end
if(~k) hold off; end

function[ins,ils]=LookingPts(ns,ls,st);
if(isempty(ns)) ins=[];
else
    if(length(ns)==1) ns=[-ns ns]; end;
    ns=ns*pi/180;
    n=st.NestOnRetina;
    ins=find((n>=ns(1))&(n<ns(2)));
end

for i=1:length(st.LMs) LMs(i,:)=st.LMs(i).LM; end;
if(isempty(ls)) ils=[];
else
    if(length(ls)==1) ls=[-ls ls]; end;
    ls=ls*pi/180;
    lmo=LMOrder(LMs);
    for i=1:length(st.LMs)
        ll=st.LMs(i).LMOnRetina;
        ils(lmo(i)).is=find((ll>=ls(1))&(ll<ls(2)));
    end
end

function[x,s,ang]=GetData(st,i);
% load(fn)
if(i==1) 
    x=[st.DToNest]';
    s=('Distance from Nest (cm)');
    ang=0;
elseif(i==0) 
    x=AngularDifference(st.Cent_Os,st.sOr)'*180/pi;
%     x=AngleWithoutFlip(AngularDifference(st.Cent_Os,st.sOr))*180/pi;
%     s=('Flight direction relative to body axis (degrees)');
    s=('\psi (degrees)');
    ang=1;
elseif(i==2) 
    x=st.sOr;
    x=AngleWithoutFlip(x)*180/pi;
    s=('Orientation (degrees). N=0');
    ang=2;
elseif(i==3) 
    eval(['x=st.OToNest;']);
    x=AngleWithoutFlip(x')*180/pi;
    s=('Angular position wr to nest(degrees). N=0');
    ang=2;
elseif(i==4) 
    eval(['x=st.Speeds;']);
    x=TimeSmooth(x,st.t,0.1);
    s=('Speed (cm/s)');
    ang=0;
elseif(i==5) 
    eval(['x=st.Cent_Os;']);
    x=TimeSmooth(AngleWithoutFlip(x)*180/pi,st.t,0.1);
%     x=mod(x,360);
    s=('Direction of flight');
    ang=2;
elseif(i==6) 
    eval(['x=st.NestOnRetina;']);
%     x=AngleWithoutFlip(x)*180/pi;
    x=x'*180/pi;
    s=('Retinal position of nest (degrees). 0 = facing');
    ang=1;
elseif(i==7) 
    eval(['x=st.Cent_Os;']);
    x2=TimeSmooth(AngleWithoutFlip(x)*180/pi,st.t,0.1);
    x=MyGradient(x2,st.t);
%     x=mod(x,360);
    s=('Angular Speed');
    ang=2;
elseif(i==12)
    x=AngularDifference(st.Cent_Os,st.OToNest)'*180/pi;
    s=('Flight direction relative to nest');
    ang=1;
elseif(i==13) 
    x=AngularDifference(st.sOr,st.OToNest)*180/pi;
    s=('Body orientation relative to nest');
    ang=1;
elseif(i==14) 
    x(1,:)=AngularDifference(st.Cent_Os,st.OToNest)'*180/pi;
    x(2,:)=AngularDifference(st.sOr,st.OToNest)*180/pi;
    s=('Body orientation (solid) and flight direction (dots) relative to nest');
    ang=1;
elseif(i>=8) 
    for j=1:length(st.LMs) LMs(j,:)=st.LMs(j).LM; end;
    lmo=LMOrder(LMs);
    lmnum=i-7;
    ind=find(lmo==lmnum);
    eval(['x=st.LMs(ind).LMOnRetina;']);
%     x=AngleWithoutFlip(x)*180/pi;
    x=x'*180/pi;
    [lst,lc]=LMStr(ind,LMs);
    s=(['Retinal position of ' lst ' LM (degrees). 0 = facing']);
    ang=1;
end

function WriteFileOnScreenZZ(fns, NumOnLine)
if isempty(fns) return; end
L=length(fns);
N=fix(L/NumOnLine)-1;
M=rem(L,NumOnLine);
for i=0:N
    for j=1:NumOnLine
        fn=i*NumOnLine+j;
        fprintf('%d:  %s ',fn,fns(fn).fn);
    end
    fprintf('\n');
end
for i=1:M
    fn=(N+1)*NumOnLine+i;
    fprintf('%d:  %s ',fn,fns(fn).fn);
end