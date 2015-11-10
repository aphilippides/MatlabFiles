function GetAllData
% dwork;
% cd GantryProj\Bees\OutdoorOF\

% THINK 16s and 17s MAYBE TOO NOISY: CHECK 17s
% DONE UP TO 16b One6s={'17', '1', '13', '14', '15', '16b', '18', '21', '23b', '24', '26', '27', '30', '31', '33', '37'};% 3 x interference (but marked) and  3 x crawling, '10', '8', '11b', '11a', '16a', '23a'}
One7s={'12', '4b', '6', '13b', '14', '15', '16', '18', '20', '24', '26', '30', '32', '34', '35', '36', '38', '44', '4a', '13a'}
% DONE Twenty1s={'7', '3', '4', '8', '10', '11', '12', '13', '14', '18', '20', '24', '26', '29'}
% DONE One9s={'6a', '1', '4b', '8b', '9b', '11b', '12b', '13', '14b', '15', '16', '3a', '4a', '8a', '9a', '11a', '12a', '14a'}
% DONE One8s={'2', '7'}
% DONE Twenty0s={'1', '2b', '3', '5b', '8', '9', '13', '15', '16b', '18', '19', '2a', '5a', '16a'}
% DONE Twenty2s={'15', '', '4', '10', '19', '20', '21'}
% DONE Twenty3s={'15', '11', '14', '1b', '2b', '3b', '10', '16', '18', '19', '20', '21a', '22', '23', '1a', '2a', '3a'} % ALSO in11
% DONE As={'-1', '3', '10', '14', '15', '16'}
Bs={'1', '6', '12', '14', '15', '16', '17', '20', '21', '24', '27'}

% % Temporary BIT
% fn=['bees_90_17_out' char(One7s(1))]
% % fn=['bee_90_23_out' char(Twenty3s(1))]
% % fn=['90_21_out' char(Twenty1s(1))];
% f=GetPaths(fn);
% bs=input('enter which bees to remove, or return')
% ts=input('enter which times to remove, or return')
% Get1Data(f,bs,ts);
% CheckVidError(fn,1)

for i=11:50%length(Twenty1s)
    %fn=['bee_90_18_out' char(One8s(i))]
    % fn=['90_21_out' char(One9s(i))]
    fn=['bees_90_B_out' char(Bs(i))]
%     TrackBee([fn '.avi']);
    f=[fn 'Path.mat'];
    f=GetPaths(fn)
    bs=input('enter which bees to remove, or return')
    ts=input('enter which times to remove, or return')
    flips=input('enter which times to flip, or return')
    Get1Data(f,bs,ts,flips);
end

function[l]=Get1Data(s,bees_out,TsRemoved,flips);
load(s);
i=strfind(s,'Path');
ff=s(1:i-1);

% Get data to get rid of
is=[];
% Select bees to get rid of
for i=bees_out
    is=union(is,find(WhichB==i));
end;

% Get rid of certain times
t=FrameNum*0.02;

% Get rid of data too close to the boundary
edges=find(OutofBounds(Bounds,[ff 'NestLMData.mat'])==1);
removed=union([is edges],GetTimes(t,TsRemoved));

% flip any that need flipping
iflips=GetTimes(t,flips);
for i=iflips
    if(Orients(i)<0) Orients(i)= Orients(i)+pi;
    else Orients(i)= Orients(i)-pi;
    end
end
save([ff 'Path.mat'],'Orients','-append')

% Remove all unwanted points
RemoveData([ff 'Path.mat'],[ff 'All.mat'],removed)
load([ff 'All.mat'])

VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));

% Check data close to the nest
onNest=find(DToNest<=(NestWid+2));
if(~isempty(onNest))
    [Orients(onNest),badFrames,bads] = AdjustOrients(Orients(onNest),Cents(onNest,:),FrameNum(onNest),[ff '.avi']);
    save([ff 'All.mat'],'Orients','-append')
%    save([ff 'Path.mat'],'Orients','-append')
    onNest=onNest(bads);
    RemoveData([ff 'All.mat'],[ff 'All.mat'],onNest);
    clear badFrames bads
    load([ff 'All.mat'])
end

% Smooth the data
sm_len=0.1;
[Orients,t_db,sOr,BadPoints]=SmoothOs(Orients,t,1,Cents,[ff '.avi'],sm_len);

RemoveData([ff 'All.mat'],[ff 'All.mat'],BadPoints);
load([ff 'All.mat'])

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n');
    if(a==0) break; end;
end 
[sOr,badis] = AdjOrients(sOr,Cents,FrameNum,[ff '.avi']);
is=setdiff(1:length(sOr),badis);
sOr=sOr(is);
RemoveData([ff 'All.mat'],[ff 'All.mat'],badis);
load([ff 'All.mat'])

plot(FrameNum,AngleWithoutFlip(sOr)*180/pi,'g');
input('Press return to continue');
% sOr=TimeSmooth(AngleWithoutFlip(Orients),t,sm_len);

Speeds=Speeds*0.02;
Vels=Vels*0.02;

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,10);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');
VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
DToLM=sqrt(sum(VToLM.^2,2));
OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
LMOnRetina=AngularDifference(OToLM,sOr');

clear i f s fn is i_out
save([ff 'All.mat'])

function RemoveData(fnin,fnout,i_out,set_os)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
t=FrameNum*0.02;
Areas=Areas(is);
Cents=Cents(is,:);
if(nargin<4) Orients=Orients(is);
else 
    Orients=set_os;
    clear set_os;
end
WhichB=WhichB(is);
EndPt=EndPt(is,:);
Bounds=Bounds(is,:);
Eccent=Eccent(is);
v1=MyGradient(Cents(is,1),FrameNum(is));
v2=MyGradient(Cents(is,2),FrameNum(is));
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

clear i_out fnin;
save(fnout)

function[Orients,bads] = AdjOrients(Orients,Cents,FrameNum,fn)
% Get the correct frames from Framenum
% Look at the offending data 
% Flip any that are necessary via return to flip, 
% anything else to skip eg
bads=[];
while 1
    a=AngleWithoutFlip(Orients)*180/pi;
    plot(FrameNum,a,'b-x',FrameNum(bads),a(bads),'ks')
    grid on;
    inp=input('enter frames to flip; -1 to end; -2 to run CleanOrients\n');
    if(~isempty(inp))
        if(inp==-1) break;
        elseif(inp==-2) Orients=CleanOrients(Orients);
        else
            for k=inp
                i=find(FrameNum==k);
                if(~isempty(i))
                    [Orients(i),badframes,b] = AdjustOrients(Orients(i),Cents(i,:),FrameNum(i),fn);
                    if(~isempty(b)) bads=[bads i]; end;
                end
            end
        end
    end
end