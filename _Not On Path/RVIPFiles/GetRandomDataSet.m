function[RndSet,SeqBegs,SeqEnds] = GetRandomDataSet(mins,SequenceLen,NumPatterns)

rand('state',sum(100*clock));
%rand('state',1);
if(nargin<3) NumPatterns=8; end;
if(nargin<2) SequenceLen=80; end;
if(nargin<1) mins=3; end;

PLen=3;
RndSet=zeros(1,SequenceLen*mins);
NumOdd=floor(NumPatterns/2);
count=1;
for t=0:(mins-1)
    for j=1:NumOdd        
        % Do Even sequence first
        Illegal = 1;          
        while(Illegal)
            RS=RndInt(SequenceLen-PLen+1)+1+SequenceLen*t;  
            % Check positions are empty
            if((RndSet(RS)==0)&(RndSet(RS+1)==0)&(RndSet(RS+2)==0))  
                % Check before and after are empty or not even
                if(RS<=2)                   %Special Case at beginning
                    if(OddEven(RndSet(RS+PLen))==1)         % eeeooo
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=1)) % NOT see-ooo
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
                elseif(OddEven(RndSet(RS-1))==1)            % ooo---
                    if((RS+PLen)>=(SequenceLen*mins))       % oooseeEND or ooosee-END
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;                       
                        Illegal = 0;
                    elseif(OddEven(RndSet(RS+PLen))==1)     % oooseeooo
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=1)) % NOT ooosee-ooo
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
                elseif((OddEven(RndSet(RS-1))==0)&(OddEven(RndSet(RS-2))~=1)) % NOT ooo-see
                    if((RS+PLen)>=(SequenceLen*mins))
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;                       
                        Illegal = 0;
                    elseif(OddEven(RndSet(RS+PLen))==1)     % eee-seeooo OR --seeooo
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=1)) % NOT eee-see-ooo OR --see-ooo 
                        RndSet(RS:RS+PLen-1)=ThreeEven;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
                end
            end
        end    
        % Next Do Odd sequence 
        Illegal = 1;          
        while(Illegal)
            RS=RndInt(SequenceLen-PLen+1)+1+SequenceLen*t;  
            % Check positions are empty
            if((RndSet(RS)==0)&(RndSet(RS+1)==0)&(RndSet(RS+2)==0))  
                % Check if before and after are empty or not odd
                if(RS<=2)
                    if(OddEven(RndSet(RS+PLen))==2)             % sooeee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=2)) % NOT soo-eee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
               elseif(OddEven(RndSet(RS-1))==2)             % eee---
                    if((RS+PLen)>=(SequenceLen*mins))       % eeesooEND OR eeesoo-END
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;                       
                        Illegal = 0;
                    elseif(OddEven(RndSet(RS+PLen))==2)     % eeesooeee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=2)) % NOT eeesoo-eee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
               elseif((OddEven(RndSet(RS-1))==0)&(OddEven(RndSet(RS-2))~=2)) % either ooo-soo or --soo
                    if((RS+PLen)>=(SequenceLen*mins))       % either ooo-sooEND or ooo-soo-END
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;                       
                        Illegal = 0;
                    elseif(OddEven(RndSet(RS+PLen))==2)     % either ooo-sooeee or --sooeee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    elseif((OddEven(RndSet(RS+PLen))==0)&(OddEven(RndSet(RS+PLen+1))~=2)) % NOT ooo-soo-eee or --soo-eee
                        RndSet(RS:RS+PLen-1)=ThreeOdd;
                        SeqEnds(count)=RS+PLen-1;
                        SeqBegs(count)=RS;
                        count=count+1;
                        Illegal = 0;
                    end
                end
            end
        end    
    end
end
SeqEnds=sort(SeqEnds);
SeqBegs=sort(SeqBegs);

% Next pad out remaining zeroes with odds and evens ensuring no bad sequences

RSLen = length(RndSet);
for i=1:length(RndSet)
    if(RndSet(i)~=0)    % if not zero skip
        i=i+1;
    elseif(i==1)        % special cases
        s=OddEven(RndSet(2));     % Check 2nd space. Sequence is:
        if(s==1)                        % -ooo
            RndSet(1) = GetRndEven(RndSet,1,8);
        elseif(s==2)                    % -eee
            RndSet(1) = GetRndOdd(RndSet,1,9);
        else
            s=OddEven(RndSet(3));     % Check 3rd space. Sequence is:
            if(s==1)                        % --ooo
                RndSet(1) = GetRndInt1(RndSet,1,9);
                RndSet(2) = GetRndEven(RndSet,2,8);
            elseif(s==2)                    % --eee
                RndSet(1) = GetRndInt1(RndSet,1,9);
                RndSet(2) = GetRndOdd(RndSet,2,9);
            else                            % ---
                s=OddEven(RndSet(4));     % Check 4th space. Sequence is:
                if(s==1)                        % ---ooo
                    RndSet(3) = GetRndEven(RndSet,3,8);
                    RndSet(2) = GetRndInt1(RndSet,2,9);
                    if(RndSet(2)==2)            % -eeooo
                        RndSet(1) = GetRndOdd(RndSet,1,9);
                    else                        % -oeooo
                        RndSet(1) = GetRndInt1(RndSet,1,9);
                    end
                elseif(s==2)                    % ---eee
                    RndSet(3) = GetRndOdd(RndSet,3,9);
                    RndSet(2) = GetRndInt1(RndSet,2,9);
                    if(RndSet(2)==2)            % -eoeee
                        RndSet(1) = GetRndInt1(RndSet,1,9);
                    else                        % -ooeee
                        RndSet(1) = GetRndEven(RndSet,1,9);
                    end
                else                            % ----
                    RndSet(1) = GetRndInt1(RndSet,1,9);
                    RndSet(2) = GetRndInt1(RndSet,2,9); 
                end
            end
        end       
    elseif(i>=RSLen-1)
        if(OddEven(RndSet(i-1))==1)    % One b4 is odd 
            if(OddEven(RndSet(i-2))==1)    % Check one b4 that: If sequence is: oo-
                RndSet(i) = GetRndEven(RndSet,i,8);
            else                            % else Sequence is: eo-
                RndSet(i) = GetRndInt1(RndSet,i,9);
            end
        else
            if(OddEven(RndSet(i-2))==2)    % Check one b4 that: If sequence is: ee-
                RndSet(i) = GetRndOdd(RndSet,i,9);
            else                            % else Sequence is: eo-
                RndSet(i) = GetRndInt1(RndSet,i,9);
            end
        end
    else                            % Check one b4
        if(OddEven(RndSet(i-1))==1)    % One b4 is odd 
            if(OddEven(RndSet(i-2))==1)    % Check one b4 that: If sequence is: oo-
                RndSet(i) = GetRndEven(RndSet,i,8);
            else                            % else Sequence is: eo-
                s=OddEven(RndSet(i+1));     % Check next space. Sequence is:
                if(s==1)                        % eo-ooo
                    RndSet(i) = GetRndEven(RndSet,i,8);
                elseif(s==2)                    % eo-eee
                    RndSet(i) = GetRndOdd(RndSet,i,9);
                else
                    s=OddEven(RndSet(i+2));     % Check next next space. Sequence is:
                    if(s==1)                        % eo--ooo
                        RndSet(i) = GetRndInt1(RndSet,i,9);
                        RndSet(i+1) = GetRndEven(RndSet,i+1,8);
                    elseif(s==2)                    % eo--eee
                        RndSet(i) = GetRndEven(RndSet,i,8);
                        RndSet(i+1) = GetRndOdd(RndSet,i+1,9);
                    else                            % eo---
                        RndSet(i) = GetRndInt1(RndSet,i,9); 
                    end
                end
            end
        else                            % One b4 is even
            if(OddEven(RndSet(i-2))==2)    % Check one b4 that: If sequence is: ee-
                RndSet(i) = GetRndOdd(RndSet,i,9);
            else                            % else Sequence is: oe-
                s=OddEven(RndSet(i+1));     % Check next space. Sequence is:
                if(s==1)                        % oe-ooo
                    RndSet(i) = GetRndEven(RndSet,i,8);
                elseif(s==2)                    % oe-eee
                    RndSet(i) = GetRndOdd(RndSet,i,9);
                else
                    s=OddEven(RndSet(i+2));     % Check next next space. Sequence is:
                    if(s==1)                        % oe--ooo
                        RndSet(i) = GetRndOdd(RndSet,i,9);
                        RndSet(i+1) = GetRndEven(RndSet,i+1,8);
                    elseif(s==2)                    % oe--eee
                        RndSet(i) = GetRndInt1(RndSet,i,9);
                        RndSet(i+1) = GetRndOdd(RndSet,i+1,9);
                    else                            % oe---
                        RndSet(i) = GetRndInt1(RndSet,i,9); 
                    end
                end
            end
        end
    end
end

function[val] = GetRndEven(RndSet,i,num)
L=length(RndSet);
if (i==1)
    val=RndEven(num);
    while(val==RndSet(2))
        val=RndEven(num);
    end
elseif(i==L)
    val=RndEven(num);
    while(val==RndSet(L-1))
        val=RndEven(num);
    end
else
    val=RndEven(num);
    while((val==RndSet(i-1))|(val==RndSet(i+1)))
        val=RndEven(num);
    end
end

function[val] = GetRndInt1(RndSet,i,num)
L=length(RndSet);
if (i==1)
    val=RndInt1(num);
    while(val==RndSet(2))
        val=RndInt1(num);
    end
elseif(i==L)
    val=RndInt1(num);
    while(val==RndSet(L-1))
        val=RndInt1(num);
    end
else
    val=RndInt1(num);
    while((val==RndSet(i-1))|(val==RndSet(i+1)))
        val=RndInt1(num);
    end
end

function[val] = GetRndOdd(RndSet,i,num)
L=length(RndSet);
if (i==1)
    val=RndOdd(num);
    while(val==RndSet(2))
        val=RndOdd(num);
    end
elseif(i==L)
    val=RndOdd(num);
    while(val==RndSet(L-1))
        val=RndOdd(num);
    end
else
    val=RndOdd(num);
    while((val==RndSet(i-1))|(val==RndSet(i+1)))
        val=RndOdd(num);
    end
end


function[seq] = ThreeEven
x=[2 4 6 8];
seq=x(randperm(length(x)));
seq=seq(1:3);

function[seq] = ThreeOdd
x=[1 3 5 7 9];
seq=x(randperm(length(x)));
seq=seq(1:3);