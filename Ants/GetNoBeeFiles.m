function[nd,tot]=GetNoBeeFiles(ss,reflist)

cd E:\

GetNBF(ss(39:end),reflist(39:end));

[nd,tot,bads]=CountDels(ss,reflist)
ToBeDeleted=nd;
bads

function GetNBF(ss,reflist)
for j=1:length(ss)
    [dn,m,nf] = FolderInfo(ss(j));
    Cents=ones(m,2)*-1000;Orients=ones(1,m)*-10;Eccent=ones(1,m)*-10;
    ToBeDeleted=zeros(1,m); NumBees=ones(1,m)*-1;Areas=ones(1,m)*-1;
    fn=['HiSpeedData' int2str(ss(j)) '.mat'];
    if(reflist(j)>0)
        cd(dn);
        refim=imread(GetDVRname(reflist(j),m));
        refimi=reflist(j);
        numb=1;
        tbd=1;
        for i=1:m
            if(~mod(i,10))
                [j i m]
            end
            im=imread(GetDVRname(i,m));
            [n,c,a,o,e]=Find1Bee_HiSpeed(refim,im);
            NumBees(i)=n;
            if(n==1)
                Areas(numb)=a;
                Cents(numb,:)=c;
                Orients(numb)=o;
                Eccent(numb)=e;
                numb=numb+1;
            elseif(n>1)
                nn=numb+n-1;
                Areas(numb:nn)=a;
                Cents(numb:nn,:)=c;
                Orients(numb:nn)=o;
                Eccent(numb:nn)=e;
                numb=nn+1;
            else
                ToBeDeleted(tbd)=i;
                tbd=tbd+1;
            end;
            save(fn,'dn','Areas','NumBees','Cents','Orients', ...
                'm','nf','ToBeDeleted','Eccent','refimi');%
        end
        endi=numb-1;
        Cents=Cents(1:endi,:);Orients=Orients(1:endi);
        Areas=Areas(1:endi);Eccent=Eccent(1:endi);
        endi=tbd-1;
        ToBeDeleted=ToBeDeleted(1:endi);
        save(fn,'dn','Areas','NumBees','Cents','Orients', ...
            'm','nf','ToBeDeleted','Eccent','refimi');%
        cd ../../
    end
end

function[nd,tot,badas]=CountDels(ss,reflist)
% tot=0;nd=0;
bads=[];
badas=[];
for j=1:length(ss)
    [dn,m,nf] = FolderInfo(ss(j));
    tot(j)=m;
    fn=['HiSpeedData' int2str(ss(j)) '.mat'];
    if(reflist(j)>0)
        load([dn '\' fn]);
        l=length(find(NumBees>1));
        l*100/m
        if(length(NumBees)~=m) 
            bads = [bads j ];
        end;
        if(sum(NumBees)~=length(Areas)) 
            badas=[badas j]
        end
        is=find(NumBees==0);
        ToBeDeleted=is;
         nd(j)=length(ToBeDeleted);
       %    copyfile([dn '\' fn],fn);
    else nd(j)=0;
    end
end