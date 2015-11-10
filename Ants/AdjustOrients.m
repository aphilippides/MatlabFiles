function[Orients,badframes,bads] = AdjustOrients(Orients,Cents,FrameNum,fn)
bads=[];
badframes=[];
[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;
for k=1:length(FrameNum)
    fr=floor((FrameNum(k)+1)/2);
    f=MyAviRead(fn,fr);
    DrawBeeBox(f,Cents(k,:),EndPt(k,:));
    title(['frame ' int2str(FrameNum(k))])
    xlabel('return if ok; click to adjust head; right click to remove')
    [p,q,r]=ginput(1);
    if(~isempty(r))
        if(r~=1)
            badframes=[badframes FrameNum(k)];
            bads=[bads k];
        else
            while 1
                EndPt(k,:) = [p q];
                v=EndPt(k,:)-Cents(k,:);
                Orients(k) = cart2pol(v(1),v(2));
                DrawBeeBox(f,Cents(k,:),EndPt(k,:));
                title('input new point, return to end')
                [p q r] = ginput(1);
                if(isempty(p)) break; end;
            end
        end
    end
end