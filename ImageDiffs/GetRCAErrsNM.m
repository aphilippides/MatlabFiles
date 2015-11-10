function[errs,errvals,otherms]=GetRCAErrsNM(dd,goal,t2,pl,opt)
if(nargin<5) opt=0; end
if(nargin<4) pl=1; end
inds=[181:360 1:180];
tvs=-180:179;
dd=dd(:,inds);
l=size(dd,1);
errs=zeros(1,l);
errvals=zeros(1,l);

% goal position
f=dd(goal,:);
tol=t2*(max(f)-min(f));
[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(f,tvs,tol,5,0);
% use only 3 lowest
if(opt)
    num_ms=min(opt,length(mi_s));
    [smi_s,s_is]=sort(mi_s);
    mi_t=mi_t(s_is(1:num_ms));
    mi_s=mi_s(s_is(1:num_ms));
end

[m,mind]=min(abs(mi_t));
errs(goal)=mi_t(mind);
errvals(goal)=mi_s(mind);
oth=[1:(mind-1) (mind+1):length(mi_t)];
otherms(goal).angs=mi_t(oth);
otherms(goal).vs=mi_s(oth);
if(pl)
    plot(tvs,f,mi_t(oth),mi_s(oth),'gs',errs(goal),errvals(goal),'ko');
    hold on;
end

% forward pass
for i=goal:1:l
    f=dd(i,:);
    tol=t2*(max(f)-min(f));
    [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(f,tvs,tol,5,0);
        % use only 3 lowest
    if(opt)
        num_ms=min(opt,length(mi_s));
        [smi_s,s_is]=sort(mi_s);
        mi_t=mi_t(s_is(1:num_ms));
        mi_s=mi_s(s_is(1:num_ms));
    end
    if(i==goal) ds=abs(mi_t);
    else ds=abs(mi_t-errs(i-1));
    end
    [m,mind]=min(ds);
    errs(i)=mi_t(mind);
    errvals(i)=mi_s(mind);
    oth=[1:(mind-1) (mind+1):length(mi_t)];
    otherms(i).angs=mi_t(oth);
    otherms(i).vs=mi_s(oth);    
    if(pl) 
%         plot(tvs,f,ma_t,ma_s,'ro',mi_t,mi_s,'gs',errs(i),errvals(i),'ks'); 
        plot(tvs,f,mi_t(oth),mi_s(oth),'gs',errs(i),errvals(i),'ko'); 
    end
end
% backward pass
for i=(goal-1):-1:1
    f=dd(i,:);
    tol=0.1*(max(f)-min(f));
    [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(f,tvs,tol,5,0);
    if(opt)
        num_ms=min(opt,length(mi_s));
        % use only 3 lowest
        [smi_s,s_is]=sort(mi_s);
        mi_t=mi_t(s_is(1:num_ms));
        mi_s=mi_s(s_is(1:num_ms));
    end
    
    ds=abs(mi_t-errs(i+1));
    [m,mind]=min(ds);
    errs(i)=mi_t(mind);
    errvals(i)=mi_s(mind);
    oth=[1:(mind-1) (mind+1):length(mi_t)];
    otherms(i).angs=mi_t(oth);
    otherms(i).vs=mi_s(oth);    
    if(pl) 
%         plot(tvs,f,ma_t,ma_s,'ro',mi_t,mi_s,'gs',errs(i),errvals(i),'ks'); 
        plot(tvs,f,mi_t(oth),mi_s(oth),'gs',errs(i),errvals(i),'ko'); 
    end
end
if(pl)
    hold off
    Setbox,xlabel('azimuth'),ylabel('Error')
    axis tight,
end