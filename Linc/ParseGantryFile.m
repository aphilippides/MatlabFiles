function[out]=ParseGantryFile(fn)

h=dlmread(fn);
h=h(9:end,:);
out.x=h(:,1);
out.y=h(:,2);
out.alvx=h(:,3);
out.alvy=h(:,4);
out.alvth=cart2pol(out.alvx,out.alvy);
out.wptx=h(:,5);
out.wpty=h(:,6);
out.wptth=cart2pol(out.wptx,out.wpty);
out.nlm=h(:,7);
out.rawx=h(:,8);
out.rawy=h(:,9);
out.prevx=h(:,10);
out.prevy=h(:,11);
out.sigma=h(:,12);
out.movex=h(:,13);
out.movey=h(:,14);
out.resolved=h(:,15:104);
out.filled=h(:,105:194);
out.final=h(:,195:284);
out.noisex=out.movex-out.rawx;
out.noisey=out.movey-out.rawy;
out.dir=cart2pol(out.movex,out.movey);
out.dirraw=cart2pol(out.rawx,out.rawy);
out.dirprev=cart2pol(out.prevx,out.prevy);
if(isempty(strfind(fn,'learn'))) [out.wpts,out.whichWpt]=GetWaypoints(out);
else 
    [out.wpts,out.whichWpt]=GetWaypointsLearn(out);
    out.wptx=out.wpts(out.whichWpt,2);
    out.wpty=out.wpts(out.whichWpt,3);
    out.wptth=out.wpts(out.whichWpt,6);
end


function[WPts,WhichWpt] = GetWaypointsLearn(out)
ts=[find(diff(out.nlm)); length(out.wpty)];
WPts=[ts out.alvx(ts) out.alvy(ts) out.x(ts) out.y(ts) out.alvth(ts)];
oldn=1;
for j=1:length(ts)
    n=ts(j);
    WhichWpt(oldn:n)=j;
    oldn=n+1;
end

function[WPts,WhichWpt] = GetWaypoints(out)
ts=[find(diff(out.nlm))+1; length(out.wpty)];
WPts=[ts out.wptx(ts) out.wpty(ts) out.x(ts) out.y(ts) out.wptth(ts)];
oldn=1;
for j=1:length(ts)
    n=ts(j);
    WhichWpt(oldn:n)=j;
    oldn=n+1;
end