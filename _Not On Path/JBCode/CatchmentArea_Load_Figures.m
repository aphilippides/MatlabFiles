function CatchmentArea_Load_Figures

FileName = 'ALV_and_RMSE/Test27' ;

Load_ALV = 1 ;
Load_ALV_SE = 1 ;
Load_RmsE = 1 ;

File_List=[];
Title_List=[];

if(Load_ALV)
    File_List=[ File_List ;
                cellstr(strcat(FileName,'_NoSE_Fig_AlvArrows.fig'))  ;
                cellstr(strcat(FileName,'_NoSE_Fig_AlvAccur.fig'))   ;
                cellstr(strcat(FileName,'_NoSE_Fig_NumObjSeen.fig')) ;
                cellstr(strcat(FileName,'_NoSE_Fig_AlvCatch.fig'))     ] ;
    Title_List=[ Title_List ;
                 cellstr('AlvArrows_NoSE')  ;
                 cellstr('AlvAccur_NoSE')   ;
                 cellstr('NumObjSeen_NoSE') ;
                 cellstr('AlvCatch_NoSE')     ] ;
    if(Load_ALV_SE)
        File_List=[ File_List ;
                    cellstr(strcat(FileName,'_SE_Fig_AlvArrows.fig')) ;
                    cellstr(strcat(FileName,'_SE_Fig_AlvAccur.fig'))  ;
                    cellstr(strcat(FileName,'_SE_Fig_NumObjSeen.fig'));
                    cellstr(strcat(FileName,'_SE_Fig_AlvCatch.fig'))   ] ;
        Title_List=[ Title_List ;
                     cellstr('AlvArrows_SE')  ;
                     cellstr('AlvAccur_SE')   ;
                     cellstr('NumObjSeen_SE') ;
                     cellstr('AlvCatch_SE')     ] ;
    end 
end

if(Load_RmsE)
    File_List=[ File_List ;
                cellstr(strcat(FileName,'_Fig_RmsEArrows.fig')) ;
                cellstr(strcat(FileName,'_Fig_RmsE.fig'))       ;
                cellstr(strcat(FileName,'_Fig_RmsECatch.fig'))    ] ;
    Title_List=[ Title_List ;
                 cellstr('RmsEArrows')  ;
                 cellstr('RmsE')  ;
                 cellstr('RmsECatch')     ] ;
end

close all ;

for i=1:size(File_List,1)
    File = char(File_List(1)) ;
    Name = char(Title_List(1)) ;
    if (exist(char(File_List(1))))
        open(File);
        set(gcf,'Name',Name);
    else
        warning('%s does not exist',File) ;
    end
    File_List(1)=[];
    Title_List(1)=[];
end
