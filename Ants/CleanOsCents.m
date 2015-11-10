function[Orients,Cent_Os,Speeds]=CleanOsCents(Cents,Orients,FrameNum,WhichB)

if(nargin<4)
    WhichB=ones(size(Orients));
end
ilist=unique(WhichB);
Vels=zeros(size(Cents));
for i=ilist
    is = find(WhichB==i);
    v1=MyGradient(Cents(is,1),FrameNum(is));
    v2=MyGradient(Cents(is,2),FrameNum(is));
    Vels(is,:)=[v1' v2'];
end
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

% for all paths, check which orientation is consistent
% when bee enters and use that to determine flip

for i=1:length(ilist)
    is = find(WhichB==ilist(i));
    o1s=CleanOrients(Orients(is));
    o2s=CleanOrients(Orients(is),1);
    d1s=AngularDifference(o1s',Cent_Os(is));
    d2s=AngularDifference(o2s',Cent_Os(is));
    b1=length(find(abs(d1s)>(pi/2)));
    b2=length(find(abs(d2s)>(pi/2)));
    if(b1<b2) 
        Orients(is) = o1s;
    else
        Orients(is) = o2s;
    end
end