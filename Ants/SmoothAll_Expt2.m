function[os,cs,len,bads,uns]=SmoothAll_Expt2(os,t,cs,len,fn,sm_len,vObj)
if(nargin<6) sm_len=0.1; end;
if(size(os,1)>size(os,2)) os =os'; end;
Printing=1;
ignore=[];setvals=[];
bads=[];unsure=[];
os=CleanOrients(os);
o=AngleWithoutFlip(os);
so=TimeSmooth(o,t,sm_len);
for i=1:length(os)
%     if(i<5)
    figure(1), 
    plot(t,o,'r-x',t(i),o(i),'go',t,so,t(bads),o(bads),'k*',t(unsure),o(unsure),'bs')
    figure(2)
    [os(i),cs(i,:),len(i),b,u] = AdjustOrientsExpt2(so(i),cs(i,:),len(i),round(t(i)/0.02),fn,vObj);
    if(b) 
        bads=[bads i];
    elseif(~isempty(u)) 
        unsure=[unsure i];
    else 
        %                 ignore=[ignore i];
        %                 setvals=[setvals os(i)];
    end
    is=setdiff(1:length(os),bads);
    os(is)=CleanOrients(os(is));    
    % Smooth the values
    goodis=setdiff(1:length(os),[bads unsure]);
    o=AngleWithoutFlip(os);
    so=o;
    so(goodis)=TimeSmooth(o(goodis),t(goodis),sm_len);
        
%     else
%     i
%     end

    % set the smoothed values to those already adjusted or re-smooth????
%     so(ignore)=setvals;
%     csm=cs;
%     csm(goodis,1)=TimeSmooth(csm(goodis,1),t(goodis),sm_len);
%     csm(goodis,2)=TimeSmooth(csm(goodis,2),t(goodis),sm_len);
end
uns=zeros(size(os));
uns(unsure)=1;