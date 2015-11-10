function[reflist]=GetRefims(ss,reflist)
cd E:\
for i=1:length(ss)
    [dn,m,nf] = FolderInfo(ss(i));
    if(isempty(dn)) reflist(i)=0;
    else
        cd(dn);
        i
        reflist(i)=GetRefIm(1,m)
        if(reflist(i)>0)
            imagesc(imread(GetDVRname(reflist(i),m)));
            pause
        end
        cd ../../
    end
end

function[refim] = GetRefIm(st,en)

notdif=1;
rp=randperm(en);
r1=imread(GetDVRname(rp(1),en));
c=2;
n=0;
while(~n)
    % *** COULD UP THRESHOLD FOR BEE FINDING TO AVOID FAKE BEES ***
    if(~isfile(GetDVRname(rp(c),en)))
        keyboard;
    end
    r2=imread(GetDVRname(rp(c),en));
    [n,cent,a]=Find1Bee_HiSpeed(r1,r2);
    if(c==en)
        refim=-1;
        return;
    end
    c=c+1;
end

ToTry = [1 en [randperm(en-2)+1]];
for t=ToTry
    im=imread(GetDVRname(t,en));
    [n1,c,a]=Find1Bee_HiSpeed(r1,im);
    if(~n1)
        [n2,c,a]=Find1Bee_HiSpeed(r2,im);
        if(~n2)
            refim=t;
            return;
        end;
    end
end
refim=-1;