function GenerateEnvironment(ObjR,NumEnvs)
NumObj = 25;
ArenaSize = 1000;
FoodNestMax = 700;
FoodNestMin = 40;
FoodR = 20;
NestR = 20
dmat; cd Linc
Drawing=1;
Printing = 0;

for i=1:NumEnvs
    i
    FoodPos = round(rand(1,2)*0.5*ArenaSize)+250;
    d=0;
    while((d<FoodNestMin)|(d>FoodNestMax))
        NestPos = round(rand(1,2)*0.5*ArenaSize)+250;
        d=sqrt(sum((FoodPos-NestPos).^2,2));
    end

    % d=0;
    % while((d<=FoodR)|(d<=NestR))
    %     AgentPos = round(rand(1,2)*ArenaSize);
    %     d1=sqrt(sum((FoodPos-AgentPos).^2,2));
    %     d2=sqrt(sum((NestPos-AgentPos).^2,2));
    %     d=min(d1,d2);
    % end

    AgentPos=NestPos;
    AgentHead = rand*2*pi;

    for NumObj=1:50
        ObjectPos = round(rand(NumObj,2)*ArenaSize);
        ObjectRs = ones(NumObj,1)*max(ObjR);
        n=1;
        while(n>0)
            Obj2Food = ObjectPos - ones(NumObj,1)*FoodPos;
            DistToHole = sqrt(sum(Obj2Food.^2,2));
            Obj2Nest = ObjectPos - ones(NumObj,1)*NestPos;
            DistToNest = sqrt(sum(Obj2Nest.^2,2));
            %     Obj2Agent = ObjectPos - ones(NumObj,1)*AgentPos;
            %     DistToAgent = sqrt(sum(Obj2Agent.^2,2))';

            Overlaps=find(DistToHole<=(ObjectRs+FoodR));
            Overlaps=union(Overlaps,find(DistToNest<=(ObjectRs+NestR)));
            %    Overlaps=union(Overlaps,find(Dist2Agent<=(ObjectRs));

            n=length(Overlaps);
            ObjectPos(Overlaps,:) = round(rand(n,2)*ArenaSize);
        end

        for r=ObjR
            ObjectRs = ones(NumObj,1)*r;

            if(Drawing)
                MyCircle(NestPos(1),NestPos(2),NestR,'g')
                % MyCircle(NestPos(1),NestPos(2),NestR)
                hold on;
                MyCircle(FoodPos,FoodR,'r')
                % MyCircle(FoodPos(1),FoodPos(2),FoodR)
                for j=1:NumObj
                    MyCircle(ObjectPos(j,:),ObjectRs(j))
                    % MyCircle(ObjectPos(j,1),ObjectPos(j,2),ObjectRs(j))
                end
                hold off
                pause
            end

            if(Printing)
                fn = ['Env' int2str(i) 'Trial' int2str(NumObj) '.env'];
                fid=fopen(fn,'w');

                fprintf(fid,'sim wall length  = %d\n', ArenaSize);
                fprintf(fid,'start pos x      = %d\n', AgentPos(1));
                fprintf(fid,'start pos y      = %d\n', AgentPos(2));
                fprintf(fid,'start heading    = %f\n\n', AgentHead);

                fprintf(fid,'type    = 3\n');
                fprintf(fid,'x       = %d\n', NestPos(1));
                fprintf(fid,'y       = %d\n', NestPos(2));
                fprintf(fid,'radius  = %d\n\n', NestR);

                fprintf(fid,'type    = 2\n');
                fprintf(fid,'x       = %d\n', FoodPos(1));
                fprintf(fid,'y       = %d\n', FoodPos(2));
                fprintf(fid,'radius  = %d\n\n', FoodR);

                for j=1:NumObj
                    fprintf(fid,'type    = 1\n');
                    fprintf(fid,'x       = %d\n', ObjectPos(j,1));
                    fprintf(fid,'y       = %d\n', ObjectPos(j,2));
                    fprintf(fid,'radius  = %d\n\n', ObjectRs(j));
                end

                fclose(fid);
            end
        end
    end
end